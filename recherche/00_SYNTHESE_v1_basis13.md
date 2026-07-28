# Gesamtsynthese: State-of-the-Art-Sweep KI-natives Software- und Systems-Engineering

Stand: 2026-07-28. Grundlage: Dossiers 01–13 (Lifecycle, Artefakte, Orchestrierung, MCP, Architektur, Plattform/Betrieb, Qualität, Experimente/Evals, UX, Android, Daten, Sicherheit, Quellenregister-Verifikation). Kontext: Andreas' Methodik v4.0 — Chefarchitekt-Mensch plus autonome Agenten, 11 private, anspruchsvolle Projekte, Windows-Server/Laptop, Claude Code als Primärwerkzeug. Diese Synthese verdichtet; Detailbelege und Quellen stehen in den Einzeldossiers (zitiert als D01–D13).

---

## 1. Executive Summary

Der Sweep zeigt ein 2026 deutlich konsolidiertes Feld: Über Anbieter- und Forschungsgrenzen hinweg hat sich ein KI-nativer Lifecycle aus Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn etabliert, in dem der Mensch Intent, Architektur und Leitplanken setzt und Agenten ausführen (D01). Die Methodik v4.0 wird in ihren Kernentscheidungen breit und teils wörtlich bestätigt: Autoritätsstufen, Spezifikationspflicht, hermetische Gates, Kontext-Engineering, Run-Manifeste und Verifikationsbandbreite entsprechen dem Stand der Technik oder sind ihm — bei Provenance — sogar voraus (D01, D05, D07, D11, D13). Der wichtigste übergreifende Befund: Der Engpass ist durchgängig Verifikation und Review, nicht Codeerzeugung — Prüfkapazität ist der Regler, an dem Parallelität, Autonomie und Werkzeugwahl hängen (D01, D03, D07, D08). Zweitens gilt: Verbindlich ist nur, was deterministisch erzwungen wird (Hooks, CI, Fitness Functions, Sandbox); Kontextdateien und Prompts sind advisory — das TDD-Prompting-Paradox ist das Warnbeispiel (D01, D02, D06, D08). Drittens ist das Selbstbestätigungsproblem jetzt quantifiziert (SpecBench-Reward-Hacking, Selbstkorrektur-Illusion, Rauschen von KI-Reviews): Nötig sind Held-out-Abnahmetests, Rollentrennung mit frischem Kontext und menschliche Freigabe — KI-Review ersetzt sie nicht (D03, D07). Echter Dissens besteht nur bei der Gate-Philosophie (ex ante hermetisch vs. OpenAIs ex post mit Architektur-Enforcement und Continuous Cleanup) und beim Prozessgewicht von Spec-driven Development — beides löst sich als regelbasierte Regime-Wahl je Projektarchetyp, nicht als Glaubensfrage (D01). Die neue Empirie (METR-Redesign, DORA-ROI, GitClear, Veracode, AIDev) widerlegt nichts an v4.0, differenziert aber: Nutzen konzentriert sich auf gut spezifizierte Standardaufgaben (~35–40 % vs. ~10 % bei komplexem Legacy-Code), Strukturerosion (Duplikation +81 %, Refactoring-Kollaps) und Security-Schwächen (XSS, Log Injection <20 % Pass-Rate) sind messbar, und Selbstwahrnehmung ist als Steuerungsgröße unbrauchbar (D07, D08). Werkzeugseitig ist Claude Code zur Plattform gereift (Hooks, Plugins, Sandbox, Headless-JSON-Läufe, Worktrees, Agent Teams, Remote Control), die die Methodik erstmals vollständig technisch durchsetzbar macht — mit der harten Randbedingung, dass die Sandbox natives Windows nicht unterstützt und WSL2 ab Autoritätsstufe A3+ faktisch Pflicht wird (D06, D12). Standards konsolidieren unter neutraler Governance (AGENTS.md, MCP, Skills unter der Linux Foundation; DTCG v2025.10 stabil; SLSA/Artifact Attestations auch privat verfügbar) — Lock-in-Risiken sinken, CLI-first bleibt für Coding-Agenten trotzdem richtig (D02, D04, D07, D09). Sicherheit verschiebt sich von Detektion zu Architektur: Lethal-Trifecta-Prüfung, Sandbox mit Egress-Allowlist, eigene Agentenidentität und Supply-Chain-Härtung nach den Wurmwellen; die Behörden-Guidance (NSA, CISA) deckt sich fast eins zu eins mit der v4.0-Philosophie (D04, D12). Daten- und Rechtsrahmen sind geklärt genug für feste Regeln: Drei-DB-Strategie bestätigt, Primärspeicher nur auf Dekaden-Formaten (Kuzu-Lektion), Compliance-by-Provenance beim Scraping, EU-AI-Act-Art.-50-Transparenz ab 02.08.2026 (vom Digital Omnibus nicht verschoben), Android Developer Verification ab 2026/2027 (D10, D11, D12, D13). Was der Methodik fehlt, ist klar umrissen: Spec-Reconciliation nach Merge, Held-out-Suiten, eine eigene Eval-Suite mit pass^k und evidenzbasiertem Auf- und Abstieg der Autoritätsstufen, eine explizite Verbindlichkeits-Taxonomie, Erosions-Gegenkräfte (Cleanup-Agent, Fitness Functions), Experiment-Protokoll, Annahmenregister und die Paketierung der Methodik als versioniertes Plugin. Überdimensioniert bleiben für den Privatkontext die Enterprise-Ketten: Microservices, Kafka, volle IDPs, Vault, Triple-Stores, BMAD-Persona-Pipelines, Multi-Agent-Flotten und SaaS-Eval-Plattformen. Die Tranche-1-Vertiefung sollte daraus Operating Model und Lifecycle-Referenzmodell bauen: konvergentes Phasenmuster plus Reconciliation- und Learn-Schritt, Regime-Wahl je Archetyp, evidenzbasierte Autonomie, Artefaktkanon mit E/N/I-Verbindlichkeit und ein Betriebs-Layer (SRE light, Backups als Gate, mobile Asymmetrie).

---

## 2. Die wichtigsten übergreifenden Befunde

1. **Konvergentes Lifecycle-Muster, divergentes Prozessgewicht.** Anthropic, GitHub Spec Kit, Amazon Kiro, OpenAI und die Forschung konvergieren auf dieselbe Artefaktkette (Konstitution/Leitplanken → Spezifikation → Plan → Tasks → Verifikationsnachweis) und das Phasenmuster Research→Specify→Plan→Execute+Verify→Review→Ship→Operate→Learn. Der Streit betrifft nur das Gewicht: Thoughtworks stuft SDD weiter als "Assess" ein und warnt vor schwer reviewbaren Spec-Wänden; leichtgewichtige Interview-Specs (Anthropic-Muster) sind für den Solo-Kontext der richtige Standard. Ungelöstes Kernproblem aller Frameworks: **Spec Drift** nach dem Merge (D01, D02).

2. **Verifikation ist der Engpass — Verifikationsbandbreite ist der Kernregler.** Multi-Agent kostet ~15× Chat-Tokens, Review ist branchenweit der neue Bottleneck, die METR-RCT zeigt 19 % Verlangsamung bei gefühlten +20 %. Konsequenz: WIP-Limit als "max. N offene, ungeprüfte Agenten-PRs" (nicht als Zahl laufender Agenten), Parallelisierung nur bei unabhängigen, read-lastigen Teilaufgaben oder disjunkten Dateimengen mit automatischem Verifier (D01, D03, D07, D08).

3. **Deterministisches Enforcement schlägt promptbasierte Disziplin.** Konsens aller Lager: Hooks, Permission-Rules, CI-Gates, Architektur-Fitness-Functions und Sandboxing erzwingen; CLAUDE.md/AGENTS.md und ADR-Regeln beraten. Das TDAD-Paradox (prozedurale TDD-Prompts erhöhen Regressionen, Test-Impact-Kontext senkt sie um 70 %) zeigt den Unterschied messbar. Daraus folgt die Verbindlichkeits-Taxonomie E (erzwungen) / N (normativ-advisory) / I (informativ) mit Promotion-Pfad für wiederholt verletzte N-Regeln (D01, D02, D06, D08).

4. **Das Selbstbestätigungsproblem ist quantifiziert und braucht strukturelle Antworten.** SpecBench: sichtbare Tests werden gesättigt, verdeckte Spezifikationstests divergieren um ~27 pp pro Verzehnfachung der Codegröße (Extremfall 97 % sichtbar / 0 % verdeckt); ~65 % sind Kompositionsfehler. Wirksames Fünf-Elemente-Schema: Spec als Testquelle, Red-first mit dokumentiertem Rot-Beweis, Rollentrennung Test-Autor/Implementierer, **Held-out-Abnahmetests** (nur CI, für den Implementierer unsichtbar), Mutation Testing als Stichproben-Audit (D07).

5. **Selbstkorrektur ist eine Illusion, unabhängige Zweitinstanz funktioniert.** Byte-identische Fehler werden 23–93 pp häufiger korrigiert, wenn sie als fremd präsentiert werden; der Reviewer-Subagent mit frischem Kontext (sieht nur Diff + Kriterien) ist daher empirisch fundiert — aber eng zu scopen (Reviewer-Overfitting erzeugt Over-Engineering). KI-Review als Ersatz menschlicher Freigabe ist nicht belastbar: −23 pp Merge-Rate, 60 % der Agent-only-Reviews unter 30 % Signalanteil (MSR 2026); das Copilot-Prinzip "Requestor darf nicht approven" ist das passende Governance-Muster (D03, D07, D09).

6. **Autonomie ist gestuft, wird verdient und wird entzogen.** Google SRE (L0–L4, Progressive Authorization gegen Golden-Data-Evals, dynamische Degradierung), CISA/NSA-Guidance (progressive Autonomie, Containment vor Effizienz) und die SASE-Forschung (Autonomiestufen 0–5) validieren A0–A5 extern. Neu: Aufstieg sollte evidenzbasiert erfolgen (eigene Golden-Task-Evals, pass^k als Zuverlässigkeitsmetrik statt pass@k) und bei Fehlerbudget-Verbrauch automatisch degradieren. Anthropics Telemetrie liefert die Arbeitsteilung dazu: Menschen treffen ~70 % der Planungs-, Claude ~80 % der Ausführungsentscheidungen (D01, D08, D12, D13).

7. **Kontext ist die knappe Ressource; kuratierte, schlanke Artefakte sind messbar besser.** AGENTS.md ist De-facto-Standard (Linux Foundation, 60k+ Projekte); Claude Code bindet ihn per `@AGENTS.md`-Import an. Empirie: menschlich kuratierte Kontextdateien +4 % Erfolgsrate bzw. 20–28 % weniger Zeit/Tokens, auto-generierte schaden leicht, jede Datei kostet 20 %+ Inferenz — Regel: <200 Zeilen, nur Nicht-Ableitbares, Schichtung über rules/Skills/Links. Tool Search (Default in Claude Code) entschärft Toolkatalog-Kosten (~85 % Ersparnis) (D02, D04, D05).

8. **Zwei legitime Kontrollregime — Regime-Wahl statt Dogma.** Ex ante (hermetische Test-/Review-Gates: Anthropic, Thoughtworks, DevSecOps) und ex post (minimale Merge-Gates + mechanisch erzwungene Architektur-Invarianten + Continuous Cleanup + triviales Rollback: OpenAI Harness Engineering) funktionieren beide nachweislich. Für die Methodik heißt das: SPRINT-Modus bekommt die drei OpenAI-Voraussetzungen als Eintrittsbedingung; STANDARD/ex ante bleibt für Auto-Deploy- und Provenance-Plattformen. HYBRID wird damit regelbasierte Archetyp-Zuordnung statt Kompromiss (D01).

9. **Agentenfreundliche Architektur ist gute Architektur mit verschobenen Prioritäten.** Modularer Monolith, Vertical Slices, Hexagonal light, DDD light, Greppability, Ein-Kommando-Verify <60 s, strict typing und maschinell erzwungene Modulgrenzen (import-linter/dependency-cruiser) sind der harte Leistungsfaktor; Microservices, Kafka, volle Clean Architecture und separate BFFs vervielfachen Agenten-Blindstellen ohne Gegenwert. Slices sind die natürliche Einheit für Worktree-Parallelität und WIP-Limit (D05).

10. **Qualitätserosion ist messbar und braucht institutionalisierte Gegenkräfte.** GitClear (623 Mio. Änderungen): Block-Duplikation +81 %, Refactoring-Anteil 21 %→3,8 %, Konnektivität −35 %; Veracode: Security-Pass-Rate stagniert bei ~55 %, XSS/Log Injection <20 %; Thoughtworks warnt vor "Cognitive Debt". Gegenmittel mit Evidenz: Fitness Functions als drittes Gate, Continuous-Cleanup-Läufe, Parallel-Varianten mit Löschzwang, Security-Gates gezielt auf die schwachen Klassen, Refactoring-Budget (D05, D07, D08).

11. **Sicherheit: Architektur statt Detektion; Werkzeuge jetzt auch für Einzelpersonen.** Prompt Injection ist nicht zuverlässig detektierbar ("95 % Erkennung" ist keine Sicherheitsgrenze); wirksam ist das Aufbrechen der Lethal Trifecta pro Lauf, deterministische Gates für konsequenzielle Aktionen und technische Egress-Kontrolle. Die Claude-Code-Sandbox (OS-Enforcement, Credential-Masking, strictAllowlist) macht das erstmals ohne Enterprise-Infrastruktur umsetzbar — läuft aber **nicht auf nativem Windows** (nur WSL2); zudem deckt `sandbox.denyRead` das Read-Tool nicht (beide Schichten nötig). Supply-Chain-Wurmwellen (Shai-Hulud, LiteLLM/Telnyx) begründen: Lockfiles mit Hashes, Cooldown 3–7 Tage, ignore-scripts, osv-scanner, eigene Agentenidentität mit kurzlebigen Tokens (D04, D06, D12).

12. **MCP konsolidiert unter neutraler Governance — CLI-first bleibt trotzdem richtig.** MCP löst das N×M-Integrationsproblem und liegt bei der Agentic AI Foundation; die große Protokollrevision (Stateless Core, Extensions, OAuth-Härtung, Deprecation von Roots/Sampling/Logging) stand zum Stichtag als Release Candidate unmittelbar bevor (D13 präzisiert: "Current" war bei Prüfung noch 2025-11-25 — Deprecations gleichwohl ab sofort meiden). Für Coding-Agenten mit Terminal sind CLIs 4–32× token-günstiger; MCP lohnt bei Multi-Client-Zugriff, Browser-Steuerung (Playwright MCP) und als schmale, überwiegend read-only Fassade über eigene Plattform-APIs. Registry-Einträge verifizieren Namen, nicht Gutartigkeit (D04, D13).

13. **Provenance und Evidence Chain werden Standard — die Methodik ist voraus.** Die Forschung verschiebt Bewertung zu Prozess-Accountability ("final-answer accuracy alone cannot explain how an output was produced"); W3C PROV bleibt das stabile Referenzmodell und lässt sich relational implementieren (source/fetch/raw_artifact/transform_run/claim); SLSA v1.2 und GitHub Artifact Attestations (auch private Repos) liefern Artefakt-Provenance als Ein-Schritt-Feature. Run-Manifeste und Provenance-Kern sollten ein Schema teilen und PROV/OTel-Vokabular übernehmen (Feldnamen der OTel-GenAI-Konventionen noch nicht einfrieren — Status Development) (D01, D07, D11, D13).

14. **Die 2026er-Empirie differenziert, statt zu widerlegen.** METR stellt sein RCT-Design wegen Selektionseffekten um (−18 %/−4 %, "very weak evidence"); DORA misst 35–40 % Gewinn bei einfachen vs. ~10 % bei komplexen Aufgaben und leicht steigende Instabilität; AIDev zeigt 46 % Ablehnungsquote agentischer Bug-Fix-PRs überwiegend aus Prozess-, nicht Codegründen; ICSE-Studien dokumentieren den Shift von Erstellung zu Verifikation. Konsequenzen: Autonomie nach Task-Klasse staffeln, eigene Kennzahlen-Baseline und lokale Struktur-Signale statt Gefühl, Aufgabenpriorisierung und CI-Anforderungen vor Agent-Start (D08).

15. **Neue Pflichten am Rand des Portfolios.** EU AI Act Art. 50 gilt ab 02.08.2026 und wurde vom Digital Omnibus ausdrücklich nicht verschoben (private, nicht-kommerzielle Nutzung weitgehend ausgenommen; Transparenz trotzdem als billiges Default-Feature). Android Developer Verification: Enforcement ab 30.09.2026 (vier Länder), global 2027; Limited Distribution Account (kostenlos, 20 Geräte) ab 08/2026 registrieren, Keystore-Verlust wird "identitätszerstörend" → Signing-Runbook. Scraping: OLG Hamburg und LG München präzisieren TDM-Schranken → API-first, maschinenlesbare Opt-outs respektieren und protokollieren (Compliance-by-Provenance) (D10, D11, D12, D13).

---

## 3. Was bestätigt die Methodik v4.0, was fordert sie heraus, was fehlt ihr

### 3.1 Breit bestätigt (beibehalten, teils schärfen)

- **Autoritätsstufen A0–A5**: extern validiert durch Google L0–L4/Progressive Authorization, CISA-Guidance, SASE-Autonomiestufen, Anthropic-Telemetrie (70/30 vs. 80/20) (D01, D08, D12, D13).
- **Spezifikationspflicht**: Branchenkonsens; Anthropic-Interview-Muster (AskUserQuestion → SPEC.md → frische Session) als Standard-Erstellungsweg; binär verifizierbare Akzeptanzkriterien als Hebel (D01, D02).
- **Hermetische Test-Gates und Test-first**: bestätigt — aber als deterministische Gates (Stop-Hooks, CI), nicht als prozedurale TDD-Prompts; lokale Stop-Hooks sind Beschleuniger (8-Block-Override), CI bleibt letzte Instanz (D01, D07).
- **Verifikationsbandbreite als WIP-Limit**: deckt sich mit Review-Bottleneck-Empirie und DORAs Small-Batches-Kapazität (D01, D03).
- **Run-Manifeste und Evidenzpflicht**: wörtlich bestätigt ("show evidence rather than asserting success"; SASE Merge-Readiness-Pack); der Provenance-Forschung sogar voraus (D01, D05, D07, D11).
- **Kontext-Engineering, kuratierte CLAUDE.md, MCP-Fähigkeitsklassen M0–M4, Trust Boundaries/untrusted Input, Least Agency**: durch Empirie, Spezifikations- und Behörden-Guidance gedeckt (D02, D04, D12).
- **Kapitel 15 (UX)**: Reihenfolge, Zustandsmatrix, Token-Schichten, Baseline-Governance und Designschleife entsprechen dem verifizierten Stand; Anthropics Generator/Evaluator-Harness bestätigt die Schleife (D09).
- **Drei-DB-Strategie, Playwright-Adapter, Provenance-Leitbild, raw→staging→marts**: Lehrbuchstand 2026 (D11).
- **Architektur-Defaults** (modularer Monolith, ein Repo, kein Kafka/Microservices): Konsens; SASE-Forschung mappt v4.0-Bausteine fast eins zu eins (BriefingScript≈Spezifikation, MRP≈Run-Manifest, CRP≈Eskalation) (D05, D13).

### 3.2 Herausgefordert (korrigieren oder präzisieren)

- **Gate-Philosophie als Universalprinzip**: OpenAIs ex-post-Regime zeigt, dass minimale Gates unter definierten Bedingungen tragen. v4.0 muss die Regime-Wahl je Archetyp explizit regeln; SPRINT braucht harte Eintrittsbedingungen (mechanische Invarianten, triviales Rollback, Cleanup-Läufe) statt nur reduzierter Zeremonie (D01).
- **Test-Pass-Rate als Erfolgssignal**: Sichtbare Tests sind sättigbar (SpecBench); ohne Held-out-Suite ist "alle Tests grün" bei wachsender Codebasis ein trügerisches Gate (D07).
- **TDD als Prompt-Prozedur**: kontraproduktiv bei kleineren Modellen; Kontext (welche Tests betroffen sind) schlägt Prozedur (D01).
- **Rollenkataloge/Persona-Denken**: Firmen-Simulationen sind Forschungsartefakte; Rollen sind Kontext- und Berechtigungsgrenzen (Lead/Implementer/Reviewer/Explorer), nicht Jobtitel — Katalog verschlanken statt ausbauen (D03).
- **KI-Review als Freigabeersatz**: nicht belastbar; menschliche Freigabe bleibt an A-Stufen gekoppelt, KI-Review nur als eng gescopte Zusatzschicht (D07).
- **Windows-native als primäre Agenten-Laufzeit**: Sandbox existiert dort nicht; ab A3+ ist WSL2 (oder Devcontainer) die Voraussetzung; PowerShell-native Projekte kompensieren über Deny-Rules und Hooks (D06, D12).
- **Selbstwahrnehmung als Steuerungsgröße**: durchgängig widerlegt (METR-Wahrnehmungslücke ~40 pp); Methodikentscheidungen brauchen Artefakt-Metriken (D08).
- **GitHub-Environment-Gates in privaten Repos**: erst ab Enterprise verfügbar — mobiles Freigabe-Gate stattdessen über Remote-Control-Permission-Prompts und workflow_dispatch (D06).
- **Formale MBSE-/SysML- und RDF/OWL-Ambitionen**: Digital-Thread-Prinzip und PROV/SKOS-Vokabular ja, Werkzeugketten nein (D01, D11).

### 3.3 Was fehlt (neue Bausteine für v4.x)

1. **Spec-Reconciliation als Lifecycle-Pflichtschritt** nach jedem Merge (OpenSpec-Delta-Denkweise für Brownfield) (D01, D02).
2. **Held-out-Abnahmesuite** je Projekt (5–20 Spezifikationstests, agentenunsichtbar, nur CI) — wichtigste Einzelneuerung (D07).
3. **Eigene Eval-Suite** (20–50 Golden Tasks aus realen Fehlern, Grader-Trias, pass^k als Freigabemetrik, Kanarien-Subset) als Grundlage evidenzbasierten A-Auf-/Abstiegs; LLM-as-Judge nur kalibriert (D08).
4. **Verbindlichkeits-Taxonomie E/N/I** mit Promotion-Pfad in die Methodik-Doku (D02).
5. **Erosions-Gegenkräfte**: Continuous-Cleanup-Agent (wöchentlich), Architektur-Fitness-Functions als Gate, Parallel-Varianten-Löschzwang, lokale GitClear-artige Signale (D01, D05, D08).
6. **Experiment-Protokoll**: Spike-Karten (Hypothese, Erfolgskriterium, Zeit-/Token-Box, Entsorgungsregel) plus Experiment-Log (D08).
7. **Annahmenregister**: [NEEDS CLARIFICATION]-Konvention, "Annahmen deklarieren statt raten", Fragen-Kopplung an A-Stufen (+8 pp Lösungsrate belegt) (D02).
8. **EARS-artige Anforderungsnotation** als Traceability-Anker Spec→Test→Run (D01, D02).
9. **Trifecta-Feld im Run-Manifest** und konkrete Agentenidentität (Bot-Account, fine-grained PATs, Credential-Masking, Env-Scrubbing) (D12).
10. **Backup-Härtung als Autonomie-Gate**: append-only-Ziele, Agenten ohne Schreibrecht aufs Backup, automatisierte Restore-Proben mit Dead-Man-Switch — Nachweis als Bedingung für A5 (D06, D12).
11. **Methodik als versioniertes Claude-Code-Plugin** (Hooks=A-Stufen, Skills=Modi, Agents=Rollen, Settings) statt kopierter CLAUDE.md-Fragmente (D06).
12. **Betriebs-Layer**: SRE light (progressive Rollouts, Feature-Flags, Fehlerbudget als Autonomie-Drossel), Observability-Minimum (JSON-Logs, Uptime Kuma + Healthchecks), mobile Positiv-/Negativliste (D01, D06).
13. **Distribution & Signing Runbook** für den Mobile-Archetyp; Limited Distribution Account ab 08/2026; Art.-50-Transparenzzeile für öffentlich erreichbare KI-Ausgaben (D10, D12).
14. **UX-Ergänzungen**: Ein-Seiten-UX-Spec je Feature, DESIGN.md (Anti-Slop-Brief), getrennter Design-Evaluator (D09).
15. **Daten-Bausteine**: Primärspeicher-Regel (Dekaden-Formate), dataset.yaml je Quelle/Mart, bitemporales Spaltenpaar selektiv, Splink für Entity Resolution, SQLite-12-Schritte-Migrationsrezept als Agenten-Guardrail (D11).

---

## 4. Konsolidierte Bewertungstabelle

Skala: **jetzt empfohlen** / **sinnvoll unter Bedingungen** / **pilotgeeignet** / **beobachten** / **überdimensioniert** / **nicht belastbar** / **überwiegend Marketing**. Auswahl der portfoliorelevanten Methoden; Detailbegründungen in den Dossiers.

| Methode / Technologie | Einordnung | Kernbegründung (Dossier) |
|---|---|---|
| Lifecycle Specify→Plan→Execute+Verify→Review→Ship (+ Reconcile/Learn) | jetzt empfohlen | Branchen- und Forschungskonsens; v4.0 weitgehend deckungsgleich (D01) |
| Leichtgewichtige Interview-Specs, EARS-Kriterien, Change-Deltas (OpenSpec-Muster) | jetzt empfohlen | testbar, brownfield-tauglich; schwere SDD-Pipelines empirisch dünn (D01, D02) |
| AGENTS.md als Verfassung + dünne CLAUDE.md-Brücke, <200 Zeilen, E/N/I-Schichtung | jetzt empfohlen | Standard-Governance, Empirie pro Kuratierung (D02) |
| Deterministische Gates: Hooks, /goal, CI, Permission-Rules | jetzt empfohlen | einziger verbindlicher Enforcement-Pfad (D01, D02, D06) |
| Held-out-Abnahmetests (agentenunsichtbar, nur CI) | jetzt empfohlen | direkte SpecBench-Konsequenz (D07) |
| Writer/Reviewer-Split mit frischem Kontext; Zweitmeinungs-Gate | jetzt empfohlen | Selbstkorrektur-Asymmetrie empirisch belegt (D03, D07) |
| Progressive Authorization / evidenzbasierter A-Auf-/Abstieg mit Golden-Data-Evals | jetzt empfohlen | Google-SRE-Muster, schärft A0–A5 (D01, D08) |
| Eigene Golden-Task-Eval-Suite (20–50 Tasks, Grader-Trias) | jetzt empfohlen | Anbieter-Konsens; öffentliche Benchmarks saturiert (D08) |
| Git-Worktrees + PR als Integrationsvertrag; Subagents für Explore/Review | jetzt empfohlen | Industriestandard aller Anbieter (D03, D08) |
| Run-Manifeste mit PROV/OTel-Vokabular; Provenance-Kern relational | jetzt empfohlen | Standardisierung im Anzug; bestehende Praxis anschlussfähig machen (D01, D07, D11) |
| CLI-first für Git/Dateien/Tests/DBs; MCP nur bei Mehrwert | jetzt empfohlen | 4–32× token-günstiger; Anthropic-eigene Praxis (D04) |
| Playwright MCP für Browser-/UI-Prüfung | jetzt empfohlen | deterministisch, auditierbar; Anthropic-intern Standard (D04, D09) |
| Modularer Monolith + Vertical Slices + Hexagonal light + Greppability + Ein-Kommando-Verify | jetzt empfohlen | agentenkritische Leistungsfaktoren (D05) |
| Architektur-Fitness-Functions (import-linter, dependency-cruiser) als Gate | jetzt empfohlen | maschineller Schutz gegen Agenten-Drift und Cognitive Debt (D05, D08) |
| Ruff + pyright als Gate; Hypothesis-PBT; Schemathesis gegen OpenAPI | jetzt empfohlen | schnellste deterministische Signale; strukturell gegen Selbstbestätigung (D07) |
| Mutation Testing als Quartals-Audit (nicht flächiges Gate) | jetzt empfohlen | einziger objektiver Testwirksamkeitsnachweis (ACH/MUTGEN) (D07) |
| Supply-Chain-Paket: Lockfile+Hashes, Cooldown 3–7 Tage, ignore-scripts, osv-scanner | jetzt empfohlen | direkte Antwort auf Wurmwellen 2025/26 (D07, D12) |
| Claude-Code-Sandbox in WSL2 + Egress-Allowlist + Credential-Masking (A3+) | jetzt empfohlen | OS-Enforcement; natives Windows nicht unterstützt (D06, D12) |
| Eigene Agentenidentität (Bot-Account, kurzlebige Tokens) + Trifecta-Prüfung je Lauf | jetzt empfohlen | CISA/OWASP-Konsens; mit Bordmitteln umsetzbar (D12) |
| Methodik als privates Claude-Code-Plugin | jetzt empfohlen | versionierte, auditierbare Verteilung über 11 Projekte (D06) |
| Deploy-Pfad: GitHub-Runner + Tailscale WIF + OpenSSH + Release-Verzeichnis + Auto-Rollback | jetzt empfohlen | secretless, ephemer, auditierbar (D06) |
| restic/Litestream + automatisierte Restore-Proben + append-only (A5-Gate) | jetzt empfohlen | Agenten-Datenzerstörung ist dokumentierte ATLAS-Technik (D06, D12) |
| SQLite/DuckDB/PostgreSQL-Dreiteilung; Primärspeicher nur Dekaden-Formate | jetzt empfohlen | Lehrbuchstand; Kuzu-Lektion (D11) |
| Splink (Entity Resolution), Pandera/pydantic-Gates, dataset.yaml, changedetection.io | jetzt empfohlen | Standardwerkzeuge im DuckDB-Stack; Validierung als Gate (D11) |
| Compliance-by-Provenance beim Scraping (robots/TDM archivieren, API-first) | jetzt empfohlen | Rechtslage präzisiert (OLG HH, LG München) (D11) |
| DTCG v2025.10 als Tokenquelle; shadcn-Modell; Storybook 9; JTBD+Zustandsmatrix als UX-Spec | jetzt empfohlen | erste stabile Spec-Version; agentenfreundlich (D09) |
| Expo/React Native für capsule-app; Maestro-E2E; Obtainium-Distribution; Limited Distribution Account | jetzt empfohlen | beste Agenten-Integration; Verification-Pflicht ab 2026/27 (D10) |
| KI-Review eng gescopt (Security, Diff-vs-Plan) | jetzt empfohlen | Zusatzschicht ja, Freigabeersatz nein (D07) |
| Ex-post-Regime (minimale Gates + Enforcement + Cleanup) für SPRINT-Archetypen | sinnvoll unter Bedingungen | nur mit trivialem Rollback und mechanischen Invarianten (D01) |
| Best-of-N / kompetitive Agenten | sinnvoll unter Bedingungen | nur mit hartem Verifier; sonst Auswahl-Plateau (D03) |
| Background-Agenten (Issue→PR: Claude Code Action, Codex-Muster) | sinnvoll unter Bedingungen | für gut spezifizierte, isolierte Tasks; Review-Kapazität limitiert (D03, D06) |
| Eigener schmaler Remote-MCP-Server (Wissensplattform, read-only) | sinnvoll unter Bedingungen | lohnt ab Multi-Client-Nutzung; Stateless Core senkt Betriebskosten (D04) |
| GitHub Artifact Attestations als Deploy-Gate; SBOM (CycloneDX) | sinnvoll unter Bedingungen | starker Integritätsgewinn bei Auto-Deploy (A4/A5) (D07, D12) |
| Claude for Chrome / Computer Use | sinnvoll unter Bedingungen | nur explorativ; 11,2 % Injection-Restrisiko → kein Gate (D09) |
| LLM-as-Judge | sinnvoll unter Bedingungen | nur binär/pairwise mit Human-Kalibrierung (D08) |
| Dynamic Workflows (Skript-Orchestrierung); Test-Impact-Kontext (TDAD); Playwright Test Agents; Continuous-Cleanup-Agent | pilotgeeignet | offiziell/evidenzbasiert, aber Kosten und Healer-Risiko lokal messen (D01, D03, D07, D09) |
| Agent Teams (experimentell); pass^k-Schwellen; Code Execution/Programmatic Tool Calling; DuckLake (NFL); Crawl4AI; PowerSync; Dev Containers; Logfire | pilotgeeignet | jung bzw. nur für Teilkontexte; mit Erfolgskriterium erproben (D03, D04, D06, D08, D10, D11) |
| OTel-GenAI-Feldnamen; MCP Apps/Registry; ty/Pyrefly; wslc; Tailscale Services; SASE-Vokabular; Kiro als IDE; KMP; ElectricSQL/Zero; AIPREF; Infisical/OpenBao; CaMeL | beobachten | reifend, noch nicht bindungswürdig (D01, D04–D13) |
| Microservices, Kafka, volle Clean Architecture, BFF-Dienst, IDP/Platform-Engineering-Vollausbau, Vault/Enterprise-IdP, Triple-Stores/OWL-Reasoner, DataHub, SaaS-Evals/Flags, Device Farms, Cloud-Visual-Testing, BMAD, MultiDevin-Flotten, eigener OTel-Stack | überdimensioniert | Enterprise-Probleme, die der Privatkontext nicht hat (D03–D09, D11, D12) |
| Prozedurale TDD-Prompts ohne Gate; Ralph-Loops ohne Checks; KI-Review als Freigabeersatz; synthetische Nutzer als Testersatz; PI-Detektions-Guardrails als Primärkontrolle; Tailscale SSH zu Windows; GitHub-Env-Gates privat; öffentliche Benchmarks als Entscheidungsbasis; ungeprüfte Community-MCP-Server | nicht belastbar | jeweils empirisch/technisch widerlegt bzw. nicht verfügbar (D01, D03, D04, D06–D09, D12) |
| "Multi-Agent = besser", "AI-native 2026"-Autonomie-Narrative, Vendor-Review-Claims (Qodo), selbstberichtete Produktivitätsgewinne, "MCP ist tot", "Mobile-First-DevOps", "KI ersetzt UX-Research", "Trusted Publishing löst Supply Chain" | überwiegend Marketing | durch MAST/METR/MSR/Primärquellen widerlegt oder unbelegt (D01, D03, D04, D06–D09, D12) |

---

## 5. Priorisierte Konsequenzen

### Sofort (Regeln und Härtungen mit belegtem Nutzen, geringem Aufwand)

1. **WSL2 als Standard-Laufzeit ab A3+** mit Sandbox-Vollkonfiguration (denyRead beider Schichten, Credential-Masking, strictAllowlist, allowUnsandboxedCommands: false) (D06, D12).
2. **Methodik als privates Claude-Code-Plugin paketieren**: Hooks (A-Stufen, Gates), Skills (Modi), Agents (Rollen mit Tool-Allowlists), Settings — identisch über alle Projekte (D06).
3. **AGENTS.md-Umstellung + Verbindlichkeits-Taxonomie E/N/I** mit Promotion-Pfad; Pruning-Zyklus; Kompaktierungs-Direktiven (D02).
4. **Held-out-Abnahmesuite** für NFL-Plattform und Datenplattformen; Red-first als Protokollpflicht ab A3; Reviewer eng scopen (D07).
5. **WIP-Limit als "max. 2–3 offene, ungeprüfte Agenten-PRs"**; Worktree-Disziplin; Abbruchkriterien (Stagnationsregel, Budgets, Evidenzpflicht) ins Run-Manifest (D03).
6. **Spec-Reconciliation-Schritt, EARS-Kriterien, Annahmenregister** in die Spezifikationspipeline (D01, D02).
7. **Supply-Chain-Paket und Agentenidentität**: Lockfile+Hashes, Cooldown, ignore-scripts, osv-scanner-Gate; GitHub-Bot-Account mit fine-grained PATs; Trifecta-Feld im Run-Manifest (D07, D12).
8. **Backup-Triade mit automatisierten Restore-Proben** (Healthchecks-Ping) als A5-Gate; Deploy-Pfad auf Tailscale WIF umstellen; mobile Positiv-/Negativliste formalisieren (D06, D12).
9. **Gate-Konsolidierung**: Ruff+pyright, Fitness Functions, axe-core, Schemathesis, Hypothesis-Invarianten für Parser/Pipelines; Security-Fokus auf XSS/Log Injection (D05, D07, D08, D09).
10. **Eval-Suite klein starten** (Golden Tasks aus realen Fehlern, Kanarien-Subset nightly); Kennzahlen-Baseline statt Gefühl; Registrierung Limited Distribution Account im August 2026; Art.-50-Transparenzzeile (D08, D10, D12).

### Pilotieren (mit Erfolgskriterium und Messung)

- **Dynamic Workflows** für Repo-Audits/Migrationen (Orchestrierung als versioniertes Artefakt); **Agent Teams** nur read-lastig (Parallel-Review, Bug-Hypothesen) (D03).
- **Test-Impact-Kontext (TDAD-Muster)** und **Mutation-Testing-Audit** auf 1–2 Kernmodulen; **Playwright Test Agents** mit Healer-Diff-Gate (D01, D07, D09).
- **Continuous-Cleanup-Agent** als wöchentlicher Scheduled Run (Drift-, Debt-, Doku-Scan mit Fix-PRs) (D01).
- **pass^k-Schwellen (k=3–5)** als Freigabemetrik für autonome Pfade; LLM-as-Judge-Kalibrierpaket (D08).
- **DuckLake** für die NFL-Plattform (Time Travel für raw→staging→marts); **Splink**-Erstläufe (Spieler/Restaurants); **Crawl4AI** für LLM-Markdown-Extraktion (D11).
- **Eigener schmaler MCP-Server** (read-only Fassade der Wissensplattform, Streamable HTTP) für Multi-Client-Zugriff; **Code Execution/Programmatic Tool Calling** bei komplexen Datenflüssen (D04).
- **Storybook 9 + DESIGN.md + getrennter Design-Evaluator**; **Best-of-N** für schwere, testbare Probleme; **Claude Code GitHub Action** (@claude Issue→PR) in zwei Projekten mit Kostenbremsen (D03, D06, D09).
- **capsule-app-Härtung M1–M3**: OpenAPI-Client + Contract-Snapshot, Maestro-Smoke-Flows, CI-Build, Signing-Runbook, Obtainium-Kanal (D10).

### Beobachten (Radar, keine Bindung)

- MCP-Revisionsrollout (Stateless Core, Extensions; Deprecations Roots/Sampling/Logging schon jetzt meiden), MCP Apps, Registry-Reife (D04, D13).
- OTel-GenAI-Konventionen (Feldnamen nicht einfrieren, Mapping vorsehen); SASE-v3-Vokabular; Spec Kit Richtung 1.0; AGENTS.md-Formalisierung (D07, D13).
- METR-Folgestudie, DORA-2026-Zyklus, weitere AIDev-Auswertungen (D08).
- ty/Pyrefly, wslc/WSL-Container, Tailscale Services/Peer Relays, ElectricSQL/Zero/Triplit, KMP/Compose Multiplatform, Android Studio Agent Mode, DuckPGQ, Croissant, AIPREF-Standard, EN 301 549 v4.1.1, Digital-Omnibus-Amtsblatt, CaMeL-Produktisierung, Infisical/OpenBao (D05–D13).

---

## 6. Vorgaben für die Tranche-1-Vertiefung (Operating Model und Lifecycle-Referenzmodell)

Die Vertiefung sollte nicht neu recherchieren, sondern die folgenden Befunde in ein konsistentes Operating Model und ein Lifecycle-Referenzmodell überführen:

1. **Lifecycle-Referenzmodell auf das konvergente Phasenmuster ausrichten** — Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn — und um zwei neue Pflichtschritte ergänzen: **Spec-Reconciliation nach Merge** und einen **Learn-Schritt**, der reale Agenten-Fehler in die Eval-Suite und Regelverstöße in den E/N/I-Promotion-Pfad einspeist (D01, D02, D08).
2. **Regime-Wahl als Kernentscheidung des Operating Model formalisieren**: ex ante (STANDARD) vs. ex post (SPRINT) je Archetyp, mit den drei SPRINT-Eintrittsbedingungen (mechanisch erzwungene Architektur-Invarianten, triviales Rollback, Continuous-Cleanup-Läufe) als prüfbarer Checkliste; HYBRID wird regelbasierte Zuordnung, kein Kompromiss (D01).
3. **Autoritätsstufen evidenzbasiert machen**: pro Projekt Golden-Task-Suite, pass^k als Freigabemetrik, automatische Degradierung über Fehlerbudget; Orchestrierungsstufen (Einzelsession → Subagents → Background/Worktree+PR → Workflows/Teams) explizit an A-Stufen koppeln (D01, D03, D08).
4. **Verifikationsbandbreite operationalisieren**: WIP-Limit als max. offene ungeprüfte Agenten-PRs, Slice als Einheit von Parallelität und Review, verschlankter Rollenkern (Chefarchitekt, Lead/Planner, Implementer worktree-isoliert, unabhängiger Reviewer read-only, Explorer) mit Tool-Allowlists als versionierte Agents; Zweitmeinungs-Gate ("Beauftragender approved nicht") als Methodikregel (D03).
5. **Artefaktkanon mit Verbindlichkeits-Taxonomie konsolidieren**: AGENTS.md-Verfassung (<200 Zeilen, E/N/I), SPEC mit EARS-Kriterien und Annahmenregister, agentenoptimierte ADRs mit Checks, STATUS/Handover, Run-Manifest (PROV/OTel-angelehnt, Trifecta-Feld, Evidenz-Pflichtfelder), Spike-Karte/Experiment-Log, dataset.yaml, DESIGN.md, Distribution-&-Signing-Runbook — jedes Artefakt mit Eigentümer, Pflege-Trigger und Drift-Schutz (D02, D08, D09, D10, D11, D12).
6. **Qualitätsschicht neu schneiden**: Gate-Hierarchie aus Statik → Tests (inkl. PBT/Schemathesis) → Fitness Functions → Held-out-Suite (nur CI) → menschliche Freigabe, plus Audits (Mutation Testing, Cleanup-Läufe, lokale Erosions-Signale); Regel "Testreparatur ist Codeänderung" und Flaky-Quarantäne-Politik aufnehmen (D05, D07, D08, D09).
7. **Betriebs-Layer ins Referenzmodell integrieren** (Operate ist bislang der dünnste Teil von v4.0): SRE light mit progressiven Rollouts, Feature-Flags und Fehlerbudget als Autonomie-Drossel; Backup/Restore-Probe als A5-Gate; Observability-Minimum (JSON-Log-Schema, Health-Endpoints, Uptime Kuma + Healthchecks, Claude als Diagnose-Konsument); mobile Freigabe-Asymmetrie (freigeben/stoppen ja, destruktiv nie) (D01, D06, D12).
8. **Technisches Fundament festschreiben**: WSL2+Sandbox als Laufzeitbedingung der A-Stufen, Methodik-Plugin als Verteilungsmechanismus, Run-Manifeste an `claude -p --bare --json-schema` gekoppelt, Deploy-Pfad Tailscale-WIF, Agentenidentität und Secrets-Regeln — das Operating Model muss benennen, welche Regel durch welchen Mechanismus erzwungen wird (D06, D12).
9. **Evidence Chain dreistufig definieren**: Stufe 1 überall (Commit-Trailer, PR-Evidenz, CI-Pflichtlauf), Stufe 2 bei Auto-Deploy (Run-Manifest als Artefakt, Attestation + Verify-Gate), Stufe 3 nur bei Bedarf (OTel-GenAI) — mit gemeinsamem Schema von Run-Manifest und Provenance-Kern (D07, D11).
10. **Messdisziplin verankern**: kleine Kennzahlen-Baseline je Projekt (Durchlaufzeit, Rework, Defekt-Escape, Duplikat-/Churn-Signale, Eval-Ergebnisse) als Steuerungsgrundlage des Operating Model; explizites Verbot, Autonomie- oder Werkzeugentscheidungen auf gefühlte Produktivität zu stützen (D08).

---

*Hinweis zur Quellenlage: Das Quellenregister (D13) hat die tragenden Empirie-Anker an den Primärquellen bestätigt; zu beachten sind die dort dokumentierten Präzisierungen (NSA-CSI vom 20.05.2026; MCP-Spec-Stand "2025-11-25 Current" mit 2026-Revision als Release Candidate; SE-3.0/SASE in v3 vom 24.06.2026; zwei neue Anthropic-Primärquellen vom Juni 2026 zur realen Claude-Code-Nutzung und zu Human-Agent-Teams).*
