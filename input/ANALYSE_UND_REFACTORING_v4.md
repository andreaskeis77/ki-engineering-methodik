# Analyse und Refactoring: KI-Engineering-Methodik und CLAUDE.md

**Version des Berichts:** 1.0
**Stand:** 2026-07-26
**Analysierte Artefakte:** `KI_ENGINEERING_METHODIK.md` v3.1 (30 Kapitel, ~2.800 Zeilen) und `CLAUDE.md` v3.1
**Ergebnis:** Refactoring auf Version 4.0 beider Dateien (beiliegend) plus offene Eigentümerentscheidungen

---

## 0. Auftrag und Vorgehen

Auftrag: umfassende Analyse und Challenge beider Dokumente gegen den State of the Art in KI-gestützter Softwareentwicklung — autonom, hochwertig, lifecycle-orientiert, parallel durch Agenten, mit Fokus auf Architektur, Sicherheit, moderne SDLC-Praxis, Test, UX/UI/Design und Interface-Management.

Vorgehen:

1. Vollständige Lektüre beider Dokumente.
2. Recherche der Primärquellen: Anthropic Engineering (Building Effective Agents, Multi-Agent Research System, Context Engineering, Long-Running Harnesses, Claude-Code-Praxis), OpenAI (Codex Best Practices, AGENTS.md), GitHub (Spec Kit / Spec-Driven Development), DORA 2025 (State of AI-assisted Software Development + AI Capabilities Model), OWASP GenAI (LLM Top 10, Agentic Top 10 2026), METR-RCT, akademische Landschaft (SE 3.0 / ICSE 2026 / KDD 2026 / AIDev), W3C DTCG Design Tokens, OpenTelemetry GenAI, Rechtslage (BFSG/EAA, EU AI Act mit Digital Omnibus).
3. Gap-Analyse, Challenge und priorisiertes Refactoring.

---

## 1. Ergebnis in Kürze

**Gesamturteil:** Der Korpus ist deutlich reifer als der Branchendurchschnitt. Autoritätsstufen, Modussystem mit Pflichtstabilisierung, Wahrheitshierarchie, hermetische Gates und Trust Boundaries sind Dinge, die die meisten Teams 2026 noch nicht formalisiert haben. Die Schwächen liegen nicht im Fundament, sondern an drei Stellen: (a) das Dokument regelt den **Agenten**, aber kaum die **Umgebung und den Menschen**; (b) mehrere neue Disziplinen (Kontext-Engineering, Spezifikationspipeline, Eval-Methodik, Agenten-Telemetrie) sind nur angedeutet; (c) das Verhältnis von Papier zu technischer Durchsetzung ist unausgewogen — genau das Muster, vor dem die eigene Regel 1.2 warnt.

**Scorecard** (eigene Einschätzung, 1–10, mit v4.0-Ziel):

| Domäne | v3.1 | Kernbefund | v4.0 |
|---|---:|---|---:|
| Architektur & Plattform | 8 | Backend-als-Kern, additive Verträge, Offline/Sync: sehr gut | 8 |
| Multi-Agent-Orchestrierung | 8 | Ownership/Lead/Pre-Integration stark; Limit falsch dimensioniert (Kosten statt Review-Bandbreite) | 9 |
| Sicherheit | 7 | Regeln stark, aber ohne externe Anker (OWASP ASI/LLM), ohne Sandbox-/Egress-Pflicht, ohne Agentenidentität | 9 |
| SDLC / Lifecycle | 7 | Tranchen + Gates exzellent; keine Outcome-Metriken, kein DORA-Anker, Spec nur implizit | 8 |
| Test & Verifikation | 7 | Hermetik/Flaky-Policy vorbildlich; Verifikationsökonomie fehlt | 8 |
| Kontext & Long Runs | 6 | Watchdogs/HANDBACK gut; Kontext-Engineering als Disziplin fehlt | 8 |
| Agenten-Evals | 4 | Trigger definiert, Methode fehlt (Golden Set, Rubrik, pass@k, Kalibrierung) | 7 |
| UX / Design / Interface | 6 | Prozess und Zustandsmatrix stark; Token-Format/Pipeline und KI-Designschleife fehlen | 8 |
| Recht & Compliance | 3 | Barrierefreiheit nur als Qualität, nicht als seit 2025 geltende Rechtspflicht; AI-Act-Transparenz unbehandelt | 7 |
| Beobachtbarkeit der Agenten | 4 | Prosa-Worklogs statt strukturierter Traces/Manifeste | 7 |
| Mensch im System | 4 | Owner-Checkpoints ja; Kompetenzerhalt, Review-Tiefe, Automation Complacency ungeregelt | 7 |
| Durchsetzung (Hooks/CI vs. Text) | 5 | Als Prinzip benannt (1.2, 26.3), als Pflichtprogramm nicht operationalisiert | 7 |

---

## 2. Was der Korpus bereits auf State-of-the-Art-Niveau macht

Zur Ehrlichkeit der Challenge gehört, das Erreichte zu benennen — mit externer Validierung:

1. **Autoritätsstufen A0–A5 mit capability-scoped Freigaben.** Deckungsgleich mit dem OWASP-Prinzip „Least Agency" (Agentic Top 10 2026): Autonomie ist verdient, nicht default. Die Regel, dass gespeicherte Freigaben historische Evidenz und keine fortgeltende Autorität sind, ist besser als das, was die meisten Enterprise-Frameworks heute haben.
2. **Sprint mit Pflichtstabilisierung und Scope Freeze.** Entspricht dem Konsens „Geschwindigkeit ohne Absenkung des Akzeptanzniveaus"; die 60/40-Heuristik ist eine ehrliche Antwort auf das branchenweit beobachtete Problem, dass KI-generierter Code Rework verlagert statt eliminiert.
3. **Untrusted Input / Prompt-Injection-Regeln (22.2).** Kompatibel mit LLM01 (Prompt Injection) und der „Lethal Trifecta"-Analyse (private Daten + untrusted Inhalt + Exfiltrationskanal). Kapitel 23 (MCP) hat das bereits auf Toolbeschreibungen und UI-Extensions erweitert.
4. **Hermetische Gates, Flaky-Policy, Anti-Retry-bis-grün.** Genau die Eigenschaft, die Anthropic als Grund nennt, warum Coding-Agenten funktionieren: Code ist über automatisierte Tests verifizierbar, und der Agent iteriert gegen Testergebnisse. Wer die Gates deterministisch hält, hält den Agenten steuerbar.
5. **Zwei-Dateien-Modell und Right-Sizing.** Entspricht Anthropic-Guidance (kompaktes, immer geladenes Projektgedächtnis; Langwissen on demand) und OpenAI-Guidance (AGENTS.md als „durable guidance", Kommandos vor Erklärungen).
6. **Read-only Recon vor Mutation, Worklog/HANDBACK, ein primärer Wiederaufnahmeschritt.** Deckt sich mit Anthropics Harness-Arbeit für Long-Running Agents: diskrete Sessions ohne Gedächtnis brauchen externe strukturierte Zustandsartefakte.
7. **Plattformarchitektur (12–13).** Eine Wahrheit je Datensorte, Expand→Migrate→Contract, Offline-Klassen, Outbox/Idempotenz — solide, zeitlos, korrekt.

---

## 3. Challenge: die zwölf härtesten Befunde

Format je Befund: **Befund → Risiko → Beleg/State of the Art → Maßnahme in v4.0.**

### C1 — Der Engpass ist verschoben: Verifikation, nicht Generierung

**Befund:** Kapitel 10 begrenzt Parallelität über Kosten, Koordination und „nachweisbaren Zeitgewinn". Nirgends steht die tatsächlich bindende Ressource: die Fähigkeit des Menschen, Diffs zeitnah **tief** zu prüfen.
**Risiko:** Fünf parallele Agenten erzeugen in Stunden mehr Änderung, als ein Eigentümer in Tagen ehrlich reviewen kann. Das Ergebnis ist Rubber-Stamping — formal grüne Reviews ohne Verstehen. Damit kollabiert die gesamte Evidenzarchitektur des Dokuments, denn „unabhängiger Review" ist in fast jedem Gate Pflichtbestandteil.
**Beleg:** Die METR-RCT (Juli 2025) zeigte, dass erfahrene Entwickler mit KI-Tools 19 % *länger* brauchten, während sie sich 20 % schneller *fühlten* — der Zeitverlust lag wesentlich im Prüfen und Integrieren fremdgenerierten Codes. (METR stuft das Ergebnis inzwischen als historisch ein und hält die Produktivitätsfrage für offen — was den Punkt eher verschärft: Wahrnehmung ist kein Beweis, in keine Richtung.) Anthropics eigene Studie über ~400.000 Claude-Code-Sessions beschreibt die stabile Arbeitsteilung: Mensch plant, Agent führt aus — der Mensch bleibt Entscheidungs- und Prüfinstanz. OpenAI lässt intern 100 % der PRs maschinell vorreviewen, gerade *weil* menschliche Review-Kapazität knapp ist.
**Maßnahme:** Neuer Abschnitt 10.8 „Verifikationsbandbreite als Limit": WIP-Obergrenze für parallele Schreibfronten = Review-Kapazität des Menschen; kleine Diffs als harte Präferenz; Verifier-Subagent mit Rubrik als Vorstufe (nie Ersatz) des menschlichen Reviews; Review-Tiefe als explizites Planungsbudget. Zeile in CLAUDE.md §10.

### C2 — Kontext ist im Dokument ein Budget, aber keine Disziplin

**Befund:** 11.1 sagt richtig „Kontext ist ein Budget wie Zeit und Geld", danach folgt nur die Handoff-Schwelle. Es fehlen die Techniken, mit denen man das Budget bewirtschaftet.
**Risiko:** Context Rot: Mit wachsender Kontextlänge sinkt die Abrufgenauigkeit; ein Agent, der alles lädt, wird messbar dümmer. Lange Läufe scheitern dann nicht an Fähigkeit, sondern an Kontexthygiene.
**Beleg:** Anthropic hat Kontext-Engineering als Nachfolgedisziplin des Prompt-Engineering formalisiert: kleinste Menge hochsignalhaltiger Token; Just-in-time-Retrieval statt Vorabladen; Kompaktierung an Phasengrenzen; Subagenten als Kontextisolation (Exploration im eigenen Fenster, kondensiertes Ergebnis zurück); strukturierte Notizen als externes Gedächtnis. Die Multi-Agent-Forschung dazu: Tokenverbrauch erklärte ~80 % der Leistungsvarianz; Subagenten-Fan-out schlug den Einzelagenten um ~90 % — bei ~15-fachem Tokenpreis, weshalb sich das nur für parallelisierbare, hochvolumige Aufgaben lohnt (und explizit *nicht* für eng gekoppeltes Coden).
**Maßnahme:** Neuer Abschnitt 11.7 „Kontext-Engineering" mit diesen Regeln; Kontextzeile im Sitzungsstart von CLAUDE.md; Verweis in 10.1, dass Subagenten auch der Kontextisolation dienen.

### C3 — Die Spezifikation ist implizit; die Branche hat sie zum Vertrag gemacht

**Befund:** 8.2 (Agent-ready Roadmap-Item) und 9.4 (Execution Plan) enthalten fast alle Zutaten einer Spezifikation — aber verstreut, ohne kanonisches Artefakt neben dem Code und ohne die Regel, dass Spec-Code-Drift ein Defekt ist.
**Risiko:** Ohne Spec als eigenes, versioniertes Artefakt bleibt „Intent" im Chatverlauf; parallele Agenten und spätere Sessions rekonstruieren Absicht aus Code — genau die Umkehrung, die im KI-Zeitalter nicht mehr nötig ist.
**Beleg:** GitHub Spec Kit etabliert `specify → plan → tasks → implement` plus Konsistenzanalyse und „Checklisten als Unit-Tests für Englisch"; die Grundthese lautet: Intent wird zur Quelle der Wahrheit, Code zu deren Ausdruck. Amazon Kiro, OpenSpec, BMAD u. a. konvergieren unabhängig auf dasselbe Muster; die Community-Synthese für Claude Code lautet Research → Plan → Execute → Review → Ship. Spec Kit kennt zudem eine „Constitution" — funktional exakt eure CLAUDE.md, was bestätigt, dass euer Zwei-Dateien-Modell richtig liegt.
**Maßnahme:** Neuer Abschnitt 9.6 „Spezifikationsgetriebener Ablauf": Spec (Was/Warum/Akzeptanz/Non-Scope) als Datei neben dem Code, Plan und Tasks daraus abgeleitet, Akzeptanz wo möglich ausführbar, Drift = Defekt; Vorlagen 28.3/28.4 als Träger benannt. Spec-Zeile in CLAUDE.md §9.

### C4 — Evals haben einen Trigger, aber keine Methode

**Befund:** 18.2 und 27.5 fordern Agenten-Evals bei Regel-/Skill-/Server-/Modelländerung. *Wie* ein Eval aussieht, fehlt.
**Risiko:** Ohne Golden Set, Bewertungsrubrik und Varianzangabe ist „Eval bestanden" eine Stimmungsaussage. Regeländerungen (auch dieses Refactoring!) sind dann unbelegt.
**Beleg:** Anthropic startete die Multi-Agent-Evals mit ~20 repräsentativen Fällen und LLM-as-Judge gegen Rubriken plus menschlicher Stichprobenkalibrierung; klein anfangen wirkt, weil frühe Effekte groß sind. OpenAI verankert „Tests zuerst schreiben, rot committen, Agent darf Tests nicht ändern" als Eval-artiges Muster im Alltag. Die akademische Seite (SWE-bench-Familie, AIDev-Datensatz mit >1 Mio. Agenten-PRs) professionalisiert Messverfahren; pass@k und Varianz sind Berichtsstandard.
**Maßnahme:** 27.5 ausgebaut: Golden Tasks je Fähigkeit + Regressionsfälle aus realen Vorfällen; deterministische Checks vor LLM-Richter; Rubriken mit periodischer menschlicher Kalibrierung; Ergebnisbericht mit n, pass@k, Varianz; Kanarienfälle (Injection, Rechteeskalation, Kostenlauf); Evals versioniert neben den Regeln.

### C5 — Sicherheit ist gut, aber selbstreferenziell

**Befund:** Kapitel 22 ist stark, referenziert aber keine externe Bedrohungstaxonomie, verlangt keine Ausführungsisolation und kennt keine Agentenidentität.
**Risiko:** Ohne Mapping auf OWASP prüft niemand systematisch Vollständigkeit; neue Bedrohungsklassen (Memory Poisoning, Cascading Failures zwischen Agenten, Tool-Missbrauch, Rogue-Verhalten) bleiben unadressiert, obwohl das Dokument Multi-Agent-Betrieb ausdrücklich vorsieht.
**Beleg:** Die OWASP Top 10 for Agentic Applications 2026 (ASI01–ASI10, veröffentlicht 09.12.2025, >100 Beitragende) ist die Referenztaxonomie für agentische Risiken: Goal Hijack, Tool Misuse, Identity/Privilege, Supply Chain, Code Execution, Memory Poisoning, Inter-Agent-Kommunikation, Cascading Failures, Mensch-Agent-Vertrauen, Rogue Agents — ausdrücklich als Ergänzung zur LLM Top 10. NSA/CISA haben im Juni 2026 eigene Design-Guidance für MCP-/Agentensicherheit publiziert. Praxisseitig gilt Sandbox-first (Container/Devcontainer, Dateisystem- und Netz-Egress-Allowlist) als Standard für autonome Läufe; Agenten erhalten eigene, kurzlebige, minimal berechtigte Identitäten statt geerbter Nutzer-Credentials.
**Maßnahme:** Neue Abschnitte 22.8 „Bedrohungsanker und Ausführungsisolation" (OWASP-Mapping-Tabelle, Sandbox-/Egress-Pflicht für unbeaufsichtigte Läufe, Agentenidentität, Memory-/Regel-Poisoning-Regel) und 22.9 „Regulatorischer Rahmen" (siehe C6). Checklistenblock in 29.4.

### C6 — Recht: Barrierefreiheit ist seit dem 28.06.2025 Pflicht, kein Qualitätsziel

**Befund:** 15.4 behandelt Accessibility ausschließlich als Engineering-Qualität. Für ein Team in Deutschland, das Endnutzerprodukte (Web + Android) baut, ist das seit über einem Jahr rechtlich falsch dimensioniert.
**Risiko:** Bußgelder bis 100.000 €, Abmahn-/Verbandsklagerisiko, Marktüberwachung; zusätzlich ab 02.08.2026 KI-Transparenzpflichten, falls Produkte KI-Interaktion enthalten.
**Beleg:** Das BFSG (deutsche Umsetzung des European Accessibility Act) gilt seit 28.06.2025 auch für die Privatwirtschaft; Webauftritte, Apps und Online-Shops haben keine Übergangsfrist; Maßstab ist EN 301 549, die für Web/Apps auf WCAG 2.1 AA verweist (WCAG 2.2 als Stand der Technik sinnvoll); eine auffindbare Barrierefreiheitserklärung ist Pflicht. Beim EU AI Act gelten die Transparenzpflichten aus Art. 50 (Kennzeichnung von Chatbots, KI-generierten Inhalten, Deepfakes) unverändert ab 02.08.2026 — der Digital Omnibus (politische Einigung Mai 2026, Ratsbestätigung Juni 2026) verschiebt nur die Hochrisiko-Pflichten auf Dez. 2027 (Anhang III) bzw. Aug. 2028 (Anhang I) und gewährt für maschinenlesbare Wasserzeichen von Bestandssystemen eine Frist bis 02.12.2026.
**Maßnahme:** Neuer Abschnitt 22.9 „Regulatorischer Rahmen" (BFSG/EAA, AI-Act-Staffelung, DSGVO-Verweis, NIST AI RMF / ISO/IEC 42001 als optionale Skalierungsrahmen, mit Disclaimer „Engineering-Governance, keine Rechtsberatung"); Rechtszeile in 15.4 und CLAUDE.md §11; Routing-Zeile in 1.5; Prüfpunkt in 29.4. Alle Fristen als zeitabhängig markiert.

### C7 — UI-Pipeline: Tokens sind benannt, aber nicht werkzeugfähig

**Befund:** 15.3 definiert die richtige Schichtung (Core → Semantic → Component), aber kein Format, keine Pipeline, keine Codegenerierung — und Kapitel 15 kennt keine KI-gestützte Designschleife, obwohl der Rest des Dokuments agentenzentriert ist.
**Risiko:** Ohne maschinenlesbare Tokenquelle driften Design und Code zwangsläufig (Figma-Variablen ≠ CSS-Variablen ≠ Compose-Theme); ohne definierte Iterationsschleife bleibt visuelle Agentenarbeit Zufall.
**Beleg:** Die W3C Design Tokens Community Group hat am 28.10.2025 die erste stabile Spezifikation (v2025.10) veröffentlicht, getragen von >20 Organisationen (Adobe, Google, Meta, Figma, Salesforce u. a.); Figma, Penpot, Sketch, Tokens Studio, Style Dictionary, Terrazzo unterstützen sie; Branchenerhebungen sehen Token-Nutzung 2026 bei ~84 % der Teams — der Wettbewerbsvorteil liegt nicht mehr im „ob", sondern im Token-Graph als einziger Quelle, aus der alle Plattformen generiert werden. Für die Agentenschleife ist das Muster etabliert: implementieren → realen Screenshot erzeugen → gegen Referenz/Designabsicht vergleichen → nachbessern; euer menschlicher Geschmackscheckpoint (15.5) und die Baseline-Freigabe (15.6) bleiben dabei die Autorität.
**Maßnahme:** Neuer Abschnitt 15.7 „Token-Pipeline und KI-gestützte Designschleife": DTCG-JSON als kanonische Quelle im Repo; generierte Plattformableitungen (CSS-Variablen/Tailwind-Theme, Compose-Theme) mit Driftprüfung im Gate; Designquelle (z. B. Figma) als read-only M1-Connector nach Kapitel 23; Screenshot-Iterationsschleife mit Iterations-Cap; Komponentenkatalog (Storybook-Klasse) als Prüf- und Referenzfläche.

### C8 — Interface-Management endet beim Contract-Dokument

**Befund:** 13.4 ist ein sehr guter Vertrag *sinhalt*. Es fehlt die Governance-Mechanik: Breaking-Change-Erkennung, Contract-Tests als Gate-Klasse, generierte Clients als Pflicht statt Option, Deprecation-Mechanik über Header/Changelog.
**Risiko:** Bei mehreren Clients (Web + Android + ggf. MCP-Server nach 23.9) ist der Vertrag der teuerste Drift-Punkt; „maschinenlesbar und versioniert" ohne CI-Zähne ist Text.
**Beleg:** Stand der Praxis: OpenAPI-first mit Spezifikations-Linting und Breaking-Change-Diff in CI (Spectral-/oasdiff-Klasse), bidirektionale Contract-Tests (Provider-Verifikation gegen Spezifikation, Schemathesis-/Pact-Klasse), generierte Clients aus dem Contract mit Driftprüfung, Deprecation-/Sunset-Header plus dokumentiertes Kompatibilitätsfenster — konsistent mit eurer Mobile-Fenster-Regel (12.2). Euer eigener MCP-Abschnitt 23.9 verlangt dieselbe Disziplin bereits für Tools; die HTTP-API sollte nicht schwächer geregelt sein als der MCP-Server.
**Maßnahme:** Neuer Abschnitt 13.9 „Interface-Governance": Contract-Linting und Breaking-Change-Diff als Gate; Contract-Tests in beide Richtungen; generierte Clients mit Driftgate; Fehlerkatalog stabil und typisiert; Deprecation-Mechanik; Mock-/Sandbox-Server für Konsumenten; Events (falls vorhanden) mit gleichwertigem maschinenlesbarem Vertrag.

### C9 — Die Codebasis wird nicht als Agentenumgebung entworfen

**Befund:** Kapitel 14 regelt Codequalität für Menschen. Die zweite Modalität — Code als Arbeitsumgebung für Agenten — fehlt.
**Risiko:** Agentenleistung hängt messbar an Umgebungseigenschaften: Feedbackgeschwindigkeit, Fehlermeldungsqualität, Auffindbarkeit. Wer nur den Agenten reguliert und nicht die Umgebung optimiert, verschenkt den größten Hebel.
**Beleg:** Anthropic rahmt Tool-/Umgebungsdesign als „Agent-Computer-Interface" mit gleicher Sorgfalt wie ein UI; die SE-3.0-Forschung (Hassan et al., ICSE 2026) macht daraus die Grunddualität „SE for Humans / SE for Agents" mit eigenen Umgebungen (Agent Command / Agent Execution Environment) und strukturierten Übergabeartefakten. OpenAI-Guidance verlangt in AGENTS.md Kommandos vor Erklärungen — die Umgebung soll ausführbar erklärt sein. Euer 18.8 (kanonischer Befehls-Einstieg) ist der richtige Keim; er braucht Geschwister.
**Maßnahme:** Neuer Abschnitt 14.8 „Agentenfreundliche Codebasis": schneller deterministischer Feedbackzyklus als Designziel; handlungsleitende Fehlermeldungen; konventionelle, greppbare Struktur; kolokalisierte Beispiele/Doku; Testnähte/DI; maschinenlesbare Projektkarte; Linter kodieren Konventionen, damit Werkzeuge korrigieren statt Reviews.

### C10 — Der Mensch im System ist ungeschützt

**Befund:** Das Dokument definiert Owner-Checkpoints, aber keine Vorkehrung gegen Kompetenzverlust, Automation Complacency und degenerierende Review-Tiefe — die vorhersehbaren Nebenwirkungen genau der Autonomie, die es ermöglicht.
**Risiko:** Nach sechs Monaten hoher Autonomie kann der Eigentümer Architekturentscheidungen formal absegnen, die er nicht mehr tief durchdringt; im Incident-Fall fehlt dann die Debugging-Kompetenz. DORA 2025 formuliert es als Spiegel-Effekt: KI verstärkt vorhandene Stärken *und* Dysfunktionen; die Wahrnehmung von Beschleunigung ist kein Beleg (METR).
**Beleg:** DORA 2025 (~5.000 Befragte, ~90 % KI-Nutzung) verortet den Nutzen in Organisationskapazitäten, nicht im Tool; Anthropics Human-Agent-Team-Guidance beschreibt „earned autonomy": anfangs manuell prüfen, Autonomie je Aufgabentyp nach wiederholtem Erfolg erweitern, Reflexionsschleifen einbauen. Die entstehenden Curricula (SE-3.0-Ausbildung) trainieren explizit die Orchestrierungs- und Prüfrolle des Menschen.
**Maßnahme:** Neuer Abschnitt 5.5 „Kompetenzerhalt und Review-Tiefe": Explain-back-Checkpoint für R2/R3-Merges (Reviewer erklärt Änderung in eigenen Worten); Autonomie je Aufgabentyp verdient und dokumentiert; regelmäßige eigenhändige Tiefenprüfungen; Review-Tiefe als beobachtete Größe; Incident-Übungen ohne Agent optional.

### C11 — Erfolg wird nicht gemessen: keine Outcome-Metriken

**Befund:** 8.4 fordert Outcome-Schleifen fürs Produkt — aber die Methodik misst sich selbst nicht. Ob Sprint-Modus, Parallelität oder eine Regeländerung wirken, ist unbelegbar.
**Risiko:** Methodik-Entscheidungen nach Gefühl; genau die Perception-Gap, die METR quantifiziert hat (−19 % gemessen vs. +20 % gefühlt).
**Beleg:** DORA bleibt der Referenzrahmen: die vier Kennzahlen (Lead Time, Deploy-Frequenz, Change Failure Rate, Time to Restore) plus Rework-Rate, ergänzt um das DORA AI Capabilities Model (klare KI-Policy, gesunde Daten, KI-zugängliche interne Daten, starkes Versionsmanagement, kleine Batches, Nutzerzentrierung, Qualitätsplattform) als Bedingungen, unter denen KI wirkt. Für Agentenläufe kommen Rework-/Revert-Quote von Agenten-PRs, Review-Latenz, Eval-Trends und Kosten je erfolgreicher Tranche hinzu (euer 21.4 hat die Rohdaten schon).
**Maßnahme:** Neuer Abschnitt 8.5 „Outcome-Metriken und DORA-Anker": kleines festes Kennzahlenset; Baseline vor größeren Methodik-/Modusänderungen; 21.4-Telemetrie als Quelle; Regel „Methodikänderung benennt die Kennzahl, die sie verbessern soll".

### C12 — Governance: Prosa skaliert schlechter als das Dokument wächst

**Befund:** Drei strukturelle Eigenprobleme: (a) CLAUDE.md dupliziert Methodik-Inhalte (Driftrisiko trotz 3.3); (b) Kapitelnummern sind instabil (v3.1 hat 23–29 → 24–30 verschoben; jede Einfügung bricht Querverweise); (c) das Verhältnis durchgesetzter zu textlicher Regeln ist unbeziffert.
**Risiko:** Bei langen Regeltexten sinkt Instruktionsbefolgung; die Community-Konsequenz lautet: deterministisch Erzwingbares gehört in settings/Hooks, nicht in Prosa („Attribution per Konfiguration statt per NEVER-Satz"). Instabile Nummern machen die Langmethodik als Referenz unzuverlässig.
**Beleg:** Anthropic- und OpenAI-Guidance konvergieren auf kurze, kommandolastige, geschichtete Regeldateien plus on-demand geladene Regeln (`.claude/rules/`, verschachtelte AGENTS.md); Claude Code bietet mit Hooks, settings, Plugins, Checkpoints/Rewind, Plan Mode und Headless-CI die Durchsetzungs- und Betriebsprimitives bereits an.
**Maßnahme:** Neuer Abschnitt 26.7 „Nummern- und Strukturstabilität" (Neues als Unterabschnitt; neue Top-Level-Kapitel nur vor den Vorlagen; Vorlagen/Referenzen bleiben letzte Kapitel); Mechanismen-Tabelle 26.2 um Plugins, Checkpoints/Rewind, Plan Mode, Headless/CI ergänzt; Härtungsreihenfolge präzisiert: erst Hooks für die unverhandelbaren Verbote, dann Skills. CLAUDE.md v4.0 entschlackt Formulierungen und verweist statt zu wiederholen, wo gefahrlos möglich.

---

## 4. State of the Art nach Quelle (Kurzsynthese)

**Anthropic.** Einfachheit vor Framework-Komplexität; Workflows vs. Agenten sauber trennen; Checkpoints vor irreversiblen Aktionen; Coding als Sweet Spot, weil testverifizierbar. Multi-Agent: Orchestrator-Worker, Fan-out nur für parallelisierbare Breitenaufgaben, Tokenbudget als dominanter Leistungsfaktor, LLM-Richter + kleine Startsets für Evals, getrennte Spezialpässe (z. B. Zitationsagent) für Hochrisikoteile. Kontext-Engineering als eigene Disziplin (Attention Budget, JIT-Retrieval, Kompaktierung, Subagenten-Isolation, strukturierte Notizen). Long-Running Harnesses: Arbeit in Sessions ohne Gedächtnis → Feature-Listen/Zustandsdateien als externer Fortschrittsspeicher. Praxisdaten (~400k Sessions): Mensch plant, Agent führt aus; Domänenexpertise erhöht Delegationstiefe und Erfolg. Human-Agent-Teams: verdiente Autonomie je Aufgabentyp, anfangs manuelle Prüfung, „nicht Aufgeschriebenes existiert für Agenten nicht".

**OpenAI.** AGENTS.md als geschichtete, dauerhafte Anleitung (global → Repo → Verzeichnis), Kommandos zuerst; Codex als konfigurierter Teamkollege statt Einmal-Assistent; TDD-Muster: fehlschlagende Tests committen, Agent implementiert ohne Teständerungsrecht; 100 % maschinelles PR-Vorreview intern; MCP und Skills mit Kontextkosten-Abwägung.

**GitHub / Industrie-SDLC.** Spec-Driven Development (Spec Kit): specify/plan/tasks/implement + Analyse + Qualitäts-Checklisten; Constitution als Projektverfassung; Intent als Quelle der Wahrheit. Konvergenz vieler unabhängiger Methoden auf Research→Plan→Execute→Review→Ship. DORA 2025: KI als Verstärker, Wert entsteht über sieben Organisationskapazitäten; kleine Batches und Plattformqualität bleiben die Basis.

**Sicherheit.** OWASP LLM Top 10 (2025) + OWASP Agentic Top 10 2026 (ASI01–ASI10) als Doppelanker; Least Agency; Lethal-Trifecta-Analyse; MITRE ATLAS für TTPs; NSA/CISA-Guidance für MCP/Agentendesign (Juni 2026); Praxis: Sandbox-first, Egress-Allowlists, kurzlebige Agentenidentitäten, Tool-Allowlists, Pinning.

**Akademia.** SE 3.0 als Forschungsprogramm (Queen's/Concordia/NAIST u. a.): Dualität „SE for Humans / SE for Agents", ACE/AEE-Umgebungen, Merge-Readiness-Artefakte; ICSE-2026-Briefing mit Empirie aus 567 Claude-Code-PRs; KDD-2026-Workshop um den AIDev-Datensatz (>1 Mio. Agenten-PRs von Claude Code, Codex, Copilot); Kurslandschaft von Berkeleys LLM-Agents-MOOC bis zu dedizierten Agentic-SE-Curricula. Kernbotschaft: Agenten-PRs sind ein messbares Artefakt; Review- und Vertrauensfragen sind das offene Forschungsfeld — nicht die Codegenerierung.

**Design/UX.** DTCG v2025.10 als erste stabile Token-Spezifikation mit breiter Tool-Adoption; Token-Graph als Single Source of Truth mit generierten Plattformableitungen; drei Ebenen (primitive/semantic/component) als Konsens; KI-Designschleifen über reale Screenshots mit menschlicher Freigabe; Barrierefreiheit als Rechtspflicht (EAA/BFSG, EN 301 549/WCAG) statt Kür; für KI-Produkt-UX bleiben Google PAIR und Microsoft HAX die etablierten Leitfäden (Unsicherheit anzeigen, Kontrolle beim Menschen, Korrigierbarkeit).

**Beobachtbarkeit.** OpenTelemetry-GenAI-Konventionen (Spans für Modell-/Tool-/Agentenaufrufe, Token-/Kostenmetriken) sind noch experimentell, aber de-facto-Konvergenzpunkt; Claude Code, Codex und Copilot emittieren bereits nativ OTel-Traces; Datadog u. a. unterstützen v1.37+. Konsequenz: Agentenläufe als Traces lesen, nicht nur als Prosa.

**Recht (DE/EU).** BFSG seit 28.06.2025 in Kraft (Privatwirtschaft, keine Übergangsfrist für Web/Apps, EN 301 549/WCAG 2.1 AA, Erklärung zur Barrierefreiheit, Bußgeld bis 100 T€). EU AI Act: Art.-50-Transparenz ab 02.08.2026 unverändert; Digital Omnibus verschiebt Hochrisiko auf 12/2027 bzw. 08/2028; Wasserzeichen-Übergang für Bestandssysteme bis 02.12.2026. Alle Angaben zeitabhängig; vor Einsatz erneut prüfen.

---

## 5. Refactoring v4.0 — umgesetzte Änderungen

Strukturprinzip: **keine Kapitelverschiebung.** Alle Ergänzungen sind Unterabschnitte; Querverweise bleiben stabil (neu kodifiziert in 26.7).

| # | Ort | Änderung | Befund |
|---|---|---|---|
| 1 | Kopf, 2.5 | Version 4.0; Changelog mit Scope, Anlass, Prüfnachweis, Review-Kriterium | Governance |
| 2 | 1.5 | Routing-Zeile Regulatorik | C6 |
| 3 | 4.4 | Minimalprofil: das verbindliche Minimum für kleine/risikoarme Projekte | C12 |
| 4 | 5.5 | Kompetenzerhalt und Review-Tiefe (Explain-back, verdiente Autonomie) | C10 |
| 5 | 8.5 | Outcome-Metriken und DORA-Anker | C11 |
| 6 | 9.6 | Spezifikationsgetriebener Ablauf (Spec→Plan→Tasks; Drift = Defekt) | C3 |
| 7 | 10.8 | Verifikationsbandbreite als Limit; Verifier-Rubrik | C1 |
| 8 | 11.7 | Kontext-Engineering (Attention Budget, JIT, Kompaktierung, Isolation) | C2 |
| 9 | 13.9 | Interface-Governance (Linting, Breaking-Diff, Contract-Tests, Deprecation) | C8 |
| 10 | 14.8 | Agentenfreundliche Codebasis | C9 |
| 11 | 15.4 (+), 15.7 | Rechtszeile; Token-Pipeline (DTCG) und KI-Designschleife | C6, C7 |
| 12 | 18.10 | Wirksamkeit der Tests (Mutation-Stichproben, Property-Schwerpunkte) | C1/C4 |
| 13 | 21.6 | Agentenläufe als Traces: Run-Manifest + OTel-GenAI-Ausrichtung | C12/Beob. |
| 14 | 22.8, 22.9 | Bedrohungsanker (OWASP-Mapping, Sandbox/Egress, Agentenidentität, Memory Poisoning); Regulatorischer Rahmen (BFSG/EAA, AI Act, NIST/ISO optional) | C5, C6 |
| 15 | 26.2, 26.7 | Mechanismen-Tabelle erweitert; Nummern-/Strukturstabilität | C12 |
| 16 | 27.5, 27.6 | Eval-Methodik ausgebaut; Modell-Routing/Kosten je Aufgabenklasse | C4 |
| 17 | 29.4 | Sechs neue Prüfpunkte (Spec, Review-Bandbreite, Testwirksamkeit, Token/Recht, OWASP/Sandbox, Run-Manifest) | quer |
| 18 | 30 | Neue Referenzgruppe „KI-gestützte Entwicklung, Sicherheit und Design" (~18 Primärquellen) | quer |
| 19 | CLAUDE.md | v4.0: vier neue operative Zeilen (Kontextbudget, Spec-Pflicht, Review-Bandbreite, Rechtspflicht Barrierefreiheit), Run-Manifest im Abschluss, Nummernstabilität in Governance; MCP-Block leicht gestrafft | C1–C3, C6, C12 |

---

## 6. Bewusst nicht übernommen — mit Begründung

1. **Aufspaltung der Langmethodik in Moduldateien** (`docs/methodik/NN-*.md`): kontextökonomisch attraktiv (Just-in-time-Laden kleinerer Dateien), aber ein Strukturbruch, der Gewohnheiten, Links und Tooling betrifft → Eigentümerentscheidung, siehe Abschnitt 7.
2. **Agent-to-Agent-Protokolle (A2A o. ä.) und Schwarm-Muster:** Peer-Kommunikation zwischen Workern widerspricht eurem (richtigen) Orchestrator-Worker-Grundsatz; auch Anthropic rät bei eng gekoppelten Aufgaben davon ab. Bleibt außen vor, bis ein realer Bedarf besteht.
3. **ISO/IEC 42001 / NIST AI RMF als Pflicht:** für die Teamgröße Überbau; als optionale Skalierungsrahmen in 22.9 erwähnt — mehr nicht (Right-Sizing 4.3).
4. **LLM-as-Judge als Gate:** nur als Vorstufe/Advisor zulässig. Richter-Modelle sind selbst fehlbar und manipulierbar; die Freigabeautorität bleibt bei deterministischen Checks + Mensch.
5. **Feste Zahlengrenzen (z. B. „max. 400 Zeilen Diff"):** als Richtwert formuliert, nicht als Regel — harte Zahlen ohne Projektbezug altern schlecht (eure eigene Lehre aus 16.3/17.9).
6. **Vollumstellung der Terminologie auf SE-3.0-Vokabular (ACE/AEE, MRP):** konzeptionell deckungsgleich mit euren Begriffen (Venue, Pre-Integration-Gate, HANDBACK); Umbenennung wäre Churn ohne Nutzen. In den Referenzen verlinkt.
7. **Kürzung der CLAUDE.md um die Architektur-/UX-Abschnitte:** wäre der reinen Lehre nach richtig (nur Operatives), aber diese Abschnitte kodieren echte projektspezifische Invarianten. Stattdessen: Straffung und klare Verweise. Aggressivere Kürzung als Option in Abschnitt 7.

---

## 7. Offene Eigentümerentscheidungen

Gemäß eurer eigenen Regel-Governance (26.5) benötigen diese Punkte eine bewusste Entscheidung; sie sind in v4.0 **nicht** vollzogen:

| # | Entscheidung | Empfehlung | Aufwand |
|---|---|---|---|
| E1 | Hooks-Pflichtpaket umsetzen (main-Schutz, `git add -A`-Block, `--no-verify`-Block, Secret-Scan, Formatter) — von Text zu Physik | Ja, vor dem nächsten größeren Lauf; größter Einzelhebel | ~½ Tag |
| E2 | Methodik in Moduldateien aufspalten (kontextfreundliches JIT-Laden) | Ja, aber erst nach E1; als eigene Tranche mit Linkmigration | ~1 Tag |
| E3 | Erste Eval-Suite anlegen (10–20 Golden Tasks + 5 Kanarienfälle) und dieses v4.0-Refactoring selbst dagegen prüfen | Ja — sonst bleibt C4 offen | ~1 Tag initial |
| E4 | DTCG-Token-Pipeline im Referenzprojekt aufsetzen (Tokenquelle + Generierung Web/Compose + Driftgate) | Ja beim nächsten UI-Vorhaben | ~1–2 Tage |
| E5 | BFSG-Anwendbarkeitsprüfung für konkrete Produkte (inkl. Kleinstunternehmen-Ausnahme bei Dienstleistungen) mit fachkundiger Stelle | Ja, zeitnah; Ergebnis als ADR | extern |
| E6 | Kennzahlen-Baseline erheben (DORA-4 + Agenten-Rework/Review-Latenz) vor der nächsten Modusentscheidung | Ja | ~½ Tag |

---

## 8. Quellen (Auswahl, geprüft am 2026-07-26)

**Anthropic Engineering:** Building Effective Agents · How we built our multi-agent research system · Effective context engineering for AI agents · Effective harnesses for long-running agents · Claude Code Best Practices (code.claude.com/docs/en/best-practices) · How Claude Code is used in practice (anthropic.com/research/claude-code-expertise) · Building effective human-agent teams (claude.com/blog).
**OpenAI:** Codex Best Practices (developers.openai.com/codex/learn/best-practices) · AGENTS.md-Konventionen und Layering.
**GitHub:** Spec Kit (github.com/github/spec-kit; github.github.com/spec-kit; github.blog Spec-driven development with AI).
**DORA:** State of AI-assisted Software Development 2025 + AI Capabilities Model (dora.dev/dora-report-2025).
**METR:** Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity (metr.org, arXiv:2507.09089) inkl. späterer Einordnung als historisch.
**OWASP GenAI:** Top 10 for LLM Applications · Top 10 for Agentic Applications 2026 (genai.owasp.org, ASI01–ASI10).
**NSA/CISA:** Security Design Considerations for AI-Driven Automation (MCP), Juni 2026.
**Akademia:** Hassan et al., Agentic Software Engineering: Foundational Pillars and a Research Roadmap (arXiv:2509.06216) · ICSE 2026 Technical Briefing SE 3.0 · KDD 2026 Agentic-SE-Workshop / AIDev-Datensatz · Berkeley LLM Agents MOOC.
**Design:** W3C DTCG Design Tokens Specification v2025.10 (designtokens.org; w3.org/community/design-tokens) · Style-Dictionary-DTCG-Support.
**Observability:** OpenTelemetry GenAI Semantic Conventions (opentelemetry.io/blog/2025/ai-agent-observability) · native OTel-Emission durch Claude Code/Codex/Copilot.
**Recht:** BFSG/EAA (IHK-Leitfäden, Aktion Mensch; EN 301 549/WCAG) · EU AI Act Art. 50 + Digital Omnibus (artificialintelligenceact.eu; Fachanalysen Mai–Juli 2026).
**MCP:** Spezifikation 2026-07-28 (RC → final 28.07.2026), modelcontextprotocol.io — siehe Methodik-Kapitel 23/30.

*Hinweis: Rechts- und Fristenangaben sind Engineering-Orientierung, keine Rechtsberatung; zeitabhängige Aussagen sind vor Einsatz erneut gegen Primärquellen zu prüfen (Methodik 1.1, 22.9).*
