# OpenAI- und weitere Anbieter-Oekosysteme im Vergleich: Konnektoren, Agenten, Automatisierung

**Stand:** 2026-07-28. Recherche mit 33 direkten Abrufen offizieller Verzeichnisse und Dokus; Quellenstatus [V] = selbst abgerufen am 2026-07-28, [S] = nur ueber Suche belegt.

## Executive Summary

OpenAI hat sein Automatisierungsangebot 2025/26 radikal umgebaut und dabei MCP als Fundament uebernommen: ChatGPT-"Connectors" heissen seit Dezember 2025 "Apps", basieren auf MCP und umfassen ueber 250 Eintraege; seit Juni 2026 gibt es erste Schreibaktionen (Gmail, Calendar, Docs) mit Pflicht-Bestaetigung. Der fruehere Operator bzw. ChatGPT Agent Mode ist eingestellt und im Juli 2026 durch **ChatGPT Work** ersetzt worden — einen stundenlang autonom arbeitenden Agenten mit Plan Mode, konfigurierbaren Check-ins und Auto-Review; der Atlas-Browser wird zum 9. August 2026 abgeschaltet. **Codex** ist inzwischen ein vollstaendiges Agent-Produkt (CLI, IDE-Extension, Desktop-App mit Windows-Support seit Maerz 2026, Cloud, SDK) mit AGENTS.md-Hierarchie, MCP-Client, Skills, Plugins und Automations — funktional das Gegenstueck zu Claude Code, mit experimenteller nativer Windows-Sandbox. Auf API-Ebene bieten Responses API (Remote-MCP-Tool plus acht serverseitige Connectors), Agents SDK und AgentKit einen kompletten Agenten-Baukasten. Google kontert mit Gemini CLI (Apache-2.0, grosszuegiger Free Tier, 1.182 ungepruefte Extensions), Jules und dem GA-gegangenen Workspace Studio; Microsoft mit dem Copilot Coding Agent (laeuft in GitHub Actions, default mit GitHub- und Playwright-MCP) und Copilot Studio (MCP GA). Bei den anbieterneutralen Verzeichnissen reicht das Spektrum von der offiziellen MCP Registry (Preview, ~9.650 Server-Records) ueber die kuratierten GitHub- (97 Server) und Docker-Kataloge bis zum riesigen, aber kaum kuratierten Smithery (13.400+). Der entscheidende Befund fuer Andreas: MCP ist der gemeinsame Nenner aller Anbieter und damit sein Anti-Lock-in-Hebel — ein selbst gebauter Server-Admin-MCP laeuft in Claude Code, Codex, Gemini CLI und (remote) sogar in ChatGPT. Der strukturelle Unterschied bleibt: Claude Code und die CLIs sprechen lokale stdio-Server im Tailnet; ChatGPT als Cloud-Client verlangt oeffentlich erreichbare Remote-Server und damit Exposition seines Windows-Servers. Fuer seinen privaten Windows-/Tailscale-Kontext ist deshalb wenig von der ChatGPT-Consumer-Seite direkt nutzbar, viel dagegen von Codex CLI, den Registries und dem AGENTS.md-Standard.

---

## 1. ChatGPT als Automatisierungsplattform

### 1.1 Connectors / Apps (inkl. Deep Research)

Das offizielle Hilfe-Center fuehrt Connectors inzwischen unter "Apps in ChatGPT" [V]. Kernpunkte:

- **Umfang:** Drittanbieter-Analysen zaehlen **250+ Connectors** (CRM, E-Mail, Projektmanagement, Entwickler-Tools, Analytik u.a.); OpenAI selbst verweist auf ein In-Produkt-Verzeichnis statt einer oeffentlichen Liste [V usecarly; V help.openai]. Serverseitig in der API benannt: Dropbox, Gmail, Google Calendar, Google Drive, Microsoft Teams, Outlook Calendar, Outlook Email, SharePoint (Abschnitt 3).
- **Modi:** synced connectors (vorab indexiert, schnelle Antworten) vs. **Deep-Research-Konnektoren** (mehrquellige Analysen mit Zitaten); Google Drive/Dropbox/SharePoint/Box auch ausserhalb von Deep Research [V; S OpenAI/X].
- **Schreibaktionen seit Juni 2026:** Gmail (eine Mail pro Anfrage, mit Bestaetigung), Google Calendar (Events anlegen), Google Docs/Sheets (Create) — Muster "ChatGPT schlaegt vor, Nutzer genehmigt"; Company Knowledge bleibt strikt read-only [V usecarly]. Freigabestufen: Always ask / Any changes / Important actions / Never ask [V help.openai].
- **Developer Mode (Beta):** verwandelt ChatGPT in einen vollen **MCP-Client** fuer eigene Remote-Server (SSE/Streamable HTTP, OAuth oder ohne Auth) inkl. Write-Tools; verfuegbar fuer Plus/Pro/Business/Enterprise/Edu; Write-Aufrufe zeigen das volle JSON-Payload zur Bestaetigung; OpenAI warnt explizit vor Prompt Injection und boesartigen Servern [V devops.com; S help.openai 12584461]. **Wichtig: nur Remote-Server — lokale stdio-Server wie bei Claude Desktop/Code gibt es nicht.**

### 1.2 Apps SDK und App-Verzeichnis

Am 6. Oktober 2025 startete "Apps in ChatGPT" mit den Partnern **Booking.com, Canva, Coursera, Expedia, Figma, Spotify, Zillow**; angekündigt u.a. AllTrails, Peloton, OpenTable, Target, theFork, Uber [V openai.com]. Das **Apps SDK** baut auf MCP auf (Logik + UI-Komponenten im Chat), ist Open Source; Submission-Prozess und "ChatGPT apps store" mit Review nach Quality/Safety/Policy-Standards, Self-Serve-Publishing "coming soon"; Monetarisierung ueber das Agentic Commerce Protocol geplant [V developers.openai.com/apps-sdk; V openai.com]. EU/EWR-Start verzoegert [V].

### 1.3 Custom GPTs und Actions

Der aeltere Mechanismus (GPTs mit **Actions** = OpenAPI-Schema + Bearer/OAuth) existiert weiter, wird aber strategisch vom Apps SDK ueberholt; bezeichnend: **Tasks funktionieren nicht in GPTs** [V help.openai Tasks]. Fuer Andreas nur noch historisch relevant.

### 1.4 ChatGPT Tasks (geplante Aufgaben)

- Verfuegbar fuer Plus/Pro/Business/Enterprise (Web, Mobile, Desktop); aktive Tasks: Go 3, Plus 5, Business/Edu 10, Pro/Enterprise 15 [V].
- Faehigkeiten: Erinnerungen, wiederkehrende Suchen/Monitoring ("nur melden, wenn es etwas gibt"), funktioniert mit verbundenen Apps wie Gmail [V].
- Harte Grenzen: **maximal stuendlich**, **keine Webhooks/Events**, kein Zugriff auf Projektdateien, nicht in Voice/GPTs; Tasks pausieren bei Nichtnutzung [V]. Fazit: zeitgesteuerte Mikro-Automatik, kein Automatisierungs-Backbone.

### 1.5 Operator → Agent Mode → ChatGPT Work

- **ChatGPT Agent (ehemals Operator) ist eingestellt**; die Hilfe verweist auf "ChatGPT Work" und Cloud Browser [V help.openai 11752874]. Das alte Sicherheitsmodell (Bestaetigung bei High-Impact-Aktionen, Watch Mode, Takeover Mode, Prompt-Injection-Monitoring) lebt konzeptionell weiter [V].
- **ChatGPT Work** (Launch 9./11. Juli 2026, mit GPT-5.6): Agent, der Ziele in fertige Artefakte umsetzt (Spreadsheets, Slides, Docs, Web-Apps via "Sites"), Kontext aus den verbundenen Apps zieht und stundenlang cloudseitig oder auf dem Desktop (inkl. **Computer Use auf lokalen Dateien/Apps**) arbeitet. Governance: **Plan Mode** (Plan vor Ausfuehrung genehmigen), konfigurierbare **Check-ins**, **Auto-Review** kritischer API-Aktionen. Abrechnung usage-metered. Windows-Desktop-Rollout laeuft [V digitalapplied; V alternativeto]. **Atlas-Browser: Abschaltung 9. August 2026**, Faehigkeiten wandern in ChatGPT-Desktop/Chrome-Sidebar [V alternativeto; S searchengineland].

---

## 2. Codex: OpenAIs Coding-Agent-Familie

- **CLI:** Open Source (Apache-2.0, Rust), Login per ChatGPT-Abo (Plus aufwaerts) oder API-Key; npm/brew/Binaries [V github.com/openai/codex]. Sandbox-/Approval-Modi, non-interactive `exec`, Slash-Commands, Skills, Plugins [V developers.openai.com/codex].
- **AGENTS.md:** dreistufige Hierarchie (global `~/.codex/`, Repo-Root, Unterverzeichnis; nahere Datei gewinnt), `AGENTS.override.md`, 32-KiB-Limit, offizieller Standard agents.md [V]. Gleiches Muster wie CLAUDE.md — aber als anbieteruebergreifende Konvention (auch Gemini/Jules/Copilot-Welt).
- **MCP:** Codex ist **MCP-Client** fuer stdio- und HTTP-Server (Bearer/OAuth via `codex mcp login`), Konfiguration in `~/.codex/config.toml`, `codex mcp add <name> -- <cmd>`; CLI und IDE-Extension teilen die Konfiguration. Laut aktueller Doku fungiert Codex **nicht** selbst als MCP-Server [V codex/mcp].
- **Windows:** Desktop-**App seit 4. Maerz 2026 auf Windows** [S x-cmd]; CLI nativ mit vierschichtiger Sandbox (dediziertes Sandbox-Konto/`CodexSandboxUsers`, Filesystem-ACLs, Firewall-Regeln gegen Netzzugriff, Policy-Anpassungen; Restricted Tokens statt AppContainer). Status "experimentell"; bekannte Schwaeche: Verzeichnisse mit Everyone-Schreibrecht unterlaufen die Sandbox; WSL2 (Landlock/seccomp) gilt als Produktionsempfehlung [V codex.danielvaughan.com].
- **App (Desktop):** parallele Threads mit Git-Worktrees, integriertes Terminal, Review/Commit/Push, **Automations (wiederkehrende Aufgaben)**, Computer Use (macOS-Apps), Browser Control, Bildgenerierung; Skills ueber App/CLI/IDE wiederverwendbar [V codex/app].
- **Cloud:** Aufgaben parallel in eigenen Container-Environments (Repo, Setup-Schritte, Tools konfigurierbar), Internetzugang steuerbar, GitHub-Integration mit **@codex-Tagging in Issues/PRs** und Code Review [V codex/cloud].
- **SDK/Automatisierung:** TypeScript- und Python-SDK steuern lokale Codex-Agenten programmatisch (Threads, Resume, Sandbox-Presets `read_only`/`workspace_write`/`full_access`), gedacht fuer CI/CD und eigene Tools; GitHub-Actions-Integration, Slack-/Linear-Integrationen, "Codex Security"-Plugin [V codex/sdk; V codex].

Codex ist damit funktional das direkteste Gegenstueck zu Claude Code — inklusive Headless-Betrieb fuer unattended Pipelines.

---

## 3. OpenAI API: Agenten-Baukasten

- **Responses API — Remote MCP Tool:** Modell spricht beliebige Remote-MCP-Server (`server_url`, Streamable HTTP / HTTP+SSE); Ablauf `mcp_list_tools` → `mcp_call`; **`require_approval`**: `always` / `never` / pro Tool granular, mit `mcp_approval_request`/`response`-Zyklus; OAuth-Token je Request im `authorization`-Parameter, wird nicht gespeichert; keine Extra-Gebuehr (nur Tokens). OpenAI warnt offiziell vor Prompt Injection und Daten-Exfiltration durch boesartige Server [V api/docs/guides/tools-connectors-mcp].
- **Serverseitige Connectors** in derselben API: `connector_dropbox`, `connector_gmail`, `connector_googlecalendar`, `connector_googledrive`, `connector_microsoftteams`, `connector_outlookcalendar`, `connector_outlookemail`, `connector_sharepoint` [V].
- **Agents SDK** (Python/TS): Primitive Agents / Handoffs / Guardrails / Sessions, eingebauter Agent-Loop, MCP-Server-Anbindung, Human-in-the-loop, Tracing, Sandbox-Umgebungen, Realtime-Voice [V openai.github.io].
- **AgentKit** (6. Okt 2025): **Agent Builder** (visueller Multi-Agent-Canvas, Beta), **ChatKit** (einbettbare Chat-UI, GA), **Connector Registry** (zentrale Admin-Verwaltung der Datenquellen, Beta, fuer API/Enterprise/Edu), erweiterte **Evals** [V openai.com/agentkit].
- **Function Calling** bleibt die Basisschicht (JSON-Schema-Tools), unveraendert etabliert.

---

## 4. Weitere Anbieter kompakt

### 4.1 Google

- **Gemini CLI:** Open Source (Apache-2.0, TypeScript), Free Tier ueber Google-Login **60 Requests/min, 1.000/Tag**, MCP-Support, `GEMINI.md`-Kontextdateien, Non-Interactive-Mode mit `--output-format json|stream-json`, GitHub-Integration (@gemini-cli, PR-Review, Issue-Triage) [V github.com/google-gemini/gemini-cli].
- **Gemini CLI Extensions:** Verzeichnis mit **1.182 Extensions**; prominente Partner: Dynatrace, Elastic, Figma, Stripe, Shopify, Firebase, Terraform, Kubernetes, Auth0; Installation per `gemini extensions install <github-url>`. Google erklaert ausdruecklich: **"Google does not vet, endorse, or guarantee"** — Supply-Chain-Risiko liegt beim Nutzer [V geminicli.com/extensions].
- **Jules:** asynchroner Coding-Agent (Cloud-VM, GitHub-PR-Workflow Plan→Diff→PR); Free 15 Tasks/Tag (3 parallel), Pro 100, Ultra 300 [V jules.google].
- **Workspace-Automatisierung:** Gemini-App **Scheduled Actions** (Pendant zu ChatGPT Tasks) [S blog.google]; **Google Workspace Studio** (frueher Workspace Flows) ist GA fuer Business/Enterprise: natuersprachlich erstellte Workflows ueber Gmail/Chat/Drive/Calendar/Docs/Sheets plus Konnektoren zu Asana, Jira, Mailchimp, Salesforce; eigene Gems als Flow-Bausteine [V workspace.google.com/studio; S workspaceupdates].

### 4.2 Microsoft / GitHub

- **Copilot Coding Agent:** autonome Issue→PR-Arbeit in einer **GitHub-Actions-Umgebung** (max. 59 Min./Session), fuer alle bezahlten Copilot-Plaene, Modellwahl moeglich. Default aktiviert: **GitHub MCP Server + Playwright MCP Server**; Admins koennen Custom-MCP-Server ergaenzen; Sicherheits-Layer: Branch Protection, Approvals, konfigurierbare Firewall [V docs.github.com].
- **GitHub MCP Registry** (github.com/mcp): **97 kuratierte Server**, u.a. Markitdown (Microsoft), Playwright (Microsoft), Context7 (Upstash), Chrome DevTools, GitHub, Notion, Stripe, Terraform (HashiCorp), MongoDB, Elasticsearch, Netdata, Serena [V].
- **Copilot Studio:** MCP **GA seit 29. Mai 2025** (Streamable Transport, Tool-Listing, Tracing); daneben das klassische Power-Platform-Konnektor-Oekosystem (Standard/Premium/Custom; Nutzung als Agent-Tools, in Topics, Agent Flows, Knowledge) — Governance via DLP auf Plattformebene [V microsoft.com Blog; V learn.microsoft.com]. VS-Code-Agent-Mode mit MCP ebenfalls GA [S devblogs].

### 4.3 Anbieterneutrale MCP-Verzeichnisse

| Verzeichnis | Groesse (Stand) | Kuratierung/Vertrauen |
|---|---|---|
| **Offizielle MCP Registry** (registry.modelcontextprotocol.io) | ~9.652 aktuelle Server-Records (Mai 2026); Anthropic: >10.000 aktive Server (Dez 2025) | Preview, API-Freeze v0.1 (Okt 2025); Namespace-Verifikation via GitHub-OAuth/DNS/HTTP; als **Metaregistry** fuer Subregistries gedacht, kaum inhaltliche Moderation [V github.com/modelcontextprotocol/registry; V digitalapplied] |
| **GitHub MCP Registry** | 97 Server | eng kuratiert, grosse Publisher — derzeit vertrauenswuerdigste Auswahl [V] |
| **Docker MCP Catalog** (hub.docker.com/mcp) | Hunderte, containerisiert | "Built by the community, powered by Docker"; Container-Isolation + MCP Toolkit/Gateway; konkrete Sicherheitsgarantien auf der Seite duenn [V] |
| **Smithery** | **13.477+ MCPs**, gehostet | Hosting-Modell mit zentralem OAuth-Vault (agent.pw); Masse statt Kuratierung; Datenfluss ueber Drittplattform [V smithery.ai] |

---

## 5. OpenAI vs. Claude: Faehigkeits- und Lock-in-Analyse

**Was OpenAI hat, Claude (heute) nicht:** ein Consumer-App-Oekosystem mit UI im Chat (Apps SDK, App Store); ChatGPT Work als fertig produktisierter "Arbeitsagent" mit Slides/Sheets/Sites-Artefakten und Auto-Review; native Tasks in der Consumer-App auf allen Bezahlplaenen; acht serverseitige Connectors direkt in der API; AgentKit als visueller Agent-Builder; Codex Cloud mit @codex-Tagging und integriertem PR-Review-Produkt.

**Was Claude hat, OpenAI nicht (oder schwaecher):** **lokale stdio-MCP-Server in Desktop und Claude Code** — ChatGPT kann ausschliesslich Remote-MCP, d.h. Andreas' Server muesste oeffentlich erreichbar sein; Hooks (deterministische Policy-Punkte im Agent-Loop), Subagents, granulare Permission-Modes und Skills in Claude Code; MCP als Heimprotokoll mit dem breitesten Client-Support; Claude Agent SDK als Harness-Nachbau. Codex hat mit Skills/Plugins/Automations stark aufgeholt — der Feature-Abstand schrumpft sichtbar; die Architekturdifferenz "lokal-first (Claude/CLIs) vs. cloud-first (ChatGPT)" bleibt.

**Lock-in-Punkte:** Apps SDK-Apps laufen nur im ChatGPT-Store (trotz MCP-Basis: UI-Komponenten und Review-Prozess sind proprietaer); AgentKit/Agent-Builder-Workflows sind OpenAI-gebunden; Copilot Studio zieht in das Power-Platform-Lizenzmodell (Premium-Konnektoren); Smithery-gehostete Server binden an deren Infrastruktur; ChatGPT Work ist usage-metered und nicht exportierbar. **Anti-Lock-in:** eigene MCP-Server (ein Server, alle Clients), AGENTS.md als neutraler Standard, Apache-2.0-CLIs (Codex, Gemini CLI), Function Calling/OpenAPI als kleinster gemeinsamer Nenner.

---

## 6. Konsequenzen fuer Andreas' Methodik und Projekte

1. **MCP-first als Architekturprinzip festschreiben.** Der geplante Windows-Server-Admin-MCP (PowerShell-Befehle, Scheduled-Task-Verwaltung, Dienststatus) und DB-MCPs (SQLite/DuckDB/PostgreSQL) sollten als eigene stdio-Server entstehen. Damit laufen sie unveraendert in Claude Code (M1–M3), Codex CLI und Gemini CLI — und bei Bedarf spaeter via Streamable HTTP hinter Cloudflare Tunnel auch in ChatGPT Developer Mode. Das ist der einzige Baustein, der alle Oekosysteme gleichzeitig bedient.
2. **ChatGPT-Anbindung des Servers nur als bewusste M3/M4-Entscheidung.** ChatGPT erreicht nur oeffentlich exponierte Remote-Server. Fuer den Tailnet-Kontext heisst das: Exposition + OAuth + Prompt-Injection-Flaeche. Empfehlung: vorerst nicht; Claude Code/Codex lokal im Tailnet decken denselben Bedarf ohne Public Endpoint (attended M2, unattended nur M0/M1 read-only).
3. **AGENTS.md neben CLAUDE.md pflegen** (per Include/Verweis synchron halten). Kostenloser Portabilitaetsgewinn: Codex, Gemini CLI (via Konfiguration), Jules und Copilot-Agenten lesen den Standard; die 32-KiB-Grenze von Codex als Obergrenze einplanen.
4. **Codex CLI als Zweitagent pilotieren (attended, A2–A3).** Mit bestehendem ChatGPT-Abo nutzbar; `workspace_write`-Sandbox, MCP-Konfig in config.toml, `codex exec` fuer Headless-Gates. Windows-nativ nur experimentell (Everyone-SID-Schwaeche!) — auf seinem Laptop WSL2 bevorzugen oder streng attended fahren. Nutzen: Quervalidierung von Claude-Code-Ergebnissen (Zwei-Agenten-Review als Quality Gate).
5. **ChatGPT Tasks fuer seine Zwecke ueberdimensionierter Ersatz vorhandener Mittel:** max. stuendlich, keine Webhooks, keine Projektdateien. Seine Windows Scheduled Tasks + Claude Code headless (bzw. Codex `exec`) sind praeziser, protokollierbar und hermetisch testbar. Tasks allenfalls fuer persoenliche Monitoring-Pings.
6. **ChatGPT Work beobachten, nicht einbauen.** Beeindruckende Governance-Ideen (Plan Mode, Check-ins, Auto-Review) als **Methodik-Quelle** uebernehmen — sie entsprechen exakt seinen Autoritaetsstufen und attended-Freigaben —, aber der Agent selbst ist cloud-zentriert, usage-metered und fuer Serversteuerung ungeeignet.
7. **DB-Administration ueber kuratierte MCP-Server:** PostgreSQL-, MongoDB-, Elasticsearch-Server existieren in GitHub-/Docker-Registry. Muster: Read-only-Varianten (M0/M1) unattended zulassen, Schreibzugriff (M2) nur attended mit expliziter Freigabe je Statement-Klasse — analog `require_approval: always` der Responses API, das er als Vorbild fuer seine Gate-Semantik zitieren kann.
8. **Verzeichnis-Politik:** GitHub MCP Registry und Docker MCP Catalog als bevorzugte Bezugsquellen (Kuratierung/Container-Isolation); offizielle Registry als Discovery; Smithery und Gemini-Extensions nur nach Code-Review — beide Plattformen kuratieren nicht bzw. hosten fremd.
9. **Kostenlose Zweitmeinung:** Gemini CLI Free Tier (1.000 Requests/Tag) fuer unkritische M0-Aufgaben (Recherche, Review-Kommentare) — pilotgeeignet, kein Vertrauen fuer Schreibzugriffe.

## Bewertungstabelle

| Baustein | Bewertung | Begruendung/Einsatz (M-Klasse, attended/unattended) |
|---|---|---|
| Eigene MCP-Server (Server-/DB-Admin) | **jetzt empfohlen** | Ein Server, alle Clients; M1–M3, Schreiben attended |
| AGENTS.md zusaetzlich pflegen | **jetzt empfohlen** | Neutraler Standard, minimale Kosten |
| Codex CLI (+ SDK, exec) | **sinnvoll unter Bedingungen** | Abo vorhanden, attended, Windows-Sandbox experimentell → WSL2; M0–M2 |
| ChatGPT Developer Mode (Custom Remote MCP) | **pilotgeeignet** | Nur mit oeffentlichem Endpoint + OAuth; M2 attended, nie unattended |
| ChatGPT Connectors/Apps (Consumer) | **sinnvoll unter Bedingungen** | Fuer persoenliche Daten (Gmail/Drive) ok; kein Bezug zum Server |
| ChatGPT Tasks | **ueberdimensioniert** (fuer seinen Zweck) | Max. stuendlich, keine Webhooks; Windows Scheduler + CLI schlagen es |
| ChatGPT Work | **beobachten** | Governance-Vorbild; Windows-Rollout und Preise offen |
| Apps SDK (eigene App bauen) | **beobachten** | Store/Review/EU offen; fuer Privatprojekte kein Kanal |
| Responses API MCP-Tool + Agents SDK | **pilotgeeignet** | Falls er OpenAI-API-Backends baut; require_approval-Muster uebernehmen |
| AgentKit / Agent Builder | **ueberwiegend Marketing** (fuer ihn) | Enterprise-Admin-Fokus, visueller Builder ersetzt seine Code-first-Methodik nicht |
| Gemini CLI + Free Tier | **pilotgeeignet** | M0-Zweitmeinung; Extensions ungeprueft → Einzelreview |
| Gemini-CLI-Extensions-Verzeichnis | **derzeit nicht belastbar** | 1.182 Eintraege, explizit ohne Google-Pruefung |
| Jules | **pilotgeeignet** | 15 Tasks/Tag frei, PR-Workflow passt zu A2-attended |
| Google Workspace Studio | **ueberdimensioniert** | Braucht Workspace Business/Enterprise; privater Kontext |
| GitHub Copilot Coding Agent | **sinnvoll unter Bedingungen** | Nur bei bezahltem Copilot; 59-Min-Sessions, Actions-Firewall = gutes Gate-Vorbild |
| Copilot Studio | **ueberdimensioniert** | M365/Power-Platform-Lizenzwelt |
| GitHub MCP Registry / Docker MCP Catalog | **jetzt empfohlen** (als Bezugsquelle) | Kuratierung bzw. Container-Isolation |
| Offizielle MCP Registry | **beobachten** | Preview, Discovery ja, Vertrauensanker noch nicht |
| Smithery | **derzeit nicht belastbar** | Masse ohne Kuratierung, Hosted-Datenfluss |

## Quellenverzeichnis

Alle [V]-Abrufe am 2026-07-28.

1. [V] help.openai.com — Connectors/Apps in ChatGPT (Art. 11487775)
2. [V] help.openai.com — Scheduled Tasks (Art. 10291617)
3. [V] help.openai.com — ChatGPT Agent, Einstellungs-Hinweis (Art. 11752874)
4. [V] developers.openai.com/apps-sdk — Apps SDK
5. [V] openai.com/index/introducing-apps-in-chatgpt — Partner-Apps, MCP-Basis
6. [V] devops.com — ChatGPT Developer Mode (Full MCP) | [S] help.openai.com Art. 12584461
7. [V] digitalapplied.com — ChatGPT Work Launch (9. Juli 2026) | [V] alternativeto.net — ChatGPT Work + Atlas-Abschaltung 9. Aug 2026 | [S] searchengineland.com — Atlas-Deprecation
8. [V] developers.openai.com/codex — Produktuebersicht (App/IDE/CLI/Cloud, Skills, Plugins)
9. [V] github.com/openai/codex — CLI, Apache-2.0, Rust
10. [V] developers.openai.com/codex/mcp — MCP-Client-Konfiguration
11. [V] developers.openai.com/codex/cloud — Cloud-Environments, @codex
12. [V] developers.openai.com/codex/app — Desktop-App (Windows), Automations
13. [V] developers.openai.com/codex/sdk — TS/Python-SDK, Sandbox-Presets
14. [V] developers.openai.com/codex/guides/agents-md — AGENTS.md-Hierarchie
15. [V] codex.danielvaughan.com — native Windows-Sandbox (Restricted Tokens) | [S] x-cmd.com — Codex App Windows 4. Maerz 2026
16. [V] developers.openai.com/api/docs/guides/tools-connectors-mcp — Responses API MCP + 8 Connectors
17. [V] openai.com/index/introducing-agentkit — AgentKit
18. [V] openai.github.io/openai-agents-python — Agents SDK
19. [V] github.com/google-gemini/gemini-cli — Gemini CLI
20. [V] geminicli.com/extensions — 1.182 Extensions, Vetting-Disclaimer
21. [V] jules.google — Jules-Plaene
22. [V] workspace.google.com/studio — Workspace Studio GA | [S] workspaceupdates.googleblog.com — Gems in Flows | [S] blog.google — Gemini Scheduled Actions
23. [V] docs.github.com — Copilot Coding Agent (Actions, MCP-Defaults, Firewall)
24. [V] github.com/mcp — GitHub MCP Registry (97 Server)
25. [V] microsoft.com Copilot-Blog — MCP GA in Copilot Studio (29. Mai 2025)
26. [V] learn.microsoft.com — Copilot-Studio-Connectors; Connectors-Overview
27. [V] github.com/modelcontextprotocol/registry — offizielle Registry (Preview, v0.1-Freeze) | [S] blog.modelcontextprotocol.io — Registry-Preview-Ankuendigung
28. [V] hub.docker.com/mcp — Docker MCP Catalog
29. [V] smithery.ai — 13.477+ MCPs, agent.pw
30. [V] digitalapplied.com — MCP-Adoptionszahlen (Registry ~9.652, Mai 2026)
31. [V] usecarly.com — ChatGPT-Connectors-Gesamtliste 2026 (250+, Write-Aktionen Juni 2026)
32. [S] x.com/OpenAI — Drive/Dropbox/SharePoint/Box ausserhalb Deep Research
