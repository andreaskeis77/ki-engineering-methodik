# bootstrap-fasttrack.ps1 - creates a new Fast-Track prototype project from the starterkit.
#
# Usage:
#   .\bootstrap-fasttrack.ps1 -Name mein-projekt -BasePath C:\dev
#   .\bootstrap-fasttrack.ps1 -Name mein-projekt -BasePath C:\dev -GitHub
#
# -Name     project name (folder and repo name, kebab-case recommended)
# -BasePath parent directory for the project folder (default: current directory;
#           must NOT lie inside an existing git repo - the script guards against that)
# -GitHub   also create a PRIVATE GitHub repo via `gh` and push the initial commit
#
# NOTE: keep this file pure ASCII - Windows PowerShell 5.1 parses BOM-less
# files as ANSI, so non-ASCII characters would break the parser.

param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9][a-z0-9._-]*$')]
    [string]$Name,

    [string]$BasePath = (Get-Location).Path,

    [switch]$GitHub
)

$ErrorActionPreference = 'Stop'

function Invoke-Native {
    param([string]$Description, [scriptblock]$Command)
    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Step failed (exit $LASTEXITCODE): $Description"
    }
}

if ($null -eq (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git not found on PATH - install git first."
}

$starterkit = Join-Path $PSScriptRoot 'starterkit'
if (-not (Test-Path $starterkit)) {
    throw "Starterkit not found at $starterkit - this script must live next to the 'starterkit' folder."
}

# Guard: refuse to nest the new project inside an existing git repo
# (running from the methodik repo without -BasePath would do exactly that).
# PS 5.1: stderr redirect on native commands throws under EAP=Stop, so lower it briefly.
$prevEap = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
$null = git -C $BasePath rev-parse --is-inside-work-tree 2>$null
$insideRepo = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = $prevEap
if ($insideRepo) {
    throw "BasePath '$BasePath' lies inside an existing git repository. Pass -BasePath with a projects folder outside any repo (e.g. -BasePath C:\dev)."
}

$projectDir = Join-Path $BasePath $Name
if (Test-Path $projectDir) {
    throw "Target folder already exists: $projectDir - aborting, nothing was overwritten."
}

$today = Get-Date -Format 'yyyy-MM-dd'
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

Write-Host "Creating Fast-Track project: $projectDir"
New-Item -ItemType Directory -Path $projectDir | Out-Null

try {
    # Copy the full starterkit (incl. .claude/ and .gitignore) and fill the
    # mechanical placeholders (name, date). Charter fields stay open on purpose -
    # filling them is the P0 kickoff.
    $copied = @()
    Get-ChildItem $starterkit -File -Recurse -Force | ForEach-Object {
        $relative = $_.FullName.Substring($starterkit.Length + 1)
        $content = [System.IO.File]::ReadAllText($_.FullName)
        $content = $content -replace '\[Projektname\]', $Name
        $content = $content -replace '"\[name\]"', ('"' + $Name + '"')
        $content = $content -replace '\[Datum\]', $today
        $target = Join-Path $projectDir $relative
        $targetDir = Split-Path $target -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        [System.IO.File]::WriteAllText($target, $content, $utf8NoBom)
        $copied += $relative
    }

    Push-Location $projectDir
    try {
        Invoke-Native 'git init (needs git >= 2.28 for -b)' { git init -b main | Out-Null }
        # Explicit paths only - never `git add -A` (Fast-Track constitution, section 3).
        Invoke-Native 'git add starterkit files' { git add -- $copied }
        Invoke-Native 'git commit (configure git user.name/user.email if this fails)' {
            git commit -m "chore: bootstrap fast-track project from starterkit" | Out-Null
        }
        Write-Host "Git repo initialized (branch: main, initial commit done)."

        if ($GitHub) {
            if ($null -eq (Get-Command gh -ErrorAction SilentlyContinue)) {
                Write-Warning "gh CLI not found - create the GitHub repo manually: gh repo create $Name --private --source . --push"
            } else {
                $prevEap2 = $ErrorActionPreference
                $ErrorActionPreference = 'Continue'
                $null = gh auth status 2>$null
                $ErrorActionPreference = $prevEap2
                if ($LASTEXITCODE -ne 0) {
                    Write-Warning "gh is not logged in (run 'gh auth login') - create the repo manually: gh repo create $Name --private --source . --push"
                } else {
                    Invoke-Native 'gh repo create' { gh repo create $Name --private --source . --push }
                    Write-Host "Private GitHub repo created and pushed."
                }
            }
        }
    }
    finally {
        Pop-Location
    }
}
catch {
    # Leave no half-initialized project behind; the folder was created by this run.
    Remove-Item -Recurse -Force $projectDir -ErrorAction SilentlyContinue
    Write-Warning "Bootstrap failed, removed incomplete folder: $projectDir"
    throw
}

Write-Host ""
Write-Host "Done. Next steps (P0 kickoff, max 30 minutes):"
Write-Host "  1. code `"$projectDir`"   - open the project in VS Code"
Write-Host "  2. Start Claude Code and say:"
Write-Host "     'Lies AGENTS.md. Fuehre den P0-Kickoff mit mir durch: Stelle mir die Fragen"
Write-Host "      fuer den Steckbrief, fuelle ihn aus, trage die Kostenschaetzung in KOSTEN.md ein"
Write-Host "      und schlage den ersten Vertical Slice vor. Danach baue los.'"
Write-Host "     (P0 includes: confirm .claude/settings.json, set up the secret scan, e.g. gitleaks.)"
if (-not $GitHub) {
    Write-Host "  3. Optional: create a private GitHub repo:  gh repo create $Name --private --source . --push"
}
