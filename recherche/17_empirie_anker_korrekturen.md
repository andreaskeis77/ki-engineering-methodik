# Empirie-Anker-Korrekturen: METR-Umstützung, Benchmark-Zitierregel, DORA-Kapazitäten

**Stand:** 2026-07-28. **Auftrag:** Auflösung der Konfliktlinien 2 und 3 aus `00_KRITIK_UND_LUECKEN.md`. **Quellenstatus:** [V] = in dieser Session selbst abgerufen und geprüft (2026-07-28); [V-D07/D08/D13] = am 2026-07-28 vom jeweiligen Dossier-Agenten an der Primärquelle verifiziert (nicht erneut abgerufen); [S] = nur über Suche belegt.

## Executive Summary

Die berühmte METR-Zahl „−19 % Verlangsamung" ist als Punktschätzer nicht mehr zitierfähig: METR selbst stuft die Daten der umgebauten Folgestudie als „only very weak evidence" und als untere Schranke ein (Originalkohorte −18 %, CI −38 % bis +9 %; neue Entwickler −4 %, CI −15 % bis +9 %). Robust bleibt aus METR aber zweierlei — die Wahrnehmungs-Mess-Lücke (alle Prognose- und Nachschätzungsgruppen lagen falsch; Survey 2026: ~40 Punkte Überschätzung) und neu die formale Task-Substitution-Analyse, die zeigt, warum Task-Speedups nie 1:1 in Gesamtproduktivität übersetzen. Die normativen Schlüsse der Dossiers 03 (Verifikationsbandbreite als WIP-Limit) und 07 (Metrikdisziplin) bleiben bestehen, werden hier aber auf ein Bündel prozess- und artefaktbasierter Anker umgestellt: AIDev-Ablehnungs- und Review-Daten, DORA-Differenzierung nach Task-Klassen, CMU-Komplexitätsbefunde, Stack-Overflow-Vertrauensdaten und Anthropic-Praxisdaten. Für SWE-bench-artige Scores wird eine einheitliche Zitierregel (B1–B5) formuliert — Kern: Scores belegen Trend und kontrollierten Vergleich, nie absolute Fähigkeit, weil das SWE-Bench-Illusion-Paper Memorisierung nachweist (76 % vs. 53 % Pfad-Identifikation allein aus dem Issue-Text). Die sieben DORA-Kapazitäten sind jetzt doppelt an Primärquellen verifiziert und vollständig benannt; der Hauptteil von Dossier 01 hatte sie bereits korrekt, nur verkürzte Zusammenfassungen erzeugten die Sechser-Zählung. Der DORA-Vollreport (PDF) bleibt gated — das betrifft aber nur Detailzahlen, nicht mehr die Kapazitätenliste.

---

## 1. METR-Umstützung (Konfliktlinie 2)

### 1.1 Sachstand: METRs Veröffentlichungen bis Juli 2026 [V]

Die Publikationsliste (metr.org/research, abgerufen 2026-07-28) zeigt als produktivitätsrelevante Arbeiten: Uplift-Redesign (2026-02-24), MirrorCode (2026-04-10, mit Epoch AI), Task Substitution and Uplift (2026-05-08), Developer-Productivity-Survey (2026-05-11), dazu Time Horizon 1.1 (2026-01-29) und als jüngste Veröffentlichung „Expenditure Horizon" (2026-07-21, Fähigkeitsmaß, nicht Produktivität). **Es gibt keine neue RCT-Zahl seit dem Redesign-Post** — die angekündigten Folgeexperimente (intensivere, besser bezahlte Studien, Fixed-Task-Designs, Developer-Level-Randomisierung, Beobachtungsdaten) sind noch nicht publiziert.

Was der Redesign-Post [V] festhält: Die zweite Studie (H2 2025, 57 Entwickler, davon 10 aus der Originalkohorte, 800+ Tasks, 143 Repos) litt unter massiver Selektionsverzerrung — Entwickler behielten gezielt die Tasks zurück, bei denen KI am meisten hilft; Bezahlung sank auf 50 $/h (vorher 150 $/h); Zeiterfassung bei parallelen Agenten unzuverlässig. METR wertet die Punktschätzungen deshalb explizit als **untere Schranke** und als „only very weak evidence". Als Beobachtungsdatum nennt der Post ~4 % der öffentlichen GitHub-Commits aus Claude Code. **Konsequenz: Die −19 % (arXiv 2507.09089 [V-D13]) bleibt als sauber dokumentiertes Einzel-RCT zitierfähig für die Wahrnehmungs-Mess-Lücke und für das Setting „erfahrene Entwickler im eigenen, reifen Repo, Anfang 2025" — nicht mehr als generalisierbare Verlangsamungsaussage.**

Zwei neuere METR-Arbeiten schärfen die Interpretation:

- **Task Substitution and Uplift (2026-05-08, Cunningham/Whitfill)** [V]: unterscheidet drei Uplift-Maße (Speedup auf alten Tasks ≤ Wert-Uplift ≤ Speedup auf neuem Task-Mix) und zeigt formal, dass Arbeitende zu KI-günstigen Tasks substituieren — große Task-Speedups implizieren daher keine proportionalen Gesamtgewinne. Das ist der methodische Grund, warum weder −19 % noch „3× schneller" als Produktivitätsaussagen taugen.
- **MirrorCode (2026-04-10, mit Epoch AI; Preliminary)** [V]: Agenten schaffen wochenlange Coding-Tasks, u. a. Reimplementierung einer 16.000-Zeilen-Codebase (Folgeberichte nennen ~60k Zeilen [S]). Das ist die Fähigkeitslinie (Fixed-Task-Ansatz) — sie misst, *was* Agenten schaffen, nicht, ob Menschen damit schneller sind.
- Der **Survey (2026-05-11)** [V-D08] bestätigt die Wahrnehmungslücke fort: Median-Selbstauskunft 1,4–2× Wert, ~3× Geschwindigkeit — bei dokumentierter ~40-Punkte-Überschätzung in der eigenen RCT und deflationierenden Extremangaben bei Nachprüfung.

### 1.2 Neuer Evidenzanker-Satz für „Verifikationsbandbreite als WIP-Limit" (Dossier 03, Konsequenz 1)

Der Schluss bleibt; die Begründung wechselt vom RCT-Punktschätzer auf Prozess- und Artefaktdaten:

| # | Anker | Befund | Quelle/Status | Belastbarkeit |
|---|---|---|---|---|
| A1 | AIDev-Ablehnungsstudie (MSR 2026) | 46,4 % Ablehnungsquote agentischer Bug-Fix-PRs; Hauptgründe Prozess/Triage (Relevanz/Priorität 24,5 %), nicht Codequalität | arXiv 2606.13468 [V-D08] | hoch (großer Realdatensatz); Preprint |
| A2 | Review-Wirkungsstudie (MSR 2026) | PRs mit nur agentischem Review: 45,2 % Merge vs. 68,4 % bei menschlichem; agentische Kommentare nur zu 0,9–19,2 % adressiert; 60,2 % der CRA-only-PRs mit ≤30 % Signalanteil | arXiv 2604.03196 [V-D07] | hoch; Preprint |
| A3 | AIDev-Merge-Charakterisierung | 24.014 gemergte agentische PRs: deutlich mehr Commits je PR (Cliff's δ 0,54) → höhere Review-Granularität pro PR | arXiv 2601.17581 [V-D08] | hoch; Preprint |
| A4 | DORA nach Task-Klassen | 35–40 % Gewinn bei einfachen Aufgaben vs. ~10 % bei komplexem Legacy-Code; Change-Failure-Rate 5 %→6 %; Nutzen fließt über die sieben Kapazitäten (u. a. Small Batches, Version Control) | DORA-ROI-Report [V-D08 via InfoQ]; Kapazitäten [V] | mittel-hoch (Survey-basiert, Modellrechnung beim ROI) |
| A5 | CMU-Komplexitätsbefund (MSR 2026) | Diff-in-Diff auf AIDev: Velocity-Gewinne front-loaded und konditional; Static-Analysis-Warnungen +18 %, kognitive Komplexität +39 % — Prüflast steigt auch ohne Tempogewinn | arXiv 2601.13597 [V-D13] | hoch; Preprint |
| A6 | Stack-Overflow-Vertrauensdaten 2025 | 84 % Nutzung, aber 46 % Misstrauen in Genauigkeit (33 % Vertrauen, 3 % hoch); 66 % Top-Frustration „almost right, but not quite"; 45,2 % „Debugging von KI-Code kostet mehr Zeit"; 75,3 % eskalieren an Menschen | survey.stackoverflow.co/2025/ai [V] | mittel (~49k Selbstauskünfte; Konvergenzindiz, kein Messwert) |
| A7 | Anthropic-Praxisdaten | „Give Claude a way to verify its work" als Architekturprinzip [V-D01]; Economic Index 06/2026: Delegation steigt stark (Claude-Code-Sessions oft 1 Prompt vs. 13 Chat-Runden; +0,37 Autonomiepunkte) [V] — Erzeugung wird billiger, Prüfung bleibt der menschliche Anteil. Claims „80–100 % des Codes von Claude geschrieben" nur PR-nah [S] | anthropic.com [V]; officechai/Fortune [S] | Prinzip hoch, Zahlen-Claims niedrig |
| A8 | Verifikations-Shift-Studien | ICSE-2026-Längsschnitt (Vella/Blincoe): dokumentierter Shift von Erstellung zu Verifikation bei stabil hoher Selbstauskunft | [V-D08] | mittel-hoch |

**Ersatzformulierung für Dossier 03 (statt „METR Q14: 19 % langsamer"):** *„Der Engpass ist Prüfkapazität, nicht Erzeugung: Fast die Hälfte agentischer Bug-Fix-PRs wird abgelehnt, überwiegend aus Triage-/Prozessgründen (A1); ohne menschlichen Review sinkt die Merge-Quote um 23 Punkte (A2); agentische PRs sind granularer zu reviewen (A3); die Prüflast steigt selbst dort, wo kein Tempogewinn messbar ist (A5); und Praktiker benennen die Verifikation fast-richtiger Lösungen als Hauptfriktion (A6). METR ergänzt: Selbst gemessene Task-Speedups übersetzen wegen Task-Substitution nicht 1:1 in Gesamtproduktivität [V]."*

### 1.3 Neuer Anker für „Metrikdisziplin" (Dossier 07, Konsequenz 10)

Der tragende Anker war nie die −19 an sich, sondern die **Wahrnehmungs-Mess-Lücke — und die überlebt das Redesign unbeschädigt**: In der 2025er-RCT lagen alle Gruppen falsch (Entwickler erwarteten +24 %, Ökonomen +39 %, ML-Experten +38 %; Nachschätzung +20 % — gemessen wurde eine Verlangsamung) [V-D13]; der 2026er-Survey dokumentiert ~40 Punkte Überschätzung und deflationierende Extremwerte [V-D08]; Stack Overflow zeigt steigende Nutzung bei sinkendem Vertrauen (Favorabilität 70 %+ → 60 %) [V] — Selbstauskünfte sind in beide Richtungen instabil. Die Task-Substitution-Arbeit [V] liefert zusätzlich den formalen Grund, warum auch ehrliche Task-Wahrnehmung Gesamtwirkung nicht abbildet. **Ersatzformulierung für Dossier 07:** *„Wirkung ausschließlich über Artefakte messen (Durchlaufzeit, Defekt-Escape, Mutation-Stichproben, Rework-Quote, GitClear-artige Struktursignale), nie über gefühlte Beschleunigung — die Wahrnehmungs-Mess-Lücke ist mehrfach repliziert (METR-RCT-Fehlprognosen aller Gruppen, Survey-Überschätzung ~40 pp, SO-Vertrauensparadox), unabhängig davon, wie groß der wahre Speedup ist."* Die Fußnote „RCT, −19 %" in Dossier 07 (Quelle 8, Zeile 134) ist um den Redesign-Verweis zu ergänzen; die Passage in §4 (Zeile 49) behält die RCT als Beleg der Lücke, nicht der Verlangsamung.

## 2. Benchmark-Zitierregel (Konfliktlinie 3)

**Befund (verifiziert):** „The SWE-Bench Illusion" (Liang/Garg/Zilouchian Moghaddam, arXiv 2506.12286, v4 vom 2025-12-01) [V]: Modelle identifizieren allein aus dem Issue-Text bis zu 76 % der Buggy-File-Pfade auf SWE-Bench-Verified-Repos vs. 53 % auf fremden Repos; 5-Gramm-Verbatim-Ähnlichkeit bis 35 % vs. 18 % — Scores sind teilweise Memorisierung/Kontamination, nicht Problemlösung.

**Regel B1–B5 (einheitlich für alle Dossiers und Folgearbeiten):**

- **B1 — Vollständige Nennung:** Benchmark + Subset (Lite/Verified/Full/Pro/…) + System/Scaffold + Messzeitpunkt + Quelle. „X löst 78 % SWE-bench" ohne Subset/Scaffold ist unzulässig.
- **B2 — Stehender Vorbehalt:** Jede SWE-bench-artige Zahl trägt den Memorisierungsvorbehalt (Illusion-Paper); bei öffentlichen, alten Repos ist ein unbekannter Score-Anteil Kontamination.
- **B3 — Wofür Scores taugen:** (a) Trendaussagen auf demselben Benchmark über die Zeit; (b) Vergleiche zwischen Systemen im selben Harness/Lauf; (c) Ablationen innerhalb einer Studie (Scaling-, Sampling-, Scaffold-Effekte).
- **B4 — Wofür nicht:** absolute Fähigkeitsaussagen („löst X % realer Issues"), Übertragung auf eigene Repos, Vergleiche über verschiedene Harnesses/Subsets/Zeitpunkte hinweg, Hersteller-Marketingzahlen ohne Methodikangabe.
- **B5 — Entscheidungsgrundlage:** Für Autonomie-/Werkzeugentscheidungen zählen eigene Golden-Task-Evals (Dossier 08, pass^k); öffentliche Scores sind nur Kontext.

**Anwendung auf die zitierten Zahlen:**

- **Dossier 01** („1,96 % (10/2023) → 78,4 % (04/2026) SWE-bench Verified"): als **Trendaussage zulässig** (agentische Scaffolds haben die gelöste Task-Menge um Größenordnungen gehoben, nicht-agentisch stagniert ~20 %) — aber umzuformulieren: *„…als Trend belastbar; als absolutes Fähigkeitsmaß nach B2 nach oben verzerrt (Memorisierungsanteil unbekannt; 76 %-vs.-53 %-Befund)."* Zusatz: Verified ist ein von OpenAI kuratiertes 500-Task-Subset öffentlicher Python-Repos — Übertragbarkeit auf Andreas' Stacks ungeprüft.
- **Dossier 03** (Repeated Sampling 15,9 % → 56 % auf SWE-bench Lite; CodeMonkeys 57,4 % Verified): **regelkonform als Within-Study-Ablationen** (B3c) — die Aussage betrifft Scaling-Verhalten und Verifier-Engpass, nicht absolute Fähigkeit. Nur der stehende Vorbehalt (B2) ist als Fußnote nachzutragen; die 57,4 % nicht mit heutigen Leaderboard-Werten vergleichen (anderer Zeitpunkt/Scaffold, B4).

## 3. DORA: die sieben Kapazitäten, vollständig und verifiziert

Doppelt primär belegt (dora.dev/capabilities [V] und Google-Cloud-Ankündigung des AI Capabilities Model, 2025-09-23 [V]); der eigenständige Capabilities-Model-Report datiert 2025-11-25, sein **Vollreport-PDF bleibt hinter einem Formular** (Landingpage [V], inhaltsarm) — das betrifft jetzt nur noch Detailzahlen, nicht die Liste:

1. **Clear and communicated AI stance** — klare, kommunizierte KI-Haltung/Policy (erlaubte Tools, Erwartungen, Experimentierräume)
2. **Healthy data ecosystems** — gesundes internes Datenökosystem (Qualität, Zugänglichkeit, Vereinheitlichung)
3. **AI-accessible internal data** — KI-zugängliche interne Daten (Firmenkontext statt Generalist; „context engineering")
4. **Strong version control practices** — starke Versionskontrollpraxis (häufige Commits, Rollback) 
5. **Working in small batches** — Arbeit in kleinen Batches
6. **User-centric focus** — Nutzerzentrierung
7. **Quality internal platforms** — hochwertige interne Plattformen (Capability-Seite firmiert unter „Platform engineering")

**Klarstellung zur Kritik:** Der Hauptteil von Dossier 01 (§4) listete bereits alle sieben korrekt; die Sechser-/Vierer-Zählung entstand in verkürzten „u. a."-Zusammenfassungen (Exec Summary, Kernbefunde). Es ist also keine inhaltliche Korrektur von Dossier 01 nötig, sondern eine Vollständigkeitsregel für Zusammenfassungen: die Kapazitätenliste entweder ganz oder mit expliziter Zählung („7, darunter …") zitieren.

## Konsequenzen für Andreas

1. **Sprachregelung METR ab sofort:** Nie mehr „−19 %" als Faktum. Standardformulierung: *„METRs 2025-RCT zeigte eine Verlangsamung bei erfahrenen Entwicklern im eigenen Repo; die Folgestudie wurde wegen Selektionseffekten umgebaut, der aktuelle Effekt liegt ‚um null mit großer Unsicherheit' und ist laut METR eine untere Schranke. Robust ist die Wahrnehmungs-Mess-Lücke."*
2. **WIP-Limit (Dossier 03) unverändert übernehmen, Evidenzblock A1–A8 einsetzen** — die These steht jetzt auf mehreren unabhängigen Datenlinien statt einem RCT-Punktschätzer und ist damit robuster als vorher.
3. **Metrikdisziplin (Dossier 07) unverändert, Anker = Wahrnehmungslücke + Artefaktsignale;** eigene Kennzahlen-Baseline (E6) zusätzlich durch die Task-Substitution-Logik begründen: auch ehrlich wahrgenommene Task-Gewinne belegen keine Gesamtwirkung.
4. **Benchmark-Regel B1–B5 in die Methodik übernehmen** (Recherche-Leitfaden/CLAUDE.md-Vorgaben für Recherche-Agenten); Synthese v2 wendet sie auf alle Dossier-Zahlen an.
5. **DORA-Kapazitäten als Selbst-Checkliste im Privatmaßstab lesen:** 4≈Rollback-Disziplin/Worktrees, 5≈WIP-Limit/kleine PRs, 3≈Kontext-Engineering, 7≈eigene Plattform-Bausteine (CI, Templates) — die Liste ist die organisatorische Begründung der v4.0-Gates, kein Enterprise-Overhead.
6. **Beobachtungsliste:** METR-Folgeexperimente (intensivere Studien, Developer-Level-Randomisierung, Fixed-Task-Ergebnisse), MirrorCode-/Expenditure-Horizon-Linie, Stack-Overflow-Survey 2026 (Feld lief Mitte 2026, Ergebnisse ausstehend [S]), DORA-2026-Zyklus.

## Quellenverzeichnis

1. [V] METR: We are Changing our Developer Productivity Experiment Design (2026-02-24) — metr.org/blog/2026-02-24-uplift-update/ (abgerufen 2026-07-28)
2. [V] METR: Research-Publikationsliste — metr.org/research/ (abgerufen 2026-07-28; jüngste Produktivitätsarbeit 2026-05-11, jüngste Publikation „Expenditure Horizon" 2026-07-21)
3. [V] METR: Task Substitution and Uplift (Cunningham/Whitfill, 2026-05-08) — metr.org/blog/2026-05-08-task-substitution-and-uplift/ (abgerufen 2026-07-28)
4. [V] METR/Epoch AI: MirrorCode — Preliminary Results (2026-04-10) — metr.org/blog/2026-04-10-mirrorcode-preliminary-results/ (abgerufen 2026-07-28)
5. [V] Liang/Garg/Zilouchian Moghaddam: The SWE-Bench Illusion, v4 (2025-12-01) — arxiv.org/abs/2506.12286 (abgerufen 2026-07-28)
6. [V] Stack Overflow Developer Survey 2025, AI-Sektion (~49.000 Befragte) — survey.stackoverflow.co/2025/ai (abgerufen 2026-07-28)
7. [V] DORA: Capabilities-Übersicht (7 AI-Kapazitäten gelistet) — dora.dev/capabilities/ (abgerufen 2026-07-28)
8. [V] Google Cloud Blog: Introducing DORA's inaugural AI Capabilities Model (2025-09-23; alle 7 mit Beschreibung) — cloud.google.com/blog/products/ai-machine-learning/introducing-doras-inaugural-ai-capabilities-model (abgerufen 2026-07-28)
9. [V] DORA: AI Capabilities Model Report Landingpage (2025-11-25; PDF gated) — dora.dev/ai/capabilities-model/report/ (abgerufen 2026-07-28)
10. [V] Anthropic Economic Index, Juni-2026-Report „Cadences" (2026-06-26) — anthropic.com/research/economic-index-june-2026-report (abgerufen 2026-07-28)
11. [V-D13] METR RCT-Paper (v2, 2025-07-25) — arxiv.org/abs/2507.09089
12. [V-D08] METR: AI-Usage-Survey (2026-05-11) — metr.org/blog/2026-05-11-ai-usage-survey/
13. [V-D13] METR: Time Horizon 1.1 (Publikation 2026-01-29; Dashboard-Stand 2026-05-08) — metr.org/time-horizons/
14. [V-D08] AIDev-Ablehnungsstudie — arxiv.org/abs/2606.13468
15. [V-D08] AIDev-Merge-Charakterisierung — arxiv.org/abs/2601.17581
16. [V-D07] Review-Wirkungsstudie „From Industry Claims to Empirical Reality" — arxiv.org/abs/2604.03196
17. [V-D13] CMU: AI IDEs or Autonomous Agents? (MSR '26) — arxiv.org/abs/2601.13597
18. [V-D08] DORA ROI of AI-assisted Software Development via InfoQ (2026-05) — infoq.com/news/2026/05/dora-roi-ai-assisted-dev-report/
19. [V-D08] GitClear: The Maintainability Gap (2026) — gitclear.com/the_ai_code_quality_maintainability_gap
20. [V-D08] Vella/Blincoe, ICSE-2026-Längsschnitt (Shift zu Verifikation) — via Dossier 08
21. [S] Epoch AI: MirrorCode-Projektseite / arXiv 2606.30182; TechTimes zu ~60k-Zeilen-Stand (06/2026)
22. [S] OfficeChai: „80 % of Claude Code's code is written by Claude Code" (Anthropic Lead Engineer); Fortune/Yahoo: „AI writes 100 % of their code" — PR-nahe Claims, nur Richtungsindikator
23. [S] Logicity: Stack-Overflow-2026-Survey geöffnet (Ergebnisse zum Stichtag nicht publiziert)
24. [S] Rob Bowley: METR's developer productivity research — 2026 update (2026-04-04, Sekundäreinordnung)
