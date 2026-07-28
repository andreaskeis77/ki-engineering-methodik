# Claude-Ökosystem 2026: Konnektoren, Plugins, Skills und Automatisierung

**Stand: 2026-07-28** — Recherche auf Basis der offiziellen Dokumentationen (claude.com, code.claude.com/docs, platform.claude.com, support.claude.com) und der offiziellen GitHub-Repos. Quellenstatus: [V] = selbst abgerufen und geprüft am 2026-07-28, [S] = nur über Suche belegt.

## Executive Summary

Das Claude-Ökosystem ist 2026 kein einzelnes Produkt mehr, sondern ein durchgängiger Automatisierungs-Stack mit drei Schichten: Consumer-Oberflächen (claude.ai, Desktop/Cowork, Chrome, Excel, Mobile), Claude Code als programmierbarer Agent-Harness, und die API-Schicht (Agent SDK, MCP-Connector, Managed Agents). Verbindendes Element ist überall MCP: Das offizielle Konnektoren-Verzeichnis listet mehrere hundert kuratierte Remote-Server (GitHub, Slack, Notion, Sentry, Stripe, Atlassian, Airtable u. v. m.), die dank Konten-Sync auch in Claude Code als "claude.ai connectors" auftauchen. Claude Code selbst ist inzwischen ein vollständiges Automatisierungssystem: drei MCP-Scopes plus Enterprise-Managed-MCP mit Allow-/Denylisten, Tool Search (deferred loading) gegen Kontextkosten, Plugins mit zwei offiziellen Marketplaces, Skills als offener Standard (agentskills.io), Hooks mit 20+ Events als deterministische Gates, Subagents mit eigenem Kontextfenster sowie experimentelle Agent Teams. Für zeitgesteuerte Automatisierung existieren drei klar getrennte Ebenen: sessiongebundenes `/loop`, lokale Desktop Scheduled Tasks (mit Berechtigungen pro Task) und cloudbasierte Routines mit Schedule-, API- und GitHub-Triggern — Letztere laufen komplett ohne Permission-Prompts. Remote Control erlaubt es, laufende lokale Sessions vom Handy zu steuern und Tool-Freigaben unterwegs zu erteilen — genau der Baustein, der attended-Betrieb mobil macht. Kritisch für Andreas' Windows-Umgebung: Das OS-Level-Sandboxing (Seatbelt/bubblewrap) läuft nicht auf nativem Windows, nur unter WSL2 — hermetische Gates müssen dort anders konstruiert werden. Auf der API-Seite ist das Agent SDK (Python/TypeScript) der empfohlene Weg für selbstgebaute Automatisierung; Managed Agents (Beta) und der MCP-Connector der Messages API ergänzen für gehostete Szenarien. Insgesamt ist der Möglichkeitsraum groß und überwiegend substanziell dokumentiert; die Marketing-Anteile sind gering, aber Reifegrade unterscheiden sich stark (GA vs. Research Preview vs. experimentell).

---

## Teil 1: claude.ai, Desktop, Cowork und die Endnutzer-Automatisierung

### Konnektoren-Verzeichnis und Konnektor-Typen

Das offizielle Verzeichnis ([claude.com/connectors](https://claude.com/connectors), [V]) organisiert Konnektoren nach Branchen-Kategorien (Sales/Marketing, Data, Productivity, Code, Communication, Design, Financial Services u. a.), nach Produkt (Claude, Claude Code, Skills) und nach Fähigkeit (Read / Read & write / Interactive). Sichtbar sind 40+ Einträge pro Seite bei 17 Seiten Pagination — also eine Größenordnung von mehreren hundert Konnektoren, darunter konkret Airtable, ActiveCampaign, Adobe (CJA, Experience Manager, Journey Optimizer), Ahrefs, Apollo.io, Amplitude. Die Doku ([claude.com/docs/connectors](https://claude.com/docs/connectors), [V]) unterscheidet fünf Typen:

1. **Prebuilt-Integrationen** von Anthropic: Google Drive, Gmail, Google Calendar, GitHub, Slack, Microsoft 365 — nur Authentifizierung nötig.
2. **Remote MCP Server** (Custom Connectors): eigene HTTPS-MCP-Server, die man unter claude.ai/customize/connectors einträgt; auf Team/Enterprise nur durch Admins.
3. **MCP Apps**: Server, die interaktive UI-Komponenten (Charts, Formulare) direkt im Chat rendern — das ist Andreas' Klasse M4 in Reinform.
4. **MCP Bundles (MCPB, früher Desktop Extensions)**: paketierte lokale MCP-Server mit Dependencies, Code-Signing und zentralen Updates für Claude Desktop.
5. **Plugins**: Bündel aus Konnektoren + Skills + Subagents, verfügbar in Claude Code und Cowork.

Plattform-Matrix laut Doku: claude.ai = voller Remote-MCP- und MCP-Apps-Support; Desktop = zusätzlich lokale Extensions; **Mobile = Remote-MCP-Zugriff**; Claude Code = Remote MCP + Plugins; Cowork = volles MCP + Plugins. Wichtig: In claude.ai verbundene Konnektoren erscheinen automatisch in Claude Code (`/mcp`), sofern man per claude.ai-Abo eingeloggt ist; Organisationen können pro Konnektor-Tool `ask` (Zwangsprompt, nicht wegklickbar, gilt sogar in `bypassPermissions`) oder `blocked` setzen ([V], MCP-Doku).

### Cowork und Scheduled Tasks

Claude Cowork ([support.claude.com](https://support.claude.com/en/articles/13345190-get-started-with-claude-cowork), [V]) ist der Agent für Wissensarbeit: lokaler Dateizugriff auf dem Desktop, parallele Workstreams, Ordner-Kontexte, Konnektoren/Plugins und drei Freigabemodi (Manual / Auto mit Klassifizierer / Skip) — konzeptuell dasselbe Modell wie in Claude Code. Cowork-eigene **Scheduled Tasks** ([V]) laufen als eigene Cowork-Sessions **remote in der Cloud** (funktionieren also bei schlafendem Rechner), außer sie brauchen lokale Dateien — dann nur lokal. Intervalle: stündlich, täglich, wochentags, wöchentlich, manuell; nur Bezahlpläne.

### Claude in Chrome und Claude for Excel

**Claude in Chrome** ist als Browser-Extension mit Claude Code gekoppelt ([code.claude.com/docs/en/chrome](https://code.claude.com/docs/en/chrome), [V]): Navigation, Klicks, Formulare, Datei-Uploads (bis 10 MB, Read-Permission-gebunden), Konsole/Netzwerk lesen, Screenshots, GIF-Recording — im sichtbaren Browserfenster mit dem echten Login-Zustand des Nutzers. Startbar mit `claude --chrome`; Chromium-Browser inkl. Edge/Brave; **nicht in WSL**; erfordert claude.ai-Login (kein API-Key). Im Plan Mode laufen nur Lese-Calls promptfrei, zustandsändernde Calls werden einzeln freigegeben. Sicherheitsmodell: Site-Permissions in der Extension, Pause bei Logins/CAPTCHAs; das Prompt-Injection-Risiko durch Webinhalte bleibt der zentrale Vorbehalt.

**Claude for Excel** ([support.claude.com](https://support.claude.com/en/articles/12650343-use-claude-for-excel), [V]) ist für Pro/Max/Team/Enterprise auf Excel Web/Windows/Mac/iPad verfügbar: Formel-Debugging (#REF!, Zirkelbezüge), Pivot/Charts/Conditional Formatting, Modellbau mit Zell-Highlighting und Erklärkommentaren, Konnektoren + Skills. Keine Makros/VBA. Für Andreas' Projekte eher Randthema, aber als Muster für "Agent in Fach-UI" (M4) interessant.

### Mobile Apps, Remote Control und Freigaben unterwegs

Der wichtigste Baustein für "Steuerung unterwegs" ist **Remote Control** ([code.claude.com/docs/en/remote-control](https://code.claude.com/docs/en/remote-control), [V], Research Preview, alle Pläne): Eine lokal laufende Claude-Code-Session (CLI, `claude remote-control` als Server-Modus mit bis zu 32 parallelen Sessions, VS Code oder Desktop) wird über ausschließlich ausgehende HTTPS-Verbindungen mit claude.ai/code und der iOS/Android-App gekoppelt. Ausführung und Dateizugriff bleiben auf der eigenen Maschine; Handy/Browser sind nur Fenster in die Session. Konkret möglich: Nachrichten und Dateien vom Handy senden, Subagent-/Workflow-Fortschritt sehen, **Permission-Prompts unterwegs beantworten** (Push "when actions required"), Push-Benachrichtigungen bei Task-Ende. MCP-Tools mit `requiresUserInteraction`-Annotation verweigern bewusst die One-Tap-Freigabe und erzwingen den vollen Prompt. Ergänzend: **Dispatch** (Task per Mobile-App an den gekoppelten Desktop schicken), **Channels** (Telegram/Discord/Webhooks pushen Events in die Session) und **Slack** (@Claude in Team-Channels, läuft in Anthropic-Cloud). Trusted Devices (Team/Enterprise, Beta) bindet Remote-Zugriff an registrierte Geräte + Biometrie.

---

## Teil 2: Claude Code als Automatisierungsplattform

### MCP-Konfiguration: Scopes, Kontrollen, Kontextkosten

Die MCP-Referenz ([code.claude.com/docs/en/mcp](https://code.claude.com/docs/en/mcp), [V]) ist das Herzstück. Kernfakten:

- **Transporte**: HTTP (empfohlen, `streamable-http`-Alias), SSE (deprecated), stdio (lokal), WebSocket (für Server, die pushen). `claude mcp add --transport http github https://api.githubcopilot.com/mcp/ --header "Authorization: Bearer PAT"` ist das dokumentierte GitHub-Beispiel; für PostgreSQL wird `npx @bytebase/dbhub --dsn "postgresql://readonly:..."` gezeigt — direkt auf Andreas' DB-Frage übertragbar.
- **Scopes**: `local` (Default, nur ich, nur dieses Projekt, in `~/.claude.json`), `project` (geteilt via `.mcp.json` im Repo, mit Approval-Dialog und Workspace-Trust-Schutz), `user` (alle Projekte). Präzedenz local > project > user > Plugin-Server > claude.ai-Konnektoren.
- **Enterprise/Policy**: `managed-mcp.json` (fixes Server-Set), `allowedMcpServers`/`deniedMcpServers` (per Name oder URL-Pattern), `disableClaudeAiConnectors`, Org-Controls pro Konnektor-Tool (`ask`/`blocked`). Für Solo-Betrieb sind das nutzbare Selbstbindungs-Werkzeuge.
- **Sicherheit im Kleinen**: OAuth 2.0 mit `claude mcp login`, `oauth.scopes` zum Pinnen minimaler Scopes, `headersHelper` für eigene Auth (Kerberos/short-lived tokens), Elicitation-Dialoge, `_meta["anthropic/requiresUserInteraction"]: true` als **serverseitig erzwungener Freigabe-Prompt pro Tool** — ein perfektes Primitive für Freigabe-Gates.
- **Kontextkosten**: Tool Search ist Default — MCP-Tooldefinitionen werden nicht mehr vorab geladen, sondern per `ToolSearch` bei Bedarf; nur Namen + Server-Instructions kosten Startkontext. `alwaysLoad` für Kern-Server, `ENABLE_TOOL_SEARCH=auto:N` als Schwellenmodus. Output-Deckel: Warnung ab 10k Tokens, Limit 25k (`MAX_MCP_OUTPUT_TOKENS`), große Ergebnisse werden auf Disk persistiert. Damit ist das alte "MCP frisst den Kontext"-Problem strukturell entschärft.
- **Sonstiges**: Channels (Server pushen Nachrichten in die Session), automatisches Backgrounding von Tool-Calls > 2 min, `claude mcp serve` macht Claude Code selbst zum MCP-Server.

### Plugins und Marketplaces

Plugins ([code.claude.com/docs/en/plugins](https://code.claude.com/docs/en/plugins), [V]) bündeln Skills, Agents, Hooks, MCP-Server, LSP-Server, Background-Monitors, `bin/`-Executables und Default-Settings in ein versionierbares Paket (`.claude-plugin/plugin.json`). Zwei offizielle Marketplaces: **`claude-plugins-official`** (kuratiert, automatisch registriert) und **`claude-community`** (Review-Pipeline mit Safety-Screening, Submission über Console oder claude.ai). Das offizielle Verzeichnis ([marketplace.json](https://github.com/anthropics/claude-plugins-official), [V]) enthält u. a. `mcp-server-dev` (scaffoldet eigene MCP-Server!), `agent-sdk-dev`, sowie Partner-Plugins wie atlassian, asana, airtable, auth0, azure, aws-agents, alloydb, amplitude, apollo, aikido (SAST). Eigene private Marketplaces sind ein Git-Repo mit `marketplace.json` — ideal, um Andreas' Methodik-Skills/Hooks versioniert über 11 Projekte auszurollen. Test lokal via `--plugin-dir`, Reload via `/reload-plugins`.

### Agent Skills

Skills ([code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills), [V]) folgen dem offenen **Agent-Skills-Standard (agentskills.io)**: Ordner mit `SKILL.md`, YAML-Frontmatter (`description`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `disallowed-tools`, `model`, `context: fork` für Subagent-Ausführung, `paths`-Globs, `hooks`, sogar `shell: powershell` für PowerShell-Inline-Befehle). Progressive Disclosure: nur Beschreibung (max. 1536 Zeichen) liegt im Kontext, der Body lädt erst bei Invokation. `allowed-tools` mit `${CLAUDE_SKILL_DIR}`-Substitution erlaubt es, gebündelte Scripts promptfrei laufen zu lassen; `disable-model-invocation: true` reserviert Skills mit Nebenwirkungen (Deploy, Commit) für den Menschen — exakt die Trennung, die Andreas' Autoritätsstufen brauchen. Speicherorte: Enterprise/Personal/Projekt/Plugin. Custom Commands sind in Skills aufgegangen.

### Hooks

Hooks ([code.claude.com/docs/en/hooks-guide](https://code.claude.com/docs/en/hooks-guide), [V]) sind Shell-Kommandos (alternativ prompt-/agentenbasiert) an Lifecycle-Events: `SessionStart`, `UserPromptSubmit`, `PreToolUse` (blockierbar), `PermissionRequest` (kann Dialoge automatisch beantworten), `PostToolUse`, `PostToolUseFailure`, `Notification`, `SubagentStop`, `TaskCompleted`, `Stop`, `PreCompact`, `Elicitation` u. a. Exit-Code 2 blockiert mit Feedback an Claude; JSON-Ausgaben erlauben `deny`/`ask`/`allow` mit Begründung; bei mehreren Hooks gewinnt die restriktivste Entscheidung. Das ist die deterministische Gate-Schicht (Formatierung erzwingen, geschützte Dateien blocken, Audit-Logs, Kontext-Reinjektion nach Compaction) — Policy as Code statt Hoffnung aufs Modell.

### Subagents, Agent Teams, Background

Subagents ([code.claude.com/docs/en/sub-agents](https://code.claude.com/docs/en/sub-agents), [V]): Markdown + Frontmatter (`tools`, `model`, `permissionMode`, `mcpServers`, `hooks`, `maxTurns`, `memory` für persistentes Lernen über Sessions in `agent-memory/`-Verzeichnissen). Eingebaut: Explore, Plan, general-purpose. Eigener Kontext, Ergebnisse fließen als Summary zurück; Foreground/Background; nested Subagents möglich. **Agent Teams** ([V]) sind experimentell (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`): mehrere vollwertige Sessions mit Shared Task List, Mailbox-Messaging, Plan-Approval durch den Lead, Quality-Gate-Hooks (`TeammateIdle`, `TaskCompleted`) — deutlich teurer in Tokens und mit bekannten Limitierungen (kein Resume, ein Team pro Session).

### Zeitsteuerung: /loop, Desktop Tasks, Routines

Drei Ebenen mit offizieller Vergleichstabelle ([code.claude.com/docs/en/scheduled-tasks](https://code.claude.com/docs/en/scheduled-tasks), [V]):

| | Cloud (Routines) | Desktop Tasks | `/loop` (Session) |
|---|---|---|---|
| Läuft auf | Anthropic-Cloud | eigener Rechner | eigener Rechner |
| Rechner an nötig | nein | ja | ja (+ offene Session) |
| Lokale Dateien | nein (frischer Clone) | ja | ja |
| Permission-Prompts | **keine (autonom)** | pro Task konfigurierbar | erbt Session |
| Min-Intervall | 1 h | 1 min | 1 min |

- **`/loop`/CronCreate** ([V]): sessiongebunden, 7-Tage-Expiry, `loop.md` als Standard-Wartungsprompt (PR pflegen, CI fixen), Monitor-Tool statt Polling.
- **Desktop Scheduled Tasks** ([V]): Prompt als `SKILL.md` unter `~/.claude/scheduled-tasks/`, Permission-Mode + Modell pro Task, "Always allowed"-Panel mit widerrufbaren Tool-Freigaben, Missed-Run-Catch-up (genau 1 Nachholer), Worktree-Isolation optional, Task kann sich per `update_scheduled_task` selbst umplanen.
- **Routines** ([code.claude.com/docs/en/routines](https://code.claude.com/docs/en/routines), [V], Research Preview, Pro/Max/Team/Enterprise): gespeicherte Konfiguration aus Prompt + Repos + Konnektoren + Cloud-Environment; Trigger kombinierbar: **Schedule** (min. stündlich), **API** (`POST .../routines/{id}/fire` mit Bearer-Token, `text`-Payload wird als untrusted `<routine-fire-payload>` gewrappt), **GitHub-Events** (PR/Release mit Filtern). Läuft **ohne jegliche Permission-Prompts**; Pushes standardmäßig nur auf `claude/`-Branches; Netzwerk per Environment-Allowlist. Verwaltung via claude.ai/code/routines oder `/schedule` im CLI.

### Headless, CI und GitHub Actions

`claude -p` ([code.claude.com/docs/en/headless](https://code.claude.com/docs/en/headless), [V]) ist der Skript-Modus: `--bare` (reproduzierbar, keine Auto-Discovery von Hooks/MCP/CLAUDE.md — empfohlen für CI), `--output-format json|stream-json`, `--json-schema` für strukturierte Ausgaben, `--allowedTools` mit Permission-Rule-Syntax (`Bash(git diff *)`), `--permission-mode` inkl. `dontAsk` für abgeriegelte Läufe, Session-Fortsetzung via `--continue`/`--resume`, Kosten im JSON (`total_cost_usd`). **claude-code-action@v1** ([code.claude.com/docs/en/github-actions](https://code.claude.com/docs/en/github-actions), [V]) reagiert auf `@claude`-Mentions oder läuft prompt-getrieben (auch `schedule:`-Cron), installiert Plugins (`plugin_marketplaces`/`plugins`), ruft Skills als Prompt auf und reicht beliebige CLI-Args via `claude_args` durch; GitHub-App braucht Contents/Issues/PRs Read&Write.

### Sandboxing — der Windows-Haken

Der sandboxed Bash-Tool ([code.claude.com/docs/en/sandboxing](https://code.claude.com/docs/en/sandboxing), [V]) erzwingt Datei- und Netzwerkgrenzen auf OS-Ebene (macOS Seatbelt, Linux/WSL2 bubblewrap + socat + optional seccomp): Schreiben nur ins Arbeitsverzeichnis, Netz nur auf Allowlist-Domains über einen Proxy, Credential-Schutz per `deny`/`mask` (Proxy injiziert echte Tokens nur für definierte Hosts), `strictAllowlist`, `failIfUnavailable`. **Natives Windows wird nicht unterstützt** — nur WSL2, und dort können sandboxed Commands keine Windows-Binaries (`powershell.exe`, `/mnt/c/...`) aufrufen. Die Doku warnt zudem explizit vor Domain-Fronting-Exfiltration bei breiten Allowlists, da der Proxy TLS standardmäßig nicht terminiert.

---

## Teil 3: API-Seite für selbstgebaute Automatisierung

- **Agent SDK** ([code.claude.com/docs/en/agent-sdk/overview](https://code.claude.com/docs/en/agent-sdk/overview), [V]): Python/TypeScript-Bibliothek mit dem kompletten Claude-Code-Loop: eingebaute Tools (Read/Edit/Bash/Glob/Grep/WebSearch/Monitor), Hooks als Callbacks, MCP-Server programmatisch, `allowed_tools`/`disallowed_tools`, `canUseTool`-Approval-Callback, Subagents per `AgentDefinition`, Sessions mit Resume/Fork, lädt auf Wunsch `.claude/`-Skills/CLAUDE.md. Bündelt das native Binary; Auth per API-Key (claude.ai-Login für Drittprodukte untersagt). Das ist der richtige Baustein für Andreas' FastAPI-basierte Eigen-Automatisierung.
- **MCP-Connector der Messages API** ([platform.claude.com](https://platform.claude.com/docs/en/agents-and-tools/mcp-connector), [V], Beta `mcp-client-2025-11-20`): `mcp_servers`-Parameter (nur URL-Server, kein stdio) plus `mcp_toolset` mit per-Tool-Allow-/Denylist (`default_config`/`configs.enabled`). Nur Tool-Calls (keine Prompts/Resources), Server müssen öffentlich erreichbar sein.
- **Code Execution / Tool Runner** ([platform.claude.com](https://platform.claude.com/docs/en/agents-and-tools/tool-use/code-execution-tool), [V], GA): serverseitige Python-3.11/Bash-Sandbox (5 GiB RAM, kein Internet), Container über Requests wiederverwendbar; ab `code_execution_20260120` **Programmatic Tool Calling** — Claude ruft eigene Tools aus Python-Code im Container auf; separater "Tool Runner" im Agent-SDK-Umfeld dokumentiert. 1.550 Gratis-Stunden/Monat, danach $0,05/h.
- **Managed Agents** ([platform.claude.com](https://platform.claude.com/docs/en/managed-agents/overview), [V], Beta `managed-agents-2026-04-01`): gehostete REST-API mit Anthropic- oder self-hosted Sandboxes, persistente Sessions, Bash/Datei/Web/MCP-Tools, Scheduled Deployments. Positioniert als Produktionspfad nach SDK-Prototyping.

---

## Konsequenzen für Andreas' Methodik und Projekte

**1. MCP als kontrollierte Fähigkeitsschicht formalisieren.** Die Claude-Mechanismen bilden seine M-Klassen fast 1:1 ab und sollten als Referenz in die Methodik: M0/M1 = lokale stdio-Server bzw. Datei-Tools (Scope `local`/`project`); M2 = Remote-HTTP-Server (GitHub-MCP mit fine-grained PAT, eigene Server hinter Tailscale); M3 = Browser (Claude in Chrome); M4 = MCP Apps/UI-Extensions. Pro Klasse verfügbare Leitplanken: `oauth.scopes`-Pinning, per-Tool-Allow/Deny (`mcp_toolset` in der API, Org-Controls in claude.ai, `deniedMcpServers` lokal), `requiresUserInteraction` für Zwangsfreigaben, Tool Search gegen Kontextkosten. **Empfehlung: jetzt umsetzen.**

**2. Windows-Server-Steuerung: eigener MCP-Server statt Konnektor-Suche.** Für seinen VPS gibt es keinen fertigen "Windows-Admin-Konnektor" im Verzeichnis — der tragfähige Weg ist ein selbst gebauter MCP-Server (Scaffolding via `/plugin install mcp-server-dev@claude-plugins-official`, [V]) auf dem Server: FastMCP/Python, erreichbar als Remote-HTTP-Server über Tailscale, mit explizit modellierten Tools (Dienst-Status lesen = M0-Analogon read-only; Scheduled-Task anlegen/Neustart = schreibend, mit `requiresUserInteraction`-Annotation für A-hohe Aktionen). Gleiches Muster für DB-Administration: dbhub/Postgres-MCP mit **readonly-DSN** für Analyse (unattended-tauglich), ein zweiter Server mit Schreib-Tools nur attended. **Empfehlung: jetzt, als Pilot mit Read-only-Start.**

**3. Unattended-Läufe sauber den drei Scheduler-Ebenen zuordnen.** `/loop` = attended-nah (erbt Session-Permissions) für Babysitting von CI/Deploys. Desktop Scheduled Tasks = lokale unattended-Läufe mit per-Task-Permission-Mode und auditierbarer Always-allow-Liste — die natürliche Ablösung/Ergänzung seiner Windows-Scheduled-Task-+-Headless-Konstruktion, sofern der Desktop läuft. Routines = voll-unattended in der Cloud, aber ohne lokalen Server-Zugriff und **ohne Prompts** — nur für Aufgaben, deren Blast Radius per Repo-Auswahl, `claude/`-Branch-Regel, Environment-Allowlist und Konnektor-Minimierung begrenzt ist (z. B. nächtliche Repo-Pflege der NFL-Plattform, PR-Review via GitHub-Trigger). Der API-Trigger von Routines ist zudem ein sauberer Webhook-Einstieg für seine eigenen Systeme (Alert → Untersuchungs-Session).

**4. Hermetische Quality Gates auf Windows neu denken.** Da OS-Sandboxing natives Windows nicht abdeckt, sollten seine Gates dort auf Hooks (`PreToolUse`-Deny-Skripte, `PermissionRequest`), Permission-Rules, `--bare`-Headless-Läufe und ggf. WSL2 für die wirklich hermetischen Läufe setzen; PowerShell-Unterstützung existiert (Skills mit `shell: powershell`, PowerShell-Tool). Für CI bleibt GitHub Actions (`claude-code-action@v1` + `--max-turns` + enge `--allowedTools`) der reifste hermetische Pfad.

**5. Methodik als privates Plugin-Marketplace ausrollen.** Skills (mit `disable-model-invocation` für A4/A5-Aktionen), Hooks, Subagent-Definitionen und MCP-Konfigurationen in ein Git-Marketplace-Repo packen — versioniert, über alle 11 Projekte identisch, in Actions via `plugins:`-Input installierbar. **Empfehlung: jetzt.**

**6. Attended mobil machen.** Remote Control + Mobile-Push ("Push when actions required") löst sein Freigabe-unterwegs-Problem ohne eigenen Serverumbau; kombinierbar mit `requiresUserInteraction`-Tools, die One-Tap bewusst verweigern. **Empfehlung: jetzt aktivieren.**

## Bewertungstabelle

| Baustein | Reife | Nutzen für Andreas | Bewertung |
|---|---|---|---|
| MCP in Claude Code (Scopes, Tool Search, OAuth) | GA, sehr ausgereift | GitHub, DBs, eigener Server | **jetzt empfohlen** |
| Eigener MCP-Server für VPS/DB (mcp-server-dev, dbhub) | Muster etabliert | Kernstück Server-/DB-Admin | **jetzt empfohlen** (read-only zuerst) |
| Konnektoren-Verzeichnis claude.ai | GA, groß | punktuell (GitHub, Sentry) | sinnvoll unter Bedingungen |
| Plugins + privates Marketplace | GA | Methodik-Verteilung | **jetzt empfohlen** |
| Agent Skills (Standard, allowed-tools) | GA, offener Standard | Autoritätsstufen-Umsetzung | **jetzt empfohlen** |
| Hooks (PreToolUse/PermissionRequest) | GA | deterministische Gates | **jetzt empfohlen** |
| Subagents (+ memory) | GA | Kontexthygiene, Rollen | **jetzt empfohlen** |
| Agent Teams | experimentell, Env-Flag | Parallel-Review | beobachten |
| `/loop` (Session-Cron) | GA, 7-Tage-Expiry | Deploy-/PR-Babysitting | sinnvoll unter Bedingungen |
| Desktop Scheduled Tasks | GA (Desktop nötig) | lokale Automationen mit Gates | pilotgeeignet |
| Routines (Cloud, API-/GitHub-Trigger) | Research Preview | Repo-Pflege, Webhooks | pilotgeeignet |
| Remote Control + Mobile-Freigaben | Research Preview, stabil dokumentiert | attended unterwegs | **jetzt empfohlen** |
| Claude in Chrome | GA-nah, kein WSL | UI-Tests, Directus-Bedienung | sinnvoll unter Bedingungen (M3/M4, nur attended) |
| Claude for Excel | GA | kaum Projektbezug | beobachten |
| Headless `claude -p --bare` + JSON-Schema | GA | Skript-/CI-Rückgrat | **jetzt empfohlen** |
| GitHub Actions (claude-code-action@v1) | GA (v1) | CI-Automatisierung | **jetzt empfohlen** |
| Sandboxing (Bash) | GA, **kein natives Windows** | hermetische Läufe | sinnvoll unter Bedingungen (WSL2) |
| Agent SDK (Python/TS) | GA | Eigenbau-Automatisierung | **jetzt empfohlen** |
| MCP-Connector Messages API | Beta | schlanke Server-Anbindung | sinnvoll unter Bedingungen |
| Code Execution / Programmatic Tool Calling | GA | Datenauswertung serverlos | sinnvoll unter Bedingungen |
| Managed Agents | Beta | gehostete Agents | beobachten |
| Cowork (+ Cloud Scheduled Tasks) | GA (Bezahlpläne) | Doku-/Dateiarbeit | sinnvoll unter Bedingungen |

## Quellenverzeichnis

Alle [V]-Quellen am 2026-07-28 selbst abgerufen und geprüft.

1. [V] https://claude.com/connectors — Konnektoren-Verzeichnis (Kategorien, Einträge, Pagination)
2. [V] https://claude.com/docs/connectors — Konnektor-Typen, MCP Apps, MCPB, Plattform-Matrix
3. [V] https://code.claude.com/docs/en/mcp — MCP-Vollreferenz (Scopes, Transporte, OAuth, Tool Search, Org-Controls, Limits)
4. [V] https://code.claude.com/docs/en/plugins — Plugin-Erstellung, offizielle Marketplaces, Submission
5. [V] https://github.com/anthropics/claude-plugins-official (marketplace.json via raw) — konkrete Plugin-Einträge
6. [V] https://code.claude.com/docs/en/skills — Skill-Format, Frontmatter, agentskills.io-Standard
7. [V] https://code.claude.com/docs/en/hooks-guide — Hook-Events, Decision-Control
8. [V] https://code.claude.com/docs/en/sub-agents — Subagents, Built-ins, memory, permissionMode
9. [V] https://code.claude.com/docs/en/agent-teams — Agent Teams (experimentell)
10. [V] https://code.claude.com/docs/en/scheduled-tasks — /loop, CronCreate, Vergleich der Scheduler
11. [V] https://code.claude.com/docs/en/desktop-scheduled-tasks — lokale Desktop-Tasks, per-Task-Permissions
12. [V] https://code.claude.com/docs/en/routines — Cloud-Routines, Schedule-/API-/GitHub-Trigger
13. [V] https://code.claude.com/docs/en/remote-control — mobile Steuerung, Push, Trusted Devices
14. [V] https://code.claude.com/docs/en/headless — claude -p, --bare, Output-Formate
15. [V] https://code.claude.com/docs/en/github-actions — claude-code-action@v1
16. [V] https://code.claude.com/docs/en/sandboxing — Seatbelt/bubblewrap, Windows-Limitierung, Credential-Masking
17. [V] https://code.claude.com/docs/en/chrome — Claude in Chrome via Claude Code
18. [V] https://code.claude.com/docs/en/agent-sdk/overview — Agent SDK (Python/TS)
19. [V] https://platform.claude.com/docs/en/agents-and-tools/mcp-connector — MCP in der Messages API
20. [V] https://platform.claude.com/docs/en/agents-and-tools/tool-use/code-execution-tool — Code Execution, Programmatic Tool Calling, Tool-Runner-Verweis
21. [V] https://platform.claude.com/docs/en/managed-agents/overview — Managed Agents (Beta)
22. [V] https://support.claude.com/en/articles/12650343-use-claude-for-excel — Claude for Excel
23. [V] https://support.claude.com/en/articles/13345190-get-started-with-claude-cowork — Cowork-Überblick
24. [V] https://support.claude.com/en/articles/13854387-schedule-recurring-tasks-in-claude-cowork — Cowork Scheduled Tasks
25. [S] https://support.claude.com/en/articles/12012173-get-started-with-claude-in-chrome — Chrome-Extension-Hilfeartikel (über Suche belegt)
26. [S] https://the-decoder.com/anthropic-opens-claudes-improved-excel-integration-to-all-pro-subscribers-after-limited-beta/ — Excel-Rollout (Sekundärquelle)
