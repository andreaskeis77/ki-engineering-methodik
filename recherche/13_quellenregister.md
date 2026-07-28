# Quellenregister-Verifikation: Primärquellen des Recherche-Kompendiums

Stand: 2026-07-28. Quellenstatus-Konvention: **[V]** = URL am angegebenen Datum selbst abgerufen und Inhalt geprüft; **[S]** = nur über Suchergebnisse/Sekundärquellen belegt. Alle [V]-Abrufe dieser Session erfolgten am 2026-07-28.

## Executive Summary

Von den rund 30 im Kompendium referenzierten Quellgruppen konnten in dieser Session 42 URLs direkt abgerufen und geprüft werden; nahezu alle Kernaussagen des Kompendiums halten der Primärquellen-Prüfung stand. Kein einziger geprüfter Befund widerspricht der Methodik v4.0 in ihren Grundzügen. Wichtige Präzisierungen: Die NSA-CSI zu MCP erschien am **20. Mai 2026** (nicht Juni) und stammt vom NSA-eigenen AI Security Center; die aktuelle MCP-Spezifikation ist weiterhin die Revision **2025-11-25** (Status "Current"), eine 2026er-Revision existiert nur als Draft. Das SE-3.0-Paper von Hassan et al. liegt seit dem 24. Juni 2026 in einer stark ausgebauten **v3** vor (SASE-Rahmen mit ACE/AEE, BriefingScript, MRP, Autonomiestufen 0–5) — die Kompendiumsentscheidung, das Vokabular nicht zu übernehmen, bleibt vertretbar, sollte aber gegen v3 erneut geprüft werden. Neu gegenüber dem Kompendiumsstand sind zwei Anthropic-Publikationen vom Juni 2026 ("How Claude Code is used in practice": Menschen treffen ~70 % der Planungs-, Claude ~80 % der Ausführungsentscheidungen; "Building effective human-agent teams": Rosters, North Star, Doer-Verifier-Paare), die DORA-Nachlieferung eines **ROI-Reports**, die Auslagerung der OpenTelemetry-GenAI-Konventionen in ein **eigenes Repository** sowie Spec Kit v0.13.0 (17.07.2026). Die empirische Basis (METR ±, Veracode ~55 % flach, GitClear-Strukturverfall, CMU/MSR-Komplexitätsanstieg, Perry-Overconfidence, SWE-Bench-Memorisierung) wurde vollständig an den Originalen bestätigt. Rechtlich zentral: Der Digital Omnibus (Einigung 06.05.2026) verschiebt die High-Risk-Fristen des AI Act, **nicht aber Art. 50** — die Transparenzpflichten greifen am 02.08.2026. Zwei Domains (designtokens.org/tr, gesetze-im-internet.de) waren technisch nicht abrufbar; ihre Kernaussagen sind über offizielle Ausweichquellen abgesichert.

## Prüfmethodik

1. Jede Quelle wurde per WebFetch direkt abgerufen; bei 404/Robots-Sperren wurde zuerst die korrekte aktuelle URL gesucht (mehrere Artikel sind seit Erstellung des Kompendiums umgezogen), erst danach auf offizielle Ausweichquellen oder [S] zurückgegangen.
2. Geprüft wurden je Quelle: (a) Existenz und exakte URL, (b) die im Kompendium transportierte Kernaussage, (c) Publikations-/Revisionsdatum und neuere Versionen oder Folgepublikationen bis zum 2026-07-28.
3. Sekundärquellen (Kanzlei-Analysen, Vendor-Zusammenfassungen) wurden nur ergänzend genutzt und sind als solche gekennzeichnet; sie erzeugen keinen [V]-Status für die Primärquelle.
4. "Neues/Änderungen" bezieht sich auf den Stand des Kompendiums (Juli 2026); da das Kompendium am 2026-07-28 erstellt wurde, sind hier vor allem Versionsstände, Umzüge und Folgepublikationen der letzten Monate dokumentiert, die dort noch nicht oder nur als [S] geführt waren.

---

## 1. Anthropic Engineering und Claude Code

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| Building Effective Agents (2024-12-19) | anthropic.com/engineering/building-effective-agents | [V] 2026-07-28 | Einfache, komponierbare Patterns schlagen Frameworks; Workflow-Taxonomie (Prompt Chaining, Routing, Parallelisierung, Orchestrator-Workers, Evaluator-Optimizer) plus Agents; "add complexity only when simpler solutions fall short". | Unverändert gültig; Cookbook als Begleitmaterial. |
| How we built our multi-agent research system (2025-06-13) | anthropic.com/engineering/multi-agent-research-system | [V] 2026-07-28 | Orchestrator-Worker mit Opus-Lead und Sonnet-Subagenten: +90,2 % gegenüber Single-Agent-Opus; ~15× Token-Verbrauch vs. Chat; Token-Budget erklärt 80 % der Performance-Varianz; 7 Prompt-Prinzipien für Delegation. | Keine neue Version; asynchrone Architekturen als Ausblick genannt. |
| Effective context engineering for AI agents (2025-09-29) | anthropic.com/engineering/effective-context-engineering-for-ai-agents | [V] 2026-07-28 | Kontext als endliche Ressource mit abnehmendem Grenzertrag ("Context Rot"); drei Langlauf-Techniken: Compaction, strukturierte Notizen außerhalb des Fensters, Subagenten mit sauberem Kontext; Just-in-time-Laden über leichte Identifikatoren statt Vorab-Einlesen. | Unverändert; Querverweise auf Tool-Writing-Artikel. |
| Effective harnesses for long-running agents (2025-11-26) | anthropic.com/engineering/effective-harnesses-for-long-running-agents | [V] 2026-07-28 | Zwei-Agent-Harness (Initializer + Coding-Agent); Feature-Liste als JSON (>200 Einträge, initial "failing"), Git als Zustandsspeicher, Progress-Dateien, init.sh; explizite Selbstverifikation (inkl. Browser-Automation) gegen "One-Shotting". | Unverändert. |
| Claude Code Best Practices | code.claude.com/docs/en/best-practices | [V] 2026-07-28 | Kontextfenster als zentrale Ressource; verifizierbare Checks als Kern ("Give Claude a way to verify its work"); Explore–Plan–Code–Commit; kurze, geprüfte CLAUDE.md ("Bloated CLAUDE.md files cause Claude to ignore your actual instructions"); Hooks deterministisch vs. CLAUDE.md advisorisch; Subagenten für Recherche und adversariales Review; Fan-out mit `claude -p`. | Doc deutlich ausgebaut ggü. dem alten Engineering-Blogpost: neu sind Auto-Mode (Klassifikator-Permissions), `/goal`-Bedingungen, Stop-Hooks als deterministische Gates (Override nach 8 Blocks), Agent Teams, Checkpoints/`/rewind`, `/btw`, Interview-Muster mit AskUserQuestion → SPEC.md. |
| How Claude Code is used in practice (2026-06-16) | anthropic.com/research/claude-code-expertise | [V] 2026-07-28 | Reale Nutzung: Menschen treffen ~70 % der Planungsentscheidungen, Claude ~80 % der Ausführungsentscheidungen; Domänenwissen (nicht Coding-Hintergrund) treibt Erfolg; verified success 15 % (Novizen) vs. 28–33 % (Erfahrene); Debugging-Anteil sank Okt 2025→Apr 2026 von 33 % auf 19 %. | Neu seit Kompendium-Basisrecherche; stützt empirisch die Rollenteilung Chefarchitekt/Agent der v4.0. |
| Building effective human-agent teams (2026-06-24) | claude.com/blog/building-effective-human-agent-teams | [V] 2026-07-28 | Vier Lektionen: Arbeit schriftlich/auffindbar machen ("If it's not written down, it doesn't exist"), Rollen-Roster mit Ownership, dokumentierter North Star, Vertrauen graduell über Verifikation (Tests, Rubriken, Doer-Verifier-Paare) ausbauen. | Neu; liegt auf claude.com/blog, nicht im Engineering-Blog. |

## 2. OpenAI Codex und AGENTS.md

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| Codex-Entwicklerdokumentation | developers.openai.com/codex | [V] 2026-07-28 | Vollständige Plattform-Doku (App, IDE, CLI, Web, GitHub/Slack/Linear-Integrationen; Config, Permissions, Rules, Hooks, MCP, Plugins, Skills, Subagents; Windows-Support). | Feature-Set konvergiert sichtbar mit Claude Code (Hooks/Skills/Subagents); Sandboxing mit Auto-Review, Memories/Chronicle. |
| Codex Best Practices | developers.openai.com/codex/learn/best-practices | [V] 2026-07-28 | AGENTS.md als "open-format README for agents" (Repo-Layout, Build-/Testbefehle, Konventionen, Constraints); Prompt-Anatomie Ziel/Kontext/Constraints/Erfolgskriterien; Plan-Modus für komplexe Aufgaben; Codex auch als Tester/Reviewer; Reasoning-Level nach Aufgabengröße. | URL-Korrektur: liegt unter /codex/learn/, nicht /codex/best-practices. |
| AGENTS.md-Konvention | agents.md | [V] 2026-07-28 | Offenes Markdown-Format für Agenten-Anweisungen; Unterstützer u.a. Codex, Jules, Cursor, Copilot Coding Agent, Devin, Zed, Aider; >60.000 OSS-Projekte nutzen es. | Governance-Wechsel: AGENTS.md wird jetzt von der **Agentic AI Foundation unter der Linux Foundation** betreut; weiterhin keine formale Versionierung. |

## 3. GitHub Spec Kit

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| Spec Kit Repository | github.com/github/spec-kit | [V] 2026-07-28 | Toolkit für Spec-Driven Development: Constitution → Specify → Plan → Tasks → Implement (optional Clarify/Analyze/Checklist); 30+ unterstützte Agenten; 123k Stars. | Aktuelle Release **v0.13.0 vom 2026-07-17**; weiterhin 0.x, hohe Release-Kadenz — als Methodik-Vorlage stabil, als Tool-Abhängigkeit volatil. |
| GitHub Blog: Spec-driven development with AI (2025-09-02) | github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/ | [V] 2026-07-28 | Motivation: Pattern-Completion scheitert an vagen Anforderungen; Spezifikation als "source of truth", Eignung für Greenfield, Feature-Ausbau und Legacy-Modernisierung. | Unverändert. |

## 4. DORA

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| 2025 State of AI-assisted Software Development | dora.dev/research/2025/dora-report/ | [V] 2026-07-28 | Kernthese direkt auf der Seite: "AI's primary role is as an amplifier, magnifying an organization's existing strengths and weaknesses"; ROI entsteht aus dem Organisationssystem, nicht dem Tool. Detailzahlen (Adoption ~90 %, Instabilitätsbefund, sieben Team-Profile) stehen im PDF, nicht auf der Landingpage. | Kein 2026-Hauptreport angekündigt (Stand 2026-07-28). |
| AI Capabilities Model (2025-11-25) | dora.dev/ai/capabilities-model/report/ | [V] 2026-07-28 | Begleitreport, der die sieben Capabilities operationalisiert, die AI-Nutzen verstärken (je Capability: Umsetzungsstrategien, Einstiegsmaßnahmen, Fortschrittsmessung). | Publikationsdatum 2025-11-25 bestätigt. |
| DORA Publications | dora.dev/research/publications/ | [V] 2026-07-28 | Publikationsliste bestätigt Report + Capabilities Model. | **Neu entdeckt: "ROI of AI-assisted Software Development Report"** als dritte Publikation (Presseecho InfoQ Mai 2026 [S]) — für Andreas' Kontext v. a. als Argumentationsrahmen, nicht als neue Empirie. |

## 5. METR

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| RCT-Studie (arXiv 2507.09089) | arxiv.org/abs/2507.09089 | [V] 2026-07-28 | Becker/Rush/Barnes/Rein: 16 erfahrene OSS-Entwickler, 246 Tasks; mit AI **+19 % Bearbeitungszeit**; Prognosen (Entwickler +24 %, Ökonomen +39 %, ML-Experten +38 % Ersparnis) und Nachschätzung (+20 %) alle falsch → dokumentierte Wahrnehmungs-Mess-Lücke. | Letzter Stand v2 (2025-07-25); keine v3. |
| Uplift-Study-Redesign (2026-02-24) | metr.org/blog/2026-02-24-uplift-update/ | [V] 2026-07-28 | Zweite Studie (H2 2025) wegen Selektionsbias umgebaut: 30–50 % der Entwickler reichten Tasks bewusst nicht ein, die sie nicht ohne AI bearbeiten wollten; Punktschätzungen der Late-2025-Daten weiter im Verlangsamungsbereich bei breiten CIs; METR stuft die eigenen Daten als "very weak evidence" ein und vermutet real gestiegenen Speedup. Geplant: kürzere Fixed-Task-Experimente, höhere Bezahlung, Beobachtungsdaten. | Unverändert; Folgepublikation mit neuen Zahlen steht noch aus. |
| Time Horizon (Blog 2025-03-19 + Dashboard) | metr.org/blog/2025-03-19-measuring-ai-ability-to-complete-long-tasks/ · metr.org/time-horizons/ | [V] 2026-07-28 (beide) | 50 %-Zeithorizont verdoppelt sich seit ~6 Jahren etwa alle 7 Monate; Blogwerte (März 2025: ~1 h) sind explizit veraltet. | **Time Horizon 1.1** (Mai 2026): größere Task-Suite, laufend aktualisiertes Diagramm; letzter Eintrag 2026-05-08; Messungen >16 h gelten mit aktueller Suite als unzuverlässig. |

## 6. OWASP GenAI

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| Top 10 for LLM Applications 2025 | genai.owasp.org/llm-top-10/ | [V] 2026-07-28 | LLM01–LLM10 (2025) bestätigt: Prompt Injection, Sensitive Information Disclosure, Supply Chain, Data/Model Poisoning, Improper Output Handling, Excessive Agency, System Prompt Leakage, Vector/Embedding Weaknesses, Misinformation, Unbounded Consumption. | Keine 2026-Revision der LLM-Liste; die Agentic-Liste ist die Fortschreibung. |
| Top 10 for Agentic Applications 2026 (2025-12-09) | genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/ | [V] 2026-07-28 (Landingpage) | Peer-Review-Rahmenwerk (>100 Beitragende) für agentische Risiken; final veröffentlicht am 09.12.2025. ASI-Namensliste über Sekundärquelle bestätigt [S: goteleport.com, direkt abgerufen]: ASI01 Agent Goal Hijack, ASI02 Tool Misuse, ASI03 Identity/Privilege Abuse, ASI04 Agentic Supply Chain, ASI05 Unexpected Code Execution, ASI06 Memory/Context Poisoning, ASI07 Insecure Inter-Agent Communication, ASI08 Cascading Failures, ASI09 Human-Agent Trust Exploitation, ASI10 Rogue Agents. | PDF selbst nicht geparst; Liste daher formal [S]. |

## 7. Veracode

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| 2025 GenAI Code Security Report | veracode.com/resources/analyst-reports/2025-genai-code-security-report/ | [V] 2026-07-28 | Basisstudie: KI-generierter Code mit Sicherheitsmängeln in **45 % der Tests**; >100 LLMs, 4 Sprachen; größere/neuere Modelle nicht sicherer. | Durch Spring-2026-Update fortgeschrieben. |
| Spring 2026 Update (2026-03-24) | veracode.com/blog/spring-2026-genai-code-security/ | [V] 2026-07-28 | >150 LLMs, 80 Tasks: Security-Pass-Rate stagniert bei **~55 %**, Syntax >95 % ("excellent at writing code that compiles… failed at writing code that's safe"); Python 62 %, C# 58 %, JS 57 %, Java 29 %; SQLi 82 %/Krypto 86 % Pass, **XSS 15 %, Log Injection 13 %**. | Bestätigt exakt die Kompendiums-Gewichtung der Security-Gates (XSS/Log-Injection-Fokus). |

## 8. Akademische Studien und Code-Qualitäts-Empirie

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| CMU: AI IDEs or Autonomous Agents? (MSR '26) | arxiv.org/abs/2601.13597 | [V] 2026-07-28 | Agarwal/He/Vasilescu, Diff-in-Diff auf AIDev: große front-loaded Velocity-Gewinne nur, wenn Agenten das erste AI-Tool im Repo sind; Static-Analysis-Warnungen **+18 %**, kognitive Komplexität **+39 %** — Qualitätslast bleibt auch ohne Tempogewinn. | v2 (2026-01-27); Replikationspaket auf GitHub. |
| Perry et al. (Stanford), ACM CCS '23 | arxiv.org/abs/2211.03622 | [V] 2026-07-28 | Nutzer mit AI-Assistent schrieben signifikant unsichereren Code und hielten ihn häufiger für sicher (Overconfidence); wer dem System misstraute und Prompts aktiv umformulierte, produzierte weniger Lücken. | Letzte Revision v3 (2023-12-18); keine Folgeversion — zeitloser Anker für Explain-back/Review-Pflicht. |
| Microsoft: The SWE-Bench Illusion | arxiv.org/abs/2506.12286 | [V] 2026-07-28 | Liang/Garg/Zilouchian Moghaddam: SWE-Bench-Gewinne teils Memorisierung — 76 % korrekte Buggy-File-Pfade allein aus Issue-Text auf SWE-Bench-Repos vs. 53 % auf fremden Repos; 35 % vs. 18 % Verbatim-Ähnlichkeit. Benchmark-Skepsis des Kompendiums bestätigt. | **v4 (2025-12-01)** — neuere Revision als im Kompendium; weiterhin Preprint. |
| Hassan et al.: Agentic SE Roadmap (SE 3.0) | arxiv.org/abs/2509.06216 (Inhalt via alphaxiv.org-Spiegel geprüft) | [V] 2026-07-28 (Spiegel; arXiv-Abstractseite lieferte kein parsebares HTML) | Structured Agentic Software Engineering (SASE): duale Umgebungen ACE (Command, menschzentriert) und AEE (Execution, agentenzentriert); Artefakte BriefingScript, LoopScript, MentorScript, CRP, **Merge-Readiness Pack (MRP)**; Autonomiestufen 0–5 analog SAE. | **v3 vom 2026-06-24** — deutlich ausgebaut ggü. Erstversion 09/2025; Kompendiumsentscheidung "kein Vokabelwechsel" bleibt haltbar, da konzeptionell deckungsgleich mit v4.0-Bausteinen (Spez-Pflicht, Pre-Integration-Gate, Run-Manifest). |
| Stanford Software Engineering Productivity | softwareengineeringproductivity.stanford.edu | [V] 2026-07-28 | Projekt existiert und misst mit Experten-Panel-ML-Modell; Basis 600+ Organisationen, 120.000+ Entwickler seit 2022. Die bekannten Differenzierungszahlen (Greenfield/geringe Komplexität stark positiv, reifes Brownfield bis negativ; Rework frisst Bruttogewinne) stehen **nicht** auf der Website, sondern stammen aus Vorträgen/Interviews [S]. | Neueste Papiere 2025/26 zu Code-Review-Automatisierung und LLM-Konsistenz, nicht zur Produktivitätszahl; die Prozentwerte bleiben vortragsbasiert. |
| GitClear: The Maintainability Gap (2026-01) | gitclear.com/the_ai_code_quality_maintainability_gap | [V] 2026-07-28 | 623 Mio. Code-Änderungen 2023–2026: Block-Duplikation +81 % (40,3→73,0 je Mio. Zeilen); Copy/Paste 9,4 % (2022) → 15,7 % (H1 2026); Moved/Refactoring-Anteil **21 % → 3,8 %**; Konnektivität −35 %; Legacy-Pflege −74 %; 2-Wochen-Churn +15 %. Kernsatz: nicht "AI schreibt schlechten Code", sondern der Default-Workflow incentiviert Volumen statt Strukturpflege. | URL-Korrektur: neuer Slug "the_ai_code_quality_maintainability_gap". |

## 9. Standards und Infrastruktur (DTCG, OpenTelemetry, MCP, NSA/CISA)

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| DTCG Design Tokens Spec 2025.10 | designtokens.org/tr/2025.10/ (Spec); w3.org/community/design-tokens/2025/10/28/… (Ankündigung) | Spec: **nicht abrufbar** (robots/Timeout) → [S]; Ankündigung: [V] 2026-07-28 | W3C-Community-Group-Post bestätigt: **erste stabile, produktionsreife Version 2025.10 am 28.10.2025**; Theming/Multi-Brand, moderne Farbräume (P3, Oklch), Aliasing; Referenzimplementierungen Style Dictionary, Tokens Studio, Terrazzo. | GitHub-README hinkt nach (nennt Living Draft 04/2025); maßgeblich ist designtokens.org/tr/2025.10 mit Format- und Resolver-Modul [S]. DTCG-Token-Pipeline der v4.0 steht damit auf stabilem Fundament. |
| OpenTelemetry GenAI Semantic Conventions | opentelemetry.io/docs/specs/semconv/gen-ai/ · github.com/open-telemetry/semantic-conventions-genai | [V] 2026-07-28 (beide) | Konventionen decken Spans (inkl. Agent-Spans), Metriken, Events ab; Provider-Spezifika für OpenAI, Anthropic, Bedrock, Azure und **MCP**. | **Umzug**: GenAI-Semconv in eigenes Repository `semantic-conventions-genai` ausgelagert; weiterhin aktiv in Entwicklung (Development, nicht Stable), Schema-Basis 1.42/1.43 — für Andreas: beobachten, Feldnamen noch nicht einfrieren. |
| MCP-Spezifikation | modelcontextprotocol.io/specification/2025-11-25 · /specification/versioning | [V] 2026-07-28 (beide) | Aktuelle Revision **2025-11-25, Status "Current"**; datumsbasierte Versionierung nur bei Breaking Changes; Feature-Lifecycle mit Deprecation-Registry (≥12 Monate bzw. 90 Tage expedited); Versionshandel bei Initialisierung. | Korrektur zum Kompendium: eine "Revision 2026" ist **nicht** veröffentlicht — nur ein Draft; 2025-11-25 bleibt maßgeblich. |
| MCP Security Best Practices | modelcontextprotocol.io/specification/2025-11-25/basic/security_best_practices | [V] 2026-07-28 | Normative Behandlung von: Confused Deputy (Pflicht zu Per-Client-Consent), Token-Passthrough-Verbot ("MUST NOT accept tokens not issued for the MCP server"), SSRF bei OAuth-Discovery, Session Hijacking (Sessions nie als AuthN, nicht-deterministische IDs, User-Bindung), Local-Server-Kompromittierung (Konsens-Dialog mit vollständigem Kommando, Sandboxing), OAuth-URL-Validierung (nur http/https), stdio-Proxy-Härtung, Scope-Minimierung. | Deckt sich mit M0–M4-Klassifikation der v4.0; präziser als frühere Fassungen. |
| NSA AISC: CSI "Model Context Protocol: Security Design Considerations for AI-Driven Automation" | nsa.gov/Press-Room/… (Pressemitteilung); PDF via media.defense.gov | Pressemitteilung: [V] 2026-07-28; PDF: [S] | Veröffentlicht am **20.05.2026** durch das NSA Artificial Intelligence Security Center: klassische Kontrollen (AuthN, AuthZ, Input-Validierung) bleiben nötig, sind aber unzureichend; agentische Umgebung als Kontinuum behandeln, da "misaligned assumptions… propagate and compound into exploitable conditions". | Datums-Korrektur ggü. Auftrag/Kompendium: **Mai**, nicht Juni 2026; Mitwirkung von CISA/internationalen Partnern nur über Presseberichte belegt [S], die NSA-Meldung nennt allein das AISC. |

## 10. Recht: EU AI Act, Digital Omnibus, EAA/BFSG

| Quelle | URL | Status | Verifizierte Kernaussage | Neues/Änderungen |
|---|---|---|---|---|
| EU AI Act Art. 50 | artificialintelligenceact.eu/article/50/ | [V] 2026-07-28 | Transparenzpflichten: Hinweis auf KI-Interaktion (außer offensichtlich), Kennzeichnung synthetischer Inhalte in maschinenlesbarer Form, Deepfake-Offenlegung; anwendbar ab **02.08.2026** (Art. 113). | Seite bildet Omnibus-Änderungen nicht ab — dafür separate Quelle nötig (nächste Zeile). |
| Digital Omnibus (AI-Teil) | gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/ (Kanzlei-Analyse, direkt abgerufen) | [V] 2026-07-28 (Sekundärquelle) | Politische Einigung **06.05.2026** (bestätigt 13.05.): High-Risk-Fristen verschoben (Annex III auf 02.12.2027, Annex I auf 02.08.2028); **Art. 50 bleibt beim 02.08.2026** ("Article 50 transparency proceeds as scheduled"), nur Kennzeichnung nach Art. 50(2) für Bestandssysteme mit Übergang bis 02.12.2026; Sandbox-Frist auf 02.08.2027. | Wichtigste rechtliche Präzisierung dieser Prüfung: keine Entwarnung für Transparenzpflichten; finaler Verordnungstext im Amtsblatt stand am Prüftag noch aus [S]. |
| EAA (Richtlinie (EU) 2019/882) | commission.europa.eu/…/european-accessibility-act-eaa_en · eur-lex.europa.eu (CELEX 32019L0882) | [V] 2026-07-28 (beide, Überblick/Metadaten) | Binnenmarkt-Richtlinie für barrierefreie Produkte/Dienste; **E-Commerce explizit erfasst**; in Kraft seit 27.06.2019, Umsetzung bis 06/2022. Anwendungsbeginn 28.06.2025 und Übergangsfristen stehen im Richtlinientext (Art. 31/32), der im Abruf nicht als Volltext parsebar war → Datumsdetail [S]. | Keine Änderungen. |
| BFSG (deutsches Umsetzungsgesetz) | gesetze-im-internet.de/bfsg/ | **nicht abrufbar** (robots/Timeout) → [S] | Kernaussage aus Sekundärlage: gilt seit 28.06.2025, erfasst u. a. E-Commerce-Dienstleistungen gegenüber Verbrauchern; Ausnahme für Kleinstunternehmen bei Dienstleistungen; Konformitätsvermutung über EN 301 549/WCAG. | Für Andreas' private, nicht-kommerzielle Projekte keine unmittelbare Pflicht; WCAG-Anker der Methodik bleibt fachlich sinnvoll. |

---

## Konsequenzen für Andreas' Methodik und Projekte

1. **Kompendium-Fußnoten aktualisieren, keine Architekturänderung nötig.** Alle tragenden Empirie-Anker (METR, Veracode, GitClear, CMU/MSR, Perry, SWE-Bench Illusion) sind an der Primärquelle bestätigt; die v4.0-Begründungsketten halten. Konkret nachzuziehen: SWE-Bench Illusion jetzt v4 (2025-12-01), Hassan SE 3.0 jetzt v3 (2026-06-24), NSA-CSI-Datum 20.05.2026, MCP-Stand "2025-11-25 Current".
2. **Zwei neue Anthropic-2026-Quellen in die Methodik-Begründung aufnehmen.** Die 70/30-Planung-vs.-80/20-Ausführung-Befunde und das Doer-Verifier/Roster-Muster liefern externe Validierung für Autoritätsstufen und Verifikationsbandbreite — zitierfähig als Primärquelle statt Plausibilitätsargument.
3. **Claude-Code-Doku-Features prüfen:** `/goal`-Bedingungen und Stop-Hooks als deterministische Gates sind die produktseitige Entsprechung der hermetischen Gates der v4.0; Auto-Mode (Klassifikator-Permissions) ist ein Kandidat für SPRINT-Modus-Läufe mit niedrigem Risiko. Die 8-Block-Override-Grenze der Stop-Hooks in der Gate-Doku vermerken (Gates nicht als unüberwindbar behandeln).
4. **DTCG-Pipeline auf 2025.10 referenzieren** (erste stabile Version, inkl. Resolver-Modul) statt auf Draft-Stände; OTel-GenAI-Feldnamen dagegen noch nicht einfrieren (Repo-Umzug, Status Development) — Run-Manifeste weiter mit eigenem, stabilem Schema führen und nur Mapping vorsehen.
5. **Rechts-Radar:** Für die öffentlich erreichbaren Weboberflächen gilt: Art.-50-Transparenz ab 02.08.2026 ist vom Omnibus **nicht** verschoben; für private nicht-kommerzielle Angebote ohne Anbieterrolle bleibt die praktische Betroffenheit gering, aber die NFL-Plattform mit Auto-Publishing von KI-Texten sollte eine Kennzeichnungszeile führen (geringer Aufwand, sauberer Auditpfad).
6. **Beobachtungsliste:** METR-Uplift-Folgestudie (neue Zahlen ausstehend), MCP-Draft-Revision, DORA-2026-Zyklus, AGENTS.md unter Linux-Foundation-Governance (mögliche Formal-Spezifikation), Spec Kit Richtung 1.0.

## Bewertung der Quellenlage (Belastbarkeit je Gruppe)

| Quellgruppe | Belastbarkeit | Anmerkung |
|---|---|---|
| Anthropic Engineering/Docs | hoch (Primärquelle, [V]) | Vendor-Perspektive, aber technisch konkret und konsistent mit Dritt-Empirie |
| OpenAI Codex/AGENTS.md | hoch für Konventionen | Marketing-Anteil gering auf den Doc-Seiten |
| DORA | hoch, Zahlen nur im PDF | Landingpages tragen die Kernthese, nicht die Detailzahlen |
| METR | sehr hoch (transparente Selbstkorrektur) | Late-2025-Daten ausdrücklich "very weak evidence" |
| OWASP/Veracode | hoch | ASI-Detailliste formal [S] (PDF) |
| Akademische Preprints | hoch, teils ohne Peer-Review-Abschluss | SWE-Bench Illusion und SE 3.0 weiter Preprints |
| GitClear | mittel-hoch | kommerzieller Anbieter, aber einzige Langzeit-Strukturdatenbasis dieser Größe |
| Standards (DTCG, OTel, MCP) | hoch | OTel GenAI ausdrücklich noch nicht stabil |
| Recht | hoch für Fakten, [S] für Detailfristen | finaler Omnibus-Amtsblatt-Text ausstehend |

## Nicht verifizierbare Quellen

- **designtokens.org/tr/2025.10/** (Format- und Resolver-Modul): Domain blockiert automatisierte Abrufe (robots/Timeout). Kernaussage über die offizielle W3C-Community-Group-Ankündigung [V] abgesichert.
- **gesetze-im-internet.de/bfsg/**: robots/Timeout; BFSG-Inhalte nur [S] über Sekundärlage.
- **NSA-CSI-PDF** (media.defense.gov): nur Pressemitteilung [V]; PDF-Inhalt und die berichtete CISA-/Partner-Mitwirkung [S].
- **OWASP Agentic Top 10 PDF**: Landingpage [V], ASI01–ASI10-Liste über direkt abgerufene Sekundärquelle (Teleport-Blog) bestätigt, formal [S].
- **Stanford-Detailzahlen** (Greenfield/Brownfield-Prozente, Rework): auf der Projektseite nicht publiziert; weiterhin nur Vortrags-/Interviewbelege [S].
- **arxiv.org/abs/2509.06216 direkt**: arXiv lieferte kein parsebares Abstract-HTML; Inhalt vollständig über alphaXiv-Spiegel geprüft (als [V] mit Spiegel-Vermerk geführt).
- **DORA-Detailzahlen 2025** (Adoption, Instabilität, sieben Profile): im Report-PDF, nicht auf den abgerufenen Seiten; Kompendiums-Zahlen bleiben auf dem früheren [V]-Stand der Vorsession.

## Neu entdeckte relevante Primärquellen

1. **Anthropic/Claude: "How Claude Code is used in practice"** (2026-06-16, anthropic.com/research/claude-code-expertise) — erste große Telemetrie-Auswertung realer Claude-Code-Nutzung.
2. **Anthropic/Claude: "Building effective human-agent teams"** (2026-06-24, claude.com/blog) — Team-Muster (Roster, North Star, Doer-Verifier).
3. **DORA: "ROI of AI-assisted Software Development Report"** (dora.dev/research/publications/, Presseecho 05/2026) — dritter Baustein neben Report und Capabilities Model.
4. **OpenTelemetry `semantic-conventions-genai`-Repository** (github.com/open-telemetry/semantic-conventions-genai) — neuer maßgeblicher Ort der GenAI-Konventionen inkl. MCP-Semantik.
5. **Hassan et al. SE 3.0 v3 mit SASE-Rahmen** (2026-06-24) — substanziell erweiterte Fassung der bereits zitierten Roadmap.
6. **METR Time Horizons Dashboard 1.1** (metr.org/time-horizons/, Stand 2026-05-08) — laufend gepflegte Zeithorizont-Daten als Ersatz für veraltete Blogwerte.
7. **MCP Feature-Lifecycle/Deprecation-Policy** (modelcontextprotocol.io, mit Deprecated-Registry) — relevant für die Wartungsplanung eigener MCP-Server.

## Quellenverzeichnis

Alle [V]-Abrufe am 2026-07-28.

1. [V] Anthropic: Building Effective Agents — https://www.anthropic.com/engineering/building-effective-agents
2. [V] Anthropic: How we built our multi-agent research system — https://www.anthropic.com/engineering/multi-agent-research-system
3. [V] Anthropic: Effective context engineering for AI agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
4. [V] Anthropic: Effective harnesses for long-running agents — https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
5. [V] Claude Code Docs: Best practices — https://code.claude.com/docs/en/best-practices
6. [V] Anthropic: How Claude Code is used in practice — https://www.anthropic.com/research/claude-code-expertise
7. [V] Claude Blog: Building effective human-agent teams — https://claude.com/blog/building-effective-human-agent-teams
8. [V] OpenAI: Codex-Doku — https://developers.openai.com/codex
9. [V] OpenAI: Codex Best Practices — https://developers.openai.com/codex/learn/best-practices
10. [V] AGENTS.md — https://agents.md/
11. [V] GitHub: spec-kit — https://github.com/github/spec-kit
12. [V] GitHub Blog: Spec-driven development with AI — https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
13. [V] DORA: 2025 State of AI-assisted Software Development — https://dora.dev/research/2025/dora-report/
14. [V] DORA: AI Capabilities Model — https://dora.dev/ai/capabilities-model/report/
15. [V] DORA: Publications — https://dora.dev/research/publications/
16. [S] InfoQ: New DORA Report… AI ROI (05/2026) — https://www.infoq.com/news/2026/05/dora-roi-ai-assisted-dev-report/
17. [V] METR: RCT arXiv 2507.09089 (v2) — https://arxiv.org/abs/2507.09089
18. [V] METR: Uplift-Update — https://metr.org/blog/2026-02-24-uplift-update/
19. [V] METR: Measuring AI ability to complete long tasks — https://metr.org/blog/2025-03-19-measuring-ai-ability-to-complete-long-tasks/
20. [V] METR: Time Horizons Dashboard — https://metr.org/time-horizons/
21. [V] OWASP GenAI: LLM Top 10 (2025) — https://genai.owasp.org/llm-top-10/
22. [V] OWASP GenAI: Top 10 for Agentic Applications 2026 (Landingpage) — https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
23. [V] Teleport: OWASP Agentic Top 10 Zusammenfassung (ASI-Liste; Sekundärquelle) — https://goteleport.com/blog/owasp-top-10-agentic-applications/
24. [V] Veracode: 2025 GenAI Code Security Report — https://www.veracode.com/resources/analyst-reports/2025-genai-code-security-report/
25. [V] Veracode: Spring 2026 Update — https://www.veracode.com/blog/spring-2026-genai-code-security/
26. [V] Agarwal/He/Vasilescu: AI IDEs or Autonomous Agents (v2) — https://arxiv.org/abs/2601.13597
27. [V] Perry et al.: Do Users Write More Insecure Code… (v3, CCS '23) — https://arxiv.org/abs/2211.03622
28. [V] Liang et al.: The SWE-Bench Illusion (v4) — https://arxiv.org/abs/2506.12286
29. [V] Hassan et al.: Agentic SE / SASE (v3; via alphaXiv-Spiegel) — https://arxiv.org/abs/2509.06216
30. [V] Stanford Software Engineering Productivity — https://softwareengineeringproductivity.stanford.edu/
31. [V] GitClear: The Maintainability Gap 2026 — https://www.gitclear.com/the_ai_code_quality_maintainability_gap
32. [V] W3C DTCG: First stable version 2025.10 (Ankündigung) — https://www.w3.org/community/design-tokens/2025/10/28/design-tokens-specification-reaches-first-stable-version/
33. [S] DTCG: Spec 2025.10 (Format/Resolver; Domain nicht abrufbar) — https://www.designtokens.org/tr/2025.10/
34. [V] DTCG: community-group Repo — https://github.com/design-tokens/community-group
35. [V] OpenTelemetry: GenAI Semconv (Docs, Umzugshinweis) — https://opentelemetry.io/docs/specs/semconv/gen-ai/
36. [V] OpenTelemetry: semantic-conventions-genai Repo — https://github.com/open-telemetry/semantic-conventions-genai
37. [V] MCP: Spezifikation 2025-11-25 — https://modelcontextprotocol.io/specification/2025-11-25
38. [V] MCP: Versioning — https://modelcontextprotocol.io/specification/versioning
39. [V] MCP: Security Best Practices — https://modelcontextprotocol.io/specification/2025-11-25/basic/security_best_practices
40. [V] NSA: Pressemitteilung zur MCP-CSI (2026-05-20) — https://www.nsa.gov/Press-Room/Press-Releases-Statements/Press-Release-View/Article/4496698/
41. [S] NSA AISC: CSI-PDF "MCP: Security Design Considerations…" — via media.defense.gov
42. [V] AI Act Explorer: Artikel 50 — https://artificialintelligenceact.eu/article/50/
43. [V] Gibson Dunn: EU AI Act Omnibus Agreement (Sekundärquelle) — https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/
44. [V] EU-Kommission: European Accessibility Act — https://commission.europa.eu/strategy-and-policy/policies/justice-and-fundamental-rights/disability/european-accessibility-act-eaa_en
45. [V] EUR-Lex: Richtlinie (EU) 2019/882 (Metadaten) — https://eur-lex.europa.eu/legal-content/DE/TXT/?uri=CELEX:32019L0882
46. [S] BFSG-Gesetzestext — https://www.gesetze-im-internet.de/bfsg/
