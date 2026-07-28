# Dossier 16: Windows-Server- und Datenbank-Administration durch KI-Agenten

**Stand: 2026-07-28 | Recherche-Agent fuer Andreas | Feld: Server-/DB-Ops durch Agenten (VPS via Tailscale, SQLite/DuckDB/PostgreSQL/Directus)**

## Executive Summary

Der Moeglichkeitsraum fuer agentische Server- und DB-Administration ist 2026 real, aber ungleich gereift: Die Bausteine fuer einen **read-only Ops-Agenten sind heute belastbar**, waehrend schreibende Fernadministration von Windows via MCP noch Bastelstatus hat. Erstens: Claude Code unterstuetzt **offiziell Windows Server 2019+ nativ** (PowerShell/CMD als Shell, eigenes PowerShell-Tool), und der Headless-Modus (`claude -p --bare`) ist mit `--allowedTools`, Permission-Modes, JSON-Schema-Output und Kosten-Reporting ein produktionsnahes Automationswerkzeug — damit ist "Agent laeuft AUF dem Server als Windows Scheduled Task" das robusteste Betriebsmodell fuer Andreas. Zweitens die wichtigste Einschraenkung: **Tailscale SSH als Server laeuft nicht auf Windows** — der Remote-Pfad fuehrt ueber Windows-OpenSSH-Server oder WinRM, jeweils nur durch Tailscale-ACLs getunnelt; dedizierte Windows-Admin-MCP-Server (WinRM-basiert) existieren, sind aber Kleinstprojekte ohne Nachweis von Reife. Drittens Datenbanken: Die Anthropic-Referenzserver fuer PostgreSQL und SQLite sind **archiviert**; die tragfaehigen Nachfolger sind **Postgres MCP Pro** (crystaldba, restricted read-only-Modus mit SQL-Parsing, Health-/Index-Analyse, ~3k Sterne) und der **offizielle MotherDuck/DuckDB-MCP** (lokale DuckDB-Files, read-only-Betrieb, Limits) — fuer SQLite ist die CLI unter Claude-Code-Permissions oft solider als jeder MCP. Viertens: **Directus hat MCP nativ eingebaut** (ab v11.12, dedizierter MCP-User, bestehendes Permission-Modell, Audit-Trail) — der reifste "Verwaltungs-MCP" in Andreas' Stack. Fuenftens Leitplanken: Claude-Code-**Hooks** (PreToolUse deny/ask, Audit-Logging, exit-code-2-Blockierung) plus Permission-Rules sind das konkrete Gate-Instrumentarium; natives Sandboxing fehlt unter Windows, also muessen OS-Konto, NTFS-ACLs, DB-Rollen und Firewall die zweite Verteidigungslinie stellen. GUI-Automatisierung (Windows-MCP, Claude for Chrome) ist fuer Server-Administration Notnagel, nicht Fundament — CLI-first gewinnt klar. Empfohlener Einstieg: ein unattended read-only Health-/Log-/DB-Inspektions-Agent auf dem VPS (M0-M2), Ausbau zu attended Write-Runbooks als Skills, erst danach selektiv unattended Writes.

---

## 1. Betriebsmodell A: Agent laeuft AUF dem Server

**Claude Code nativ auf Windows Server.** Die offizielle Doku nennt als Systemvoraussetzung explizit "Windows 10 1809+ oder **Windows Server 2019+**", Shells Bash/Zsh/**PowerShell/CMD**; Installation per `irm https://claude.ai/install.ps1 | iex` oder WinGet. Ohne Git for Windows nutzt Claude Code ein **PowerShell-Tool** als Shell-Ersatz; mit Git for Windows das Bash-Tool (Git Bash), und ein natives PowerShell-Tool rollt als Zusatzoption aus (`CLAUDE_CODE_USE_POWERSHELL_TOOL=1`). Wichtig fuer die Risikoanalyse: **Sandboxing wird unter nativem Windows nicht unterstuetzt** (nur WSL2) — Isolierung muss also aus Permissions, Hooks und dem OS-Konto kommen. [Q1]

**Headless-Betrieb (`claude -p`)** ist inzwischen ausgereift und dokumentiert als Automationspfad: `--bare` (empfohlen fuer Skripte, kuenftig Default) laedt keine Hooks/Skills/MCP/CLAUDE.md aus der Umgebung — deterministisch fuer geplante Laeufe, alles Noetige wird explizit per `--settings`, `--mcp-config`, `--append-system-prompt` uebergeben. `--allowedTools "Bash(git diff *)"` nutzt Permission-Rule-Syntax; `--permission-mode dontAsk` verweigert alles ausserhalb der Allow-Liste (ideal fuer unattended read-only), `acceptEdits` fuer Datei-Workflows. `--output-format json` liefert `total_cost_usd` und Session-ID; mit `--json-schema` erzwingt man **strukturierte Reports** (perfekt fuer Health-Check-Pipelines). Stdin-Pipes sind auf 10 MB begrenzt (grosse Logs als Datei referenzieren); SIGTERM beendet sauber mit SessionEnd-Hooks und Exit 143 — kompatibel mit Windows Scheduled Tasks als Supervisor. Authentifizierung headless via `ANTHROPIC_API_KEY` oder `apiKeyHelper` (Bare-Mode liest keinen OAuth/Keychain). [Q2]

**Scheduling.** Der pragmatische Weg auf Andreas' VPS: Windows Scheduled Task startet einen PowerShell-Wrapper, der `claude -p --bare` mit Prompt-Datei, Allowlist und JSON-Schema aufruft, Output archiviert und bei Befund eskaliert (Mail/ntfy). Daneben existieren **native "Scheduled Tasks"/Routinen in Claude Code selbst** (die Doku referenziert `/docs/en/scheduled-tasks`; Skills koennen als Prompt einer geplanten Aufgabe feuern) [Q3]; Dritt-Guides beschreiben zusaetzlich Auto Mode, `/goal` (Zielbedingung statt Turn-Ende) und cloudseitige Routinen mit Mindestintervall 1 h [Q4 — Drittquelle, Kernaussagen plausibel, im Detail nicht offiziell verifiziert]. Fuer Andreas' Kontrollanspruch bleibt der Windows-Task-Weg erste Wahl: Er ist auditierbar, offline testbar und haengt nicht an Anthropic-Cloud-Scheduling.

**Agent SDK.** Fuer Dauerbetrieb jenseits von Einzellaeufen bietet das Agent SDK (Python/TypeScript) dieselbe Loop mit Tool-Approval-Callbacks und Message-Objekten — Andreas koennte einen kleinen FastAPI-Dienst als "Ops-Agent-Daemon" bauen, der Webhooks (Alerts) entgegennimmt und pro Ereignis eine Session mit eng gescopter Allowlist startet. [Q2]

**Codex CLI (OpenAI)** laeuft laut offizieller Doku **nativ unter Windows in PowerShell mit Windows-Sandbox** (alternativ WSL2), hat `exec` fuer Non-Interactive-Runs, Approval-Modes und MCP-Support — als Zweitmeinungs-Agent oder Vergleichsbaustein pilotgeeignet, fuer Andreas' Claude-zentrierte Methodik aber kein Muss. [Q5]

**Risiken dieses Modells:** Der Agent hat die Rechte seines Windows-Kontos; ohne Sandbox ist die Allowlist die Hauptbarriere. Gegenmittel: eigenes Servicekonto (Abschnitt 5), keine Admin-Gruppe, und fuer unattended Laeufe ausschliesslich read-only-Kommandos in der Allowlist.

## 2. Betriebsmodell B: Agent greift REMOTE zu

**Tailscale-Realitaet zuerst:** Tailscale SSH (der eingebaute SSH-Server mit ACL-basiertem Auth, Check-Mode und Session-Recording) laeuft **nur auf Linux und macOS-Open-Source-Variante — Windows wird als Tailscale-SSH-*Server* nicht unterstuetzt**; Windows kann nur Client sein. [Q6] Konsequenz fuer den VPS: Standard-**OpenSSH-Server fuer Windows** (optionales Windows-Feature) oder **WinRM/PowerShell-Remoting** betreiben und den Zugang rein netzseitig ueber Tailscale-ACLs (nur Andreas' Geraete auf Port 22/5985/5986) einschraenken. Session-Recording aus Tailscale SSH entfaellt damit; Audit muss auf dem Server passieren (PowerShell-Transcription, Event-Logs).

**SSH-MCP-Server:** Der reifste generische Kandidat ist **tufantunc/ssh-mcp** (TypeScript, offizielles MCP-SDK, ~474 Sterne, v1.5.0 Jan 2026): Tools `exec` und `sudo-exec`, Passwort- oder Key-Auth, Timeout mit aktivem Abort, dokumentierte Unterstuetzung fuer Windows-Ziele. [Q7] Damit kann Claude Code auf dem Laptop PowerShell-Befehle auf dem VPS ausfuehren — jede Ausfuehrung laeuft als normales MCP-Tool durch Andreas' Permission-Gates. Alternativen wie classfang/ssh-mcp-server existieren [Q8, S].

**Windows-Administrations-MCPs:** Das Feld ist duenn. **Cosmicjedi/windows-admin-mcp** verbindet per **WinRM (5985/5986) mit SSH-Fallback** und bietet acht Tools (`diagnose_system`, `execute_command`, `check_service`, `get_performance_metrics`, `view_logs`, `apply_solution` u. a.); Credentials werden zur Laufzeit uebergeben, nicht gespeichert — aber: 5 GitHub-Sterne, v2.0 vom Sep 2025, Frueh­phase ohne Sicherheitsreview. [Q9] Ein WinRM-MCP von rorymcmahon ist gelistet, war aber nicht direkt abrufbar [Q10, S]. Bewertung: Konzept valide (WinRM ist der kanonische Windows-Fernverwaltungsweg), Implementierungen **derzeit nicht belastbar** — wer den Weg will, faehrt besser mit ssh-mcp + PowerShell oder eigenem Mini-MCP.

**Lokale Ausfuehrungs-MCPs (Agent auf Laptop, Ausfuehrung lokal/uebers Netz):** Der frueher verbreitete **win-cli-mcp-server ist seit Okt 2025 archiviert/deprecated**; der Maintainer verweist auf **DesktopCommanderMCP** (~6,3k Sterne: Terminal, Prozesse, Datei-Edits, SSH-Sessions, Audit-Logging; Achtung: `allowedDirectories` gilt nur fuer Dateioperationen, "terminal commands can still access files outside allowed directories"). [Q11][Q12] Fuer Andreas' Setup ist das weitgehend redundant zu Claude Codes eigenen Tools.

**GUI-/RDP-Automatisierung vs. CLI-first:** **CursorTouch/Windows-MCP** (~6,1k Sterne) steuert Windows auf GUI-Ebene (Click/Type/Snapshot/Screenshot plus PowerShell), mit 0,2-0,5 s Latenz pro Aktion, Praeferenz fuer englischsprachige UI und explizitem Hinweis auf irreversible Operationen bei vollen Rechten. [Q13] Microsoft baut derweil **natives MCP-/Agent-Framework in Windows 11** (Insider-Builds mit File-Explorer-/Settings-Konnektoren und MCP-Registry) — Windows 11, nicht Server, Status Preview [Q14, S]. Klare Einordnung: Fuer Server-Administration ist GUI-Automation fehleranfaellig und schlecht auditierbar; **CLI-first (PowerShell) ist der richtige Default**, GUI/Browser-Automation nur fuer die seltenen Faelle ohne API (z. B. VPS-Provider-Panel) und dann attended. Am Rande: Tailscale selbst baut mit **Aperture** einen MCP-Proxy, der mehrere Remote-MCP-Server hinter einem `/v1/mcp`-Endpoint mit identitaetsbasierten Grants aggregiert — Alpha, aber strategisch interessant als kuenftige zentrale MCP-Zugriffsschicht im Tailnet. [Q15]

## 3. Datenbank-MCPs und -Tools

**Grundsatz:** Die MCP-Referenzserver fuer **PostgreSQL, SQLite und Redis wurden von Anthropic archiviert** (Repo `servers-archived`); Discovery laeuft heute ueber die offizielle Registry (registry.modelcontextprotocol.io). Archivierte Server sind unmaintained und sollten nicht produktiv eingesetzt werden. [Q16]

**PostgreSQL — klare Empfehlung: Postgres MCP Pro (crystaldba/postgres-mcp, ~3k Sterne).** Zwei Modi: *unrestricted* (Dev) und **restricted** (Prod): read-only-Transaktionen, SQL-Parsing via pglast, das COMMIT/ROLLBACK-Umgehungen blockt, plus Ausfuehrungszeit-Limits. Werkzeuge weit ueber Query hinaus: `list_schemas`/`list_objects`/`get_object_details` (Schema-Introspektion), `execute_sql`, `explain_query` inkl. **hypothetischer Indizes**, `get_top_queries`, `analyze_workload_indexes`, `analyze_db_health` — also genau die DBA-Inspektionsfaehigkeiten, die ein Ops-Agent braucht. Transport stdio und SSE. [Q17] Defense in Depth: restricted Mode **zusaetzlich** zu einer read-only DB-Rolle, nicht statt ihrer.

**DuckDB — offizieller MotherDuck/DuckDB-MCP (motherduckdb/mcp-server-motherduck, ~488 Sterne).** Unterstuetzt lokale DuckDB-Dateien, `:memory:`, S3 und MotherDuck-Cloud; laut aktuellem README **read-only als sicherer Default** mit explizitem `--read-write`-Flag, dazu `--max-rows`/`--max-chars`, `--query-timeout`, SaaS-Mode zur Dateisystem-Abschottung; Tools `execute_query`, `list_databases/tables/columns`. [Q18] Praxis-Hinweis: DuckDB kann per Extension auch SQLite-Dateien und PostgreSQL anbinden — der DuckDB-MCP taugt damit als **einheitliche read-only-Analysefront ueber Andreas' gesamten Datenbestand** (dieser Extension-Weg ist Standard-DuckDB-Funktionalitaet, im MCP-README nicht explizit beworben).

**SQLite — Luecke mit pragmatischer Loesung.** Der Referenzserver ist archiviert und wird in Analysen als verwundbar/verwaist kritisiert [Q19, S]. Multi-DB-Alternative: **executeautomation/mcp-database-server** (~351 Sterne; SQLite, SQL Server, PostgreSQL, MySQL; getrennte `read_query`/`write_query`-Tools, Schema-Inspektion, CSV/JSON-Export — aber keine formalen Releases, kein hartes read-only-Enforcement). [Q20] Ehrliche Einschaetzung: Fuer SQLite/DuckDB-Dateien auf dem eigenen Server ist **die CLI (`sqlite3`, `duckdb`) unter Claude-Code-Permission-Rules oft die robustere Wahl** — z. B. `Bash(sqlite3 -readonly *)` in der Allowlist, Datei-ACLs read-only fuer das Agentenkonto, oder Arbeit auf Kopien/Snapshots. Weniger Moving Parts, gleiche Gate-Mechanik.

**Directus — der reifste Baustein im Stack.** MCP ist **nativ in Directus ab v11.12** integriert: aktivieren unter Settings → AI, **dedizierter MCP-User mit eigenem Token**, Agent operiert strikt innerhalb des bestehenden Directus-Permission-Modells (Rollen/Policies), vollstaendiger Audit-Trail, optionale globale Delete-Protection — die allerdings **default-off** ist und von Andreas sofort aktiviert werden sollte. Tools decken Items, Collections/Schema, Files und Flows ab. [Q21] Das ist das Musterbeispiel eines "Verwaltungs-MCP mit eingebauten Gates": Rechtevergabe passiert im Zielsystem, nicht im Agenten.

**Monitoring-Anschluss (perspektivisch):** Der **offizielle Grafana-MCP** (grafana/mcp-grafana, ~3k Sterne, v0.14) bietet `--disable-write` fuer reinen Lesebetrieb, abschaltbare Tool-Kategorien, PromQL/Loki-Queries, Alerting/Incident/OnCall — relevant, falls Andreas je einen Metrik-Stack aufsetzt; fuer den einzelnen VPS vorerst ueberdimensioniert. [Q22]

## 4. Betriebsautomatisierung: Health, Logs, Runbooks, Backups

**Health-Checks als geplanter Read-only-Lauf.** Muster: Scheduled Task → `claude -p --bare` mit Allowlist aus rein lesenden PowerShell-Kommandos (`Get-Service`, `Get-Counter`, `Get-WinEvent`, `Get-PSDrive`, Zertifikats- und Backup-Alter) plus Postgres-MCP restricted (`analyze_db_health`) → Report per `--json-schema` (Felder: status, findings[], recommended_actions[]) → Ablage in Git + Benachrichtigung nur bei Befund. Der Agent liefert den Mehrwert der **Interpretation** (Anomalien, Korrelation ueber Quellen), nicht der Messung.

**Log-Triage.** Event-Logs und App-Logs (FastAPI/Django, Caddy/IIS) per PowerShell vorfiltern (letzte 24 h, Level Error/Warning), als Datei referenzieren (10-MB-stdin-Grenze [Q2]), Agent clustert, dedupliziert, hebt Neues hervor. Unattended voellig unkritisch, solange die Allowlist lesend bleibt.

**Runbooks als Skills.** Claude Codes Skill-Mechanik passt exakt auf Andreas' Runbook-Idee: `SKILL.md` mit Prozedur + gebuendelten Skripten; `disable-model-invocation: true` stellt sicher, dass **nur der Mensch** (oder eine explizit konfigurierte geplante Aufgabe) das Runbook ausloest, nie der Agent aus Eigeninitiative; `allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/restart-service.ps1 *)` erlaubt genau das mitgelieferte Skript ohne Prompt; `disallowed-tools` entzieht autonomen Skills gefaehrliche Tools; `context: fork` isoliert die Ausfuehrung in einem Subagenten. [Q3] Damit werden Runbooks versionierbare, testbare Artefakte im Repo — Quality-Gate-faehig.

**Backup/Restore.** Empfehlung (Synthese, kein Produktbefund): Das Backup selbst bleibt **deterministisches Skript** (pg_dump/`pg_basebackup`, Datei-Snapshots via VSS/robocopy, Directus-Schema-Export) unter Windows Task Scheduler — kein LLM im kritischen Pfad. Der Agent uebernimmt die **Verifikation**: taeglich Alter/Groesse/Checksummen pruefen, woechentlich attended einen Restore-Test in eine Wegwerf-Datenbank fahren und das Ergebnis protokollieren. Restore in Produktion ist immer attended (A-Stufe hoch), mit Runbook-Skill.

**Alert-Reaktion.** Realistische Stufe 2026: Alert → Agent erstellt unattended eine **Diagnose** (read-only) und einen Massnahmenvorschlag → Mensch gibt frei → Runbook-Skill fuehrt aus. Vollautonome Remediation nur fuer idempotente, reversible Einzelaktionen (z. B. Neustart eines definierten Dienstes) mit Audit und Rate-Limit.

## 5. Sicherheitsleitplanken konkret

- **Identitaet:** Eigenes Windows-Konto `svc-claude` (kein Administrator, "Log on as a batch job"), NTFS-ACLs: read-only auf Log-/Datenpfade, Schreibrechte nur im Arbeitsverzeichnis. Getrennte DB-Identitaeten: PostgreSQL-Rolle `agent_ro` mit `pg_read_all_data` bzw. gezielten GRANT SELECT und `ALTER ROLE ... SET default_transaction_read_only = on`; Directus-MCP-User mit minimaler Policy. Kurzlebigkeit: Tokens rotieren (Directus), DB-Passwoerter nur im Task-Kontext injizieren, nichts in CLAUDE.md/Repo.
- **Gates in Claude Code:** Permission-Rules/`--allowedTools` als erste Schicht; **Hooks** als zweite: PreToolUse-Hook prueft jedes Bash/MCP-Tool-Call-Input, kann `deny`/`ask`/`allow` zurueckgeben (z. B. "DELETE/DROP → ask", "rm/Remove-Item -Recurse → deny"), Exit-Code 2 blockt hart; Command-Hooks schreiben jedes Tool-Event in ein Append-only-Audit-Log; `dontAsk`-Mode fuer unattended Laeufe verweigert alles Ungelistete. [Q23]
- **Kein Windows-Sandboxing:** Da natives Sandboxing fehlt [Q1], gilt: Was das Konto darf, kann der Agent im schlimmsten Fall tun. Also Rechte am Konto minimieren, nicht nur am Prompt.
- **Egress:** Windows-Firewall-Ausgangsregeln fuer das Agentenkonto/den Prozess auf Anthropic-API + benoetigte Ziele begrenzen (bzw. Proxy mit Allowlist); Tailscale-ACLs begrenzen eingehend auf Andreas' Geraete.
- **Notausschalter:** (1) Scheduled Task deaktivieren, (2) Kill-Datei (`C:\ops\HALT`), die ein SessionStart/PreToolUse-Hook prueft und mit `continue:false` abbricht, (3) API-Key rotieren, (4) DB-Rolle `NOLOGIN`, (5) Tailscale-ACL ziehen. Alle fuenf dokumentiert im Repo, Wiederanlauf nur attended.

**Mapping auf Andreas' Faehigkeitsklassen (Vorschlag):**

| Aktionsklasse | Beispiele | M-Klasse | Modus |
|---|---|---|---|
| Lokal lesen (Server-Selbstinspektion) | Get-Service, Logs, sqlite3 -readonly, DuckDB-MCP read-only | M0 | unattended ok |
| Remote lesen | ssh-mcp mit read-only-Allowlist, Postgres MCP restricted, Directus-MCP read-Policy, Grafana `--disable-write` | M2 | unattended ok (nach Pilotphase) |
| Lokal/remote schreiben, reversibel | Dienst-Neustart, Cache leeren, Directus-Item-Update, INSERT in Staging | M3 | attended; unattended nur per Runbook-Skill mit Audit |
| Schreibend, schwer reversibel | Schema-Migration, DROP, Restore, Registry, Updates | M3 (hohe A-Stufe) | immer attended, Zwei-Schritt (Plan → Freigabe → Ausfuehrung) |
| UI-/Desktop-Automation | Windows-MCP, Claude for Chrome (Provider-Panel, Directus-Admin-UI) | M4 | nur attended, nur ohne API-Alternative |

## Konsequenzen fuer Andreas' Methodik und Projekte

1. **Betriebsmodell festlegen: "Agent auf dem Server" als Primaerpfad.** Claude Code laeuft offiziell auf Windows Server 2019+; `claude -p --bare` unter einem Scheduled Task ist auditierbar und passt zu seiner PowerShell-nativen Umgebung. Remote-MCP (ssh-mcp vom Laptop) als Sekundaerpfad fuer interaktive attended Sessions. Windows-Admin-MCPs (WinRM) beobachten, nicht einsetzen.
2. **Tailscale-Architektur korrigieren:** Kein Tailscale-SSH-Server auf Windows — stattdessen Windows-OpenSSH + Tailscale-ACLs; Audit serverseitig (PowerShell-Transcription, Event-Log-Weiterleitung ins Ops-Repo).
3. **DB-Standard setzen:** Postgres MCP Pro im restricted Mode + `agent_ro`-Rolle als PostgreSQL-Norm (M2); DuckDB-MCP read-only als Analysefront auch fuer SQLite-Bestaende; SQLite direkt per CLI-Allowlist; Directus-MCP mit dediziertem User aktivieren und **Delete-Protection einschalten**.
4. **Runbooks als Skills institutionalisieren:** Jede wiederkehrende Ops-Prozedur als `SKILL.md` mit `disable-model-invocation: true` + eng gescoptem `allowed-tools` — das ist die technische Form seiner Autoritaetsstufen: Die A-Stufe entscheidet, ob ein Runbook attended oder als geplante Aufgabe laufen darf.
5. **Gate-Bibliothek bauen:** Ein wiederverwendbares `.claude/`-Profil "ops-readonly" (Allowlist, dontAsk, Audit-Hook, Kill-File-Hook) und ein Profil "ops-runbook" (ask fuer Writes, Audit) — versioniert, projektuebergreifend.

**Einstiegs-Pilot (risikoarm, 1-2 Wochenenden):**
- **Stufe 0 (M0/M2, unattended):** `svc-claude`-Konto + `agent_ro`-DB-Rolle anlegen; taeglicher Scheduled Task: Health-Report (Dienste, Disk, Event-Log-Fehler, Backup-Alter, `analyze_db_health`, Directus-`/server/health` via read-User) als JSON-Schema-Output ins Ops-Repo; Benachrichtigung nur bei Befund; Kill-File + Audit-Hook von Tag 1.
- **Stufe 1 (attended):** Interaktive Admin-Sessions auf dem Server (SSH/VS Code Remote), Writes im ask-Modus; erste Runbook-Skills: "Dienst-Neustart", "Log-Triage tief", "pg_dump-Verify".
- **Stufe 2 (selektiv unattended M3):** Genau ein reversibles Runbook (z. B. Neustart eines definierten App-Dienstes bei Health-Fail) unattended freigeben — mit Rate-Limit, Audit, Rollback-Pfad; vier Wochen Bewaehrung, dann naechstes.
- **Stufe 3 (beobachten):** Claude-Code-Routinen/Cloud-Scheduling, Tailscale Aperture, Windows-natives MCP — quartalsweise neu bewerten.

## Bewertungstabelle

| Baustein | Kern | Bewertung |
|---|---|---|
| Claude Code headless auf Windows Server (Scheduled Task) | `-p --bare`, Allowlist, JSON-Schema | **jetzt empfohlen** |
| Claude Code Hooks + Permission-Rules als Gates | PreToolUse deny/ask, Audit | **jetzt empfohlen** |
| Postgres MCP Pro (crystaldba) restricted | read-only, Health/Index/Explain | **jetzt empfohlen** |
| Directus nativer MCP (v11.12+) | eigener User, Permission-Modell, Audit | **jetzt empfohlen** (Delete-Protection aktivieren) |
| MotherDuck/DuckDB-MCP | lokale Files, read-only Default, Limits | **jetzt empfohlen** (read-only) |
| SQLite/DuckDB per CLI-Allowlist statt MCP | sqlite3 -readonly, Kopien | **jetzt empfohlen** |
| ssh-mcp (tufantunc) vom Laptop zum VPS | exec ueber Tailnet-OpenSSH | **sinnvoll unter Bedingungen** (attended, Allowlist serverseitig) |
| Runbooks als Skills mit disable-model-invocation | versionierte Prozeduren | **jetzt empfohlen** |
| executeautomation mcp-database-server | Multi-DB inkl. write | **pilotgeeignet**, kein hartes read-only |
| Grafana-MCP (offiziell) | Metrics/Alerts, --disable-write | **sinnvoll unter Bedingungen** (erst mit Monitoring-Stack), sonst ueberdimensioniert |
| Codex CLI als Zweit-Agent auf dem Server | exec, Windows-Sandbox | **pilotgeeignet** |
| Windows-Admin-/WinRM-MCPs (Cosmicjedi u. a.) | WinRM-Fernverwaltung | **derzeit nicht belastbar** (Kleinstprojekte) |
| DesktopCommanderMCP | Terminal/Dateien lokal | **beobachten** (redundant zu Claude Code; Pfad-Schutz umgehbar) |
| GUI-Automation (Windows-MCP, Claude for Chrome) fuer Server-Ops | Click/Type/Browser | **sinnvoll unter Bedingungen** (nur ohne API, attended); als Ops-Fundament **ueberdimensioniert/fehleranfaellig** |
| Windows 11 natives MCP/Agent-Framework | OS-Registry fuer Agenten | **beobachten** (Insider, nicht Server) |
| Tailscale Aperture MCP-Proxy | zentrale MCP-Schicht im Tailnet | **beobachten** (Alpha) |
| Unattended Write-Vollautonomie auf Prod-Server/DB | — | **derzeit nicht belastbar** |

## Quellenverzeichnis

1. [Q1] Claude Code Docs — Advanced setup (Windows Server 2019+, PowerShell-Tool, Sandbox-Tabelle): code.claude.com/docs/en/setup — **[V] abgerufen 2026-07-28**
2. [Q2] Claude Code Docs — Headless/`claude -p` (bare, allowedTools, json-schema, stdin-Limit): code.claude.com/docs/en/headless — **[V] 2026-07-28**
3. [Q3] Claude Code Docs — Skills (Frontmatter, disable-model-invocation, allowed-tools, scheduled tasks): code.claude.com/docs/en/skills — **[V] 2026-07-28**
4. [Q4] vybecoding.ai — "Run Claude Code Unattended: Auto Mode, /goal, Routines" — **[V] 2026-07-28**, Drittquelle/Guide
5. [Q5] OpenAI — Codex CLI Doku (exec, Approval-Modes, Windows nativ): developers.openai.com/codex/cli — **[V] 2026-07-28**
6. [Q6] Tailscale KB 1193 — Tailscale SSH (Server nur Linux/macOS-oss, ACLs, Recording): tailscale.com/kb/1193/tailscale-ssh — **[V] 2026-07-28**
7. [Q7] GitHub tufantunc/ssh-mcp (exec/sudo-exec, Timeout, v1.5.0) — **[V] 2026-07-28**
8. [Q8] classfang/ssh-mcp-server (via Glama) — **[S]**
9. [Q9] GitHub Cosmicjedi/windows-admin-mcp (WinRM/SSH, 8 Tools, 5 Sterne) — **[V] 2026-07-28**
10. [Q10] rorymcmahon WinRM-MCP (LobeHub-Listing; Direktabruf 403) — **[S]**
11. [Q11] GitHub simon-ami/win-cli-mcp-server (archiviert Okt 2025, Verweis auf DesktopCommander) — **[V] 2026-07-28**
12. [Q12] GitHub wonderwhy-er/DesktopCommanderMCP (6,3k Sterne, allowedDirectories-Caveat) — **[V] 2026-07-28**
13. [Q13] GitHub CursorTouch/Windows-MCP (6,1k Sterne, GUI-Tools, Caveats) — **[V] 2026-07-28**
14. [Q14] Windows 11 natives MCP/Agent-Framework (Windows Central, 4sysops zu Insider-Builds) — **[S]**
15. [Q15] Tailscale Docs — Aperture MCP server proxying (Alpha, /v1/mcp, Grants): tailscale.com/docs/aperture/mcp-server — **[V] 2026-07-28**
16. [Q16] GitHub modelcontextprotocol/servers (archivierte DB-Referenzserver; registry.modelcontextprotocol.io) — **[V] 2026-07-28**
17. [Q17] GitHub crystaldba/postgres-mcp (Postgres MCP Pro; restricted Mode, Tools, ~3k Sterne) — **[V] 2026-07-28**
18. [Q18] GitHub motherduckdb/mcp-server-motherduck (Flags, Limits, ~488 Sterne) — **[V] 2026-07-28**
19. [Q19] chatforest.com — Kritik am archivierten SQLite-MCP — **[S]**
20. [Q20] GitHub executeautomation/mcp-database-server (Multi-DB, read/write, ~351 Sterne) — **[V] 2026-07-28**
21. [Q21] Directus Docs — MCP-Guide (v11.12+, dedizierter User, Permissions, Delete-Protection): directus.io/docs/guides/ai/mcp — **[V] 2026-07-28**
22. [Q22] GitHub grafana/mcp-grafana (--disable-write, Kategorien, v0.14) — **[V] 2026-07-28**
23. [Q23] Claude Code Docs — Hooks (PreToolUse-Entscheidungen, Exit-Codes, Audit): code.claude.com/docs/en/hooks — **[V] 2026-07-28**
