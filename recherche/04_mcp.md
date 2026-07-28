# MCP, Tool-Integration und Alternativen — Sachstandsdossier

Stand: 2026-07-28. Quellenstatus: [V] = URL am 2026-07-28 selbst abgerufen und inhaltlich geprueft; [S] = nur ueber Suchergebnisse belegt. Bewertungsmassstab: professionell ohne Enterprise-Overhead, lokal/privat betreibbar, agentenfreundlich, reproduzierbar, auditierbar.

## Executive Summary

MCP hat sich 2025/2026 als De-facto-Standard fuer die Anbindung von Tools und Datenquellen an LLM-Agenten etabliert: Es loest real das N-mal-M-Integrationsproblem (jeder Client mal jede Datenquelle) und ist seit Dezember 2025 unter neutraler Governance der Agentic AI Foundation (Linux Foundation), getragen von Anthropic, OpenAI, Block, Google, Microsoft, AWS u. a., mit ueber 10.000 oeffentlichen Servern und 97 Mio. monatlichen SDK-Downloads. Heute (2026-07-28) erscheint planmaessig die groesste Protokollrevision seit dem Start: ein zustandsloser Kern ohne Initialize-Handshake und Session-Header, ein formales Extensions-Framework (MCP Apps, Tasks, Enterprise-Managed Authorization), OAuth-Haertung, Konformitaetssuite mit SDK-Tiers sowie Deprecation von Roots, Sampling und Logging. Zugleich ist die Kritik substanziell: Fuer Coding-Agenten mit Terminalzugriff sind CLI-Werkzeuge oft token-guenstiger (Benchmarks nennen Faktor 4-32) und einfacher; Anthropic selbst adressiert die Kontextkosten grosser Toolkataloge mit Tool Search (ca. 85 % Kontextersparnis, deutliche Genauigkeitsgewinne auf MCP-Evals) und Code Execution / Programmatic Tool Calling (im Beispiel 98,7 % Tokenersparnis). Sicherheit ist der kritischste Punkt: Eine dokumentierte Vorfallskette von April 2025 bis April 2026 (GitHub-MCP-Exfiltration, Asana-Cross-Tenant-Leak, mcp-remote CVE-2025-6514, postmark-mcp-Backdoor, STDIO-Designschwaechen) zeigt, dass Tool Poisoning und Prompt Injection ueber Tool-Beschreibungen und -Ergebnisse reale, ausgenutzte Angriffsvektoren sind; NSA (Mai 2026) und die offizielle Spezifikation liefern inzwischen konkrete, brauchbare Gegenmassnahmen (Least Privilege, Scope-Minimierung, Sandboxing, vollstaendiges Aufruf-Logging). Fuer Andreas' Privatkontext lautet der Kernbefund: MCP ist kein Selbstzweck — fuer Git/GitHub, Dateien, Tests und lokale Datenbanken bleiben CLI und native Tools erste Wahl; klaren Mehrwert liefert MCP bei Browser-Steuerung (Playwright), bei Multi-Client-Zugriff auf eigene Dienste (Claude Code und claude.ai teilen denselben Server) und als kuratierte, schmale Fassade ueber eigene Plattform-APIs (NFL-Wissensplattform, Ontologie-Abfragen). Die bestehenden M0-M4-Faehigkeitsklassen der Methodik v4.0 werden durch die externe Guidance bestaetigt, sollten aber um Herkunftsvertrauen, Lese/Schreib-Trennung und ein explizites Kontextbudget fuer Toolkataloge ergaenzt werden.

## 1. Was MCP tatsaechlich loest — und was nicht

MCP standardisiert, wie ein LLM-Client Tools entdeckt, beschreibt, aufruft und Ergebnisse zurueckerhaelt (JSON-RPC, Primitives: Tools, Resources, Prompts; Transporte: stdio lokal, Streamable HTTP remote). Der reale Nutzen ist ein Oekosystem-Effekt, kein technischer: Ein einmal gebauter Server funktioniert in Claude (Code/Desktop/Web), ChatGPT, VS Code, Cursor, Gemini-Produkten und Copilot — das bestaetigt inzwischen auch OpenAI, dessen Apps SDK und AgentKit auf MCP aufsetzen [S]. Anthropic nennt zur Uebergabe an die Stiftung >10.000 aktive Server, >97 Mio. monatliche SDK-Downloads und Adoption durch alle grossen Plattformen [V].

Was MCP *nicht* loest: Es macht einzelne Integrationen weder maechtiger noch sicherer als eine gute CLI oder REST-API, und es senkt nicht per se Kontextkosten — im Gegenteil, naive Toolkataloge erhoehen sie (Abschnitt 4). Die treffendste Einordnung aus der Praxisdebatte: Der Wert haengt an der Ausfuehrungsqualitaet („light and purpose-built"), nicht am Protokoll; wer 80 REST-Endpunkte automatisch in 80 MCP-Tools konvertiert, erzeugt Bloat [V] (kaxil). Charles Chen praezisiert die Trennlinie: Lokales stdio-MCP ist gegenueber CLI-Tools oft verzichtbar; der eigentliche Wert liegt bei Remote-MCP ueber HTTP — zentrale Auth statt verteilter API-Keys, Telemetrie, dynamisch ausgelieferte Prompts/Resources, Eignung fuer ephemere Runtimes [V].

## 2. Spezifikationsstand: Revision 2026-07-28

Die finale Spezifikation erscheint heute; der Release Candidate war seit 21. Mai 2026 eingefroren, Beta-SDKs gibt es seit 29. Juni (Tier-1-SDKs mussten im 10-Wochen-Fenster nachziehen) [V]. Kernpunkte laut offiziellem Blog [V]:

- **Stateless Core**: `initialize`/`initialized`-Handshake und `Mcp-Session-Id`-Header entfallen; Protokoll-Metadaten reisen in `_meta` mit jedem Request. Remote-Server laufen damit hinter simplen Round-Robin-Loadbalancern ohne Sticky Sessions. Anwendungszustand wandert in explizite Handles, die das Modell sichtbar zwischen Tool-Aufrufen weiterreicht — Zustand wird modell-sichtbar statt protokoll-verborgen. Mehrschrittige Interaktionen laufen ueber `InputRequiredResult` statt SSE-Streams; Server duerfen Requests an Clients nur noch waehrend aktiver Verarbeitung stellen.
- **Betrieb**: `Mcp-Method`/`Mcp-Name`-Header fuer Routing ohne Body-Parsing; `ttlMs`/`cacheScope` erlauben Clients das Cachen von `tools/list`; W3C Trace Context in `_meta` fuer durchgaengige Observability.
- **Extensions-Framework**: formaler Prozess mit Reverse-DNS-IDs, eigener Versionierung und delegierten Maintainern. **MCP Apps** (server-gerenderte UIs) und **Tasks** (Langlaeufer, aus dem experimentellen Kern zurueck in eine Extension ueberfuehrt) sind die ersten offiziellen Extensions; **Enterprise-Managed Authorization** (zentrale OAuth-Verwaltung ohne wiederholte Consent-Prompts) ist seit 18. Juni 2026 stable [V].
- **Autorisierungs-Haertung**: sechs OAuth-2.0/OIDC-Angleichungen, u. a. Pflicht zur `iss`-Validierung nach RFC 9207 (Mix-up-Attacken), `application_type` bei Dynamic Client Registration, klarere Scope-Akkumulation bei Step-up.
- **Deprecations mit 12-Monats-Fenster**: **Roots** (ersetzt durch Tool-Parameter/Resource-URIs/Serverkonfiguration), **Sampling** (ersetzt durch direkte LLM-API-Integration), **Logging** (ersetzt durch stderr bzw. OpenTelemetry). Neu verbauen sollte man diese drei nicht mehr.
- **Qualitaet/Governance**: JSON Schema 2020-12 vollstaendig fuer Tool-Schemas; formale Feature-Lifecycle-Policy; **Konformitaetssuite** als Pflicht fuer Standard-Track-Proposals, SDK-Tier-System mit Scoring gegen die Suite.

**MCP Apps** (offiziell seit 26. Januar 2026): Tools deklarieren `_meta.ui.resourceUri` auf `ui://`-Ressourcen (gebuendeltes HTML/JS), gerendert im sandboxed iframe, Kommunikation via JSON-RPC ueber postMessage; unterstuetzt von Claude (Web/Desktop), Goose, VS Code Insiders und ChatGPT — eine seltene Anthropic/OpenAI-Ko-Standardisierung [V].

**Registry**: Die offizielle Registry (registry.modelcontextprotocol.io, Start 8. September 2025) ist auch heute noch **Preview** ohne Datengarantien: Reverse-DNS-Namespaces mit GitHub-/DNS-Verifikation, standardisiertes `server.json`, Moderation nur reaktiv (Denylisting), Sicherheitsscanning an Paketregistries und Subregistries delegiert [V][V]. Fuer die Vertrauensfrage heisst das: Die Registry verifiziert Namensbesitz, nicht Code-Gutartigkeit.

**Governance/Adoption**: MCP wurde am 9. Dezember 2025 in die Agentic AI Foundation (Directed Fund der Linux Foundation) eingebracht, ko-gegruendet von Anthropic, Block und OpenAI, unterstuetzt von Google, Microsoft, AWS, Cloudflare, Bloomberg; Schwesterprojekte sind goose und AGENTS.md [V]. Damit ist das Risiko eines Vendor-Lock-in auf Protokollebene weitgehend ausgeraeumt.

## 3. Wann MCP — wann CLI, REST oder SDK?

Die 2026 konsolidierte Entscheidungslogik aus Praxisberichten [V] (kaxil, chrlschn, Willison):

**CLI gewinnt**, wenn der Agent ohnehin Terminalzugriff hat (Claude Code!), das Werkzeug im Trainingswissen liegt (`git`, `gh`, `sqlite3`, `jq`, `psql`, `pytest`) und Zwischenergebnisse per Pipe/Filter verarbeitet werden koennen. Benchmarks nennen 4-32x weniger Tokens als aequivalente MCP-Aufrufe; Simon Willison arbeitet mit Coding-Agenten erklaertermassen ueberwiegend ohne MCP und nutzt stattdessen CLI-Utilities und Bibliotheken wie Playwright-Python [V]. Wichtiges Gegenargument von Chen: *Bespoke*-CLIs ohne Trainingsdaten-Praesenz brauchen aehnlich viel Erklaerkontext wie MCP-Schemas — nur unstrukturiert [V].

**MCP gewinnt**, wenn (a) mehrere Clients denselben Zugang brauchen (Claude Code + claude.ai + Handy), (b) kein Terminal existiert (Web-/Mobile-Kontexte), (c) OAuth-Flows, zentrale Scopes und Audit an einer Stelle liegen sollen, (d) der Dienst remote laeuft und eine kuratierte, agentengerechte Tool-Sicht (5-15 Tools, nicht 80) sinnvoller ist als eine generische API, oder (e) UI-Rueckgabe (MCP Apps) bzw. Push-Kanaele gebraucht werden. Der neue Stateless Core senkt die Betriebskosten von Remote-Servern deutlich (kein Session-Store, simple Loadbalancer) [V].

**REST/SDK direkt** bleibt richtig fuer klassische Programm-zu-Programm-Integration und wenn der Agent Code schreibt, der die API nutzt — dann ist die API Teil des Produkts, nicht der Agentenschnittstelle. Ein bekanntes ungeloestes MCP-Problem: mehrere Instanzen desselben Servertyps (zwei Postgres-Instanzen, zwei Workspaces) kollidieren bei Toolnamen; CLIs haben das Problem nicht [V].

## 4. Kontextkosten von Toolkatalogen und Gegenmittel

Das Grundproblem ist zweiteilig: Tool-Definitionen belegen Kontext, bevor irgendetwas passiert, und Zwischenergebnisse fliessen mehrfach durchs Modell [V] (Anthropic Engineering). Messbare Gegenmittel:

- **Tool Search Tool** (Claude API): Definitionen werden erst bei Bedarf geladen; ~85 % weniger Kontextverbrauch (72K → 8,5K Tokens im Beispiel) und deutlich *bessere* Genauigkeit auf MCP-Evals (Opus 4: 49 % → 74 %; Opus 4.5: 79,5 % → 88,1 %) — lohnend ab ca. 10+ Tools bzw. >10K Tokens Definitionen [V]. In **Claude Code ist Tool Search inzwischen Default**: Beim Start laden nur Toolnamen und Server-Instructions, Schemas kommen on demand; Beschreibungen und Instructions werden bei 2 KB abgeschnitten; MCP-Outputs werden ab 10K Tokens gewarnt und bei 25K gekappt (`MAX_MCP_OUTPUT_TOKENS`) [V].
- **Programmatic Tool Calling / Code Execution with MCP**: Der Agent orchestriert Tools per Code in einer Sandbox, nur Endergebnisse erreichen das Modell; Anthropic berichtet 37 % Tokenersparnis auf komplexen Tasks (43.588 → 27.297) und im Extrembeispiel 150.000 → 2.000 Tokens (98,7 %) [V][V]. Preis: sichere Ausfuehrungsumgebung noetig; fuer einfache Aufgaben bleibt der Direktaufruf besser.
- **Kuratierung** bleibt das wirksamste Mittel: wenige, aufgabenzentrierte Tools mit Beispielen (Tool Use Examples: 72 % → 90 % Parametergenauigkeit) statt API-Spiegelung [V].

Konsequenz: Das oft zitierte „MCP frisst den Kontext"-Argument ist 2026 fuer Claude-Nutzer weitgehend entschaerft — aber nur bei aktiviertem Deferred Loading und diszipliniertem Katalog.

## 5. Sicherheit: Bedrohungslage, Vorfaelle, Guidance

**Bedrohungen.** Die offizielle Security-Best-Practices-Seite der Spezifikation behandelt inzwischen detailliert: Confused-Deputy-Angriffe auf OAuth-Proxys (Pflicht zu Per-Client-Consent), Token Passthrough (explizit verboten), SSRF ueber OAuth-Discovery-URLs, Session Hijacking (Sessions duerfen nie Authentifizierung ersetzen), Kompromittierung lokaler Server (Consent-Dialoge mit vollstaendigem Kommando, Sandboxing), XSS/RCE ueber Authorization-URLs sowie **Scope-Minimierung** (progressive Elevation statt Omnibus-Scopes) [V]. Forschung (STRIDE/DREAD-Threat-Modeling ueber 7 MCP-Clients) identifiziert **Tool Poisoning** — bösartige Instruktionen in Tool-Metadaten — als kritischste Client-seitige Schwachstelle; die meisten Clients pruefen Metadaten unzureichend statisch und zeigen Parameter schlecht an [V] (arXiv 2603.22489). Das verallgemeinert sich zu Willisons „lethal trifecta": privater Datenzugriff + Exposition gegenueber unvertrauenswuerdigem Inhalt + Exfiltrationskanal — jede MCP-Konfiguration ist gegen diese Kombination zu pruefen [S].

**Vorfaelle (Auswahl, dokumentiert)** [V] (AuthZed-Timeline): WhatsApp-Chat-Exfiltration via Tool Poisoning (04/2025); GitHub-MCP-Prompt-Injection leakt private Repos ueber ueberprivilegierten Token (05/2025); Asana Cross-Tenant-Leak (06/2025); RCE in Anthropics MCP Inspector (06/2025); `mcp-remote` OS-Command-Injection CVE-2025-6514 bei 437.000+ Downloads (07/2025); bösartiges `postmark-mcp` npm-Paket mit BCC-Backdoor auf alle E-Mails (09/2025); Figma-MCP-Command-Injection (10/2025); Smithery-Hosting Path Traversal (10/2025); 2026 u. a. trojanisierte Server in Registries und ein systemisches STDIO-Designproblem ueber mehrere Frameworks. Muster: ueberbreite Tokens amplifizieren Schaden; Tool-Beschreibungen sind ein unueberwachter Supply-Chain-Vektor; lokale Dev-Tools verhalten sich wie exponierte APIs.

**Behoerden-Guidance.** Die NSA (AI Security Center) veroeffentlichte am 20. Mai 2026 ein Cybersecurity Information Sheet zu MCP [V][V]: sechs Luecken-Kategorien (fehlendes RBAC, Serialisierung, fehlende Consent-Workflows, Token-/Session-Schwaechen, Implementierungs-Inkonsistenzen, Audit-Defizite) und konkrete Massnahmen — nur gepflegte Server einsetzen, strikte Schema-/Parametervalidierung, OS-Sandboxing (AppContainers/seccomp/SELinux), Least Privilege, **Logging aller Aufrufe mit exakten Parametern und kryptografischen Hashes**, Monitoring der Ausgaben auf Injection. CISA und internationale Partner flankieren mit „Careful Adoption of Agentic AI Services" (04/2026) [S]. Bemerkenswert: Diese Empfehlungen decken sich fast eins zu eins mit Andreas' vorhandenen Konzepten (Autoritaetsstufen, hermetische Gates, Run-Manifeste) — die Methodik ist hier *vor* der Behoerden-Guidance gewesen.

**Berechtigungen und Logging in der Praxis (Claude Code)** [V]: drei Installations-Scopes (local: `~/.claude.json`, project: `.mcp.json` im Repo — versionierbar, user: global); projektbezogene Server erfordern explizite Approval plus Workspace-Trust (ein geklontes Repo kann seine eigenen Server nicht selbst freischalten — wichtige Supply-Chain-Haertung seit v2.1.196); Tool-Permissions, Hooks und Subagent-Toollisten adressieren MCP-Tools ueber `mcp__server__tool`-Namen; OAuth via `/mcp`; Roots-Unterstuetzung begrenzt Server-Dateizugriff auf freigegebene Verzeichnisse.

## 6. Konkurrierende und komplementaere Standards

- **A2A (Agent2Agent, Linux Foundation)**: Version 1.0, >150 Organisationen, Produktionsnutzung in Konzern-Szenarien; explizit komplementaer — A2A regelt Agent-zu-Agent ueber Organisationsgrenzen, MCP Agent-zu-Tool [V]. Fuer einen Einzelbetreiber ohne fremde Agenten praktisch ohne Anwendungsfall.
- **Agent Skills (SKILL.md)**: Anthropics Skills-Format ist seit Ende 2025 offener Standard (agentskills.io) und breit adoptiert (Claude Code, Codex, Cursor u. v. m.) [S]. Skills und MCP sind orthogonal: Skills liefern *Wissen und Verfahren* (progressive Disclosure, nahezu kontextfrei bis zur Nutzung), MCP liefert *Faehigkeiten/Zugaenge*. Viele vermeintliche MCP-Anwendungsfaelle (Konventionen, Workflows, API-Nutzungsanleitungen plus Scripts) sind als Skill billiger und robuster.
- **AGENTS.md** (OpenAI, jetzt AAIF): Konventionsdatei fuer Repo-Kontext — komplementaer, kein Konkurrent [V].
- **Klassisches Function Calling**: bleibt die Basisschicht, auf der MCP aufsetzt; fuer selbstgebaute Einzel-Anwendungen (eigene FastAPI-Agenten) ohne Multi-Client-Anspruch weiterhin voellig ausreichend.
- **Computer Use / Browser-Agenten**: Fallback fuer Systeme ohne API; langsamer und fehleranfaelliger als strukturierte Tools — nur nutzen, wo nichts anderes existiert.

## 7. Konsequenzen fuer Andreas' Methodik und Projekte

1. **Grundregel „CLI-first, MCP-second" explizit verankern.** In Claude Code gilt: `gh` fuer GitHub, native Datei-Tools, `sqlite3`/`duckdb`/`psql` fuer Datenbanken, `pytest`/`vitest` fuer Tests. MCP nur bei nachweisbarem Mehrwert: Multi-Client-Zugriff, kein Terminal, OAuth/Scoping zentralisieren, strukturierte Browser-Steuerung. Das deckt sich mit Anthropic-eigener Praxis und unabhaengigen Messungen [V][V].
2. **Playwright MCP als Standard fuer Browser/E2E** (interaktive Privatprodukte, Astro-Frontends, Django-Admin): strukturierte Interaktion statt Screenshot-Raten, gut in hermetische Gates integrierbar. Alternative im reinen Testkontext: Playwright-CLI/Python direkt — beides zulassen, MCP bevorzugen, wenn der Agent explorativ bedienen soll.
3. **Ein eigener, schmaler MCP-Server lohnt fuer die NFL-Wissensplattform und die Daten-/Ontologie-Projekte**: 5-10 kuratierte, ueberwiegend read-only Tools (Ontologie-Query, Provenance-Lookup, kuratierte Reports) als duenne Fassade ueber FastAPI, Streamable HTTP hinter Cloudflare Tunnel/Tailscale. Der neue Stateless Core passt ideal zum Setup ohne Session-Infrastruktur; Handles (IDs) statt Sessions entsprechen ohnehin Andreas' Provenance-Denken. Damit wird derselbe Zugang aus Claude Code, claude.ai und kuenftig der Android-App nutzbar — das ist der eigentliche MCP-Business-Case im Privatkontext.
4. **M0-M4-Faehigkeitsklassen bestaetigt, um drei Dimensionen ergaenzen**: (a) Herkunftsvertrauen (offizieller Anbieter / eigener Code / Community — Letzteres nur nach Code-Review und Versions-Pinning; Registry-Eintrag ist kein Gutartigkeitsnachweis [V]); (b) Lese/Schreib-Split pro Server (read-only Default, Schreib-Tools nur ab hoeherer Autoritaetsstufe); (c) Output-Budget (`MAX_MCP_OUTPUT_TOKENS` bewusst setzen, Toolkatalog-Umfang als Teil der Verifikationsbandbreite).
5. **Sicherheitsleitplanken konkretisieren**: Lethal-Trifecta-Pruefung als Pflichtfrage in jeder Spezifikation, die MCP-Server hinzufuegt; fine-grained GitHub-Tokens pro Repo (Lehre aus 05/2025); `.mcp.json` versioniert, Secrets nur via env-Substitution; Tool-Beschreibungen gepinnter Server bei Updates diffen (Rug-Pull-Erkennung); keine ungeprueften npm-MCP-Server (postmark-Lektion). NSA-CSI als Checklistenquelle in die Methodik aufnehmen [V].
6. **Protokollierung an Run-Manifeste anschliessen**: PreToolUse/PostToolUse-Hooks mit `mcp__server__tool`-Matchern loggen Aufrufe samt Parametern (NSA-Empfehlung: inkl. Hashes); ab der neuen Spec W3C Trace Context in `_meta` fuer eigene Server uebernehmen — das macht MCP-Aufrufe erstmals sauber auditierbar und passt direkt in die bestehende Manifest-Systematik [V][V].
7. **Kontextkosten**: Tool Search in Claude Code (Default) aktiv lassen; eigene Server bekommen praezise Server-Instructions unter 2 KB („wann suchen, was koennen wir"); Tool Use Examples in eigene Tool-Definitionen aufnehmen. Code Execution/Programmatic Tool Calling als Pilot beobachten, nicht als Pflicht.
8. **Spec-Hygiene**: Bei eigenen Servern nichts mehr auf Roots, Sampling oder MCP-Logging aufbauen (Deprecation, 12-Monats-Fenster); Migration vorhandener Konfigurationen im Blick behalten, sobald Claude Code die 2026-07-28-Revision ausrollt [V]. MCP Apps fuer eigene Weboberflaechen-Projekte beobachten — interessant als UI-Kanal in claude.ai, aber jung.
9. **Nicht investieren**: A2A (kein Multi-Agent-Foederationsbedarf), Enterprise-Managed Authorization (kein IdP-Fleet), Registry-Publikation (private Server brauchen keinen Katalog), MCP-Gateways/Marktplaetze.

## 8. Bewertungstabelle

| Methode/Technologie | Einordnung fuer Andreas' Kontext | Begruendung |
|---|---|---|
| CLI-first fuer Git/GitHub/Dateien/Tests/lokale DBs | jetzt empfohlen | Token-guenstiger, im Trainingswissen, pipe-faehig [V] |
| Playwright MCP (Browser, E2E, exploratives Bedienen) | jetzt empfohlen | strukturierte Interaktion, klarer Mehrwert ggue. Screenshots |
| Eigener schmaler Remote-MCP-Server (Wissensplattform, read-only) | sinnvoll unter Bedingungen | lohnt ab Multi-Client-Nutzung; Stateless Core senkt Betriebsaufwand [V] |
| Tool Search / Deferred Loading | jetzt empfohlen | Default in Claude Code; 85 % Kontextersparnis, bessere Genauigkeit [V] |
| Code Execution with MCP / Programmatic Tool Calling | pilotgeeignet | grosse Ersparnis, aber Sandbox-Aufwand; fuer komplexe Datenfluesse [V] |
| MCP Apps (UI-Extension) | beobachten | offiziell und breit getragen, aber jung; fuer eigene UIs spaeter pruefen [V] |
| Offizielle Registry (publizieren/konsumieren) | beobachten | weiter Preview; verifiziert Namen, nicht Code [V] |
| Ungepruefte Community-MCP-Server (npm etc.) | derzeit nicht belastbar | dokumentierte Supply-Chain-Vorfaelle [V] |
| NSA-CSI / offizielle Security Best Practices als Checkliste | jetzt empfohlen | konkret, deckungsgleich mit Methodik-Philosophie [V] |
| A2A, Enterprise-Managed Authorization, MCP-Gateways | ueberdimensioniert fuer den Privatkontext | Enterprise-Probleme, die Andreas nicht hat [V] |
| Agent Skills als Traeger von Verfahren/Wissen statt MCP | jetzt empfohlen | orthogonal zu MCP, nahezu kontextfrei, offener Standard [S] |
| „MCP ist tot"-These | ueberwiegend Marketing | Kritik trifft lokales stdio-MCP, nicht Remote-/Multi-Client-Faelle [V] |

## 9. Quellenverzeichnis

1. [V] MCP Blog: The 2026-07-28 Specification Release Candidate (2026-05-21) — https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/ (Abruf 2026-07-28)
2. [V] MCP Blog Index (Beta-SDKs 2026-06-29; Enterprise-Managed Authorization 2026-06-18) — https://blog.modelcontextprotocol.io/ (Abruf 2026-07-28)
3. [V] MCP Blog: MCP Apps — Bringing UI Capabilities to MCP Clients (2026-01-26) — https://blog.modelcontextprotocol.io/posts/2026-01-26-mcp-apps/ (Abruf 2026-07-28)
4. [V] MCP Blog: Introducing the MCP Registry (2025-09-08) — https://blog.modelcontextprotocol.io/posts/2025-09-08-mcp-registry-preview/ (Abruf 2026-07-28)
5. [V] MCP Docs: The MCP Registry (About/Status) — https://modelcontextprotocol.io/registry/about (Abruf 2026-07-28)
6. [V] MCP Spezifikation: Security Best Practices — https://modelcontextprotocol.io/specification/2025-06-18/basic/security_best_practices (Abruf 2026-07-28)
7. [V] Anthropic: Donating MCP / Agentic AI Foundation (2025-12-09) — https://anthropic.com/news/donating-the-model-context-protocol-and-establishing-of-the-agentic-ai-foundation (Abruf 2026-07-28)
8. [V] Anthropic Engineering: Code execution with MCP — https://www.anthropic.com/engineering/code-execution-with-mcp (Abruf 2026-07-28)
9. [V] Anthropic Engineering: Advanced tool use (Tool Search, Programmatic Tool Calling, Examples) — https://www.anthropic.com/engineering/advanced-tool-use (Abruf 2026-07-28)
10. [V] Claude Code Docs: MCP (Scopes, Approval/Trust, Tool Search, Output-Limits) — https://code.claude.com/docs/en/mcp (Abruf 2026-07-28)
11. [V] NSA Pressemitteilung: Security Design Considerations for MCP (2026-05-20) — https://www.nsa.gov/Press-Room/Press-Releases-Statements/Press-Release-View/Article/4496698/ (Abruf 2026-07-28)
12. [V] NSA CSI: Model Context Protocol (PDF, Ver. 1.0) — https://media.defense.gov/2026/Jun/02/2003943289/-1/-1/0/CSI_MCP_SECURITY.PDF (Abruf 2026-07-28)
13. [V] AuthZed: A Timeline of MCP Security Breaches — https://authzed.com/blog/timeline-mcp-breaches (Abruf 2026-07-28)
14. [V] arXiv 2603.22489: MCP Threat Modeling / Tool Poisoning (7 Clients) — https://arxiv.org/abs/2603.22489 (Abruf 2026-07-28)
15. [V] Linux Foundation: A2A Protocol Surpasses 150 Organizations (2026-04-09) — https://www.linuxfoundation.org/press/a2a-protocol-surpasses-150-organizations-lands-in-major-cloud-platforms-and-sees-enterprise-production-use-in-first-year (Abruf 2026-07-28)
16. [V] Kaxil Naik: "MCP Sucks" (Until It Doesn't) — MCP vs CLI vs REST — https://kaxil.substack.com/p/mcp-vs-cli-vs-rest (Abruf 2026-07-28)
17. [V] Charles Chen: MCP is Dead; Long Live MCP! (2026-03) — https://chrlschn.dev/blog/2026/03/mcp-is-dead-long-live-mcp/ (Abruf 2026-07-28)
18. [V] Simon Willison: Code execution with MCP (Kommentar, 2025-11-04) — https://simonwillison.net/2025/Nov/4/code-execution-with-mcp/ (Abruf 2026-07-28)
19. [S] CISA/NSA u. a.: Careful Adoption of Agentic AI Services (2026-04) — https://www.cisa.gov/resources-tools/resources/careful-adoption-agentic-ai-services (Abruf 403; PDF: media.defense.gov)
20. [S] CyberScoop: Five-Eyes-Guidance zu AI-Agenten — https://cyberscoop.com/cisa-nsa-five-eyes-guidance-secure-deployment-ai-agents/
21. [S] The Register: MCP prepares to break with its stateful past (2026-07-23) — https://www.theregister.com/devops/2026/07/23/model-context-protocol-prepares-to-break-with-its-stateful-past/5276722
22. [S] The Register: Claude supports MCP Apps (2026-01-26) — https://www.theregister.com/2026/01/26/claude_mcp_apps_arrives/
23. [S] Linux Foundation: Formation of the Agentic AI Foundation — https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation
24. [S] OpenAI: Introducing AgentKit / MCPKit (Apps SDK auf MCP) — https://openai.com/index/introducing-agentkit/
25. [S] Snyk: Malicious postmark-mcp on npm — https://snyk.io/blog/malicious-mcp-server-on-npm-postmark-mcp-harvests-emails/
26. [S] Paperclipped: Agent Skills Open Standard / SKILL.md-Adoption — https://www.paperclipped.de/en/blog/agent-skills-open-standard-interoperability/
27. [S] Spring Blog: Dynamic Tool Discovery 34-64 % Token Savings — https://spring.io/blog/2025/12/11/spring-ai-tool-search-tools-tzolov/
28. [S] Simon Willison: The lethal trifecta (Konzept) — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/
