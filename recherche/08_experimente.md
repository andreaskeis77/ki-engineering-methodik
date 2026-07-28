# Dossier 08 — Experimentiermethodik, Agenten-Evals und neue Empirie

**Stand:** 2026-07-28. **Quellenstatus:** [V] = URL selbst abgerufen und Inhalt geprüft (Abrufdatum 2026-07-28); [S] = nur über Suchergebnisse belegt. Bewertung nach dem Modell aus Kapitel 8 des Forschungsauftrags.

---

## Executive Summary

Die Experimentierseite der Methodik v4.0 wird durch den Stand 2025/2026 in ihrer Grundrichtung bestätigt, muss aber um zwei Bausteine geschärft werden: ein formalisiertes Experiment-Protokoll (Spike-Karten mit Hypothese, Zeitbox, Erfolgskriterium und Entsorgungsregel) und eine eigene, kleine Eval-Suite als Regressionsnetz für Agentenverhalten. Git Worktrees sind 2026 der De-facto-Standard für die Isolation paralleler Agenten-Experimente; Claude Code unterstützt sie inzwischen nativ inklusive Subagenten-Isolation, automatischem Cleanup und Windows-spezifischen Schutzmechanismen. Architecture Fitness Functions erleben durch agentische KI eine Renaissance als maschinenprüfbare Leitplanken; Ford/Richards positionieren MCP als Entkopplungsschicht für Governance. Bei Agenten-Evals konvergieren Anthropic und OpenAI auf dieselbe Praxis: klein anfangen (20–50 Golden Tasks aus realen Fehlern), Grader-Trias aus Code-, Modell- und Human-Grading, pass@k für Fähigkeit und pass^k für Zuverlässigkeit, LLM-as-Judge nur mit Kalibrierung gegen menschliche Labels. Die neue Empirie seit Anfang 2026 korrigiert das Bild nicht fundamental, differenziert es aber: METR misst Ende 2025 statt −19 % nur noch −18 % (Originalgruppe) bzw. −4 % (neue Entwickler) und stellt sein Design wegen massiver Selektionseffekte um; selbstberichtete Gewinne (Median 1,4–2x) bleiben systematisch überhöht. DORA modelliert positiven ROI, findet aber 35–40 % Gewinn nur bei einfachen Aufgaben gegenüber ~10 % bei komplexem Legacy-Code und steigende Instabilität. GitClear dokumentiert strukturelle Erosion (Block-Duplikation +81 %, Refactoring-Kollaps von 21 % auf 3,8 %), Veracode Stagnation der Security-Pass-Rate bei ~55 % trotz zweier Modellgenerationen. Die AIDev-Folgearbeiten zeigen 46 % Ablehnungsquote bei agentischen Bug-Fix-PRs — überwiegend aus Prozess-, nicht aus Codegründen. Konsequenz für Andreas: Autonomie nach Task-Komplexität staffeln, Duplikat-/Churn-Signale lokal messen, Security-Gates gezielt auf die nachweislich schwachen Klassen (XSS, Log Injection) richten, und die Eval-Suite (offene Entscheidung E3) als kleines, kuratiertes Golden-Task-Set jetzt starten.

---

## Teil 1 — Experimentiermethodik

### 1.1 Spikes, PoCs und Prototypen im Agentenzeitalter

Die klassische Agile-Definition (zeitgeboxte Forschungsaufgabe zur Risikoreduktion, Ergebnis ist Erkenntnis, nicht Code) bleibt gültig [S]. Neu ist die Kostenstruktur: Agenten senken die Erstellungskosten eines Prototyps um Größenordnungen, wodurch der Engpass von "bauen" zu "bewerten und entsorgen" wandert. Der wichtigste Grundsatz — "der Prototyp ist eine Frage, kein Produkt" [S] — wird dadurch kritischer, nicht obsoleter: GitClears Befunde (siehe 3.3) zeigen, was passiert, wenn Prototyp-Code ungefiltert ins Hauptsystem sickert. Praktisch bewährt sich ein dreistufiges Muster:

1. **Spike-Karte vor Beginn**: Hypothese ("DuckDB-FTS ist für die NFL-Suche schnell genug"), messbares Erfolgskriterium ("p95 < 100 ms auf 50k Dokumenten"), Zeit-/Token-Box, und vorab fixierte Entscheidungsregel (übernehmen / verwerfen / weiterer Spike). Das entspricht dem Hypothesenteil klassischer Experimentprotokolle und ist die agentenfreundliche Form: Der Agent kann gegen das Kriterium selbst verifizieren.
2. **Isolation** (siehe 1.2), damit der Spike das stabile System physisch nicht berühren kann.
3. **Explizite Entsorgung**: Erkenntnis wandert in ein Experiment-Log/ADR, der Code wird gelöscht oder bewusst als Neuimplementierung (nicht per Merge) übernommen. "Adopt the finding, rewrite the code" verhindert, dass Prototyp-Qualität zur Systemqualität wird.

Ein durch Agenten neu ermöglichtes Muster ist der **Parallel-Varianten-Vergleich**: dieselbe Spezifikation an 2–3 Agenten in getrennten Worktrees, Bewertung über identische Tests plus Rubrik, der Verlierer wird vollständig gelöscht. Community-Guides berichten dies 2026 als etablierte Praxis für Durchsatz und Explorationsbreite [S].

### 1.2 Worktrees und Branches als Isolationsmechanismus

Git Worktrees (getrenntes Arbeitsverzeichnis, gemeinsame Historie) sind der 2026 dominierende Isolationsmechanismus für parallele Agentensessions. Die offizielle Claude-Code-Dokumentation [V] beschreibt eine ausgereifte native Integration, die für Andreas' Workflow direkt relevant ist:

- `claude --worktree <name>` erzeugt Worktree unter `.claude/worktrees/<name>` auf eigenem Branch; `--worktree "#1234"` checkt direkt einen PR aus.
- **Subagenten-Isolation** per Frontmatter `isolation: worktree` — parallele Edits kollidieren nicht; ein periodischer Sweep räumt nur Worktrees ohne ungesicherte Arbeit ab.
- `.worktreeinclude` kopiert gitignorierte Dateien (`.env`, Secrets) automatisch in neue Worktrees — löst das Haupt-Setup-Problem frischer Checkouts.
- `worktree.baseRef` steuert, ob vom Default-Branch (`fresh`, sauber, Standard) oder vom lokalen HEAD (`head`, für Arbeit auf In-Progress-Ständen) abgezweigt wird.
- **Windows-relevant**: Beim Entfernen eines Worktrees löscht Claude Code NTFS-Junctions/Symlinks nur als Link, nicht das Ziel (Schutz erst ab v2.1.205 vollständig) — für Andreas' Windows-Setup ein Grund, aktuelle Versionen zu pinnen.

Branches bleiben der Mechanismus für die *logische* Trennung (Review, PR, CI), Worktrees für die *physische* (parallele Dateisysteme). Temporäre Testumgebungen im Privatkontext heißen realistisch: Worktree + eigene SQLite-/DuckDB-Datei + eigener Port — hermetisch genug, ohne Docker-Pflicht; ephemere Cloud-Preview-Umgebungen sind für den Kontext überdimensioniert.

### 1.3 Feature Flags

Feature Flags entkoppeln Deploy von Release und sind für den vollautonomen Pfad (NFL-Plattform mit Auto-Deploy) das passende Sicherheitsventil: Agent merged hinter Flag, Aktivierung bleibt Eigentümerentscheidung. Standardisierung läuft über **OpenFeature** (CNCF Incubating seit 2023, herstellerneutrale SDK-Schnittstelle; inzwischen mit kostenlosem Linux-Foundation-Kurs LFS140) [S]. Für Andreas' Maßstab gilt: config-/ENV-basierte Flags mit klarer Namenskonvention und dokumentierter Lebensdauer genügen; kommerzielle Flag-Plattformen und selbst gehostete Server (Unleash, Flagsmith) sind überdimensioniert, das OpenFeature-SDK-Muster lohnt nur, falls später Vereinheitlichung über Projekte nötig wird. Zentrale Disziplin ist **Flag-Hygiene**: Jedes Flag erhält Ablaufdatum im Run-Manifest; verwaiste Flags sind dieselbe Erosionsklasse wie GitClears Duplikate.

### 1.4 Architecture Fitness Functions und Benchmarking

Fitness Functions ("Unit Tests für Architektureigenschaften", Ford/Richards seit 2017) erleben laut O'Reilly Radar [V] durch agentische KI eine zweite Welle: Ihr historisches Problem war Brüchigkeit bei Technologiewechseln; Ford/Richards schlagen vor, Governance-Absichten abstrakt zu formulieren und per **MCP als Anticorruption Layer** teamlokal implementieren zu lassen (Buchprojekt "Architecture as Code"). Für den Einzelkontext ist die MCP-Vermittlung noch Beobachtungsmaterial; sofort nutzbar sind klassische Fitness Functions als CI-Gates: `import-linter` (Python-Schichtenregeln), `dependency-cruiser` (TypeScript), Schema-/Migrationsprüfungen, Lizenz- und Größenbudgets. Ihr eigentlicher Wert im Agentenbetrieb: Sie übersetzen Architekturentscheidungen in maschinenprüfbare Leitplanken, die ein Agent nicht "wegdiskutieren" kann — die architektonische Ergänzung zu Andreas' hermetischen Testgates.

Beim **Benchmarking** eigener Varianten gelten zeitlose Regeln, die durch Agenten-Nichtdeterminismus wichtiger werden: fixierte Datensätze und Seeds, mehrere Läufe, Median plus Streuung statt Einzelwert, identische Umgebung, Ergebnisse im Experiment-Log mit Rohdaten. Öffentliche Coding-Benchmarks (SWE-bench u. a.) gelten 2026 als weitgehend saturiert und für Werkzeugentscheidungen nur noch eingeschränkt aussagekräftig [S] — ein weiteres Argument für eigene Task-Suiten (Teil 2).

---

## Teil 2 — Agenten-Evals und neue Empirie

### 2.1 Eval-Methodik: Konvergenz der Anbieter-Leitfäden

Anthropics Engineering-Leitfaden "Demystifying evals for AI agents" (2026-01-09) [V] und OpenAIs Evaluation Best Practices [V] konvergieren auf eine gemeinsame Praxis, die sich fast unverändert auf den Privatkontext übertragen lässt:

- **Klein starten**: "20–50 simple tasks drawn from real failures is a great start" (Anthropic). Nicht auf hunderte Fälle warten; jede real beobachtete Agenten-Panne wird zum Golden Task.
- **Grader-Trias**: Code-basierte Grader (schnell, objektiv, spröde gegenüber validen Variationen), modellbasierte Grader (flexibel, nichtdeterministisch, teurer), Human-Grading (Goldstandard, teuer). Für Code-Agenten empfiehlt Anthropic konkret: Unit-Tests als primärer Grader plus LLM-Rubriken für Qualitätsaspekte.
- **pass@k vs. pass^k**: pass@k (mindestens 1 von k Läufen erfolgreich) misst Fähigkeit; **pass^k (alle k Läufe erfolgreich) misst Zuverlässigkeit** und ist die richtige Metrik für autonome Pfade. Varianz ist Messgegenstand, nicht Störgröße: mehrere Trials pro Task, isolierte Umgebungen je Trial.
- **Grader-Qualität dominiert**: Anthropic dokumentiert einen Fall, in dem Grader-Fixes (starre Präzisionsanforderungen, mehrdeutige Task-Spezifikationen) die gemessene Rate von 42 % auf 95 % hoben — ein erheblicher Teil scheinbarer Modellschwäche ist Eval-Artefakt. Gegenmittel: Referenzlösungen je Task, ausbalancierte Sets (positive *und* negative Fälle, an denen ein Agent korrekt ablehnen/eskalieren muss), regelmäßiges Lesen der Transcripts, Sättigungsprüfung (100 % = Eval liefert kein Signal mehr).
- **LLM-as-Judge nur kalibriert**: OpenAI empfiehlt Pairwise-Vergleich oder binäres pass/fail statt feiner Skalen, Chain-of-Thought im Judge, Kontrolle von Positions- und Längen-Bias (Antwortreihenfolge tauschen), und Skalierung erst, wenn der Judge "consistently agrees with human annotations". Praktisch: eine kleine, menschlich gelabelte Stichprobe (20–50 Urteile) als Kalibrierreferenz, Übereinstimmung periodisch nachmessen [V; Bias-Taxonomien ergänzend [S]].
- **Kontinuierlich, aber kostenbewusst**: OpenAI rät zu "continuous evaluation" bei jeder Änderung; im Privatkontext realistisch als gestuftes Schema — Kanarien-Subset (5–10 Tasks, die nie fehlschlagen dürfen) pro Nacht oder pro Agent-Konfigurationsänderung, Vollsuite vor Modell-/Promptwechseln.

Als Harness genügen pytest-basierte Eigenbauten; wer Struktur will, findet in **Inspect AI** (UK AI Security Institute, Open Source, Python) und **promptfoo** etablierte lokale Frameworks [S]. SaaS-Eval-Plattformen sind für den Kontext überdimensioniert. Evaluation-Driven Development ist als Begriff akademisch beschrieben (Prozessmodell/Referenzarchitektur, arXiv 2411.13768) [S], inhaltlich deckungsgleich mit obiger Praxis.

### 2.2 Neue Empirie seit Anfang 2026: Produktivität

**METR-Redesign (2026-02-24)** [V]: METR ändert das RCT-Design wegen dreier Validitätsprobleme: Rekrutierungsverzerrung (Entwickler wollen nicht ohne KI arbeiten), massiver Task-Selektionsbias (30–50 % der Entwickler reichen gerade die Tasks nicht ein, bei denen KI am meisten hilft — Zitat eines Teilnehmers: "Ich vermeide absichtlich Issues, die KI in 2 Stunden lösen kann"), unzuverlässige Zeitmessung bei agentischen Tools. Zwischenergebnisse der zweiten Studie (57 Entwickler, 143 Repos, 800+ Tasks, Ende 2025): **−18 % Speedup (CI −38 % bis +9 %) für die Originalgruppe, −4 % (CI −15 % bis +9 %) für neue Entwickler** — die berühmte −19 % ist also weder bestätigt noch widerlegt, sondern in ein "vermutlich um null, mit großer Unsicherheit, bei erfahrenen Entwicklern im eigenen Repo" übergegangen. METR verbreitert auf Beobachtungsdaten (~4 % der GitHub-Commits stammen von Claude Code), Fixed-Task-Experimente und Agent-Evals.

**METR-Survey (2026-05-11)** [V]: 349 technische Fachkräfte berichten Median-Wertgewinn 1,4–2x und Geschwindigkeitsgewinn ~3x durch KI (März 2026), mit Prognose 2,5x für 2027. METR selbst mahnt zur Skepsis: In der eigenen 2025er-Studie überschätzten Teilnehmer den KI-Effekt im Schnitt um 40 Prozentpunkte; die Prüfung extremer Antworten (≥10x) ergab mehrfach Übertreibung; METR-Mitarbeiter gaben die niedrigsten Schätzungen ab. Kernbotschaft: **Die Wahrnehmungs-Mess-Lücke besteht fort** — Selbstauskünfte sind als Evidenz für Methodikentscheidungen ungeeignet.

**DORA "ROI of AI-assisted Software Development" (April/Mai 2026)** [V via InfoQ; dora.dev-Landingpage abgerufen, inhaltsarm]: ~5.000 Befragte plus >100 Interviewstunden. Modellierter Erst-Jahres-ROI ~39 % (Payback ~8 Monate) für eine 500-Personen-Organisation — Modellrechnung, keine Messung. Belastbarer sind die Differenzierungen: **35–40 % Produktivitätsgewinn bei einfachen Aufgaben, nur ~10 % bei komplexem Legacy-Code**; Change-Failure-Rate steigt von 5 % auf 6 %; der Nutzen fließt über sieben organisatorische Fähigkeiten (u. a. interne Plattformqualität, Versionskontrollpraxis, KI-zugängliche Daten). Harveys Fazit — Rendite kommt "not from the tools themselves but from … the underlying organizational system" — ist die empirische Bestätigung von Andreas' Kernthese, dass Methodik (Kontext, Gates, Artefakte) den Unterschied macht.

**ICSE 2026**: Die Längsschnittstudie von Vella/Blincoe (University of Auckland; 158→101 Teilnehmer, Okt 2024/Apr 2025) [V] findet stabil 84 % selbstberichtete Produktivitätsverbesserung und 82 % weniger Zeit beim Code-Schreiben — bei gleichzeitiger Verdopplung des Anteils mit verschlechterter Developer Experience in mindestens einer Dimension (14 %→27 %); dokumentierter **Shift von Erstellung zu Verifikation**. "Beyond the Commit" (CMU + BNY Mellon, 2.989 Entwickler, ICSE-SEIP 2026) [V] findet widersprüchliche Nützlichkeitswahrnehmungen und mahnt Langfristmetriken an (technische Expertise, Ownership) — deckungsgleich mit Andreas' Sorge um Kompetenzerhalt beim Chefarchitekten-Modell. Eine IBM-Enterprise-Studie zu Nutzung/Anforderungen erschien ebenfalls bei ICSE 2026 [S].

### 2.3 Neue Empirie: Qualität und Sicherheit

**GitClear "The Maintainability Gap" (2026)** [V]: 623 Mio. Code-Änderungen 2023–2026, acht Qualitätssignale. Block-Duplikation +81 % seit 2023; Copy/Paste-Anteil 9,4 % (2022) → 15,7 % (H1 2026); **Refactoring-Anteil kollabiert von 21 % (2022) auf 3,8 % (2026)**; Two-Week-Churn +15 %; Konnektivität neuen Codes zum Bestand −35 %; Legacy-Pflege −74 %; fehlermaskierende Konstrukte +47 %. Interpretation: KI-Volumen ersetzt Strukturpflege — genau der Drift, den Fitness Functions, Refactoring-Budgets und der Parallel-Varianten-Löschzwang (Teil 1) adressieren.

**Veracode Spring 2026 Update (2026-03-24)** [V]: >150 Modelle, 80 Tasks, 4 Sprachen/CWE-Klassen. **Security-Pass-Rate stagniert bei ~55 %** ("Zwei Jahre revolutionärer Model-Releases haben die Security-Bilanz von etwa 55 % auf etwa 55 % bewegt"), während Syntaxkorrektheit >95 % erreicht. Python 62 %, C# 58 %, JavaScript 57 %, Java 29 %; SQL-Injection/Krypto >80 % Pass, **XSS und Log Injection <20 %**; OpenAI-Reasoning-Modelle als Ausreißer bei 70–72 %. Konsequenz: Security-Gates dürfen nicht generisch sein, sondern müssen die nachweislich schwachen Klassen gezielt prüfen.

**AIDev-Folgearbeiten (MSR 2026 Mining Challenge)**: Die Rejection-Studie (arXiv 2606.13468, Juni 2026) [V] analysiert 306 abgelehnte von 1.497 agentischen Bug-Fix-PRs (Copilot, Devin, Cursor, Claude): **46,4 % Ablehnungsrate**; identifizierte Gründe verteilen sich auf Relevanz/Priorität (24,5 %), Implementierungsprobleme (9,6 %), Provider-Fehler (8,5 %), technische Probleme wie CI-Brüche (7,2 %), Rest unklar. Praktische Ableitung der Autoren: explizite Fix-Strategie-Vorgaben, klare Test-/CI-Richtlinien, Aufgabenpriorisierung *vor* Agent-Einsatz — exakt die Funktion von Spezifikationspflicht und Autoritätsstufen. Die Schwesterstudie (arXiv 2601.17581) [V] charakterisiert 24.014 gemergte agentische PRs (440k Commits) gegen 5.081 menschliche: deutlich mehr Commits je PR (Cliff's δ 0,54), aber leicht *höhere* Konsistenz zwischen PR-Beschreibung und Diff — agentische PRs sind beschreibungstreuer, aber granularer zu reviewen.

**Gesamtbild der Empirie**: Kein 2026er-Befund widerlegt die v4.0-Architektur; die Daten verschieben die Debatte von "hilft KI?" zu "unter welchen Bedingungen, bei welcher Task-Klasse, zu welchen Strukturkosten?". Die Methodik-Antwort darauf sind differenzierte Autonomie, eigene Evals und harte Struktur-Gates.

---

## Konsequenzen für Andreas' Methodik und Projekte

1. **Experiment-Protokoll als Artefakttyp einführen** (Ergänzung zu Run-Manifesten): Spike-Karte mit Hypothese, Erfolgskriterium, Zeit-/Token-Box, Entscheidungsregel; Ergebnis als Eintrag im Experiment-Log/ADR. Begründung: macht Spikes agentenverifizierbar und erzwingt die Entsorgungsentscheidung. Aufwand gering, sofort für alle 5 Archetypen.
2. **Worktrees als Standard-Isolationsslot verankern**: `claude --worktree` für Experimente, `isolation: worktree` für parallelisierende Subagenten, `.worktreeinclude` für `.env`-Dateien; `.claude/worktrees/` in `.gitignore`; Claude Code aktuell halten (Windows-Junction-Fix ≥ v2.1.205). Temporäre Testumgebung = Worktree + eigene SQLite/DuckDB-Datei + eigener Port; Docker dafür nicht nötig.
3. **Parallel-Varianten-Muster mit Löschzwang**: Bei architekturrelevanten Unsicherheiten 2–3 Varianten gegen dieselbe Spezifikation, Bewertung über identische Tests plus kurze Rubrik, Verlierer vollständig löschen. Direkte Gegenmaßnahme zur GitClear-Duplikat-Drift.
4. **Fitness Functions als drittes Gate neben Tests und Security**: `import-linter` (FastAPI/Django-Schichten), `dependency-cruiser` (Astro), Schema-/Migrationschecks, Größen-/Kopplungsbudgets. MCP-vermittelte Governance-Funktionen (Ford/Richards) nur beobachten.
5. **Eval-Suite (Entscheidung E3) jetzt starten, klein**: 20–50 Golden Tasks aus realen Agenten-Fehlern der eigenen Repos, beginnend mit der NFL-Plattform (höchste Autonomie). Grader-Trias; balancierte Sets inkl. Negativfälle ("Agent muss eskalieren"); 5–10 Kanarienfälle nightly; Vollsuite vor Modell-/Prompt-/CLAUDE.md-Änderungen. Harness: pytest-Eigenbau, optional Inspect AI. **pass^k (k=3–5) als Freigabemetrik für autonome Pfade**, pass@k nur für Fähigkeitsvergleiche.
6. **LLM-as-Judge nur mit Kalibrierpaket**: binäre/pairwise Urteile, CoT-Begründung, Positionsrotation, plus eine kleine menschlich gelabelte Referenzmenge; Übereinstimmung quartalsweise nachmessen. Ohne Kalibrierung keine Judge-basierten Gates.
7. **Autonomie nach Task-Klasse staffeln** (empirische Begründung: DORA 35–40 % vs. ~10 %; METR −18 % bei Experten im eigenen Code): hohe A-Stufen für gut spezifizierte, testbare Standardaufgaben; für komplexe Legacy-/Kernarchitektur-Eingriffe bewusst niedrigere Stufe und Chefarchitekten-Review. Die Wahrnehmungs-Mess-Lücke (METR-Survey) heißt konkret: eigene Kennzahlen-Baseline (E6) statt Gefühl — ergänzt um lokal messbare GitClear-artige Signale (Duplikat-Rate, Churn, Refactoring-Anteil).
8. **Security-Gates präzisieren**: SAST-/Review-Fokus auf XSS und Log Injection (Modell-Pass-Rate <20 %) in den Astro-/FastAPI-Webflächen; SQL-Injection/Krypto sind laut Veracode die geringeren Modellrisiken. OWASP-Anker der v4.0 entsprechend gewichten.
9. **PR-Hygiene für Agenten-Läufe**: Aus den AIDev-Befunden — Aufgaben vor Agent-Start priorisieren (24,5 % der Ablehnungen sind Relevanzprobleme), Fix-Strategie und CI-Anforderungen in die Spezifikation schreiben, granulare Commits der Agenten als Review-Einheit nutzen.

## Bewertungstabelle

| Methode/Technologie | Bewertung | Begründung (Kurz) |
|---|---|---|
| Git Worktrees für parallele Agenten-Isolation | jetzt empfohlen | Nativer Claude-Code-Support, löst reales Kollisionsproblem, Windows-tauglich [V] |
| Spike-Karten + Experiment-Log mit Entsorgungsregel | jetzt empfohlen | Geringer Aufwand, agentenverifizierbar, verhindert Prototyp-Drift |
| Eigene Golden-Task-Eval-Suite (20–50 Tasks) | jetzt empfohlen | Anbieter-Konsens, öffentliche Benchmarks saturiert, Grundlage für Autonomie-Freigaben [V] |
| Architecture Fitness Functions als CI-Gates | jetzt empfohlen | Zeitloses Prinzip, als maschinenprüfbare Leitplanke agentenkritisch [V] |
| pass^k als Zuverlässigkeits-Gate für autonome Pfade | pilotgeeignet | Konzept klar (Anthropic), Schwellenwerte müssen lokal erprobt werden [V] |
| LLM-as-Judge mit Human-Kalibrierung | sinnvoll unter Bedingungen | Nur binär/pairwise, mit Bias-Kontrolle und Referenzlabels [V] |
| Parallel-Varianten-Vergleich in Worktrees | sinnvoll unter Bedingungen | Stark bei Architektur-Unsicherheit; Token-Kosten und Löschdisziplin nötig |
| Leichtgewichtige Feature Flags (config/ENV) | sinnvoll unter Bedingungen | Wertvoll für Auto-Deploy-Pfad; Flag-Hygiene erforderlich [S] |
| Inspect AI / promptfoo als Eval-Harness | pilotgeeignet | Reife OSS-Optionen, lokal betreibbar; pytest-Eigenbau oft ausreichend [S] |
| MCP-vermittelte Governance-Fitness-Functions | beobachten | Ford/Richards-Konzept jung, Enterprise-Zuschnitt [V] |
| Feature-Flag-Plattformen (SaaS/Unleash-Server) | überdimensioniert für Privatkontext | Betriebsaufwand ohne Mehrwert bei Einzelbetreiber [S] |
| SaaS-Eval-Plattformen | überdimensioniert für Privatkontext | Lokale Harnesses decken Bedarf, Datenhoheit [S] |
| Öffentliche Coding-Benchmarks als Entscheidungsbasis | derzeit nicht belastbar | Sättigung, Kontamination, geringe Übertragbarkeit [S] |
| Selbstberichtete Produktivitätsgewinne (Surveys) | überwiegend Marketing / nicht belastbar | METR: systematische Überschätzung, 40-Punkte-Lücke [V] |

## Quellenverzeichnis

1. [V] METR: "We are Changing our Developer Productivity Experiment Design" (2026-02-24) — https://metr.org/blog/2026-02-24-uplift-update/ (abgerufen 2026-07-28)
2. [V] METR: "Measuring the Self-Reported Impact of Early-2026 AI on Technical Worker Productivity" (2026-05-11) — https://metr.org/blog/2026-05-11-ai-usage-survey/ (abgerufen 2026-07-28)
3. [V] InfoQ: "New DORA Report Claims Strong Engineering Foundations Drive AI ROI" (2026-05) — https://www.infoq.com/news/2026/05/dora-roi-ai-assisted-dev-report/ (abgerufen 2026-07-28)
4. [S] DORA: "ROI of AI-assisted Software Development report" — https://dora.dev/ai/roi/report/ (Landingpage abgerufen, Reportinhalt über [3] belegt)
5. [V] GitClear: "The Maintainability Gap: 2026 AI Code Quality Research" — https://www.gitclear.com/the_ai_code_quality_maintainability_gap (abgerufen 2026-07-28)
6. [V] Veracode: "Spring 2026 GenAI Code Security Update" (2026-03-24) — https://www.veracode.com/blog/spring-2026-genai-code-security/ (abgerufen 2026-07-28)
7. [V] arXiv 2606.13468: "Understanding the Rejection of Fixes Generated by Agentic Pull Requests — Insights from the AIDev Dataset" (2026-06-11) — https://arxiv.org/html/2606.13468 (abgerufen 2026-07-28)
8. [V] arXiv 2601.17581: "How AI Coding Agents Modify Code: A Large-Scale Study of GitHub Pull Requests" (2026-01/04) — https://arxiv.org/abs/2601.17581 (abgerufen 2026-07-28)
9. [V] arXiv 2605.23135: Vella/Blincoe, "The Impact of AI Coding Assistants on Software Engineering: A Longitudinal Study" — https://arxiv.org/html/2605.23135 (abgerufen 2026-07-28)
10. [V] ICSE 2026 SEIP: Chen et al. (CMU/BNY), "Beyond the Commit: Developer Perspectives on Productivity with AI Coding Assistants" — https://conf.researchr.org/details/icse-2026/icse-2026-software-engineering-in-practice/62/ (abgerufen 2026-07-28)
11. [V] Anthropic Engineering: "Demystifying evals for AI agents" (2026-01-09) — https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents (abgerufen 2026-07-28)
12. [V] OpenAI: "Evaluation best practices" — https://developers.openai.com/api/docs/guides/evaluation-best-practices (abgerufen 2026-07-28)
13. [V] Claude Code Docs: "Run parallel sessions with worktrees" — https://code.claude.com/docs/en/worktrees (abgerufen 2026-07-28)
14. [V] O'Reilly Radar: Ford/Richards, "How Agentic AI Empowers Architecture Governance" (2025-11-19) — https://www.oreilly.com/radar/how-agentic-ai-empowers-architecture-governance/ (abgerufen 2026-07-28)
15. [S] MSR 2026 Mining Challenge (AIDev): "Behind Agentic Pull Requests …" — https://2026.msrconf.org/details/msr-2026-mining-challenge/26/
16. [S] IBM Research: "Usage, Effects and Requirements for AI Coding Assistants in the Enterprise" (ICSE 2026) — https://research.ibm.com/publications/usage-effects-and-requirements-for-ai-coding-assistants-in-the-enterprise-an-empirical-study
17. [S] UK AISI: Inspect AI — https://github.com/UKGovernmentBEIS/inspect_ai und https://www.aisi.gov.uk/blog/inspect-evals
18. [S] CNCF: "OpenFeature becomes a CNCF incubating project" — https://www.cncf.io/blog/2023/12/19/openfeature-becomes-a-cncf-incubating-project/ ; Linux Foundation Kurs LFS140
19. [S] arXiv 2411.13768: "Evaluation-Driven Development of LLM Agents: A Process Model and Reference Architecture"
20. [S] arXiv 2510.08996: "Saving SWE-Bench: A Benchmark Mutation Approach for Realistic Agent Evaluation" (Benchmark-Sättigung/Kontamination)
21. [S] The Long Commit: "The Prototype Is a Question, Not a Product" — https://newsletter.thelongcommit.com/p/the-prototype-is-a-question-not-a
22. [S] Rob Bowley: "METR's developer productivity research: 2026 update" (2026-04-04) — https://blog.robbowley.net/2026/04/04/metrs-developer-productivity-research-2026-update/ (sekundäre Einordnung)
