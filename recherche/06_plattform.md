# Dossier 06: Entwicklungsplattform, Deployment, Betrieb und Remote-Steuerung

Stand: 2026-07-28. Quellenstatus-Konvention: [V] = URL am 2026-07-28 selbst abgerufen und inhaltlich geprueft; [S] = nur ueber Suchergebnisse belegt. Bewertungsmassstab: professionell ohne Enterprise-Overhead, lokal/privat betreibbar, agentenfreundlich, reproduzierbar, auditierbar.

## Executive Summary

Claude Code hat sich 2025/2026 von einem CLI-Werkzeug zu einer Plattform mit fuenf fuer Andreas' Methodik direkt relevanten Bausteinen entwickelt: Hooks als technischer Enforcement-Punkt (PreToolUse kann Aktionen mit Exit-Code 2 hart blockieren), Plugins als versionierbares Paketformat fuer die gesamte Methodik, OS-Level-Sandboxing, Headless-Betrieb mit JSON-Schema-Ausgabe und Remote Control fuer Steuerung per Smartphone. Der wichtigste Einzelbefund: Das Bash-Sandboxing laeuft auf macOS, Linux und WSL2, aber nicht auf nativem Windows — fuer hohe Autonomiestufen (A3+) ist WSL2 damit faktisch Pflicht, waehrend PowerShell-native Projekte kompensierend auf Permission-Rules und Hooks angewiesen bleiben. Bei Containern hat Microsoft mit den WSL Containers (wslc, Public Preview seit Build 2026) Docker Desktop optional gemacht; fuer Andreas lohnt Containerisierung primaer fuer Dev-/Test-Reproduzierbarkeit (Wegwerf-Datenbanken, CI-Paritaet, Sandbox-Basis), nicht fuer den Produktionsbetrieb auf dem eigenen Windows-Server, wo native Dienste (WinSW/NSSM) plus Scheduled Tasks weiterhin die robustere und wartbarere Loesung sind. Fuer Deployments ist das staerkste Muster 2026: GitHub-hosted Runner tritt per Tailscale GitHub Action mit Workload Identity Federation (seit 2/2026 GA, keine statischen Secrets) als ephemerer Node in den Tailnet ein und deployt ueber OpenSSH auf den Windows-Server; Tailscale SSH selbst faellt aus, weil der SSH-Server nur Linux/macOS unterstuetzt. GitHub Environments mit Required Reviewers — das kanonische mobile Freigabe-Gate — sind in privaten Repos erst ab Enterprise verfuegbar und damit fuer Andreas nicht belastbar; als Ersatz taugen Claude Codes Remote-Control-Permission-Prompts aufs Handy und workflow_dispatch im mobilen Browser. Backup/Restore ist mit restic (Dateien) und Litestream v0.5 (SQLite-Point-in-Time-Restore, neues LTX-Format) solide loesbar, muss aber durch regelmaessige Restore-Proben mit Dead-Man-Switch (Healthchecks) abgesichert werden. Observability fuer Kleinumgebungen heisst 2026: OpenTelemetry als Instrumentierungs-Standard im Code ja, eigener Collector/Backend-Stack nein; stattdessen strukturierte JSON-Logs, die Claude Code selbst als Diagnose-Agent auswertet, plus Uptime Kuma (Aussensicht) und Healthchecks (Cron-Ueberwachung). Fuer Remote-Steuerung gilt eine klare Asymmetrie: Freigaben, Reviews kleiner Diffs, Stopp-Aktionen und Status mobil ja — destruktive Infrastruktur-, Secret-, Restore- und Policy-Aenderungen mobil bewusst unmoeglich.

## 1. Claude Code und VS Code 2026

**Hooks** sind der zentrale Mechanismus, um Andreas' Autoritaetsstufen A0–A5 technisch durchzusetzen statt nur zu dokumentieren. Das Ereignismodell umfasst u. a. SessionStart/SessionEnd, UserPromptSubmit, PreToolUse/PostToolUse/PostToolUseFailure, PermissionRequest und Stop; Handler-Typen sind Shell-Command, HTTP-Endpoint, MCP-Tool, Ein-Turn-LLM-Prompt und Subagent. PreToolUse-Hooks koennen mit Exit-Code 2 (stderr = Begruendung) oder per JSON (`permissionDecision: deny`) Aktionen hart blockieren; Matcher unterstuetzen Permission-Rule-Syntax wie `Bash(git push *)` oder `Edit(*.ts)` [V]. Damit lassen sich hermetische Testgates (z. B. "kein `git push` ohne gruenen Testlauf"), Spezifikationspflicht und Verifikationsbandbreite maschinell erzwingen — auditierbar, weil Hooks Session-ID, Transcript-Pfad und Agent-Kontext auf stdin erhalten.

**Plugins** buendeln Skills, Agents, Hooks (hooks.json), MCP-Server, LSP-Server, Hintergrund-Monitore, `bin/`-Executables und Default-Settings in einem versionierten Verzeichnis mit Manifest; Verteilung ueber (auch private) Git-Marketplaces, Test per `--plugin-dir` [V]. Das ist das natuerliche Paketformat fuer die Methodik v4.x: einmal als privates Plugin gepflegt, in allen 11 Projekten identisch geladen, Aenderungen per Versionssprung nachvollziehbar.

**Sandboxing** isoliert Bash-Kommandos auf OS-Ebene (macOS Seatbelt, Linux/WSL2 bubblewrap + socat), mit getrennten Schichten fuer Dateisystem (Default: Schreiben nur ins Arbeitsverzeichnis + Session-Tempdir) und Netzwerk (Proxy mit Domain-Allowlist, ab v2.1.219 optional `strictAllowlist`). Credentials lassen sich fuer sandboxed Commands per `deny` entfernen oder per `mask` durch Sentinel-Werte ersetzen, die erst der Proxy fuer definierte Hosts einsetzt. Entscheidend: **Natives Windows wird nicht unterstuetzt; auf Windows laeuft die Sandbox nur in WSL2**, und aus WSL2 heraus sind Windows-Binaries (powershell.exe, /mnt/c/...) in der Sandbox blockiert [V]. Die Doku warnt zudem explizit vor Domain-Fronting-Restrisiken, da der Proxy TLS standardmaessig nicht terminiert.

**Headless/CI-Betrieb**: `claude -p` mit `--bare` (laedt keine lokalen Hooks/MCP/CLAUDE.md — reproduzierbar auf jeder Maschine; wird kuenftig Default fuer `-p`), `--output-format json` inkl. `total_cost_usd`, `--json-schema` fuer schema-validierte strukturierte Ausgaben, `stream-json` fuer Events, `--allowedTools` mit Permission-Rule-Syntax, Permission-Modes `dontAsk`/`acceptEdits`, Session-Fortsetzung via `--resume` [V]. Das passt exakt auf Run-Manifeste: Jeder autonome Lauf kann Kosten, Session-ID und ein schema-konformes Ergebnisobjekt maschinenlesbar abliefern.

**Checkpoints**: Vor jedem Prompt wird der Dateizustand gesichert (100 Checkpoints/Session, 30 Tage), `/rewind` kann Code und/oder Konversation zuruecksetzen oder Teilbereiche zusammenfassen. Grenzen: Aenderungen durch Bash-Kommandos, Hintergrund-Subagenten und Symlinks/Hardlinks werden nicht erfasst — Checkpoints sind "lokales Undo", Git bleibt die Wahrheit [V].

**VS Code** hat mit Agent Mode, Custom Agents (AGENTS.md-Konvention) und einem dedizierten Agents-Window nachgezogen [S]; fuer Andreas bleibt die Claude-Code-Extension der Kern, inkl. `/remote-control` direkt aus VS Code [V].

## 2. GitHub und GitHub Actions fuer Solo-Entwickler

Kontingente 2026: Free 2000 min/Monat + 500 MB Artefakt-Storage fuer private Repos, Pro 3000 min + 1 GB; public Repos und self-hosted Runner kostenlos; Windows-Runner kosten ~1,7x Linux (0,010 vs. 0,006 USD/min), macOS ~10x [V]. Konsequenz: Test-/Lint-Jobs auf `ubuntu-latest`, Windows-Runner nur fuer PowerShell-/Windows-spezifische Pfade.

Security-Hardening laut GitHub [V]: Actions auf Commit-SHA pinnen (einzige immutable Referenz), `GITHUB_TOKEN` default read-only und je Job minimal eskalieren, OIDC statt langlebiger Cloud-Secrets, Secrets-Redaction nicht als garantiert behandeln. Self-hosted Runner "fast nie" fuer public Repos — fuer private Solo-Repos ist das Risiko beherrschbar (keine Fremd-PRs), aber ein Runner auf dem Produktionsserver ist Remote-Code-Execution by design und gehoert in ein dediziertes, minimal berechtigtes Konto.

Wichtiger Negativbefund fuer den Privatkontext: **Deployment Protection Rules (Required Reviewers, Wait Timer) sind in privaten Repos erst mit Enterprise verfuegbar**; Pro kann Environments zwar konfigurieren, aber die Schutzregeln greifen nur in public Repos [V]. Das kanonische "Approve vom Handy"-Gate via GitHub Environments faellt fuer Andreas' private Repos also aus.

Die **Claude Code GitHub Action v1** (auf dem Agent SDK) reagiert auf `@claude`-Mentions in Issues/PRs oder laeuft prompt-getrieben (Cron/Events), kann Plugins/Skills im CI laden und wird ueber `claude_args` (z. B. `--max-turns`) begrenzt; Betrieb auf GitHub-Runnern, API-Key als Secret [V]. Fuer Andreas sinnvoll als asynchroner Kanal ("Issue anlegen → Claude baut PR"), mit `--max-turns`, Concurrency-Limits und Timeout als Kostenbremse.

## 3. Container auf Windows: WSL2, wslc, Dev Containers vs. nativer Betrieb

Neu 2026: **WSL Containers (wslc.exe)**, auf der Build 2026 angekuendigt und seither in Public Preview — OCI-Container laufen nativ ueber WSL ohne Docker Desktop, CLI weitgehend Docker-syntaxkompatibel inkl. `--gpus all`, dazu eine Windows-API fuer programmatische Nutzung. Grenzen: kein Docker-Compose-Support (als "top feature ask" anerkannt), kein USB-Passthrough, CLI explizit fuer Entwicklung positioniert; benoetigt WSL 2.9.3 Pre-Release [V]. Docker Desktop, Podman Desktop und Rancher Desktop bleiben als Aufsaetze bestehen [S].

Bewertung fuer Andreas — wann lohnt Containerisierung wirklich:

- **Dev/Test-Reproduzierbarkeit: ja.** Wegwerf-Postgres/Redis fuer Integrationstests (Testcontainers-Muster), identische Toolchains, Paritaet zum `ubuntu-latest`-CI-Runner. Das reduziert "works on my machine" und macht hermetische Testgates glaubwuerdig. WSL2 ist ohnehin gesetzt, weil die Claude-Code-Sandbox es braucht — Container sind dort ein kleiner Zusatzschritt.
- **Dev Containers: pilotgeeignet.** Fuer Projekte mit heiklen Abhaengigkeiten oder fuer vollautonome Laeufe (Anthropic dokumentiert die Devcontainer-Konfiguration als Weg, `--dangerously-skip-permissions` als Non-Root sicher zu nutzen [V, Sandbox-Doku]). Fuer die Mehrzahl der 11 Projekte reicht WSL2 + Sandbox.
- **Produktion auf dem eigenen Windows-Server: nein (derzeit).** Linux-Container auf einem Windows-Server bedeuten eine zusaetzliche Virtualisierungsschicht, wslc ist Preview und ausdruecklich nicht fuer Produktions-CLI-Betrieb gedacht, und Andreas' Stacks (FastAPI/Django/Astro, SQLite/DuckDB/PostgreSQL) laufen nativ unproblematisch. Native Windows-Dienste via WinSW/NSSM plus Scheduled Tasks sind einfacher zu betreiben, zu ueberwachen und im Fehlerfall zu debuggen. Erst bei einer Migration auf einen Linux-VPS wuerde Docker Compose als Deployment-Einheit (ggf. mit Coolify/Dokploy [S]) zur ersten Wahl.

## 4. IaC fuer Kleinumgebungen und Reverse Proxies

Terraform/OpenTofu fuer einen einzelnen Heimserver ohne Cloud-Ressourcen ist ueberdimensioniert [S, Konsens der IaC-Uebersichten 2026]. Angemessen ist "Infrastruktur als reproduzierbares Skript": idempotente PowerShell-Setup-Skripte im Repo (winget-Manifeste, Dienst-Registrierung, Firewall-Regeln), von Claude Code gepflegt und getestet — dieselbe Auditierbarkeit bei einem Bruchteil des Overheads. Sinnvoll unter Bedingungen: OpenTofu/Terraform punktuell fuer Cloudflare-DNS/Tunnel-Konfiguration und Tailscale-Policy (beide haben Provider), weil dort Drift real weh tut. PowerShell DSC v3 und Ansible-ueber-SSH bleiben Beobachtungskandidaten [S].

**Reverse Proxy**: Caddy ist fuer Kleinumgebungen die beste Wahl — automatisches HTTPS, Zero-Downtime-Reload, laeuft auf Windows als Dienst via `sc.exe` oder besser WinSW (XML-Konfig, Log-Rotation, graceful reload) [V]. In Andreas' Topologie terminiert fuer oeffentliche Domains ohnehin der Cloudflare Tunnel; Caddy dient dann als lokaler Router/Virtual-Host-Multiplexer vor den FastAPI/Django/Astro-Diensten. Tailnet-intern uebernimmt **Tailscale Serve** dieselbe Rolle inklusive automatischer HTTPS-Zertifikate und Identity-Headers (Login/Name des zugreifenden Nutzers) — fuer interne Weboberflaechen ist das ein kostenloses SSO-Light [V].

## 5. Tailscale Funktionsumfang 2026

Aus dem Changelog [V]: **Grants** (GA 5/2025) ersetzen die klassische ACL-Syntax und vereinen Netz- und Anwendungsschicht; dazu Visual Policy Editor (GA 10/2025). **Tailscale Services** (GA 1/2026) entkoppeln Dienste per virtueller IP vom Host-Geraet — interessant, um z. B. die NFL-Plattform unter stabiler Service-Adresse anzubieten, unabhaengig davon, welcher Rechner sie gerade hostet. **Peer Relays** (GA 2/2026) fuer High-Throughput ohne DERP. **Workload Identity Federation** (GA 2/2026) erlaubt GitHub-Actions-Workflows den Tailnet-Beitritt ueber OIDC statt statischer Secrets. Seat-Billing seit 4/2026; der Personal-Plan umfasst nun sechs kostenlose Nutzer. Node Key Sealing (verschluesselter State) ist auf Windows/Linux Default (10/2025).

**Tailscale SSH**: Der SSH-Server laeuft nur auf Linux und macOS — **Windows kann nicht Tailscale-SSH-Ziel sein**, nur Client [V]. Fuer den Windows-Server heisst Fernzugriff daher: Microsofts **OpenSSH Server** (Feature-on-Demand; in Windows Server 2025 vorinstalliert, nur zu aktivieren) mit Key-Auth und PowerShell als Default-Shell, erreichbar ausschliesslich ueber den Tailnet [V]; alternativ PowerShell-Remoting/WinRM oder RDP ueber Tailscale. **Funnel** bleibt das Werkzeug fuer punktuelle oeffentliche Freigaben (Demo-Links), waehrend dauerhafte oeffentliche Produkte beim Cloudflare Tunnel bleiben — ein Port kann nicht gleichzeitig Serve und Funnel bedienen [V].

## 6. Automatisierte Deployments, Rollback, Backup, Restore

Drei Muster fuer Deployments auf den eigenen Windows-Server:

1. **GitHub-hosted Runner + Tailscale GitHub Action (empfohlen):** Der Workflow tritt per Workload Identity Federation als ephemerer, `tag:ci`-gebundener Node in den Tailnet ein (Node wird nach dem Job automatisch entfernt), Grants beschraenken ihn auf Port 22 des Servers, Deployment laeuft ueber OpenSSH/PowerShell [V]. Keine eingehenden Ports, keine statischen Langzeit-Secrets, jede Zustellung als Actions-Run auditierbar.
2. **Self-hosted Runner auf dem Server:** einfacher, aber der Runner ist dauerhafte RCE-Oberflaeche; nur fuer private Repos, dediziertes Konto, kein Zugriff auf fremde Workloads [V, GitHub-Hardening].
3. **Pull-basiert:** Scheduled Task pollt GitHub Releases und installiert signierte Artefakte. Robustestes Muster fuer die vollautonome NFL-Plattform (kein eingehender Kanal, Server zieht selbst), um den Preis hoeherer Latenz.

**Rollback-Faehigkeit** entsteht durch Struktur, nicht durch Werkzeuge: versionierte Release-Verzeichnisse (`releases\2026-07-28_git-sha\`), ein `current`-Junction, Dienststopp → Umschalten → Dienststart via WinSW/NSSM, danach Health-Check-Endpoint; bei Fail automatisches Zurueckschalten. DB-Migrationen expand/contract halten, damit Rollback ohne Schema-Ruecknahme moeglich bleibt. Jedes Deployment schreibt ein Run-Manifest (Commit, Artefakt-Hash, Testlauf-Referenz, Health-Ergebnis) — das verbindet Andreas' bestehende Manifest-Praxis mit dem Betrieb.

**Backup/Restore:** restic (dedupliziert, verschluesselt, Windows inkl. VSS-Support [S]) fuer Dateien/Konfiguration auf lokales Zweitmedium plus S3-kompatiblen Cloud-Speicher (3-2-1 light). Fuer SQLite ist **Litestream v0.5** (10/2025) der Standard: Sidecar-Prozess streamt WAL-Aenderungen in Objektspeicher, neues transaktionsbewusstes LTX-Format mit hierarchischer Kompaktion (30 s/5 min/1 h), Point-in-Time-Restore ohne Voll-Download, CGO-frei [V]; Windows-Betrieb ist zu validieren (die Ankuendigung nennt Windows nicht explizit). PostgreSQL: geplantes `pg_dump` reicht im Privatkontext. Entscheidend: **Restore-Proben als Scheduled Task** (Backup in Temp-Verzeichnis wiederherstellen, Integritaet pruefen, Healthchecks-Ping) — ein Backup ohne geprobten Restore ist Hoffnung, kein Verfahren.

## 7. Observability fuer Kleinumgebungen

Zweischichtiges Minimalmodell mit klarer Aufgabenteilung [V, futurion-Analyse]:

- **Aussensicht:** Uptime Kuma probt HTTP/TCP/DNS und alarmiert bei Ausfall/TLS-Problemen — idealerweise nicht auf dem ueberwachten Server selbst (Who-watches-the-watcher), sondern auf einem Zweitgeraet oder extern.
- **Dead-Man-Switch:** Healthchecks.io (SaaS-Free-Tier genuegt) fuer Scheduled Tasks, Backups, Restore-Proben und Deploy-Jobs — "silent automation death" (Backups seit drei Wochen tot, Website trotzdem gruen) ist fuer externe Probes unsichtbar. Beide kombiniert sind der belastbare Standard fuer Solo-Betreiber.

**OpenTelemetry:** Als Instrumentierungs-Standard im Code sinnvoll (FastAPI/Django-Auto-Instrumentation, zukunftssicher, vendor-neutral); ein eigener Collector-plus-Backend-Stack (SigNoz, Grafana LGTM) ist fuer 11 Privatprojekte auf einem Windows-Server ueberdimensioniert. Pragmatisch: strukturierte JSON-Logs mit Rotation auf Platte, einheitliches Schema ueber alle Projekte — **agentenfreundliche Observability**: Claude Code kann per (Remote-)Session Logs, Manifeste und Health-Endpoints direkt lesen und diagnostizieren; das ist im Privatkontext wertvoller als Dashboards. Optional Pydantic **Logfire** als verwaltetes OTel-Backend mit FastAPI/Pydantic-Naehe [S] — pilotgeeignet, Datenschutz (Cloud) abwaegen. Alerting: ntfy/Pushover-Push aus Healthchecks/Kuma genuegt.

## 8. Remote-Steuerung per Smartphone und Browser

**Claude Code Remote Control** (Research Preview, Pro/Max verfuegbar) verbindet claude.ai/code bzw. die Claude-App mit einer lokal laufenden Session: Ausfuehrung und Dateisystem bleiben auf dem eigenen Rechner, die Verbindung ist outbound-only ueber die Anthropic-API (keine eingehenden Ports), mit kurzlebigen, zweckgebundenen Credentials; Transcripts liegen waehrend der Verbindung auf Anthropic-Servern. Push-Benachrichtigungen kennen zwei Klassen — "Push when Claude decides" und **"Push when actions required"**: Permission-Prompts lassen sich damit vom Handy beantworten, d. h. das Handy wird zum Freigabe-Terminal fuer laufende Agentenarbeit. Server-Mode (`claude remote-control`) verwaltet bis zu 32 Sessions, optional je Session ein eigenes Git-Worktree; Trusted Devices (Team/Enterprise, Beta) bindet Zugriff an registrierte Geraete plus Biometrie [V]. Ergaenzend existieren Dispatch (Task per App an den Desktop schicken), Channels (Telegram/Discord als Ausloeser), Slack-Integration, Scheduled Tasks sowie `--teleport` zum Verschieben von Cloud-Sessions in den Terminal [V Doku-Matrix; Teleport-Details S].

**GitHub Mobile** kann Issues/PR-Triage, PR-Reviews inklusive Kommentaren, Approvals und Merges — und seit 2021 **Deployments freigeben oder ablehnen** (pending jobs mit Push-Notification) [V]; das setzt allerdings die o. g. Environment-Protection voraus, die in privaten Repos erst ab Enterprise greift [V]. Das Freigeben von Workflow-Runs aus Forks ist mobil weiterhin nicht moeglich (offene Feature-Request) [S]. Der mobile Browser auf github.com kann mehr als die App (u. a. `workflow_dispatch` ausloesen, Actions-Runs canceln).

**Was mobil moeglich sein soll (Positivliste):** Freigaben und Ablehnungen (Claude-Permission-Prompts, Deploy-Gates), Review kleiner, klar abgegrenzter Diffs, Issue-/Backlog-Pflege, Statusabruf (Dashboards read-only, Alerts), Stopp-Aktionen (Workflow abbrechen, Dienst anhalten, Claude-Session unterbrechen), Nachsteuern laufender Agenten-Sessions per Text.

**Was mobil bewusst unmoeglich sein soll (Negativliste):** Loeschen/Restore von Backups, Produktions-Restores, Aenderungen an Tailscale-Grants/ACLs, DNS/Tunnel-Konfiguration, Secrets-Anlage/-Rotation, Branch-Protection- und Repo-Settings-Aenderungen, Force-Push, Anlegen neuer Autoritaetsstufen-Ausnahmen. Begruendung: kleine Screens verhindern echtes Diff-/Blast-Radius-Verstaendnis, Mobilgeraete sind verlust- und Session-Hijack-exponiert, und asymmetrische Faehigkeiten ("Stopp geht immer, Start/Destroy nie") sind das etablierte Sicherheitsmuster. Umsetzung: Admin-Oberflaechen (Tailscale-Admin, Cloudflare, GitHub-Settings) nur mit separater, nicht auf dem Handy eingeloggter Identitaet; Grants so schneiden, dass Mobilgeraete Admin-Ports des Servers nicht erreichen; destruktive Skripte erfordern lokale Konsole.

## Konsequenzen fuer Andreas' Methodik und Projekte

1. **WSL2 zur primaeren Claude-Code-Laufzeit machen (A3+).** Sandboxing ist das fehlende OS-Level-Fundament unter den Autoritaetsstufen und existiert auf nativem Windows nicht. Native PowerShell-Sessions bleiben fuer Windows-spezifische Projekte (Infrastruktur-Transformation), dort kompensieren Deny-Rules, PreToolUse-Hooks und `sandbox.credentials`-analoge Disziplin.
2. **Methodik als privates Claude-Code-Plugin paketieren.** Hooks (Gates), Skills (STANDARD/SPRINT/HYBRID-Ablaeufe), Agents (Reviewer/Tester), Default-Settings und MCP-Konfiguration in einem versionierten Plugin ueber ein privates Marketplace-Repo — identisch in allen 11 Projekten, Aenderungen auditierbar. Das ersetzt kopierte CLAUDE.md-Fragmente.
3. **Autoritaetsstufen in PreToolUse-Hooks giessen.** A-Stufe pro Projekt/Modus als Setting; ein Hook-Skript mappt Tool-Aufrufe dagegen (deny mit Begruendung via Exit 2). PermissionRequest-Hooks koennen A5-Projekte (NFL-Plattform) definiert autonom entscheiden lassen.
4. **Run-Manifeste an `claude -p --bare` + `--json-schema` koppeln.** Autonome Laeufe liefern schema-validierte Ergebnisse inkl. Kosten und Session-ID; SessionStart/SessionEnd-Hooks schreiben Manifest-Header/-Footer. `--bare` garantiert Reproduzierbarkeit im CI.
5. **CI-Split: Linux-Runner fuer Tests, Windows nur wo noetig; Actions auf SHA pinnen, GITHUB_TOKEN read-only.** Claude Code Action fuer @claude-Issue-zu-PR-Fluesse mit `--max-turns` und Concurrency-Limit einfuehren — zuerst in zwei Projekten pilotieren.
6. **Deploy-Pfad umstellen auf: GitHub-hosted Runner → Tailscale WIF (ephemerer `tag:ci`-Node) → OpenSSH auf dem Windows-Server → versioniertes Release-Verzeichnis + `current`-Junction + WinSW-Dienst + Health-Check mit Auto-Rollback.** Keine statischen Secrets, keine offenen Ports, voll auditierbar. Die NFL-Plattform kann alternativ beim Pull-Modell bleiben; beide Muster schreiben Deploy-Manifeste.
7. **Nicht auf GitHub-Environment-Gates in privaten Repos bauen.** Mobiles Freigabe-Gate stattdessen ueber Remote-Control-Permission-Prompts ("Push when actions required") und, wo ein CI-Gate gewuenscht ist, ueber `workflow_dispatch` im mobilen Browser.
8. **Tailscale-Policy auf Grants migrieren, Serve fuer interne Weboberflaechen (Identity-Headers als SSO-Light), Services fuer die Wissensplattformen evaluieren; Funnel nur ad-hoc, Cloudflare Tunnel bleibt fuer oeffentliche Produkte.**
9. **Backup-Triade einfuehren: restic (Dateien, lokal + B2/S3), Litestream v0.5 fuer produktive SQLite-Datenbanken (nach Windows-Validierung), pg_dump fuer PostgreSQL — plus monatliche automatisierte Restore-Probe mit Healthchecks-Ping.** Restore-Faehigkeit wird Gate-Kriterium fuer A5-Betrieb.
10. **Observability-Minimum als Methodik-Baustein: einheitliches JSON-Log-Schema ueber alle Projekte, Health-Endpoints, Uptime Kuma extern + Healthchecks fuer alle Scheduled Tasks; Claude Code als erster Diagnose-Konsument der Logs.** Kein eigener OTel-Collector-Stack; OTel-SDK-Instrumentierung im Code ist erlaubte Vorbereitung.
11. **Mobile Positiv-/Negativliste formal in die Methodik aufnehmen** (Kapitel Betrieb): mobil = freigeben, reviewen, stoppen, beobachten; niemals = loeschen, wiederherstellen, Policies/Secrets/Netz aendern. Separate Admin-Identitaet ohne Mobil-Login.

## Bewertungstabelle

| Methode/Technologie | Einordnung | Kernbegruendung |
|---|---|---|
| Claude-Code-Hooks als Policy-Enforcement | jetzt empfohlen | Harte, auditierbare Durchsetzung der A-Stufen und Gates [V] |
| Claude-Code-Sandbox in WSL2 | jetzt empfohlen (A3+) | OS-Level-Isolation; auf nativem Windows nicht verfuegbar [V] |
| Headless `claude -p --bare` + `--json-schema` | jetzt empfohlen | Reproduzierbare, schema-validierte Laeufe fuer Run-Manifeste [V] |
| Methodik als Plugin (privates Marketplace) | jetzt empfohlen | Versionierte, projektuebergreifende Verteilung [V] |
| Checkpoints/`/rewind` | jetzt empfohlen (als lokales Undo) | Kein Git-Ersatz; Bash-/Subagent-Aenderungen nicht erfasst [V] |
| Claude Code Remote Control | sinnvoll unter Bedingungen | Research Preview; stark fuer Freigaben, nicht fuer kritische Admin-Pfade [V] |
| GitHub Actions CI (Linux-Runner) | jetzt empfohlen | Kontingente reichen; SHA-Pinning und Token-Minimierung Pflicht [V] |
| Claude Code GitHub Action (@claude) | sinnvoll unter Bedingungen | Kosten-/Turn-Limits noetig; ideal fuer Issue-zu-PR [V] |
| Self-hosted Runner auf dem Windows-Server | sinnvoll unter Bedingungen | Nur private Repos, dediziertes Konto; RCE-Oberflaeche [V] |
| Docker/WSL2 fuer Dev-/Test-Abhaengigkeiten | sinnvoll unter Bedingungen | Wegwerf-DBs, CI-Paritaet; kein Selbstzweck |
| WSL Containers (wslc) | pilotgeeignet / beobachten | Preview, kein Compose; koennte Docker Desktop ersetzen [V] |
| Dev Containers | pilotgeeignet | Fuer heikle Toolchains und vollautonome Laeufe [V] |
| Container im Produktionsbetrieb auf Windows-Server | ueberdimensioniert fuer den Privatkontext | Zusatzschicht ohne Nutzen; native Dienste einfacher |
| OpenTofu/Terraform fuer den Heimserver | ueberdimensioniert; fuer Cloudflare/Tailscale-Konfig sinnvoll unter Bedingungen | Drift-Schutz nur dort, wo er weh tut [S] |
| Caddy als Reverse Proxy (WinSW-Dienst) | jetzt empfohlen | Auto-HTTPS, graceful reload, Windows-tauglich [V] |
| Tailscale Grants + Serve | jetzt empfohlen | Grants GA; Serve mit Identity-Headers als internes SSO-Light [V] |
| Tailscale Services / Peer Relays | pilotgeeignet | Frisch GA (1–2/2026); Nutzen fuer Dienst-Entkopplung pruefen [V] |
| Tailscale GitHub Action + Workload Identity Federation | jetzt empfohlen | Secretless, ephemer, tag-beschraenkt [V] |
| Tailscale SSH zum Windows-Server | derzeit nicht belastbar | SSH-Server nur Linux/macOS; OpenSSH-Server nutzen [V] |
| restic + Litestream v0.5 + Restore-Proben | jetzt empfohlen | PITR fuer SQLite; Restore-Probe als Gate [V/S] |
| Uptime Kuma + Healthchecks (kombiniert) | jetzt empfohlen | Aussensicht + Dead-Man-Switch decken sich nicht [V] |
| Voll-OTel-Stack self-hosted (SigNoz/LGTM) | ueberdimensioniert fuer den Privatkontext | Betriebsaufwand uebersteigt Nutzen bei 11 Privatprojekten |
| Pydantic Logfire | pilotgeeignet | FastAPI-nah, verwaltet; Datenschutz abwaegen [S] |
| GitHub-Environment-Gates in privaten Repos | derzeit nicht belastbar | Protection Rules erst ab Enterprise [V] |
| "Mobile-First-DevOps" (alles vom Handy) | ueberwiegend Marketing | Asymmetrie noetig: freigeben/stoppen ja, destruktiv nie |

## Quellenverzeichnis

1. [V] Claude Code Docs — Hooks, https://code.claude.com/docs/en/hooks (2026-07-28)
2. [V] Claude Code Docs — Sandboxing, https://code.claude.com/docs/en/sandboxing (2026-07-28)
3. [V] Claude Code Docs — Headless/Agent SDK via CLI, https://code.claude.com/docs/en/headless (2026-07-28)
4. [V] Claude Code Docs — Checkpointing, https://code.claude.com/docs/en/checkpointing (2026-07-28)
5. [V] Claude Code Docs — GitHub Actions, https://code.claude.com/docs/en/github-actions (2026-07-28)
6. [V] Claude Code Docs — Remote Control, https://code.claude.com/docs/en/remote-control (2026-07-28)
7. [V] Claude Code Docs — Plugins, https://code.claude.com/docs/en/plugins (2026-07-28)
8. [V] Tailscale Changelog, https://tailscale.com/changelog (2026-07-28)
9. [V] Tailscale KB — Serve, https://tailscale.com/kb/1312/serve (2026-07-28)
10. [V] Tailscale KB — Tailscale SSH, https://tailscale.com/kb/1193/tailscale-ssh (2026-07-28)
11. [V] Tailscale Docs — GitHub Action, https://tailscale.com/docs/integrations/github/github-action (2026-07-28)
12. [V] Microsoft DevBlogs — WSL container public preview, https://devblogs.microsoft.com/commandline/wsl-container-is-now-available-for-public-preview/ (2026-07-28)
13. [V] Caddy Docs — Running (Windows/WinSW, systemd), https://caddyserver.com/docs/running (2026-07-28)
14. [V] GitHub Docs — Actions Billing, https://docs.github.com/en/billing/concepts/product-billing/github-actions (2026-07-28)
15. [V] GitHub Docs — Security hardening for GitHub Actions, https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions (2026-07-28)
16. [V] GitHub Docs — Managing environments for deployment, https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments (2026-07-28)
17. [V] Fly.io Blog — Litestream v0.5.0, https://fly.io/blog/litestream-v050-is-here/ (2026-07-28)
18. [V] futurion.blog — Uptime Kuma vs Healthchecks.io fuer Solo-Self-Hoster, https://futurion.blog/self-hosting-uptime-kuma-vs-healthchecks-io-honest-trade-offs-for-solo-builders/ (2026-07-28)
19. [V] Microsoft Learn — OpenSSH fuer Windows (Overview), https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview (2026-07-28)
20. [V] GitHub Changelog — Reviewing Deployments on GitHub Mobile, https://github.blog/changelog/2021-04-01-reviewing-deployments-on-github-mobile/ (2026-07-28)
21. [S] Neowin — Microsoft launches WSL Containers in public preview, https://www.neowin.net/news/microsoft-finally-launches-wsl-containers-in-public-preview/
22. [S] SmartScope — WSL Containers Preview: WSLc vs Docker Engine and Compose Limits, https://smartscope.blog/en/blog/wsl-containers-public-preview-2026/
23. [S] VS Code Release Notes v1.110 / Custom Agents, https://code.visualstudio.com/updates/v1_110 und https://code.visualstudio.com/docs/agent-customization/custom-agents
24. [S] Boris Cherny (Threads) — Teleport/Remote Control Nutzung, https://www.threads.com/@boris_cherny/post/DWfjo22FKJ4/
25. [S] GitHub Community Discussion #110751 — Workflow-Run-Approval in der Mobile-App (offen), https://github.com/orgs/community/discussions/110751
26. [S] Tailscale Blog — Grants, https://tailscale.com/blog/acl-grants
27. [S] Pydantic Logfire, https://pydantic.dev/logfire
28. [S] dev.to — GitHub Actions to VPS: Zero-Trust mit Tailscale, https://dev.to/rihdusr/github-actions-to-vps-zero-trust-with-tailscale-2omf
29. [S] Litestream Projektseite, https://litestream.io/
30. [S] ComputingForGeeks — Best IaC and Cloud Automation Tools 2026, https://computingforgeeks.com/best-infrastructure-as-code-iac-cloud-automation-tools/
