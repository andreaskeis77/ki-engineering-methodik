# Recherche-Kompendium: KI-gestütztes Software-Engineering

**Stand:** 2026-07-28
**Zweck:** Arbeitsgrundlage und Nachschlagewerk. Bündelt die vollständige Recherche und den Entscheidungskontext, der zur Methodik-Version 4.0 und zu Kapitel 23 geführt hat.
**Abgrenzung:** Enthält Substanz, nicht Publikationsarbeit. Redaktionelles zum LinkedIn-Artikel ist bewusst ausgeklammert.

---

## 0. Wie dieses Dokument zu den anderen steht

| Datei | Rolle |
|---|---|
| `CLAUDE.md` (v4.0) | Operative Projektverfassung, immer geladen |
| `KI_ENGINEERING_METHODIK.md` (v4.0, 30 Kapitel) | Langmethodik, on demand geladen |
| `ANALYSE_UND_REFACTORING_v4.md` | Auditbericht: Scorecard, C1–C12 im Volltext, Änderungstabelle |
| **dieses Dokument** | Rechercheteil: Was wurde gefunden, wie belastbar ist es, was folgt daraus |

Die Analyse begründet **eine bestimmte Änderung**. Dieses Kompendium hält die **Wissensbasis** fest, die auch die nächste Änderung tragen soll.

### Verifikationsstatus der Quellen

Drei Stufen, weil das für die Weiterverwendung entscheidend ist:

- **[V]** URL in dieser Session direkt abgerufen und Inhalt bestätigt.
- **[S]** Über Suchergebnisse belegt, URL nicht einzeln aufgerufen.
- **[K]** Aus dem Kontext der Recherche, vor erneuter Verwendung nachprüfen.

---

# TEIL A — MCP und externe Fähigkeiten

## A.1 Was MCP ist und warum es zählt

Model Context Protocol: offener, JSON-RPC-basierter Standard zwischen Host/Client (Claude Code, Claude-App, andere Agentenprodukte) und Servern. Drei Serverprimitive:

| Primitiv | Bedeutung | Risikoprofil |
|---|---|---|
| Resources | lesbare Daten, ohne Seiteneffekt | Datenabfluss, untrusted Inhalt |
| Tools | Funktionen mit Seiteneffekt | Mutation, Kosten, Irreversibilität |
| Prompts | Interaktionsvorlagen | Kontext- und Instruktionsdrift |

Ökonomisches Argument: statt eines Adapters je Agentenprodukt entsteht einer je System (M×N → M+N).

**Die konzeptionelle Kernunterscheidung**, die in die Methodik einging: MCP erweitert **Fähigkeiten**, niemals **Regeln**. Ein Skill ist ein Verfahren *ohne neue Rechte*. Ein MCP-Server ist eine *neue Angriffsfläche mit Credentials*. Daraus folgt unterschiedliche Freigabe, Prüfung und Überwachung.

## A.2 Protokollrevision 2026-07-28 [S]

Datumsbasierte Versionskennung; das Datum markiert die letzte rückwärtsinkompatible Änderung. Diese Revision ist der größte Umbau seit Protokollstart:

- **Stateless Core** — `initialize`-Handshake und Protokoll-Session entfallen; Skalierung per Round-Robin ohne Sticky Sessions.
- **Extensions-Framework** — optionale Fähigkeiten mit reverse-DNS-IDs, eigenen Repositories, delegierten Maintainern, eigenem Versionszyklus.
- **MCP Apps** als offizielle Extension — Server liefern interaktives HTML, das der Host im sandboxed iframe rendert; UI-Templates vorab deklariert, damit Hosts prefetchen und prüfen können.
- **Tasks** wandert für langlaufende Operationen aus dem Kern in eine Extension.
- **Feature-Lifecycle-Policy** — Active/Deprecated/Removed, mindestens zwölf Monate zwischen Deprecation und Entfernung.
- **Konformitätssuite** als Voraussetzung für Final-Status eines Standards-Track-SEP.

Nicht rückwärtskompatibel. Konsequenz für die Methodik: genau eine gepinnte Zielrevision je Projekt; Kompatibilität wird belegt, nicht angenommen; kein Produktivbetrieb gegen einen Release Candidate; Revisionswechsel als eigene Tranche mit ADR.

> Zeitabhängig. Vor Scaffold, Upgrade und Release gegen die Primärquellen prüfen.

## A.3 Fähigkeitsklassen M0–M4

Nicht der Server, sondern die einzelne Fähigkeit bestimmt die nötige Autorität:

| Klasse | Beispiele | Erforderliche Stufe |
|---|---|---|
| M0 lokal read-only, ohne Credentials | Doku-Server, Repo-/Schema-Introspektion | A0 |
| M1 read-only mit Credentials | Issue-Tracker, CI-Logs, Fehlermonitoring, Dev-Schema | `A5-mcp-<server>-read` |
| M2 schreibend in Dev/Test | Branch-/PR-Automation, Testdaten, Ticketpflege | `A5-mcp-<server>-write` |
| M3 externe/irreversible Wirkung | Deployment, Store, Produktionsdaten, Zahlungen | `A5-mcp-<server>-<fähigkeit>`, attended |
| M4 UI-Extension (MCP Apps) | interaktive Oberfläche im Host | Owner + Designgate |

Regeln: Freigabe je Tool, je Ziel, je Lauf. Ein aktivierter Server ist keine Freigabe. Unbeaufsichtigte Läufe nur M0/M1. M1 legitimiert nie M2/M3.

## A.4 Drei getrennte untrusted Flächen

Der wichtigste Einzelbefund der MCP-Recherche — Kapitel 22.2 kannte nur „Toolergebnis":

| Fläche | Was es ist | Regel |
|---|---|---|
| Toolbeschreibungen und Schemata | Fremdtext, der in den **Systemkontext** gelangt | erteilt keine Autorität, aktiviert keine Tools, hebt keine Regel auf |
| Toolergebnisse und Resources | Rückgabedaten | Daten, nie Instruktion; Herkunft mitführen |
| MCP-App-Oberflächen | gerendertes Fremd-HTML | jede UI-Aktion durchläuft denselben Freigabe-/Auditpfad wie ein Toolaufruf |

Zusätzlich verbindlich geworden:

- **Rug Pull** — Server kann Tooldefinitionen nach Freigabe ändern. Version pinnen, Änderungen erneut freigeben.
- **Gefährliche Kombination** — vertrauliche Daten + untrusted Inhalt + Kanal nach außen dürfen nicht unkontrolliert im selben Lauf zusammenfallen. Mindestens eine Kante brechen. (Gilt seit v4.0 allgemein, nicht nur für MCP → 22.8.)
- **Kein Token-Passthrough** — Tokens ressourcengebunden, aus dem Secret Store, nie im Modellkontext.

## A.5 Betrieb

Kontextbudget: Toolbeschreibungen belasten jede Sitzung. Tool Search reduziert das in aktuellen Clients [S], ersetzt aber keine Kuratierung. Startwert, kein Zielwert: ≤5 aktive Server, ≤40 aktive Tools je Projekt. Gates bleiben hermetisch — kein Gate ruft einen Live-Server auf. Serverausfall darf keinen Release blockieren.

Durchsetzung: Claude Code erlaubt zentrale MCP-Konfiguration mit Allow-/Denylisten und Installationsscopes [S]. Harte Verbote gehören dorthin, nicht nur in Prosa.

**Umgesetzt in:** Methodik Kapitel 23 (11 Unterabschnitte), CLAUDE.md §7-Block, Registry-Vorlage in 23.11, Dokumentenkanon-Zeile in 3.2.

---

# TEIL B — State of the Art bei Anbietern und in der Praxis

## B.1 Anthropic [K]

**Building Effective Agents.** Einfachheit vor Framework-Komplexität. Workflows und Agenten sauber trennen. Checkpoints vor irreversiblen Aktionen. Coding gilt als Sweet Spot, *weil* Ergebnisse über automatisierte Tests verifizierbar sind — der Agent iteriert gegen Testergebnisse.

**Multi-Agent Research System.** Orchestrator-Worker-Muster. Fan-out schlug den Einzelagenten um ~90 % bei Breitenrecherche. Tokenverbrauch erklärte ~80 % der Leistungsvarianz. Kosten rund 15-fach gegenüber einem Chat. Ausdrücklich **ungeeignet für eng gekoppeltes Coden**. Evals starteten mit ~20 repräsentativen Fällen plus LLM-Richter gegen Rubriken und menschlicher Stichprobenkalibrierung.

**Effective Context Engineering.** Kontext als endliche, degradierende Ressource („Context Rot"). Ziel ist die kleinste Menge hochsignalhaltiger Token. Techniken: Just-in-time-Retrieval statt Vorabladen, Kompaktierung an Phasengrenzen, Subagenten als Kontextisolation, strukturierte Notizen als externes Gedächtnis.

**Effective Harnesses for Long-Running Agents.** Sessions haben kein Gedächtnis → externe Zustandsdateien als Fortschrittsspeicher.

**Praxisdaten (~400.000 Claude-Code-Sessions).** Stabile Arbeitsteilung: Mensch trifft Planungsentscheidungen, Agent Ausführungsentscheidungen. Domänenexpertise erhöht Delegationstiefe und Erfolg.

**Human-Agent-Teams.** „Earned autonomy": anfangs manuell prüfen, Autonomie je Aufgabentyp nach wiederholtem Erfolg erweitern. „Was nicht aufgeschrieben ist, existiert für Agenten nicht."

**Economic Index.** Anteil direktiver Konversationen von 27 % (Ende 2024) auf 39 % gestiegen; erstmals überstieg Automation die Augmentation. Coding wandert zunehmend aus interaktiver Nutzung in automatisierte API-Workflows.

## B.2 OpenAI [K]

- **AGENTS.md** geschichtet (global → Repo → Verzeichnis), Kommandos vor Erklärungen.
- **TDD-Muster:** fehlschlagende Tests committen; der implementierende Agent darf die Tests nicht ändern.
- **100 % maschinelles PR-Vorreview** intern — gerade weil menschliche Review-Kapazität knapp ist.
- MCP und Skills mit expliziter Kontextkosten-Abwägung.

## B.3 GitHub Spec Kit und Spec-Driven Development [K]

Ablauf `specify → plan → tasks → implement`, ergänzt um Konsistenzanalyse und Qualitäts-Checklisten („Unit-Tests für Englisch"). Grundthese: **Intent wird Quelle der Wahrheit, Code deren Ausdruck.**

Bemerkenswert: Spec Kit kennt eine „Constitution" — funktional exakt die Rolle von `CLAUDE.md`. Unabhängige Konvergenz auf dasselbe Muster (Amazon Kiro, OpenSpec, BMAD). Community-Synthese für Coding-Agenten: Research → Plan → Execute → Review → Ship.

## B.4 DORA [V für 2025-Report]

**2024** (~3.000 Befragte): +25 % KI-Adoption korrelierte mit −1,5 % Delivery-Throughput und −7,2 % Stabilität, trotz +3,4 % Codequalität. Plausibelste Erklärung: KI verführt zu größeren Changesets, größere Batches erhöhen Deploy-Risiko. [K]

**2025** (~5.000 Befragte, Bayes-Modellierung, Erhebung 13.06.–21.07.2025): Throughput ins Positive gedreht, Instabilität bleibt. Kernaussage wörtlich sinngemäß: KI ist primär ein **Verstärker**, der Stärken leistungsstarker Organisationen und Dysfunktionen kämpfender Organisationen vergrößert; der größte Ertrag kommt nicht aus den Werkzeugen, sondern aus dem darunterliegenden organisatorischen System. [V]

**AI Capabilities Model** — sieben Kapazitäten, die den KI-Nutzen verstärken; u. a. klare KI-Policy, gesunde Datengrundlage, KI-zugängliche interne Daten, starkes Versionsmanagement, kleine Batches, Nutzerzentrierung, Qualitätsplattform. [V]

**2026 ROI-Folgebericht** — ohne solide Plattformqualität und klare Workflows entstehen lokale Produktivitätsinseln, die stromabwärts verpuffen. [S]

## B.5 Sicherheit

**OWASP Top 10 for Agentic Applications 2026** [V] — veröffentlicht 09.12.2025, über 100 Beitragende, global peer-reviewed. Kategorien ASI01–ASI10: Goal Hijack (Planung), Tool Misuse, Identity, Supply Chain, Code Execution, Memory Poisoning, Inter-Agent-Kommunikation, Cascading Failures, Mensch-Agent-Vertrauen, Rogue Agents. Zwei vorangestellte Prinzipien: **Least Agency** (Autonomie verdient, nicht default) und **starke Observability**.

Ergänzend: OWASP LLM Top 10 als Basisliste; MITRE ATLAS für TTPs; NSA/CISA-Guidance zu MCP-/Agentendesign, Juni 2026 [K].

Praxisstandard: Sandbox-first (Container/Devcontainer), Dateisystemgrenzen, **Netz-Egress-Allowlist**, eigene kurzlebige Agentenidentitäten statt geerbter Nutzer-Credentials, Tool-Allowlists, Pinning.

## B.6 Akademische Landschaft [K]

- **SE 3.0** (Hassan et al., arXiv:2509.06216): Dualität „SE for Humans / SE for Agents", eigene Umgebungen (Agent Command Environment / Agent Execution Environment), strukturierte Übergabeartefakte, Merge-Readiness.
- **ICSE 2026** Technical Briefing zu SE 3.0, mit Empirie aus 567 Claude-Code-PRs (Merge-Rate ~83,8 %).
- **KDD 2026** Workshop rund um den **AIDev-Datensatz** (>1 Mio. Agenten-PRs von Claude Code, Codex, Copilot) — die Datenbasis der unten zitierten CMU-Studie.
- Berkeley LLM Agents MOOC und dedizierte Agentic-SE-Curricula.

Kernbotschaft: Agenten-PRs sind ein messbares Artefakt geworden. Das offene Forschungsfeld ist **Review und Vertrauen**, nicht Codegenerierung.

## B.7 Design und Interface [K]

**W3C DTCG Design Tokens** — erste stabile Spezifikation **v2025.10** am 28.10.2025, getragen von >20 Organisationen (Adobe, Google, Meta, Figma, Salesforce). Toolunterstützung: Figma, Penpot, Sketch, Tokens Studio, Style Dictionary, Terrazzo. Token-Nutzung branchenweit bei ~84 %.

Konsens: dreistufige Tokenschichtung (primitive → semantic → component); Token-Graph als einzige Quelle, aus der alle Plattformen **generiert** werden; Handdrift ist ein Gatefehler.

KI-Designschleife: implementieren → real rendern → Screenshot gegen Referenz vergleichen → nachbessern, mit Iterations-Cap und menschlichem Geschmackscheckpoint als Autorität.

Für KI-Produkt-UX bleiben Google PAIR und Microsoft HAX die etablierten Leitfäden: Unsicherheit anzeigen, Kontrolle beim Menschen, Korrigierbarkeit.

## B.8 Beobachtbarkeit [K]

**OpenTelemetry GenAI Semantic Conventions** — Spans für Modell-, Tool- und Agentenaufrufe, Token-/Kostenmetriken. Noch experimentell, aber de-facto-Konvergenzpunkt. Claude Code, Codex und Copilot emittieren bereits nativ. Konsequenz: Agentenläufe als Traces lesen, nicht nur als Prosa. Schemaversion festhalten.

## B.9 Recht (DE/EU) [K — vor Einsatz prüfen]

- **BFSG / European Accessibility Act:** seit **28.06.2025** auch für die Privatwirtschaft in Kraft. Websites, Apps und E-Commerce ohne Übergangsfrist. Maßstab EN 301 549, für Web/Apps auf WCAG 2.1 AA verweisend (WCAG 2.2 als Stand der Technik). Auffindbare Barrierefreiheitserklärung Pflicht. Bußgeld bis 100.000 €.
- **EU AI Act Art. 50** (Transparenz: Kennzeichnung von Chatbots, KI-Inhalten, Deepfakes): gilt unverändert ab **02.08.2026**. Der Digital Omnibus verschiebt nur Hochrisiko — Anhang III auf 12/2027, Anhang I auf 08/2028. Maschinenlesbare Kennzeichnung für Bestandssysteme: Übergang bis 02.12.2026.
- **DSGVO** bei KI-Verarbeitung personenbezogener Daten: Rechtsgrundlage und Auftragsverarbeitung des Modellanbieters prüfen.
- **NIST AI RMF / ISO IEC 42001**: optionale Skalierungsrahmen, für kleine Teams Überbau.

*Engineering-Orientierung, keine Rechtsberatung.*

---

# TEIL C — Die zwölf Challenge-Befunde (Kurzform)

Volltext mit Risiko, Beleg und Maßnahme in `ANALYSE_UND_REFACTORING_v4.md`.

| # | Befund | Antwort in v4.0 |
|---|---|---|
| C1 | Engpass ist Verifikation, nicht Generierung | 10.8 Verifikationsbandbreite als WIP-Limit |
| C2 | Kontext war Budget, aber keine Disziplin | 11.7 Kontext-Engineering |
| C3 | Spezifikation nur implizit | 9.6 Spezifikationsgetriebener Ablauf |
| C4 | Evals hatten Trigger, aber keine Methode | 27.5 Golden Set, Kanarien, pass@k |
| C5 | Sicherheit ohne externe Anker, Sandbox, Agentenidentität | 22.8 Bedrohungsanker |
| C6 | Barrierefreiheit als Qualität statt Rechtspflicht | 22.9 Regulatorischer Rahmen |
| C7 | Token-Pipeline und KI-Designschleife fehlten | 15.7 |
| C8 | Interface-Governance ohne CI-Zähne | 13.9 |
| C9 | Codebasis nicht als Agentenumgebung entworfen | 14.8 |
| C10 | Mensch ungeschützt: Deskilling, Complacency | 5.5 Explain-back |
| C11 | Keine Outcome-Metriken für die Methodik selbst | 8.5 DORA-Anker |
| C12 | Governance: Prosa statt Durchsetzung, instabile Nummern | 26.7 plus Hooks-Priorität |

**Strukturprinzip seit v4.0:** keine Renumberierung mehr. Neues nur als Unterabschnitt. Neue Top-Level-Kapitel ausschließlich vor den Vorlagen. Kodifiziert in 26.7.

---

# TEIL D — Empirische Evidenzlage

Der methodisch wichtigste Teil: Was ist tatsächlich belegt, wie gut, und wie schnell altert es.

## D.1 Evidenzklassen

Absteigend nach Aussagekraft für Kausalität:

1. **Randomisierte kontrollierte Studien** — belegen Kausalität, aber immer für ein konkretes Werkzeug zu einem konkreten Zeitpunkt.
2. **Quasi-experimentelle Kausalanalysen** (Difference-in-Differences mit gematchten Kontrollen) — nächstbeste Stufe, größere Stichproben, realer Kontext.
3. **Großskalige Telemetrie und Längsschnitt** — starke Muster, keine Kausalität.
4. **Organisationsbefragungen** (DORA) — Korrelationen plus Modellierung, gut für Systemfragen.
5. **Benchmarks** — vergleichbar, aber kontaminationsanfällig.
6. **Anbieterangaben und Selbstauskünfte** — Hypothesen, keine Belege.

## D.2 Randomisierte Experimente

| Studie | Design | Ergebnis | Werkzeugstand |
|---|---|---|---|
| Peng et al. (GitHub/Microsoft) 2023 | 95 Profis, HTTP-Server in JS | **+55,8 % schneller** | Copilot, Codex-Ära |
| Cui et al. (Management Science) | 3 Feldexperimente, **4.867 Entwickler** bei Microsoft, Accenture, Fortune-100 | **+26,08 %** abgeschlossene Tasks (SE 10,3 %); weniger erfahrene Entwickler mit höherer Adoption und größeren Gewinnen | Daten **2022–2024**, Autocomplete |
| Paradis et al. (Google), ICSE-SEIP 2025 | 96 Vollzeit-Engineers, komplexe Enterprise-Aufgabe | **~21 %** Zeitersparnis, großes Konfidenzintervall | intern, 2024 |
| METR 2025 | 16 erfahrene OSS-Entwickler, 246 Tasks, reife eigene Repos (Ø 5 J.) | **−19 %**, also langsamer; Prognose der Teilnehmer vorab −24 %, Selbstwahrnehmung nachher +20 % | Cursor Pro, Claude 3.5/3.7, Feb–Jun 2025 |

**Auflösung des scheinbaren Widerspruchs:** Greenfield und unvertraute Codebasen profitieren stark. Reifes Brownfield mit hohen Qualitätsstandards profitiert wenig bis negativ. Die **Varianz ist der Befund**, nicht der Mittelwert.

**Wichtig für Zitierdisziplin:** Die „positiven" Zahlen sind die **ältesten**. Cui et al. misst Autocomplete von 2022–2024, nicht Agenten.

## D.3 METR-Nachfolgedaten, Februar 2026 [V]

Zweites Experiment, Start August 2025: 57 Entwickler, 143 Repositories, 800+ Tasks.

- Teilmenge der ursprünglichen Entwickler: **≈ −18 %**, also **18 % schneller** (KI 95 % −38 % bis +9 %).
- Neu rekrutierte Entwickler: ≈ −4 % (KI −15 % bis +9 %).
- Beide Intervalle überstreichen die Null.

**Der methodisch interessanteste Teil:** Die Rekrutierung wird schwierig, weil Entwickler zunehmend ablehnen, ohne KI zu arbeiten; 30–50 % gaben an, Aufgaben gar nicht erst einzureichen, die sie ungern unassistiert erledigen würden. METR hält den eigenen Wert deshalb für eine **Untergrenze** und gestaltet das Experiment neu.

→ Lehre: Ein und dieselbe Studie kann innerhalb von zwölf Monaten das Vorzeichen wechseln. Absolute Produktivitätszahlen sind Momentaufnahmen.

## D.4 Agentische Ära: Carnegie Mellon, MSR 2026 [V]

**Agarwal, He, Vasilescu — „AI IDEs or Autonomous Agents?"**, MSR '26, arXiv:2601.13597, DOI 10.1145/3793302.3793589. CC BY 4.0.

Design: Längsschnitt-Kausalstudie zur Agentenadoption in Open-Source-Repositories, **staggered Difference-in-Differences mit gematchten Kontrollen**, AIDev-Datensatz. Adoption definiert als erster agenten-generierter Pull Request. Monatliche Repository-Metriken für Velocity (Commits, Zeilen) und Qualität (Static-Analysis-Warnungen, kognitive Komplexität, Duplikation, Kommentardichte). Untersuchte Agenten: Claude Code, Codex, Devin, Jules, Cursor Agent.

Ergebnisse:

- **Agent-First-Repos** (Agenten als erstes KI-Werkzeug): +36,3 % Commits, +76,6 % hinzugefügte Zeilen — front-loaded.
- **IDE-First-Repos** (vorher AI-IDE im Einsatz): +3,1 % Commits, **−6,3 %** Zeilen; minimal oder kurzlebig, bis Monat 6 teils negativ.
- **In beiden Gruppen persistent:** Static-Analysis-Warnungen **+18 %**, kognitive Komplexität **+39 %**.
- Duplikationseffekte klein und inkonsistent — relativiert die stärkeren Duplikationsaussagen aus Telemetriequellen.

Schlussfolgerung der Autoren: abnehmende Erträge; Bedarf an **Qualitätssicherungen, Provenienz-Tracking und selektivem Einsatz**; konkret komplexitätsbewusste Reviews von Agenten-PRs, regelmäßiges Refactoring, umfassende automatisierte Tests.

**Die Formel:** Der Speedup ist bedingt. Die Schuld ist es nicht.

Replikationspaket: `github.com/shyamagarwal13/agentic-coding-impact`.

## D.5 Telemetrie und Längsschnitt

**Stanford Software Engineering Productivity** [K] — knapp 100.000 Entwickler in über 600 Firmen, Output-Modell kalibriert über Expertenpanels. KI erhöht zunächst deutlich den **Rework**; vieles, was wie Mehrleistung aussieht, ist Reparatur des gerade Erzeugten. Netto im Schnitt ~15–20 % Gewinn. Matrix: einfaches Greenfield +30–40 %, komplexes Brownfield deutlich weniger, hochkomplexe Aufgaben teils negativ.

**GitClear** [K] — observationell, keine Kausalität, aber größter Code-Datensatz. 211 Mio. geänderte Zeilen 2020–2024: Refactoring-Anteil von 25 % auf unter 10 % gefallen, Copy/Paste von 8,3 % auf 12,3 % gestiegen; 2024 überstieg Copy/Paste erstmals wiederverwendeten Code, Duplikatblöcke verachtfacht. Fortsetzung 2026: Cross-File-Aufrufe −35 %, Refactoring −70 % gegenüber 2022, Duplikation +81 %, Fehler-Maskierung +47 %, Churn +15 %.

→ Vorsicht: GitClear und CMU widersprechen sich teilweise bei Duplikation. Die konsistente Aussage über beide hinweg ist **Komplexitäts- und Wartbarkeitsdruck**, nicht die konkrete Duplikationszahl.

## D.6 Sicherheit — die konsistenteste Befundlage

**Veracode, laufende Benchmark** [V] — Spring-2026-Update vom 24.03.2026.

Methodik: 80 Coding-Tasks, 4 Sprachen (Java, JavaScript, C#, Python), 4 CWE-Klassen (SQL-Injection CWE-89, XSS CWE-80, Log-Injection CWE-117, unsichere Krypto CWE-327), 5 Instanzen je Kombination. Bewusst **ohne** sicherheitsspezifisches Prompting — gemessen wird das Out-of-the-box-Verhalten. Über 150 Modelle bis heute evaluiert.

Ergebnisse:

- **Security-Pass-Rate ~55 %**, also in 45 % der Fälle ein bekannter Fehler. Seit zwei Jahren flach (Band 45–55 %).
- **Syntaxkorrektheit von ~50 % (2023) auf über 95 %** gestiegen. Die Lücke wächst.
- Modellgröße hat nur sehr kleinen Effekt; die Differenz ist mit neueren Releases weitgehend verschwunden.
- Spring-2026-Test der aktuellen Flaggschiffe (GPT-5.1/5.2, Gemini 3, Claude 4.5/4.6): **kein Unterschied**.
- **Einzige Ausnahme:** reasoning-fokussierte Modelle bei **70–72 %** — immer noch etwa jeder dritte Schnipsel fehlerhaft.
- Nach Sprache: Python 62 %, C# 58 %, JavaScript 57 %, **Java 29 %**. Hypothese: Übertraining auf Legacy-Java-Muster.
- Nach CWE: SQL-Injection 82 %, Krypto 86 % — aber **XSS 15 %, Log-Injection 13 %**. Muster: Pattern-Matching gelingt, Dataflow-Analyse über mehrere Zeilen und Dateien nicht.

**Perry, Srivastava, Kumar, Boneh (Stanford), ACM CCS 2023** [V] — arXiv:2211.03622, DOI 10.1145/3576915.3623157. 47 ausgewertete Teilnehmer, fünf sicherheitsbezogene Aufgaben in Python, JavaScript, C, randomisiert in Experiment- und Kontrollgruppe.

- Teilnehmer mit KI-Assistent schrieben bei vier von fünf Aufgaben **signifikant unsichereren Code**.
- Gleichzeitig hielten sie ihn **eher für sicher** — Overconfidence.
- **Der wichtigste Nebenbefund:** Wer der KI *weniger* vertraute und mehr an Prompts arbeitete, schrieb sichereren Code. 87 % der sicheren Antworten erforderten erhebliche Bearbeitung der KI-Ausgabe.
- Wer die Ausgabe der KI als nächsten Prompt wiederverwendete, verstärkte Fehler („Model Close"-Muster).

→ Zusammen: Das Modell wählt in fast der Hälfte der Fälle unsicher, und der Mensch merkt es schlechter, wenn er der KI vertraut. **Vertrauen ist keine Kontrolle. Gates sind es.**

## D.7 Benchmarks und ihre Grenzen [K]

**„The SWE-Bench Illusion"** (Microsoft Research, NeurIPS) — Spitzenmodelle identifizieren bis zu 76 % der fehlerhaften Dateipfade allein aus der Issue-Beschreibung, ohne Repo-Zugriff; außerhalb des Benchmarks fällt das auf 53 %. Kontamination und Memorisierung blähen Scores auf.

**METR Time Horizon** — Länge der Aufgaben, die Agenten mit 50 % Zuverlässigkeit schaffen, gemessen in menschlicher Arbeitszeit. Verdopplung etwa alle **7 Monate** über sechs Jahre; bestätigt in TH1.1 (Januar 2026, 196 Tage); 2024–25 eher beschleunigt auf ~4 Monate.

→ Beides stimmt gleichzeitig: Benchmark-Scores überzeichnen, der Fähigkeitstrend ist real und steil.

## D.8 Praxis-Stimmung [K]

**Stack Overflow Developer Survey 2025** (49.000+ Antworten): 84 % nutzen oder planen KI-Tools (2024: 76 %). Aber 46 % misstrauen der Genauigkeit — deutlich gestiegen. Vertrauen von 40 % auf 29 % gefallen. Top-Frustration (45 %): „fast richtige" Lösungen. 66 % verbringen mehr Zeit mit dem Fixen von Fast-richtig-Code. Die erfahrensten Entwickler sind die vorsichtigsten (nur 2,6 % hohes Vertrauen).

**Konzernangaben** wie „X % unseres Codes schreibt KI" sind Marketing: keine Methodik, keine Definition von „geschrieben", nicht prüfbar. Nicht als Beleg verwenden.

## D.9 Halbwertszeit von Befunden

Das Ordnungsraster, das aus der Aktualitätsprüfung entstand:

| Halbwertszeit | Was | Beispiele |
|---|---|---|
| **kurz (6–12 Monate)** | absolute Produktivitätszahlen, Benchmark-Scores, konkrete Fehlermodi | METR −19 % → +18 %; Cui +26 % aus der Autocomplete-Ära |
| **mittel (2–5 Jahre)** | Interaktionseffekte: Abhängigkeit von Aufgabentyp und Codebasis-Reife; Qualitätseffekte | Greenfield vs. Brownfield; CMU-Komplexitätsbefunde |
| **lang (Jahrzehnte)** | Aussagen über Menschen, Warteschlangen und Organisationen | Wahrnehmungslücke; Batchgröße → Instabilität; Generierung skaliert, Verstehen nicht; Verstärkerthese |

**Struktureller Zusatzbefund:** Belastbare Kausalforschung hinkt den Werkzeugen systematisch **12–18 Monate** hinterher, weil Design, Durchführung und Review so lange dauern. Das ist kein vorübergehender Zustand, sondern dauerhaft. Deshalb ist die eigene Messung (8.5) die einzige jemals aktuelle Datenquelle.

**Der stärkste Beleg gegen „alles veraltet":** Veracode misst **über Modellgenerationen hinweg**. Dass Syntax von 50 auf 95 % steigt, während Sicherheit flach bleibt, ist selbst der Beweis, dass Fähigkeitszuwachs die Sicherheitsfrage nicht löst.

## D.10 Mythen, gesicherte Erkenntnisse, Überraschungen

| | Aussage |
|---|---|
| **Mythos** | Pauschale 2×–10×-Beschleunigung. |
| **Gesichert** | Seriöse Spanne −19 % bis +55 % je nach Aufgabe, Codebasis-Reife, Erfahrung. Nach Rework realistisch ~15–25 % auf geeigneten Aufgaben. |
| **Mythos** | Gefühlte Beschleunigung belegt Nutzen. |
| **Gesichert** | Wahrnehmung und Messung klaffen systematisch auseinander. Rework erscheint als Mehrleistung. |
| **Mythos** | Qualität und Sicherheit verbessern sich mit den Modellen automatisch mit. |
| **Überraschung** | Security-Pass-Raten über Generationen flach; Wartbarkeitssignale verschlechtern sich messbar — außer man erzwingt Gates. |
| **Mythos** | Benchmark-Score = reale Engineering-Fähigkeit. |
| **Gesichert** | Teilweise Memorisierung. Gleichzeitig ist der Zeithorizont-Trend echt und steil. |
| **Überraschung** | Vertrauen sinkt, während Adoption steigt. Die Praxis lernt, dass Verifikation der Preis der Geschwindigkeit ist. |
| **Überraschung** | Der Speedup ist bedingt, die technische Schuld nicht — sie entsteht auch dort, wo kein Tempogewinn eintritt. |

---

# TEIL E — Rückschlüsse und offene Entscheidungen

## E.1 Was aus der Evidenz für die eigene Arbeit folgt

1. **Selbst messen.** Bei dieser Varianz ist jede fremde Zahl nur eine Hypothese. Baseline vor größeren Änderungen (Methodik 8.5).
2. **Nach Aufgabentyp routen.** Hohe Autonomie bei Greenfield und geringer Komplexität, enge Führung bei reifem Brownfield. Deckt sich mit den Risikoklassen R0–R3.
3. **Security-Gates sind nicht verhandelbar.** Das Modell wählt in ~45 % der Fälle unsicher, und Menschen mit KI liegen überzeugter falsch. Deterministische Scanner statt Modellvertrauen (22.8).
4. **Kleine Tranchen.** Die plausibelste Erklärung für DORAs Instabilitätsbefund und dessen Besserung. WIP-Limit nach Review-Bandbreite (10.8).
5. **Komplexität und Warnungen als Gate-Signale** beobachten, nicht nur Tests — direkte Konsequenz aus der CMU-Studie (18.10, 14.8).
6. **Explain-back ist keine Paranoia**, sondern die direkte Gegenmaßnahme zur dokumentierten Overconfidence (5.5).
7. **Autonomie evalbasiert erweitern.** Was heute enge Führung braucht, kann in zwei Zyklen delegierbar sein. Turnusmäßige Prüfung gegen frische Evidenz, wie im Sunset-Kriterium vorgesehen.

## E.2 Offene Eigentümerentscheidungen

| # | Entscheidung | Empfehlung | Aufwand |
|---|---|---|---|
| E1 | Hooks-Pflichtpaket: main-Schutz, `git add -A`-Block, `--no-verify`-Block, Secret-Scan, Formatter | **Ja, zuerst.** Größter Einzelhebel: überführt Text in Physik | ~½ Tag |
| E2 | Methodik in Moduldateien aufspalten (kontextfreundliches JIT-Laden) | Ja, aber nach E1; eigene Tranche mit Linkmigration | ~1 Tag |
| E3 | Erste Eval-Suite: 10–20 Golden Tasks plus 5 Kanarienfälle; v4.0 selbst dagegen prüfen | Ja — sonst bleibt C4 offen | ~1 Tag initial |
| E4 | DTCG-Token-Pipeline im Referenzprojekt (Quelle + Generierung Web/Compose + Driftgate) | Ja beim nächsten UI-Vorhaben | ~1–2 Tage |
| E5 | BFSG-Anwendbarkeitsprüfung für konkrete Produkte mit fachkundiger Stelle, Ergebnis als ADR | Ja, zeitnah | extern |
| E6 | Kennzahlen-Baseline: DORA-4 plus Agenten-Rework und Review-Latenz | Ja, vor der nächsten Modusentscheidung | ~½ Tag |

## E.3 Bewusst nicht übernommen

1. **Agent-to-Agent-Protokolle und Schwarm-Muster** — widerspricht dem Orchestrator-Worker-Grundsatz; auch Anthropic rät bei eng gekoppelten Aufgaben ab.
2. **ISO/IEC 42001 oder NIST AI RMF als Pflicht** — Überbau für die Teamgröße; als optionale Rahmen in 22.9 erwähnt.
3. **LLM-as-Judge als Gate** — nur Vorstufe und Advisor. Richter-Modelle sind fehlbar und manipulierbar; Freigabeautorität bleibt bei deterministischen Checks und Mensch.
4. **Feste Zahlengrenzen** — nur als Richtwerte formuliert; harte Zahlen ohne Projektbezug altern schlecht.
5. **Umstellung auf SE-3.0-Vokabular** (ACE/AEE, MRP) — konzeptionell deckungsgleich mit Venue, Pre-Integration-Gate und HANDBACK; Umbenennung wäre Churn.
6. **Radikalkürzung der CLAUDE.md** — die Architektur- und UX-Abschnitte kodieren echte projektspezifische Invarianten.

---

# TEIL F — Quellenverzeichnis

## F.1 In dieser Session direkt geprüft [V]

- Agarwal, He, Vasilescu (CMU), *AI IDEs or Autonomous Agents? Measuring the Impact of Coding Agents on Software Development*, MSR '26, Rio de Janeiro, April 2026
  https://arxiv.org/abs/2601.13597 · https://doi.org/10.1145/3793302.3793589
- Veracode, *Spring 2026 GenAI Code Security Update*, 24.03.2026
  https://www.veracode.com/blog/spring-2026-genai-code-security/
- Veracode, *2025 GenAI Code Security Report* (Basisstudie)
  https://www.veracode.com/resources/analyst-reports/2025-genai-code-security-report/
- DORA, *2025 State of AI-assisted Software Development Report*
  https://dora.dev/research/2025/dora-report/
- DORA, *AI Capabilities Model*
  https://dora.dev/ai/capabilities-model/report/
- Perry, Srivastava, Kumar, Boneh (Stanford), *Do Users Write More Insecure Code with AI Assistants?*, ACM CCS '23, S. 2785–2799
  https://arxiv.org/abs/2211.03622 · https://doi.org/10.1145/3576915.3623157
- OWASP GenAI Security Project, *Top 10 for Agentic Applications 2026* (ASI01–ASI10), 09.12.2025
  https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- METR, *We are Changing our Developer Productivity Experiment Design*, 24.02.2026
  https://metr.org/blog/2026-02-24-uplift-update/

## F.2 Über Suchergebnisse belegt [S]

- METR, *Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity* — arxiv.org/abs/2507.09089
- Cui, Demirer, Jaffe, Musolff, Peng, Salz, *The Effects of Generative AI on High-Skilled Work*, Management Science — doi.org/10.1287/mnsc.2025.00535
- Paradis et al. (Google), *How much does AI impact development speed?*, ICSE-SEIP 2025 — arxiv.org/abs/2410.12944
- Peng, Kalliamvakou, Cihon, Demirer, *The Impact of AI on Developer Productivity: Evidence from GitHub Copilot* — arxiv.org/abs/2302.06590
- CMU-Volltext (frei): cmustrudel.github.io/papers/msr2026agarwal.pdf
- Replikationspaket: github.com/shyamagarwal13/agentic-coding-impact
- MCP: modelcontextprotocol.io/specification/latest · /docs/learn/versioning · /docs/learn/architecture · /docs/tutorials/security/security_best_practices · blog.modelcontextprotocol.io
- Claude Code MCP-Doku: code.claude.com/docs/en/mcp

## F.3 Aus dem Recherchekontext, vor Wiederverwendung prüfen [K]

- Anthropic Engineering: Building Effective Agents · Multi-Agent Research System · Effective Context Engineering · Effective Harnesses for Long-Running Agents · Claude Code Best Practices · How Claude Code is used in practice · Building effective human-agent teams · Economic Index
- OpenAI: Codex Best Practices, AGENTS.md-Konventionen
- GitHub Spec Kit: github.com/github/spec-kit
- Stanford Software Engineering Productivity: softwareengineeringproductivity.stanford.edu
- GitClear: *The Maintainability Gap: 2026 AI Code Quality Research*
- Liang et al., *The SWE-Bench Illusion*, NeurIPS 2025 — arxiv.org/abs/2506.12286
- METR *Time Horizon 1.1*, Januar 2026
- Stack Overflow Developer Survey 2025 — survey.stackoverflow.co/2025
- Hassan et al., *Agentic Software Engineering: Foundational Pillars and a Research Roadmap* — arxiv.org/abs/2509.06216
- W3C DTCG Design Tokens Specification v2025.10 — designtokens.org
- OpenTelemetry GenAI Semantic Conventions — opentelemetry.io
- NSA/CISA, *Security Design Considerations for AI-Driven Automation* (MCP), Juni 2026
- BFSG/EAA: IHK-Leitfäden, EN 301 549 · EU AI Act Art. 50 und Digital Omnibus: artificialintelligenceact.eu

---

## Nachtrag: Prüfroutine für die nächste Aktualisierung

1. Halten die zeitabhängigen Abschnitte? Zu prüfen sind Methodik **23.3** (MCP-Revision), **22.9** (Fristen), **15.7**, **21.6**, **26.2** (Werkzeugstand).
2. Gibt es neue Kausalstudien der agentischen Ära? Suchanker: MSR, ICSE, FSE, AIDev-Datensatz, METR-Redesign.
3. Hat sich die Veracode-Pass-Rate bewegt? Das ist der empfindlichste Einzelindikator dafür, ob Gates weiterhin nicht verhandelbar sind.
4. Neue OWASP-Version der Agentic Top 10?
5. Eigene Kennzahlen gegen die letzte Baseline (8.5) — die einzige aktuelle Datenquelle.
