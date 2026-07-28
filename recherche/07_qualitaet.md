# Dossier 07 — Qualitätssicherung, Teststrategie und Evidence Chain

**Stand:** 2026-07-28. Quellenstatus: [V] = Quelle am 2026-07-28 selbst abgerufen und geprüft; [S] = nur über Suchergebnisse belegt. Bewertungsmodell gemäß Forschungsplan (jetzt empfohlen / sinnvoll unter Bedingungen / pilotgeeignet / beobachten / überdimensioniert / derzeit nicht belastbar / überwiegend Marketing).

---

## Executive Summary

Die Kernideen der Methodik v4.0 — Test-first mit hermetischen Gates, Verifikationsbandbreite als Engpass, Run-Manifeste als Evidenz — werden durch die Empirie 2025/2026 klar bestätigt und in zwei Punkten verschärft. Erstens: Die Test-Pass-Rate ist als alleiniges Erfolgssignal für Agentenarbeit nachweislich unzuverlässig. SpecBench zeigt, dass Coding-Agenten sichtbare Validierungstests nahezu sättigen, während verdeckte Spezifikationstests dramatisch schlechter ausfallen — die Lücke wächst um ca. 27 Prozentpunkte pro Verzehnfachung der Codegröße; dokumentiert ist ein Extremfall mit 97 % sichtbarem und 0 % verdecktem Bestehen (Lookup-Table statt Implementierung). Konsequenz: Held-out-Abnahmetests, die der implementierende Agent nicht sieht, gehören in die Methodik. Zweitens: KI-Code-Reviews sind 2026 eine nützliche Zusatzschicht, aber kein Ersatz für menschliche Freigabe — eine MSR-2026-Studie über 3.109 PRs misst für Agent-only-Reviews 23 Prozentpunkte niedrigere Merge-Raten und überwiegend Rauschen (60 % der untersuchten Fälle unter 30 % Signalanteil); Herstellerclaims („80 % der PRs brauchen keine menschlichen Kommentare") halten der Prüfung nicht stand. Positiv belastbar sind dagegen zwei Testtechniken im Agentenverbund: Property-based Testing (Anthropics Claude-Agent fand mit Hypothesis reale Bugs in NumPy/SciPy/Pandas; 56–86 % valide Reports) und mutationsgeleitete Testgenerierung (Meta ACH: 73 % Akzeptanz durch Engineers; MUTGEN: +11,6 bis +19,2 pp Mutation Score gegenüber naiver LLM-Testgenerierung). Für die Evidence Chain existieren inzwischen tragfähige Standards (SLSA v1.2, GitHub Artifact Attestations mit Sigstore auch für private Repos, OpenTelemetry-GenAI-Konventionen inkl. MCP), von denen für den Privatkontext eine pragmatische Dreistufung reicht: Commit-Trailer plus PR-Evidenz immer; Run-Manifeste mit Hashes und Attestation bei Auto-Deploy; OTel-GenAI-Traces nur beobachten. Die METR-RCT (19 % Verlangsamung bei gleichzeitig wahrgenommener 20-%-Beschleunigung) mahnt, Qualitäts- und Produktivitätsaussagen nie auf Selbstwahrnehmung zu stützen, sondern auf gemessene Artefakte.

---

## 1. Basisschicht: statische Analyse, Typprüfung, Linting

Für Python ist Ruff (Linting + Formatting in einem, Rust-basiert) de facto Standard; als Typprüfer konkurrieren mypy (Plugin-Ökosystem, Django-Support), pyright (Referenz für Strictness, VS-Code-nativ) und die neuen Rust-Checker ty (Astral) und Pyrefly (Meta), die 2026 vor allem durch Geschwindigkeit auffallen, aber jünger und in Randbereichen weniger vollständig sind ([S] danilchenko.dev, pydevtools, codegym). Für TypeScript bleibt `tsc --strict` gesetzt, ergänzt um ESLint oder Biome.

Der eigentliche 2025/26-Erkenntnisgewinn ist nicht die Toolwahl, sondern die Rolle: Statik ist das schnellste deterministische Verifikationssignal für Agenten. Anthropics offizielle Best Practices bauen die gesamte Autonomie-Argumentation auf „give Claude a check it can run" auf — Linter, Typcheck und Build sind die billigsten dieser Checks und sollten als Hooks (deterministisch) statt als CLAUDE.md-Prosa (advisory) verankert werden [V] code.claude.com. Wichtiges Detail für hermetische Gates: Ein Stop-Hook blockiert das Beenden eines Turns, aber Claude Code überstimmt den Hook nach 8 aufeinanderfolgenden Blocks — lokale Hooks sind also Beschleuniger, nicht letzte Instanz; die harte Instanz bleibt CI [V].

**Einordnung:** Ruff + pyright: jetzt empfohlen. ty/Pyrefly: beobachten, Pilot unverbindlich möglich. Statik als Hook/Gate: jetzt empfohlen.

## 2. Teststrategie: die einzelnen Ebenen

**Unit-/Integrationstests.** Keine Revolution, aber eine Verschiebung: Tests sind primär das Steuerungs- und Verifikationsinstrument für Agenten, erst sekundär Regressionsschutz für Menschen. Hermetik (kein Netz, keine Echtzeit, deterministische Seeds) bleibt Voraussetzung, damit ein Agent aus Testausgaben verlässlich lernen kann. Für Andreas' DB-Landschaft: SQLite/DuckDB sind in-process direkt und schnell testbar (echte Engine statt Mocks); für PostgreSQL ist eine dedizierte lokale Test-Instanz oder — als einer der wenigen guten Docker-Anlässe — Testcontainers der saubere Weg.

**Property-based Testing (PBT).** Die stärkste Aufwertung des Sweeps. Anthropics Frontier Red Team hat einen Claude-Agenten gebaut, der aus Typannotationen, Docstrings und Funktionsnamen Invarianten ableitet, Hypothesis-Tests schreibt und in einer Fünf-Schritt-Schleife (verstehen → Eigenschaften vorschlagen → Tests schreiben → reflektieren → Bug-Report) reale Bugs in NumPy, SciPy und Pandas fand; von 984 Reports waren 56 % valide, bei den top-gerankten 86 %, mehrere Patches wurden upstream gemergt [V] red.anthropic.com. PBT ist zudem ein strukturelles Gegenmittel gegen Selbstbestätigung: Eine Invariante („Roundtrip erhält Daten", „Ausgabe ist sortiert") lässt sich nicht aus der Implementierung abschreiben wie ein Beispieltest. Werkzeuge: Hypothesis (Python) [S] hypothesis.works, fast-check (TS).

**Mutation Testing.** 2025 vom akademischen Nischenwerkzeug zum praxisrelevanten Wirksamkeitsnachweis gereift — gerade wegen LLMs. Meta beschreibt mit ACH (Automated Compliance Hardening), wie LLMs gezielt realistische, domänenspezifische Mutanten erzeugen und dazu garantiert fangende Tests generieren; im Pilotbetrieb (Facebook/Instagram/WhatsApp, Q4 2024) wurden 73 % der generierten Tests von Engineers akzeptiert, die LLM-basierte Äquivalenzerkennung erreichte mit Preprocessing Präzision/Recall um 0,95/0,96 [V] engineering.fb.com. Akademisch bestätigt MUTGEN (Univ. Limerick/Briand, Huawei) den Mechanismus: Mutation-Feedback im Prompt hebt den Mutation Score LLM-generierter Tests um +11,6 pp (HumanEval-Java) bzw. +19,2 pp (LeetCode-Java) gegenüber Vanilla-LLM-Generierung und um bis zu +51 pp gegenüber EvoSuite — allerdings evaluiert auf isolierten Methoden, nicht auf realen Projekten [V] arxiv 2506.02954. Tools: mutmut, cosmic-ray (Python), Stryker (JS/TS) [S]. Flächiges Mutation Testing ist teuer; als Stichproben-Audit für agentengeschriebene Suiten ist es das beste verfügbare Messinstrument für Testqualität jenseits von Coverage.

**Contract- und API-Tests.** Schemathesis (property-based Fuzzing direkt aus dem OpenAPI-Schema, Hypothesis-basiert) ist für FastAPI-Projekte ein Fast-Gratis-Gewinn: Es findet 500er, Schema-Verstöße und Validierungslücken ohne handgeschriebene Testfälle [S] schemathesis.io, buttondown.com. Konsumenten-getriebene Contracts (Pact) lohnen sich bei mehreren unabhängigen Teams — im Ein-Personen-Portfolio überdimensioniert; das OpenAPI-Schema selbst plus Schemathesis ist der Contract.

**End-to-End und UI.** Playwright bleibt Standard und hat mit den offiziellen Test Agents (seit Okt 2025) eine agentische Ebene: Planner (exploriert App, erzeugt Markdown-Testplan), Generator (macht daraus verifizierte Tests), Healer (repariert fehlschlagende Tests); Setup via `npx playwright init-agents --loop=vscode|claude|codex|opencode`, also direkt Claude-Code-integriert [V] playwright.dev. Achtung Healer: Ein Agent, der Tests „heilt", kann funktionale Regressionen als Testproblem wegdefinieren — Selbstbestätigung auf E2E-Ebene. Heilung darf Selektoren/Wartezeiten fixen, Soll-Verhaltensänderungen muss ein Mensch bestätigen.

**Visuelle Regression.** Playwright `toHaveScreenshot` deckt den Bedarf lokal ab; Cloud-Dienste (Chromatic, Percy, Argos) sind für Privatprojekte überdimensioniert [S] bug0.com, qaskills.sh. Praktische Falle: Screenshots sind plattformabhängig — Baselines konsistent auf einer Plattform (Windows-lokal oder Linux-CI, nicht gemischt) erzeugen.

**Accessibility.** Deques Datenanalyse (13.000+ Seiten, ~300.000 Issues) beziffert den automatisiert findbaren Anteil auf 57,38 % des Issue-Volumens (Kontrast 83 %, Parsing 90 % automatisch erkennbar) — deutlich mehr als die oft zitierten 20–30 %, die sich auf WCAG-Kriterien statt Problemvolumen beziehen [V] deque.com. axe-core in Playwright integriert ist Pflichtbaustein; Tastaturbedienung, Fokusreihenfolge, Alt-Text-Qualität und Screenreader-Semantik bleiben menschliche (agentenassistierte) Prüfaufgaben.

**Performance und Stabilität.** k6 oder Locust für Lasttests der Webdienste, pytest-benchmark für Hot Paths — anlassbezogen, nicht als Dauergate. Wichtiger im Agentenkontext ist Stabilitätshygiene: Flaky Tests zerstören das Verifikationssignal, auf dem die gesamte Agentenautonomie beruht. Praxisstandard 2026: Flaky-Erkennung, Quarantäne statt Retry-Kaschierung, Ursachenklassifikation [S] mergify.com, testdino.com. Regel für Agenten: Ein Agent darf einen instabilen Test quarantänisieren, aber nicht stillschweigend „robuster machen" (= abschwächen).

**Security-Tests.** Basis: Semgrep/Bandit (schnell, lokal) und CodeQL (tiefer, GitHub-integriert) [S]. Neu und für Andreas direkt relevant: Anthropics offizielle claude-code-security-review-Action bzw. der `/security-review`-Befehl — diff-aware, sprachagnostisch, mit explizitem False-Positive-Filter (blendet Low-Impact-Findings wie generische DoS aus) über Injection-, Auth-, Krypto-, Deserialisierungs- und Logikklassen; Anthropic warnt selbst, dass die Action nicht gegen Prompt Injection gehärtet ist — externe Beiträge nur nach Maintainer-Freigabe scannen [V] github.com/anthropics. GitHub Copilot Autofix generiert Fixvorschläge für CodeQL-Alerts; belastbare unabhängige Fix-Qualitätszahlen fehlen, GitHub selbst mahnt Review-Pflicht an [S] docs.github.com.

## 3. Dependency- und Supply-Chain-Prüfung

Der professionelle Kern ist mit Bordmitteln erreichbar: (1) Vollständiges Pinning über Lockfiles (uv.lock, package-lock.json) — auch als Schutz gegen agentische Risiken wie halluzinierte Paketnamen: Agenten installieren nichts ad hoc, Dependency-Änderungen laufen als eigene, menschlich freigegebene PRs. (2) Verwundbarkeits-Scans mit osv-scanner (multi-ökosystem, lockfile-basiert) und/oder pip-audit bzw. `npm audit`, plus Renovate/Dependabot für Update-PRs [S] bernat.tech, appsecsanta.com. (3) SBOM-Erzeugung (CycloneDX hat das reichste Toolökosystem, u. a. cyclonedx-py) ist mit einem CI-Schritt erledigt, hat aber ohne Konsumenten begrenzten Eigenwert — pilotgeeignet, kein Muss [S] cyclonedx.org.

Auf der Standardseite ist SLSA v1.2 approved (Build- und Source-Track, Provenance- und VSA-Attestationsformate) [V] slsa.dev. GitHub Artifact Attestations machen SLSA Build Level 2 zum Ein-Schritt-Feature (`actions/attest-build-provenance`, Verifikation via `gh attestation verify`); private Repos nutzen GitHubs eigene Sigstore-Instanz ohne öffentliches Transparenzlog, Level 3 gelingt mit Reusable Workflows [V] docs.github.com. Für den Privatkontext heißt das: Pinning + wöchentlicher/pre-deploy osv-scan jetzt; Attestations dort sinnvoll, wo unbeaufsichtigt deployt wird (NFL-Plattform) — der Server verifiziert vor dem Start, dass das Artefakt aus dem erwarteten Workflow auf dem erwarteten Commit stammt. Alles darüber (eigene Rekor-Instanz, SLSA L3+) ist überdimensioniert.

## 4. KI-Code-Reviews 2026: Evidenz statt Marketing

Die bisher beste unabhängige Messung ist die MSR-2026-Studie „From Industry Claims to Empirical Reality" (AIDev-Datensatz, 3.109 PRs, 13 Review-Agenten, u. a. Copilot, Ellipsis, Semgrep-Bots): PRs mit ausschließlich agentischem Review wurden zu 45,2 % gemergt gegenüber 68,4 % bei rein menschlichem Review (−23,2 pp) und häufiger aufgegeben (34,9 % vs. 21,6 %). Beim Signal-Rausch-Verhältnis lagen 60,2 % der untersuchten CRA-only-PRs in der Kategorie 0–30 % Signal; menschliche Reviewkommentare wurden zu ~60 % adressiert, agentische nur zu 0,9–19,2 %. Die Autoren stellen dem explizit den Qodo-2025-Claim („80 % der PRs erhalten mit KI-Review keine menschlichen Kommentare mehr") gegenüber und empfehlen: Agenten-Reviews eng scopen (z. B. nur Security), menschliche Freigabe vor Merge erzwingen [V] arxiv 2604.03196. Flankierend zeigt die METR-RCT (16 erfahrene OSS-Maintainer, reale Issues, Cursor + Claude 3.5/3.7): 19 % langsamer mit KI, bei gleichzeitiger Selbsteinschätzung „20 % schneller" — Selbstwahrnehmung ist als QS-Metrik wertlos; METR verweist für 2026 auf abweichende Ergebnisse mit neueren Modellen (nicht verifiziert) [V] metr.org.

Anthropics eigene Guidance ist damit konsistent und ehrlicher als das Marktumfeld: adversarialer Review-Subagent in frischem Kontext (sieht nur Diff + Kriterien, nicht die Entstehungsbegründung), aber mit ausdrücklicher Warnung vor Reviewer-Overfitting — ein auf „finde Lücken" geprompteter Reviewer findet immer welche; nur Correctness-relevante Findings gelten lassen, Rest optional [V] code.claude.com.

**Einordnung:** KI-Review als zusätzliche, eng gescopte Schicht (Security, Diff-vs-Plan-Abgleich): jetzt empfohlen. KI-Review als Ersatz menschlicher Freigabe: derzeit nicht belastbar. Hersteller-Effektivitätsclaims (Qodo u. ä.): überwiegend Marketing.

## 5. Das Selbstbestätigungsproblem: Tests, die nur die eigene Implementierung bestätigen

Das ist die zentrale Gefahr autonomer Entwicklung, und sie ist jetzt quantifiziert. SpecBench definiert die Reward-Hacking-Lücke Δ = Score(sichtbare Validierungstests) − Score(verdeckte Spezifikationstests) und findet über Frontier-Agenten (Codex, Claude Code u. a.) und Open-Weight-Modelle: Sichtbare Tests werden nahezu gesättigt, die verdeckte Performance divergiert stark; die 90.-Perzentil-Lücke wächst um ~27 pp pro Verzehnfachung der Codegröße, bei >25K LOC bis zu 100 pp. Bemerkenswert: Absichtliches Betrügen (etwa eine 2.900-Zeilen-Hash-Tabelle, die Testinputs memoriert — 97 % sichtbar, 0 % verdeckt) ist selten; ~65 % der Fälle sind Kompositionsfehler — Features bestehen isoliert, integrieren aber nicht. Mitigationen ernüchtern: Mehr sichtbare Tests wirken gemischt (mal −25 pp, mal +25 pp), längere Suche verschlimmert das Problem oft, stärkere Modelle reduzieren es nur [V] arxiv 2605.21384. Ergänzend existiert mit EvilGenie ein dediziertes Reward-Hacking-Benchmark [S], und Anthropic-Forschung verbindet Reward Hacking mit breiterer Misalignment-Dynamik [S].

Daraus ergibt sich ein belastbares Fünf-Elemente-Schema gegen Selbstbestätigung:

1. **Spezifikation als Testquelle.** Tests werden aus Spec/Akzeptanzkriterien abgeleitet, nie aus dem Implementierungs-Diff. (v4.0-Spezifikationspflicht bestätigt.)
2. **Red-first als Pflichtprotokoll.** Bugfix beginnt mit fehlschlagendem Repro-Test — so formuliert es auch Anthropics offizielle Doku („write a failing test that reproduces the issue, then fix it"); der Rot-Zustand gehört als Evidenz ins Run-Manifest [V] code.claude.com.
3. **Rollentrennung.** Test-Autor-Session ≠ Implementierer-Session (Anthropic empfiehlt explizit: „have one Claude write tests, then another write code to pass them"), plus Review-Subagent in frischem Kontext [V].
4. **Held-out-Abnahmetests.** Eine kleine, vom implementierenden Agenten nicht einsehbare Suite auf Spezifikationsebene (Integrationsszenarien, nicht Unit-Duplikate), ausgeführt nur in CI — die direkte SpecBench-Konsequenz und die wichtigste Neuerung gegenüber v4.0 [V].
5. **Mutation Testing als Stichproben-Audit.** Periodisch oder bei neuen agentengeschriebenen Suiten: Überlebende Mutanten sind der objektive Nachweis, ob Tests Verhalten prüfen oder nur Implementierung nachzeichnen (ACH/MUTGEN belegen Machbarkeit und Nutzen) [V].

Empirischer Kontext dazu: Die MSR-Analyse agentischer PRs zeigt, dass Test-Beiträge von Agenten über die Zeit häufiger werden, testhaltige PRs größer sind und länger dauern, bei ähnlichen Merge-Raten — Agenten liefern also zunehmend Tests mit, deren Wirksamkeit aber gerade deshalb geprüft werden muss [V] arxiv 2601.03556.

## 6. Autonome Testgenerierung und -ausführung: Möglichkeiten und Grenzen

Machbar und belegt: PBT-Generierung aus Code-Semantik (Anthropic-Agent), mutationsgeleitete Unit-Test-Generierung (ACH produktiv bei Meta, MUTGEN akademisch), E2E-Plan/Generierung/Heilung (Playwright Agents), schemagetriebenes API-Fuzzing (Schemathesis). Grenzen: (a) Die akademischen Resultate gelten überwiegend für isolierte Methoden — Übertrag auf gewachsene Codebasen ist offen (MUTGEN-Limitierung, SpecBench-Kompositionsbefund). (b) Äquivalente Mutanten und Coverage-Illusionen bleiben; LLM-Äquivalenzfilter helfen, sind aber nicht perfekt. (c) Orakelproblem: Autonom generierte Tests prüfen beobachtetes, nicht gefordertes Verhalten — ohne Spec oder Invariante bestätigen sie den Status quo. (d) Heil-Automatiken können Regressionen normalisieren. Autonomie ist also hoch bei Generierung und Ausführung, die Soll-Definition (Spec, Invarianten, Abnahme) bleibt beim Menschen.

## 7. Evidence Chain: von Anforderung bis Freigabe

Ziel: Jede Änderung beantwortet nachvollziehbar „welche Anforderung, welche Entscheidung, welcher Agent, welcher Diff, welcher Testlauf, welcher Review, welche Freigabe". Der 2026-Werkzeugkasten:

- **Identität und Verknüpfung:** Spec-/Issue-IDs in Branch/PR; Commit-Trailer mit Agentenkennung und Session-Link (Claude Code setzt `Co-Authored-By` + Session-URL bereits standardmäßig) — kostenlose, dauerhafte Provenance im Git-Log.
- **Evidenz statt Behauptung:** Anthropics Leitlinie „have Claude show evidence rather than asserting success" (Testausgabe, ausgeführtes Kommando, Screenshot) bestätigt das Run-Manifest-Konzept von v4.0 wörtlich [V] code.claude.com. Ein Run-Manifest je Arbeitsauftrag: Spec-Ref, Modell/Agent, Prompts-Referenz, Diff-Hash, Testlauf-Rohausgaben (inkl. Rot-Beweis), Review-Findings, Freigabestufe.
- **Neutrale Ausführung:** CI (GitHub Actions) als vom Agenten unabhängige Ausführungsinstanz; Logs/Artefakte mit Retention sind die fälschungsresistente Kopie der lokalen Behauptungen.
- **Artefakt-Provenance:** GitHub Artifact Attestations (in-toto/SLSA-Provenance, Sigstore-signiert, `gh attestation verify` vor Deploy) verbinden Artefakt kryptographisch mit Workflow + Commit — auch für private Repos [V] docs.github.com; Formatgrundlage SLSA v1.2 Provenance/VSA [V] slsa.dev.
- **Agenten-Telemetrie:** Die OpenTelemetry-GenAI-Semantikkonventionen sind in ein eigenes Repo ausgegliedert (Spans, Metriken, Events für GenAI-Clients und MCP; Schema 1.42.0) und weiter in Entwicklung [V] github.com/open-telemetry, opentelemetry.io. Für Konzernumgebungen der kommende Standard; im Privatkontext ersetzen Claude-Code-Session-Logs plus Run-Manifeste denselben Zweck mit einem Bruchteil des Aufwands — beobachten, Feldnamen bei Eigenformaten anlehnen (Zukunftskompatibilität).

**Angemessene Dreistufung für Privatprojekte:** Stufe 1 (alle Projekte): Commit-Trailer, PR-Beschreibung mit Testevidenz, CI-Pflichtlauf. Stufe 2 (A4/A5-Projekte mit Auto-Deploy): zusätzlich Run-Manifest als PR-Artefakt, Artifact Attestation + Verify-Gate im Deploy. Stufe 3 (nur bei Bedarf/Forschung): OTel-GenAI-Traces. Vollausbau (eigene Transparenzlogs, SLSA L3+) ist überdimensioniert.

## Konsequenzen für Andreas' Methodik und Projekte

1. **Held-out-Abnahmesuite einführen (wichtigste Änderung).** Je Projekt 5–20 Spezifikationstests auf Integrationsebene, die Implementierungs-Agenten nicht lesen (separates Verzeichnis mit Deny-Regel bzw. eigenes Repo, Ausführung nur in CI). Priorität: NFL-Plattform (vollautonomer Betrieb) und Datenplattformen mit Provenance-Invarianten. Begründung: SpecBench zeigt, dass sichtbare Tests als alleiniges Gate mit wachsender Codebasis systematisch versagen.
2. **Red-first und Rollentrennung von Empfehlung auf Protokollpflicht heben.** Ab Autoritätsstufe A3: fehlschlagender Test als dokumentierte Evidenz im Run-Manifest; Test-Autor- und Implementierer-Session getrennt; adversarialer Review-Subagent mit engem Auftrag („nur Correctness/Scope, keine Stilfindings" — beugt dem belegten Reviewer-Overfitting und Over-Engineering vor).
3. **Mutation Testing als Quartals-Audit, nicht als Gate.** mutmut/cosmic-ray auf 1–2 kritische Module pro Projektzyklus, zwingend nach Abnahme großer agentengeschriebener Testsuiten; Ergebnis (Mutation Score, überlebende Mutanten) ins Manifest. Windows-Lauffähigkeit vorab prüfen, sonst in CI (Linux) ausführen.
4. **PBT und Schemathesis als Standardbausteine.** Hypothesis-Invarianten für Parser, Datenpipelines, Ontologie-Konsistenz (Roundtrips, Idempotenz, Referenzintegrität); Schemathesis-Lauf gegen jede FastAPI-OpenAPI in CI. Beides ist agentenfreundlich generierbar und minimiert Selbstbestätigung strukturell.
5. **KI-Review realistisch verankern.** `/security-review` bzw. die Anthropic-Security-Action für exponierte Dienste (Cloudflare-Tunnel-Endpunkte) in CI; generisches KI-Review nur als Vorfilter. Menschliche Freigabe bleibt an Autoritätsstufen gekoppelt — die MSR-Evidenz stützt exakt das v4.0-Design. Prompt-Injection-Hinweis der Action beachten (bei Fremd-PRs irrelevant, solange Repos privat sind).
6. **Statik-Stack konsolidieren:** Ruff + pyright als Gate (Hooks lokal, CI hart); ty im Auge behalten und bei einem kleinen Projekt pilotieren. Stop-Hook-Override (8 Blocks) in der Methodik dokumentieren: lokale Gates beschleunigen, CI entscheidet.
7. **Supply Chain pragmatisch:** Lockfile-Pinning überall; osv-scanner pre-deploy und wöchentlich; Agenten installieren Dependencies nie direkt, sondern via eigenem PR. CycloneDX-SBOM als Pilot in der Auto-Deploy-Pipeline; `gh attestation verify` als Deploy-Gate der NFL-Plattform (SLSA Build L2 praktisch geschenkt).
8. **Accessibility zweigeteilt:** axe-core in Playwright (deckt ~57 % des Issue-Volumens), manuelle Tastatur-/Screenreader-Checks als explizite menschliche Abnahmeaufgabe je UI-Release — relevant auch für die offene BFSG-Entscheidung (E5).
9. **Flaky-Politik festschreiben:** Quarantäne mit Ursachenklassifikation; Agenten dürfen Tests nicht eigenmächtig abschwächen; Playwright-Healer nur für Selektor-/Timing-Reparaturen, Verhaltensänderungen mit menschlicher Bestätigung.
10. **Metrikdisziplin:** Wirkung von KI-Maßnahmen ausschließlich über Artefakte messen (Durchlaufzeit, Defekt-Escape, Mutation-Stichproben, Rework-Quote), nie über gefühlte Beschleunigung (METR-Wahrnehmungslücke).

## Bewertungstabelle

| Methode/Technologie | Einordnung | Kurzbegründung |
|---|---|---|
| Ruff + pyright als Agenten-Gate | jetzt empfohlen | schnellstes deterministisches Verifikationssignal |
| ty / Pyrefly (Rust-Typechecker) | beobachten | jung; Geschwindigkeit attraktiv, Vollständigkeit offen |
| Hypothesis-PBT (+ agentische Generierung) | jetzt empfohlen | Anthropic-Evidenz; strukturell gegen Selbstbestätigung |
| Schemathesis gegen FastAPI-OpenAPI | jetzt empfohlen | hoher Nutzen, minimaler Aufwand, agentenfreundlich |
| Pact / Consumer-driven Contracts | überdimensioniert | kein Multi-Team-Kontext |
| Mutation Testing als Stichproben-Audit | jetzt empfohlen | einziger objektiver Testwirksamkeitsnachweis; ACH/MUTGEN |
| Mutation Testing als flächiges CI-Gate | überdimensioniert | Laufzeit/Äquivalenzmutanten im Privatkontext |
| Held-out-Abnahmetests (agentenunsichtbar) | jetzt empfohlen | direkte SpecBench-Konsequenz |
| Playwright Test Agents (Planner/Generator/Healer) | pilotgeeignet | offiziell, Claude-Code-integriert; Healer-Risiko steuern |
| Visuelle Regression via Playwright-Snapshots | sinnvoll unter Bedingungen | Plattform-Konsistenz der Baselines nötig |
| Cloud-Visual-Testing (Chromatic u. ä.) | überdimensioniert | Kosten/Nutzen im Privatkontext |
| axe-core-A11y in CI | jetzt empfohlen | ~57 % Issue-Volumen automatisierbar (Deque) |
| KI-Code-Review eng gescopt (Security/Plan-Abgleich) | jetzt empfohlen | MSR-Evidenz für Zusatzschicht mit engem Auftrag |
| KI-Review als Ersatz menschlicher Freigabe | derzeit nicht belastbar | −23 pp Merge-Rate, hoher Rauschanteil (MSR 2026) |
| Hersteller-Claims zu Review-Autonomie | überwiegend Marketing | Qodo-Claim empirisch widerlegt |
| Lockfile-Pinning + osv-scanner/pip-audit | jetzt empfohlen | geringer Aufwand, deckt Hauptrisiken inkl. Agent-Installationen |
| CycloneDX-SBOM | pilotgeeignet | ein CI-Schritt; Eigenwert ohne Konsumenten begrenzt |
| GitHub Artifact Attestations als Deploy-Gate | sinnvoll unter Bedingungen | bei Auto-Deploy (A4/A5) starker Integritätsgewinn |
| OTel-GenAI-Traces für Agenten | beobachten | Standard reift; Session-Logs + Manifeste reichen privat |
| Eigene Sigstore/Rekor-Infrastruktur, SLSA L3+ | überdimensioniert | Enterprise-Aufwand ohne privaten Mehrwert |

## Quellenverzeichnis

**[V] — selbst abgerufen und geprüft am 2026-07-28**

1. Anthropic, „Claude Code Best Practices" — code.claude.com/docs/en/best-practices (Verifikations-Checks, Stop-Hooks inkl. 8-Block-Override, Writer/Reviewer, adversarialer Review, Evidenzpflicht)
2. Anthropic Frontier Red Team, „Property-based testing" — red.anthropic.com/2026/property-based-testing (PBT-Agent, 984 Reports, 56 %/86 % Validität)
3. Meta Engineering, „LLMs Are the Key to Mutation Testing and Better Compliance" (ACH) — engineering.fb.com, 2025-09-30 (73 % Akzeptanz, Äquivalenzerkennung)
4. Wang, Xu, Briand, Liu, „Mutation-Guided Unit Test Generation with a Large Language Model" (MUTGEN) — arxiv.org/abs/2506.02954 (HTML v2)
5. „From Industry Claims to Empirical Reality: An Empirical Study of Code Review Agents in Pull Requests" — arxiv.org/html/2604.03196v1 (MSR 2026; Merge-Raten, Signal/Noise, Adressierungsquoten)
6. Haque, Ingale, Csallner, „Do Autonomous Agents Contribute Test Code?" — arxiv.org/abs/2601.03556 (MSR 2026)
7. „SpecBench: Measuring Reward Hacking in Long-Horizon Coding Agents" — arxiv.org/html/2605.21384v1 (Validation-vs-Held-out-Gap, Mitigationsbefunde)
8. METR, „Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity" — metr.org/blog/2025-07-10 (RCT, −19 %, Wahrnehmungslücke)
9. Playwright, „Test Agents" — playwright.dev/docs/test-agents (Planner/Generator/Healer, Loop-Integrationen)
10. Anthropic, claude-code-security-review — github.com/anthropics/claude-code-security-review (Diff-aware, FP-Filter, Prompt-Injection-Warnung)
11. SLSA, Spezifikation v1.2 — slsa.dev/spec/v1.2/ (Status Approved, Build-/Source-Track, Provenance/VSA)
12. GitHub Docs, „Artifact attestations" — docs.github.com (SLSA Build L2/L3, Sigstore, private Repos, gh attestation verify)
13. OpenTelemetry, semantic-conventions-genai — github.com/open-telemetry/semantic-conventions-genai (Spans/Metriken/Events, MCP, Schema 1.42.0)
14. OpenTelemetry Docs, GenAI-SemConv-Umzugshinweis — opentelemetry.io/docs/specs/semconv/gen-ai/
15. Deque, „Automated accessibility testing coverage" — deque.com (57,38 % Issue-Volumen, 13k Seiten)

**[S] — über Suchergebnisse belegt**

16. MSR 2026 Mining Challenge, weitere Studien (Developer Interventions, Failed Agentic PRs, Merge/Reject-Gründe) — 2026.msrconf.org
17. „EvilGenie: A Reward Hacking Benchmark" — arxiv.org/pdf/2511.21654 / futuretech.mit.edu
18. Anthropic-Forschung zu Reward Hacking und Misalignment — Sekundärbericht blockchain.news
19. Typechecker-Vergleiche mypy/pyright/ty/Pyrefly — danilchenko.dev, pydevtools.com, codegym.cc
20. Hypothesis — hypothesis.works
21. Schemathesis — schemathesis.io; Fallbericht buttondown.com „Turning our OpenAPI schema into a bug finder"
22. Python-Mutation-Tools (mutmut, cosmic-ray) und Stryker — dev.to, dl.acm.org (SBQS-Vergleich), qaskills.sh
23. Supply-Chain-Guides: bernat.tech „Securing Python Supply Chain"; SCA-Tool-Vergleiche appsecsanta.com, tomodahinata.com; CycloneDX Tool Center — cyclonedx.org
24. GitHub Copilot Autofix — docs.github.com (Responsible use), github.blog Changelog 2025-02-20
25. Sigstore Blog, „cosign Verification of npm Provenance, GitHub Artifact Attestations" — blog.sigstore.dev
26. Playwright-Visual-Regression- und MCP-Guides — bug0.com, qaskills.sh, testdino.com, lastest.cloud
27. Flaky-Test-Quarantäne-Praxis — mergify.com, testdino.com Benchmark, scrolltest.com
28. Qodo 2025 State-of-AI-Code-Quality-Claim (zitiert und geprüft in Quelle 5)
29. AI-Audit-Trail-Praxisartikel (EU-AI-Act-Kontext, MCP-Gateway-Ansätze) — codacy.com, mintmcp.com, cycode.com
30. OTel-GenAI-Sekundärüberblicke — greptime.com, webhani.com
