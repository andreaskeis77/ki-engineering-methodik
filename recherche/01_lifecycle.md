# KI-nativer Engineering-Lifecycle und SDLC-Modelle — Stand der Technik, Forschung und Praxis

Stand: 2026-07-28. Quellenstatus: [V] = URL am 2026-07-28 selbst abgerufen und inhaltlich geprueft; [S] = nur ueber Suchergebnisse belegt.

## Executive Summary

Der KI-native SDLC hat sich 2025/2026 von Experimenten zu einem erkennbaren Konsensmuster verdichtet: ein Lifecycle aus Research → Specify → Plan → Execute (mit Verifikationsschleifen) → Review → Ship → Operate → Learn, in dem Menschen Intent, Architektur und Leitplanken setzen und Agenten die Ausfuehrung uebernehmen. Spec-driven Development (SDD) ist die dominierende Formalisierung: GitHub Spec Kit (v0.13.0, Juli 2026, 123k Stars), Amazon Kiro (EARS-Requirements, Design, Tasks), OpenSpec (Change-Deltas fuer Brownfield) und BMAD (Persona-Pipeline) konvergieren auf dieselben Artefakttypen, unterscheiden sich aber stark im Gewicht. Thoughtworks stuft SDD weiterhin nur als "Assess" ein und warnt vor ueberschweren Workflows und einer "bitter lesson" handgefertigter Regelwerke; das ungeloeste Kernproblem aller Frameworks ist Spec Drift, also die Divergenz von Spezifikation und Implementierung nach dem Merge. Die Forschung (u. a. eine grosse arXiv-Uebersicht 04/2026) zeigt: Agentische Systeme loesen inzwischen ~78 % von SWE-bench Verified, die Arbeitseinheit schrumpft von Sprints auf Minuten-bis-Stunden-Tasks, und der Engpass wandert vom Schreiben zum Verifizieren und Reviewen. DORA 2025 belegt, dass KI ein Verstaerker der vorhandenen Organisationsqualitaet ist und benennt sieben Kapazitaeten (u. a. klare KI-Policy, kleine Batches, Versionskontrolle, interne Plattformqualitaet), die den Nutzen moderieren. Der groesste Dissens der Anbieter betrifft die Gate-Philosophie: Anthropic und Thoughtworks setzen auf harte Verifikationsschleifen und Test-Gates, waehrend OpenAI im "Harness Engineering"-Bericht bewusst minimale Merge-Gates faehrt und Qualitaet ex post ueber striktes Architektur-Enforcement, Continuous Cleanup und billige Korrekturen sichert. Google SRE liefert mit Autonomiestufen L0–L4, Progressive Authorization und "Golden Data"-Evaluierung das derzeit ausgereifteste Betriebsmodell fuer agentische Autonomie. Systems-Engineering-seitig bestaetigen INCOSE SE Vision 2035 und die Provenance-Forschung die Richtung durchgaengiger digitaler Faeden, Traceability und kontinuierlicher V&V — mit dem Befund, dass einheitliche Trace-Schemata noch fehlen. Fuer Andreas' Methodik v4.0 bedeutet das: Kernentscheidungen (Autoritaetsstufen, Spezifikationspflicht, hermetische Gates, Kontext-Engineering, Run-Manifeste, Verifikationsbandbreite) sind durch den Stand 2026 breit bestaetigt; nachzuschaerfen sind Spec-Reconciliation, evidenzbasierter Autonomie-Aufstieg, EARS-Requirements und ein explizites Ex-post-Kontrollregime fuer den SPRINT-Modus.

## 1. Das konvergente Lifecycle-Bild 2026

Ueber Anbieter- und Forschungsgrenzen hinweg hat sich ein gemeinsames Phasenmuster herausgebildet, das sich als **Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn** beschreiben laesst:

- **Anthropic (Claude Code Best Practices)** [V]: Der empfohlene Vier-Phasen-Workflow Explore → Plan → Implement → Commit, mit Plan Mode als explizitem Trennmechanismus zwischen Recherche und Ausfuehrung. Zentrales Prinzip: "Give Claude a way to verify its work" — jede Aufgabe braucht einen maschinenlesbaren Check (Tests, Build-Exit-Code, Screenshot-Vergleich), der als Prompt-Anweisung, `/goal`-Bedingung, deterministischer Stop-Hook oder adversarialer Review-Subagent eskaliert werden kann. Ergaenzt um Interview-getriebene Spec-Erstellung ("Let Claude interview you" → SPEC.md, dann frische Session zur Umsetzung), Writer/Reviewer-Trennung in getrennten Kontexten und Fan-out ueber `claude -p` fuer Migrationen.
- **GitHub Spec Kit** [V]: Sieben Kommandos — `/speckit.constitution` (unveraenderliche Projektprinzipien), `specify`, `clarify`, `plan`, `tasks`, `analyze` (Cross-Artefakt-Konsistenzpruefung), `implement`. Version 0.13.0 vom 17.07.2026, 123k Stars, 30+ Agent-Integrationen, Erweiterungssystem (Extensions/Presets/Bundles).
- **Amazon Kiro** [V, Docs]: Drei Spec-Dateien — `requirements.md` in EARS-Notation ("WHEN [Bedingung] THE SYSTEM SHALL [Verhalten]"), `design.md` (Architektur, Sequenzdiagramme), `tasks.md` (diskrete, verfolgbare Tasks) — plus Vier-Phasen-Workflow Requirements → Design → Implementation Planning → Execution. Ergaenzend Hooks und Steering-Dateien [S].
- **Forschung** [V, arXiv:2604.26275]: Eine Referenzarchitektur in sechs Schichten (L0 Foundation-Modelle bis L5 Governance/Safety) und eine Phasen-Gegenueberstellung: Requirements werden zu Intent-Spezifikation mit Agenten-Entwurf, Design zu "Agenten schlagen vor, Mensch waehlt", Implementierung zu "Agent fuehrt aus, Mensch reviewt", Testing zu generierten Suiten, Deployment zu CI-Agenten-Gates mit menschlicher Freigabe, Maintenance zu Monitor-/Repair-Agenten. Kernbefund: Die Arbeitseinheit schrumpft von Zwei-Wochen-Sprints auf Minuten-bis-Stunden-Tasks; "developers shift from producing to orchestrating, reviewing, and directing". SWE-bench-Verified-Loesungsraten stiegen von 1,96 % (10/2023) auf 78,4 % (04/2026) fuer agentische Systeme, waehrend nicht-agentische Ansaetze bei ~20 % stagnieren.

Microsoft propagiert dasselbe Bild als End-to-End-agentischen SDLC auf Azure/GitHub [S], PwC und Beratungen vermarkten es als "Agentic SDLC" [S]. Wichtig zur Einordnung: Die Konvergenz betrifft die **Artefaktstruktur** (Konstitution/Leitplanken, Spezifikation, Plan, Tasks, Verifikationsnachweis), nicht das Prozessgewicht — dort liegen die echten Differenzen (Abschnitt 6).

## 2. Spec-driven Development: Reifegrad und Kritik

Der Frameworkvergleich (dev.to-Analyse [V], konsistent mit Marktuebersichten [S]) ergibt ein klares Nutzungsprofil:

| Framework | Modell | Staerken | Schwaechen |
|---|---|---|---|
| Spec Kit (v0.13.0) | Linear: Constitution → Spec → Plan → Tasks → Implement | Greenfield, 30+ Agenten, `analyze`-Konsistenzcheck | Change-skopierte Artefakte; Reverse-Engineering-Last in Bestandscode |
| OpenSpec | Change-zentriert: Deltas (ADDED/MODIFIED/REMOVED) gegen Ist-Verhalten | Brownfield-nativ, Specs kumulieren zur Systemdoku, geringe Einstiegshuerde | Keine Multi-Agent-Orchestrierung, manuelle Drift-Reconciliation |
| BMAD (v6) | Multi-Agent-Persona-Pipeline (Analyst→PM→Architect→SM→Dev→QA) mit versionierten Artefakten | Audit-Trail Requirement→PR, compliance-tauglich | Token-schwer, Handoff-Fehler, setzt Prozessdisziplin voraus |

Drei Befunde sind methodisch entscheidend. Erstens **Spec Drift**: Alle Frameworks scheitern bisher daran, Spezifikationen nach der Implementierung automatisch abzugleichen; "a stale spec misleads agents that don't know any better" — die Reconciliation bleibt manuell und wird in der Praxis uebersprungen [V]. Zweitens die **Thoughtworks-Einordnung** [V]: SDD steht im Radar (Stand 11/2025) nur auf "Assess"; die Workflows seien "elaborate and opinionated", erzeugten schwer reviewbare Spec-Waende, und es drohe eine "bitter lesson — that handcrafting detailed rules for AI ultimately doesn't scale". Drittens **EARS als praktikabler Requirements-Standard**: Kiro hat die aus der Luftfahrt (Rolls-Royce) stammende Notation massentauglich gemacht — testbare, atomare Anforderungssaetze, die sich direkt in Akzeptanztests uebersetzen lassen [V].

Radar Vol. 34 (04/2026) [V] liefert den uebergreifenden Rahmen: Thoughtworks warnt vor **"Cognitive Debt"** — KI erzeugt Code schneller, als Menschen Systemverstaendnis aufbauen — und empfiehlt Rueckbesinnung auf Fundamentals (Testbarkeit, DORA-Metriken, Zero Trust) sowie "Harnesses" fuer Coding-Agenten mit Feedforward-Kontrollen (Skills, SDD) und Feedback-Kontrollen (u. a. Mutation Testing zur Selbstkorrektur vor menschlichem Review).

## 3. TDD/BDD und Verifikation mit Agenten

Die Verifikationsfrage ist 2026 der am besten untersuchte und zugleich strittigste Teil des KI-nativen Lifecycles:

- **Anthropic** [V] macht Verifizierbarkeit zum Architekturprinzip: Ohne maschinenlesbaren Check wird der Mensch zur Verifikationsschleife; mit Check schliesst sich die Schleife autonom. Deterministische Stop-Hooks blockieren das Beenden eines Turns bis der Check besteht; adversariale Review-Subagenten mit frischem Kontext pruefen Diffs gegen Plan und Kriterien — mit der expliziten Warnung, Reviewer auf korrektheitsrelevante Findings zu beschraenken, um Over-Engineering zu vermeiden.
- **TDAD (arXiv:2603.17973, 03/2026)** [V] quantifiziert: Ein Code-Test-Abhaengigkeitsgraph (AST-basiert), der dem Agenten die betroffenen Tests als leichtgewichtigen Skill mitgibt, senkte Regressionen um 70 % (6,08 % → 1,82 % Testfehler) und hob die Loesungsrate von 24 % auf 32 %. Zentral ist das **TDD-Prompting-Paradox**: Rein prozedurale TDD-Anweisungen im Prompt *erhoehten* bei kleineren Modellen die Regressionen auf 9,94 % — "context (which tests to check) outperforms procedure (how to do TDD)". Fuer Multi-Agent-Codegenerierung existiert ergaenzend Arbeit zu TDD-Governance via Prompt Engineering [S, arXiv:2604.26615].
- **OpenAI (Harness Engineering, 2026)** [V] widerspricht der harten Gate-Philosophie frontal: Beim Bau eines Produkts mit ~1 Mio. Zeilen ausschliesslich Codex-generierten Codes (5 Monate, anfangs 3 Engineers, ~1.500 PRs, ~3,5 PRs/Engineer/Tag) galten **minimale Merge-Gates** — "corrections are cheap, waiting is expensive"; strikte Test-first-Workflows und blockierende Reviews wurden als kontraproduktiv bei hoher Agentengeschwindigkeit eingestuft. Kompensiert wird ex post: strikt erzwungene Schichtenarchitektur (Custom-Linter validieren Abhaengigkeitsrichtungen), Continuous-Cleanup-Agenten als "Garbage Collection fuer Tech Debt", Doku als System of Record (AGENTS.md als Inhaltsverzeichnis, "give Codex a map, not a 1,000-page instruction manual"), Observability-Zugriff fuer Agenten (LogQL/PromQL, Chrome DevTools Protocol). Lehre: "Enforcement beats guidance" — mechanische Invarianten-Validierung skaliert besser als Doku.

Die Aufloesung des scheinbaren Widerspruchs: Es konkurrieren zwei Kontrollregime — **ex ante** (hermetische Gates vor Merge; Anthropic, Thoughtworks, klassisches DevSecOps) und **ex post** (freier Fluss plus starres Architektur-Enforcement, schnelles Rollback, kontinuierliche Reparatur; OpenAI, in Teilen Google SRE mit Fix-Forward). Beide setzen dieselbe Grundlage voraus: deterministisch erzwungene Invarianten statt promptbasierter Disziplin.

## 4. Betrieb: DORA, DevSecOps, Platform Engineering, SRE

**DORA 2025 (State of AI-assisted Software Development)** [V]: KI ist "primarily an amplifier" — sie vergroessert vorhandene Staerken und Dysfunktionen; ~90 % der Entwickler nutzen KI taeglich. Das begleitende **AI Capabilities Model** [V] benennt sieben moderierende Kapazitaeten: (1) klare, kommunizierte KI-Policy, (2) gesundes Datenoekosystem, (3) KI-zugaengliche interne Daten ("context engineering"), (4) starke Versionskontrolle mit Rollback, (5) Arbeit in kleinen Batches (explizit gegen schwer reviewbare KI-Grossdiffs), (6) Nutzerzentrierung ("speed is irrelevant if you are moving in the wrong direction"), (7) hochwertige interne Plattformen als "paved roads".

**Google SRE (AI engineering for reliable operations)** [V] liefert das ausgereifteste Autonomie-Betriebsmodell: eine **Safety-Trifecta** (Transparenz der Agenten-Begruendung inkl. gelogter Hypothesen und Konfidenzen; Echtzeit-Risikobewertung jeder Aktion im Kontext von Deployments, Error Budgets, Incidents; **Progressive Authorization** — Autonomie wird nur nach nachgewiesener Praezision gegen menschlich verifizierte "Golden"-Evaluationsdatensaetze erweitert und bei Risikospitzen dynamisch degradiert). Autonomiestufen **L0–L4** (Mensch entscheidet → KI schlaegt vor → KI handelt in definierten Szenarien → KI fuehrt Incident-Lifecycle adaptiv). Architektur-Guardrails: Least Privilege mit eigenen Agenten-Identitaeten, verpflichtender Dry-Run, agentische Circuit Breaker, Zero-Trust-Aktuierung ueber einen zentralen Control Plane (kein Agent fuehrt rohe Skripte aus). Messbare Effekte: ~44 % MTTM-Reduktion durch Investigation Dashboards. Fuer agentische Entwicklung fordert Google den Shift von Zeilen-Review zu Validierung von "designs, intent, and policies", adaptive progressive Rollouts, Feature Flags und AI-Assisted Fix-Forward.

**Platform Engineering** [V, CNCF 07/2026]: "Platform Engineering 2.0" erweitert interne Entwicklungsplattformen um **Agenten als eigenstaendige Plattformnutzer** mit Governance, Zugriffskontrollen und Guardrails analog zu Menschen; Golden Paths umfassen kuenftig Modell-Lifecycle, MCP-Gateways und agentische Angriffsvektoren. Die Community erwartet die Verschmelzung von Platform Engineering und KI-Betrieb [S, platformengineering.org, The New Stack].

**DevSecOps** [S]: OWASP hat 2026 die Top 10 fuer Agentic Applications veroeffentlicht; AI-BOM (Bill of Materials fuer Modelle/Agenten), MCP-Security und die Uebertragung von SLSA-Provenance auf agentisch erzeugte Artefakte sind die aktiven Baustellen (OWASP Global AppSec EU 2026, State of Agentic AI Security v2.01 06/2026). Kernaussage der Supply-Chain-Community: Agenten setzen die Uhr der Lieferkettensicherheit teilweise auf null zurueck.

**Continuous Discovery** [S]: Teresa Torres selbst operationalisiert ihr Framework inzwischen mit KI (Interview-Auswertung, synthetische Personas mit Vorsicht, KI-Prototypen als Discovery-Beschleuniger); Discovery bleibt der menschlich gefuehrte Teil des Lifecycles, wird aber agentengestuetzt guenstiger und kontinuierlicher.

## 5. Systems Engineering, Traceability, kontinuierliche V&V

**INCOSE SE Vision 2035** [V]: MBSE wird Fundament der SE-Praxis — ontologisch verknuepfte, Digital-Twin-basierte Modell-Assets, ein durchgaengiger Digital Thread "cradle to grave", AI/ML-Agenten fuer Parameterstudien und Safety/Security-Explorationsraeume, sowie **kontinuierliche Validierung** durch Echtzeitmonitoring und "Shadow Software" im Parallelbetrieb. Traceability laeuft ueber semantisch reiche Modelle mit Audit-Trails. Die akademische Umsetzung fuer KI-gestuetztes MBSE ("MBSE Co-Pilot", Wiley Systems Engineering 2026) ist Forschungs-Roadmap, keine Praxis [S]. Fuer den Privatkontext relevant ist die abgespeckte Lesart: maschinenlesbare Anforderungen (EARS), verknuepfte Artefakte (Spec ↔ Design ↔ Task ↔ Test ↔ Run) und kontinuierliche Pruefung — nicht SysML-Werkzeugketten.

**Execution Provenance (arXiv:2606.04990, 06/2026)** [V]: Die Survey systematisiert Evidenz- und Ausfuehrungs-Provenance fuer LLM-Agenten — Trace-Quellen (Reasoning, Retrieval, Tools, Memory, Multi-Agent), Provenance-Relationen (Support/Derive/Depend-on/Invalidate…), Granularitaet (Run/Step/Tool-Call/Claim) und Trust-Funktionen (Verifikation, Attribution, Audit, Recovery), angebunden an W3C PROV-DM und OpenTelemetry. Befund: "final-answer accuracy alone cannot explain how an output was produced" — Bewertung verschiebt sich zu **Prozess-Accountability**. Offene Luecken: einheitliche Trace-Schemata, Claim-Level-Provenance, provenance-getriebene Runtime-Guardrails, Rollback-/Kompensationsmechanismen. Praktisch heisst das: Wer heute Run-Manifeste fuehrt, ist der Standardisierung voraus; ein anschlussfaehiges Vokabular (PROV-DM-Begriffe, OTel-Spans) reduziert spaeteren Migrationsaufwand. Fuer Requirements-Traceability mit LLMs existieren erste Ansaetze (TraceLLM) und regulatorische Treiber (EU-AI-Act-Anforderungsvalidierung) [S].

## 6. Konsens und Dissens

**Konsens der grossen Anbieter und der Forschung (belastbar):**
1. Spezifikation vor Implementierung; Intent und Akzeptanzkriterien sind das primaere menschliche Artefakt (GitHub, Amazon, Anthropic, OpenAI, Forschung — einhellig).
2. Verifikation ist der Engpass; der Mensch wird Review-Bottleneck, daher maschinenlesbare Checks, unabhaengige Reviewer-Kontexte und Evidenzpflicht ("show evidence rather than asserting success").
3. Kontext ist die knappe Ressource: kuratierte, schlanke, hierarchische Repo-Doku (CLAUDE.md/AGENTS.md als Karte), progressive Disclosure, Subagenten zur Kontextisolation.
4. Deterministisches Enforcement schlaegt promptbasierte Anweisung (Hooks, Linter, Architektur-Validierung, Sandboxing).
5. Kleine Batches, starke Versionskontrolle, schnelles Rollback (DORA, Anthropic, Google).
6. Autonomie ist gestuft und muss verdient werden (Google Progressive Authorization; Forschung: "delegated execution under human supervision").
7. Wissensablage im Repo statt in Koepfen/Chats — "repository knowledge is infrastructure" (OpenAI).

**Dissens (echt, nicht rhetorisch):**
- **Gate-Philosophie:** ex ante hermetische Test-/Review-Gates (Anthropic, Thoughtworks, DevSecOps) vs. ex post minimale Merge-Gates mit Architektur-Enforcement und Continuous Cleanup (OpenAI). Beides funktioniert nachweislich — unter verschiedenen Voraussetzungen (Risikoprofil, Rollback-Faehigkeit, Enforcement-Reife).
- **Prozessgewicht von SDD:** Vollformalisierte Pipelines (BMAD, Spec Kit komplett) vs. Thoughtworks-Skepsis (Assess, "bitter lesson", schwer reviewbare Spec-Waende) vs. leichtgewichtige Interview-Specs (Anthropic). Die Empirie fuer schwere SDD-Prozesse ist duenn; Token-Kosten und Handoff-Fehler sind dokumentiert.
- **TDD als Agentenprozedur:** Als Prompt-Prozedur teils kontraproduktiv (TDAD-Paradox), als deterministisches Gate bzw. Kontextlieferung (betroffene Tests) klar wirksam — die Community verwischt diesen Unterschied haeufig.
- **Ausmass der Rollenverschiebung:** Forschung dokumentiert einen Zwei-Klassen-Arbeitsmarkt (erfahrene Orchestratoren profitieren, Einsteiger straucheln); Anbieter-Marketing ("AI-native 2026", Xebia/PwC [S]) ueberzeichnet die Autonomiereife jenseits gut abgegrenzter Domaenen.

## Konsequenzen fuer Andreas' Methodik und Projekte

**Breit bestaetigt (beibehalten, teils schaerfen):**
1. **Autoritaetsstufen A0–A5** sind durch Googles L0–L4 plus Progressive Authorization extern validiert. Schaerfung: Aufstieg nicht diskretionaer, sondern **evidenzbasiert** — pro Projekt eine kleine "Golden"-Menge verifizierter Faelle (Regression-Suite, historische Fixes), gegen die ein Agent nachweislich performen muss, bevor eine hoehere Stufe gilt; bei Auffaelligkeiten automatische Degradierung (sein A-Modell bekommt damit Auf- *und* Abstieg).
2. **Spezifikationspflicht** entspricht dem Branchenkonsens. Empfehlung: Anthropic-Interviewmuster als Standard-Erstellungsweg (Agent interviewt Andreas, SPEC.md, frische Session zur Umsetzung) statt schwerer Persona-Pipelines; BMAD ist fuer den Ein-Personen-Kontext ueberdimensioniert.
3. **Test-first mit hermetischen Gates** bleibt fuer die Daten-/Wissensplattformen (Provenance, Auto-Deploy) richtig — aber als *deterministische* Gates (Stop-Hooks, CI), nicht als prozedurale TDD-Prompts (TDAD-Paradox). Zusaetzlich pro Repo eine leichte Test-Impact-Angabe (welche Tests betreffen welche Module) als Agentenkontext — grosser Effekt bei minimalem Aufwand.
4. **Kontext-Engineering und Run-Manifeste** sind Stand der Technik bzw. voraus. Empfehlung: Run-Manifeste terminologisch an W3C PROV-DM/OTel anlehnen (Entities/Activities/Agents, Span-IDs), um anschlussfaehig zu bleiben; Evidenzpflicht (Testoutput, Kommandos, Exit-Codes) als Manifest-Pflichtfelder.
5. **Verifikationsbandbreite als WIP-Limit** deckt sich mit dem Forschungsbefund "Economics of human review bottlenecks" und DORAs Small-Batches-Kapazitaet.

**Erweitern/korrigieren:**
6. **Spec-Reconciliation als expliziter Lifecycle-Schritt:** Nach jedem Merge prueft ein Agent Spec↔Code-Divergenz und aktualisiert die Spec (OpenSpec-Delta-Denkweise fuer die Brownfield-Mehrheit seiner 11 Projekte). Ohne diesen Schritt werden Specs zur aktiven Fehlerquelle fuer nachfolgende Agenten.
7. **EARS-Notation fuer Anforderungen** uebernehmen (MBSE light ohne SysML): testbar, atomar, direkt in Gates uebersetzbar; passt zu Ontologie-/Provenance-Projekten als natuerliche Traceability-Anker Spec→Test→Run.
8. **Ex-post-Regime fuer SPRINT sauber definieren:** OpenAI zeigt, dass minimale Gates tragen, wenn (a) Architektur-Invarianten mechanisch erzwungen werden (Linter/Hooks), (b) Rollback trivial ist, (c) Continuous-Cleanup-Laeufe existieren. SPRINT sollte genau diese drei Voraussetzungen als Eintrittsbedingung haben — damit ist HYBRID kein Kompromiss, sondern regelbasierte Regime-Wahl je Archetyp (Privatprodukte: SPRINT-tauglich; NFL-Auto-Deploy und Provenance-Plattformen: STANDARD/ex ante).
9. **Continuous-Cleanup-Agent** einfuehren (woechentlicher Scheduled Run: Drift-, Debt-, Doku-Scan mit Fix-PRs) — direkt uebertragbares OpenAI-Muster, auch auf Windows/PowerShell.
10. **Mutation Testing pilotieren** (Thoughtworks-Feedback-Control) fuer die kritischen Kernmodule der Wissensplattformen: misst, ob die von Agenten generierten Tests tatsaechlich Fehler fangen — genau die Schwachstelle test-generierender Agenten.
11. **Betrieb der NFL-Plattform an SRE light anlehnen:** progressive Rollouts mit automatischem Health-Check, Feature-Flag fuer Sofortabschaltung, Fix-Forward vor Rollback, Fehlerbudget als Autonomie-Drossel (bei Budgetverbrauch faellt Auto-Deploy eine A-Stufe zurueck).
12. **DORA-Kapazitaeten als Jahres-Checkliste** nutzen (KI-Policy = seine Methodik-Doku; interne Datenzugaenglichkeit = MCP-Anbindung eigener Wissensbasen; Plattformqualitaet = Repo-Vorlagen/Hooks als persoenliche "paved road" — ein volles IDP ist ueberdimensioniert).

## Bewertungstabelle

| Methode/Technologie | Einordnung fuer Andreas' Kontext |
|---|---|
| Lifecycle-Muster Specify→Plan→Execute→Verify→Review→Ship | jetzt empfohlen (bereits weitgehend implementiert) |
| Spec Kit (leichtgewichtig genutzt: constitution/specify/clarify/analyze) | sinnvoll unter Bedingungen (Greenfield; Kommandos als Vorlage, nicht als Pflichtpipeline) |
| OpenSpec / Change-Delta-Spezifikation | jetzt empfohlen fuer Brownfield-Projekte |
| EARS-Requirements-Notation | jetzt empfohlen |
| Kiro als IDE | beobachten (Konzepte uebernehmen, Werkzeugbindung an AWS unnoetig) |
| BMAD-Persona-Pipeline | ueberdimensioniert fuer den Privatkontext |
| Deterministische Verifikations-Gates (Stop-Hooks, CI, /goal) | jetzt empfohlen |
| Prozedurale TDD-Prompts ohne Gate | derzeit nicht belastbar (Paradox-Befund) |
| Test-Impact-Kontext (TDAD-Muster) | pilotgeeignet, hoher erwarteter Nutzen |
| Mutation Testing fuer Kernmodule | pilotgeeignet |
| Ex-post-Regime (minimale Gates + Architektur-Enforcement + Cleanup) | sinnvoll unter Bedingungen (nur SPRINT-Archetypen mit trivialem Rollback) |
| Progressive Authorization mit Golden-Data-Evals | jetzt empfohlen (Schaerfung von A0–A5) |
| Run-Manifeste mit PROV/OTel-Vokabular | jetzt empfohlen (bestehende Praxis anschlussfaehig machen) |
| Platform Engineering 2.0 / IDP | ueberdimensioniert; "paved road" als Repo-Vorlagen+Hooks sinnvoll |
| SRE light (Rollout-Gates, Feature Flags, Fehlerbudget-Drossel) | jetzt empfohlen fuer Auto-Deploy-Projekte |
| OWASP Agentic Top 10 / AI-BOM | beobachten, als Sicherheitsanker ergaenzen |
| MBSE/SysML-Werkzeugketten, Digital Twin voll | ueberdimensioniert; Digital-Thread-Prinzip (verknuepfte Artefakte) uebernehmen |
| KI-gestuetzte Continuous Discovery (Interview-Auswertung, Prototypen) | sinnvoll unter Bedingungen (leichtgewichtig, fuer Privatprodukte) |
| "AI-native 2026"-Gesamtautonomie-Narrative (Beratungen) | ueberwiegend Marketing |

## Quellenverzeichnis

1. [V] Anthropic: Best practices for Claude Code — code.claude.com/docs/en/best-practices (abgerufen 2026-07-28)
2. [V] OpenAI: Harness engineering: leveraging Codex in an agent-first world — openai.com/index/harness-engineering/ (abgerufen 2026-07-28)
3. [V] GitHub Spec Kit Dokumentation — github.github.com/spec-kit/ (Stand 2026-05-27; abgerufen 2026-07-28)
4. [V] GitHub spec-kit Repository (v0.13.0, 2026-07-17) — github.com/github/spec-kit (abgerufen 2026-07-28)
5. [V] Kiro Docs: Specs Concepts (EARS, requirements/design/tasks) — kiro.dev/docs/specs/concepts/ (Stand 2025-11-10; abgerufen 2026-07-28)
6. [V] W. Torber: Spec Kit vs BMAD vs OpenSpec — dev.to/willtorber/... (abgerufen 2026-07-28)
7. [V] arXiv:2604.26275 — Agentic AI in the Software Development Lifecycle (04/2026; abgerufen 2026-07-28)
8. [V] arXiv:2603.17973 — TDAD: Test-Driven Agentic Development (2026-03-18; abgerufen 2026-07-28)
9. [V] arXiv:2606.04990 — From Agent Traces to Trust: Evidence Tracing and Execution Provenance in LLM Agents (2026-06-03; abgerufen 2026-07-28)
10. [V] DORA: State of AI-assisted Software Development 2025 — dora.dev/dora-report-2025/ (abgerufen 2026-07-28)
11. [V] Google Cloud Blog: From adoption to impact — DORA AI Capabilities Model (abgerufen 2026-07-28)
12. [V] Google SRE: AI engineering for reliable operations — sre.google/resources/practices-and-processes/ai-engineering-reliable-operations/ (abgerufen 2026-07-28)
13. [V] CNCF: Evolving platform engineering for AI-native workloads (2026-07-06) — cncf.io (abgerufen 2026-07-28)
14. [V] Thoughtworks Technology Radar: Spec-driven development (Assess, 2025-11-05) — thoughtworks.com/radar/techniques/spec-driven-development (abgerufen 2026-07-28)
15. [V] Thoughtworks: Radar Vol. 34 — Cognitive Debt, Harnesses, Mutation Testing (2026-04) — thoughtworks.com/about-us/news/2026/combat-ai-cognitive-debt-radar-v34 (abgerufen 2026-07-28)
16. [V] INCOSE Systems Engineering Vision 2035: Model-Based Practices — sevisionweb.incose.org/model-based-practices (abgerufen 2026-07-28)
17. [S] Microsoft Tech Community: An AI led SDLC — End-to-End Agentic SDLC mit Azure und GitHub (Stand 2026-02-05)
18. [S] arXiv:2604.26615 — TDD Governance for Multi-Agent Code Generation via Prompt Engineering
19. [S] Zhang et al.: MBSE Co-Pilot: A Research Roadmap — Systems Engineering (Wiley/INCOSE, 2026)
20. [S] OWASP Top 10 for Agentic Applications 2026 (via Cycode / Practical DevSecOps)
21. [S] OWASP: State of Agentic AI Security and Governance v2.01 (06/2026)
22. [S] Xygeni: OWASP Global AppSec EU 2026 — Supply Chain, MCP Security, AI-BOM
23. [S] CNCF: Platform engineering for the agentic enterprise (2026-07-21)
24. [S] platformengineering.org: 10 Platform engineering predictions for 2026
25. [S] The New Stack: In 2026, AI Is Merging With Platform Engineering
26. [S] Rootly / Traversal / Augment Code: AI-SRE-Marktueberblicke 2026
27. [S] AGENTS.md Field Guide 2026 / codersera: AGENTS.md Complete Guide 2026
28. [S] Teresa Torres / Product Talk: AI Product Discovery (Podcast/Beitraege 2026)
29. [S] Xebia: 2026 — The Year Software Engineering Will Become AI Native
30. [S] PwC: Agentic SDLC in practice — the rise of autonomous software delivery (2026)
