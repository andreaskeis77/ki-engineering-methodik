# Softwarearchitektur für kleine, agentenfreundliche Systeme

Stand: 2026-07-28. Quellenstatus-Konvention: [V] = URL am 2026-07-28 selbst abgerufen und inhaltlich geprüft; [S] = nur über Suchergebnisse belegt. Bewertungsmaßstab: professionell ohne Enterprise-Overhead, lokal/privat betreibbar, agentenfreundlich, reproduzierbar, auditierbar.

## Executive Summary

Der wichtigste Befund 2025/2026: Agentenfreundliche Architektur ist zu etwa 80 Prozent identisch mit guter, menschenfreundlicher Architektur – aber mit verschobenen Prioritäten. Was für Menschen "nice to have" war (Greppability, Ein-Kommando-Verifikation, kolokalisierte Doku, strenge Typisierung, konventionelle Struktur), wird für Agenten zum harten Leistungsfaktor, weil ihr Produktivitätsdeckel durch Kontext und Feedbackqualität gesetzt wird, nicht durch Modellqualität. Für die Makroarchitektur kleiner Teams ist der modulare Monolith unverändert Konsens-Default; Microservices lohnen erst ab Organisationsgröße (50+ Entwickler) und sind im Privatkontext überdimensioniert – die Agenten-Ära ändert daran nichts, weil ein Solo-Architekt mit Agenten organisatorisch weiterhin "ein Team, ein Deployable" ist. Als Innenarchitektur setzt sich die pragmatische Kombination durch: Vertical Slices als Ordnungsprinzip, Hexagonal light (Ports nur an volatilen Rändern), DDD light (Bounded Contexts, Domänensprache, sparsame Aggregate) – statt vollem Clean-Architecture-Schichtenzeremoniell. Die SE-3.0-Forschung (SASE-Paper) formalisiert "SE for Agents" mit strukturierten Artefakten (BriefingScripts, Merge-Readiness-Packs, Mentorship-as-Code) und bestätigt damit zentrale Elemente von Andreas' Methodik v4.0 (Spezifikationspflicht, Run-Manifeste, hermetische Gates) fast eins zu eins. Event-Streaming-Infrastruktur (Kafka) ist für den Privatkontext klar überdimensioniert; DB-basierte Queues und das Outbox-Muster auf SQLite/Postgres genügen. Local-first/Offline-first ist selektiv produktionsreif geworden (PowerSync, Yjs; ElectricSQL mit Restkanten; Zero/Triplit beobachten), lohnt aber nur für nutzergenerierte Daten mit Offline-Bedarf – nicht für servergenerierte Wissensplattformen. PWAs tragen auf Android/Desktop gut, bleiben auf iOS strukturell limitiert (kein Background Sync, fragile Storage); für den Mobile Companion bleibt Expo richtig. Serverseitiges SQLite plus Streaming-Backup (Litestream) ist als "Renaissance"-Muster für Ein-Server-Betrieb etabliert und passt exakt zu Andreas' VPS-Setup. Neu aufzunehmen in die Methodik: Architektur-Fitness-Functions als deterministische Gates gegen "Codebase Cognitive Debt" sowie eine explizite Agentenfreundlichkeits-Checkliste je Repo.

## 1. Makroarchitektur: Modularer Monolith als Default

Die Datenlage 2025 ist ungewöhnlich einhellig. Branchenübersichten nennen als Faustregel: 1–10 Entwickler klassischer Monolith, 10–50 modularer Monolith, erst ab ~50 Entwicklern rechtfertigen unabhängige Deployments und Fault-Isolation den Microservices-Overhead; prominente Rückbauten (Amazon Prime Video, Shopifys "modular monolith") stützen das ([V] Java Code Geeks 2025). Fowlers "MonolithFirst" (2015) bleibt die zeitlose Begründung: Servicegrenzen sind anfangs unbekannt, und Refactoring über Servicegrenzen ist um Größenordnungen teurer als im Monolith ([V] martinfowler.com).

Verändert die Agenten-Ära diese Rechnung? Teilweise, aber nicht in Richtung Microservices. Sourcegraphs Praxisleitfaden zeigt: Agenten scheitern vor allem an *Sichtbarkeit* – "a model can only reason about code it can see"; Cross-Cutting-Änderungen über Repo-Grenzen (Auth-Middleware, DTOs, Migrationsskripte, Frontend-Guards) sind der dominante Fehlerfall ([V] Sourcegraph 2026). Verteilte Systeme vervielfachen genau diese Blindstellen. Ein modularer Monolith in einem Repo maximiert dagegen deterministische Suche (grep statt Embeddings) und hält den Gesamtzusammenhang in Agentenreichweite. Ein Einzelautor (Reilly) plädiert zwar für "lots of tiny CLIs" statt Monolithen ([V] actuallymaybe.com 2026-01) – sein eigentlicher Kern ist aber der "Editor-Navigation-Test": Was Menschen leicht navigieren, navigieren Agenten leicht. Das erreicht ein sauber modularisierter Monolith ebenso, ohne verteilte Betriebskomplexität. Position: Für alle 11 Projekte gilt "ein Repo, ein Deployable, erzwungene Modulgrenzen"; Prozess-Trennung nur, wo Betriebsrealität sie erzwingt (Edge-Kollektor getrennt vom Server ist Topologie, keine Microservices-Architektur).

## 2. Innenarchitektur: Vertical Slice + Hexagonal light + DDD light

Der Streit "Clean Architecture vs. Vertical Slice" hat sich 2025 pragmatisch aufgelöst: nicht entweder/oder, sondern Slices als Ordnungsprinzip mit selektiven Ports. Der Vergleich von nadirbad.dev arbeitet das Kohäsionsproblem der Schichtenarchitektur heraus (ein Feature-Change berührt vier Schichten) und empfiehlt Hybridformen je Kontext ([V]). Die präziseste Synthese liefert "Domain Boundaries Without Ceremony" (2025-10): Vertical Slices organisieren nach Business-Fähigkeit, Hexagonal liefert austauschbare Adapter *nur für Abhängigkeiten, deren Wechsel realistisch ist*, DDD light behält Aggregate/Invarianten, Bounded Contexts als Modulgrenzen, Domänensprache und Domain-Events – und streicht Event-Storming-Zeremonien und Strategieworkshops. Motto: "Keep domain pure, feedback loops fast, adapters swappable" ([V] developersvoice.com).

Agentenrelevanz: Slices sind für Agenten ideal, weil eine Aufgabe ("Feature X ändern") auf einen kolokalisierten Ordner abbildet – minimaler Kontext, minimale Cross-File-Navigation, natürliche Einheit für Worktree-Parallelität und Verifikationsbandbreite. Ports/Fakes liefern die Testnähte, die hermetische Gates ohne Netz und ohne Docker erlauben. Die im Artikel empfohlene Testpyramide (70–80 % Mikro-Unit auf Domänenlogik, Slice-Tests mit In-Memory-Adaptern, wenige Integrationstests; Gesamtsuite unter einer Minute) ist exakt das deterministische Schnell-Feedback, das Agenten-Loops brauchen. Volle Clean Architecture (vier Schichten, Interfaces überall) ist im Privatkontext Zeremonie ohne Gegenwert und verschlechtert sogar die Greppability (Indirektion).

Ein realer Dissens verdient Erwähnung: Thoughtworks zählt DRY zu den AI-freundlichen Eigenschaften ([V] Radar "AI-friendly code design", Assess, 2025), während das SASE-Paper argumentiert, für Agenten kehre sich das teils um – Duplikation "simplifies its reasoning process", während Compile-Time-Sicherheit kritisch wird ([V] arXiv 2509.06216). Vernünftige Mittelposition: DRY strikt für Domäneninvarianten und Konstanten (Greppability!), tolerierte Duplikation in Tests und Slice-lokalem Glue-Code.

## 3. Was Architektur agentenfreundlich macht

Aus den Primärquellen lässt sich ein konsistentes Eigenschaftsbündel destillieren:

**a) Deterministische, schnelle Feedbackzyklen als erstes Architekturkriterium.** Anthropics offizielle Best Practices stellen "Give Claude a way to verify its work" an die Spitze: Tests, Build-Exit-Codes, Linter, Diff-gegen-Fixture, Screenshots – eskalierbar vom Prompt über Stop-Hooks (deterministische Gates) bis zum adversarialen Review-Subagenten ([V] code.claude.com). Das SASE-Paper fordert "expressive feedback" (Vorbild Rust-Compiler) und mehrstufige Verifikation direkt im Auftrag ([V]). Architektonisch heißt das: Jedes Repo braucht ein Ein-Kommando-Verify (`task verify` o. ä.), das schnell, hermetisch und aussagekräftig scheitert. Feedbackgeschwindigkeit ist damit ein *Architektur*-Attribut, kein CI-Detail – sie diktiert Modulgröße, Fake-Strategie und Datenbankwahl (SQLite in-memory statt Container).

**b) Der ACI-Gedanke, verallgemeinert auf die eigene Codebasis.** Anthropics SWE-bench-Arbeit zeigt die Prinzipien guter Agent-Computer-Interfaces: Fehlerklassen konstruktiv ausschließen (absolute Pfade erzwingen), Mutationen nur bei eindeutiger Spezifikation (exakter String-Match), enge THOUGHT→ACTION→OBSERVATION-Loops, minimales Scaffolding ([V] anthropic.com/research/swe-bench-sonnet). Übertragen: Die eigene Codebasis *ist* das ACI des Agenten. Interne CLIs mit klaren Exit-Codes und präzisen Fehlermeldungen, idempotente Skripte, eindeutige Namenskonventionen und Guardrails via Hooks/Linter sind Interface-Design für den Hauptnutzer "Agent". Dieselbe Linie verfolgt "Writing effective tools for agents" ([S] anthropic.com/engineering).

**c) Greppability und konventionelle Struktur.** Die konkreten Praktiken ([V] morizbuesing.com): keine dynamisch konstruierten Bezeichner (String-Konkatenation von Tabellen-/Keynamen), konsistentes Naming über den ganzen Stack (kein snake_case↔camelCase-Mapping an Grenzen), flache statt tief verschachtelte Strukturen. Für Agenten, deren primäres Navigationswerkzeug wörtliche Suche ist, ist das unmittelbar leistungswirksam; Sourcegraph bestätigt deterministische Suche als Fundament ([V]). Dazu kommt Konventionalität: Framework-Standardlayouts (Django-Apps, FastAPI-Router-Struktur, Astro-Projektlayout) sind massiv im Trainingsmaterial vertreten – Eigenwilligkeit kostet Agentenleistung.

**d) Kolokalisierte, maschinenlesbare Doku.** CLAUDE.md (kurz, geprüft, hierarchisch: Root plus Child-Verzeichnisse in Monorepos, Imports via `@pfad`) ist der etablierte Mechanismus ([V] code.claude.com); AGENTS.md ist als offener Standard mit 60k+ Projekten unter der Linux Foundation (Agentic AI Foundation) breit adoptiert ([V] agents.md). ADRs erleben als "architektonisches Gedächtnis für Agenten" eine Renaissance – Entscheidungen mit Begründung im Repo verhindern, dass Agenten getroffene Entscheidungen wieder aufreißen ([S] actual.ai, ai.gopubby.com). Thoughtworks' "Codebase Cognitive Debt" (Radar Vol. 34, 2026) benennt die Gegenkraft: Wenn Agenten-Output das Teamverständnis überholt, kippen Systeme; Gegenmittel sind Feedback-Sensoren, Fitness-Functions und bewahrte Entscheidungsdokumentation ([V]).

**e) Typisierung und erzwungene Grenzen.** Statische Typen (TypeScript strict, mypy/pyright) verhindern Fehlerklassen "by construction" – von Reilly, SASE und Thoughtworks gleichlautend betont ([V]×3). Modulgrenzen müssen *maschinell* erzwungen werden (import-linter/tach für Python, dependency-cruiser für TS), sonst erodieren sie unter hochfrequenten Agenten-Änderungen; das ist die konkrete Form der von Thoughtworks geforderten Architektur-Fitness-Functions.

**f) SE-3.0-Forschungsrahmen.** Das AIDev-Datensatz-Paper (arXiv 2507.15003) belegt empirisch: Agenten-PRs sind schneller, strukturell einfacher, werden aber seltener akzeptiert ("Trust-Utility-Gap") – Governance und Evidenz, nicht Fähigkeit, sind der Engpass ([V]). Das SASE-Paper (arXiv 2509.06216) liefert das Vokabular: SE4H vs. SE4A, BriefingScripts (Auftrag mit Erfolgskriterien und Gotchas), LoopScripts (deklarative Workflows), MentorScripts (Mentorship-as-Code ≈ CLAUDE.md), Consultation Request Packs (Eskalation) und Merge-Readiness-Packs (Evidenzbündel: Tests, Statik, Benchmarks, Auditierbarkeit) ([V]). Bewertung: Forschungsroadmap, kein Werkzeug – aber die stärkste externe Validierung von Andreas' v4.0-Bausteinen (Spezifikationspflicht ≈ BriefingScript, Run-Manifest ≈ MRP, Autoritätsstufen ≈ CRP-Eskalationslogik).

## 4. Event-driven, API-first, BFF – in kleiner Dosis

**Event-driven:** Morlings vielbeachtete Analyse (2025-11) rehabilitiert Kafka für echte Streaming-Fälle, bestätigt aber zugleich: Als Job-Queue im Kleinen ist Postgres (mit pgmq statt Eigenbau) legitim; Kafkas Mehrwert liegt in Log-Semantik, Consumer-Groups, Konnektoren und Cluster-Fault-Tolerance – nichts davon braucht ein Privatsystem ([V] morling.dev). Für Andreas: In-Process-Domain-Events plus Outbox-Tabelle und ein DB-basierter Worker (SQLite: eigene Jobs-Tabelle mit `BEGIN IMMEDIATE`; Postgres: `SELECT ... FOR UPDATE SKIP LOCKED` oder pgmq) decken alles ab – auditierbar, wiederherstellbar, agentenfreundlich, weil Zustand per SQL inspizierbar. Broker-Infrastruktur: überdimensioniert.

**API-first/Contract-first:** Gewinnt durch Agenten neu an Wert: Eine OpenAPI-Spezifikation ist ein maschinenprüfbarer Vertrag, gegen den Agenten generieren und testen können – Spec-driven Development konvergiert hier mit Contract-first ([S] Augment Code, Java Code Geeks 2026). FastAPI liefert OpenAPI code-first "gratis"; entscheidend ist, das Schema als Artefakt einzufrieren (Snapshot-Test gegen Drift) und typisierte Clients daraus zu generieren, sobald ein zweiter Konsument existiert (Mobile Companion). Volles Design-first-Zeremoniell (Stoplight-Governance etc.) ist Enterprise-Overhead.

**BFF:** Klare Praxisregel ([V] marmelab 2025-10): Bei einem einzigen Frontend, kleinen Teams und flexibler API ist ein separates BFF Overkill; ein BFF, das Businesslogik ansammelt, ist ein Anti-Pattern. Legitim bleibt das *Muster in Dünnform* für Token-Handling (OAuth-Secrets nie im Browser/Client – GitGuardian-Argument [S]) – bei Astro/FastAPI erledigen das serverseitige Routen im selben Deployable; Sam Newmans Original-Kontext (mehrere Client-Teams) liegt nicht vor ([S] samnewman.io, Microsoft Azure Architecture Center).

## 5. Client-Seite: PWA, Offline-first, Synchronisierung

**PWA:** Auf Android/Desktop tragfähig (Installation, Service Worker, Push, Badges). Auf iOS bleiben strukturelle Grenzen: Push nur nach Home-Screen-Installation (Reichweite ~10–15× kleiner als nativ), kein Background-Sync-API, Storage kann unter Druck evakuiert werden, kein App-Store-Listing, kein Web-Bluetooth/NFC; der DMA-Rückzieher 2024 zeigt das Plattformrisiko ([V] MobiLoud 2026). Konsequenz: PWA ist der richtige Default für Andreas' Heimnetz-Dashboards und Webprodukte (auch am iPhone als "installierte Website" nutzbar), aber nichts, worauf iOS-kritische Funktionen (zuverlässige Notifications, Offline-Garantien) gebaut werden.

**Local-first/Offline-first:** Die Ink&Switch-Ideale (7 Ideals, CRDTs; 2019) bleiben der konzeptionelle Anker ([V] inkandswitch.com). Der Praxisstand 2026 ([V] Smashing Magazine 2026-05): Client-seitiges SQLite via WASM/OPFS ist Standardbaustein; produktionsreif sind Yjs, Automerge und PowerSync (Postgres↔SQLite-Sync), ElectricSQL hat noch "rough edges", Zero und Triplit sind beobachten. Konflikte: feldweises Last-Write-Wins genügt meist; semantische Konflikte serverseitig validieren. Entscheidend ist die Eignungsmatrix: Local-first lohnt für nutzergenerierte Daten mit Offline-/Kollaborationsbedarf – *nicht* für servergenerierte Daten (Feeds, Analytik, Wissensplattformen), nicht für einfache CRUD-Panels, nicht bei strenger Konsistenz. Kosten sind real: Schema-Migrationen über Geräteflotte, ~400 KB Bundle, erschwertes Testen. Für den Mobile Companion heißt das: lokale SQLite (expo-sqlite) als primärer Store, Sync je nach Anspruch als simples Pull/Push mit LWW-Timestamps (selbst gebaut, auditierbar) oder als PowerSync-Pilot; CRDT-Bibliotheken nur bei echter Mehrgeräte-Kollaboration.

## 6. Lokale und hybride Betriebsarchitektur

**SQLite serverseitig** ist als seriöses Produktionsmuster etabliert ("SQLite-Renaissance": WAL-Modus, Litestream-Streaming-Backup auf S3-kompatiblen Speicher, LiteFS/libSQL als Optionen) und passt ideal zu Ein-Server-Betrieb mit Wiederherstellbarkeitsanspruch: Restore = Binärdatei zurückspielen, Point-in-time via Litestream ([S] mehrere 2025/2026-Quellen, u. a. onidel.com, matthewswong.com). Postgres bleibt richtig, wo Concurrent Writes, pgvector oder mehrere Dienste auf denselben Daten zugreifen; DuckDB für analytische Workloads (NFL-Statistik) – die Drei-DB-Strategie ist zeitgemäß, kein Sonderweg.

**Sensorik/Edge:** Das kanonische Muster ist Store-and-Forward: Messwerte am Edge in lokale SQLite-Puffer schreiben, bei Konnektivität idempotent nachliefern; MQTT als Transport, Persistenz in Postgres/Timescale oder Parquet/DuckDB ([S] FlowFuse 2025, TigerData). Architektonisch: ein hexagonaler Port "Transport" (MQTT heute, HTTP fallback), Idempotenzschlüssel (device_id, timestamp), Uhren nie als Ordnungsgarantie. Das ist zugleich maximal agentenfreundlich: Jede Stufe ist als CLI mit Fixture-Dateien testbar.

## Konsequenzen für Andreas' Methodik und Projekte

1. **Architektur-Default kodifizieren:** "Modularer Monolith, ein Repo, Vertical Slices, Hexagonal light an volatilen Rändern, DDD light nur wo Domänenkomplexität real ist." Microservices, Kafka, volle Clean Architecture und separate BFF-Dienste explizit als Nicht-Defaults mit Begründung führen (verhindert, dass Agenten sie aus Trainingsdaten-Gewohnheit einführen). Begründung: Abschnitte 1–2, 4.

2. **Agentenfreundlichkeits-Checkliste als Definition-of-Ready je Repo** (neu in v4.x): (a) Ein-Kommando-Verify < 60 s, hermetisch; (b) Greppability-Regeln (keine dynamischen Bezeichner, ein Naming über den Stack, flache Struktur); (c) CLAUDE.md kurz + Child-CLAUDE.md je Modul, zusätzlich AGENTS.md als Standard-Einstieg für Fremd-Agenten; (d) ADRs unter `docs/adr/` als Pflichtartefakt bei Architekturentscheidungen; (e) strict typing (mypy/pyright, TS strict); (f) Modulgrenzen maschinell erzwungen (import-linter/tach bzw. dependency-cruiser) als hermetisches Gate – das ist die konkrete Umsetzung der Thoughtworks-Fitness-Functions und die Versicherung gegen Cognitive Debt.

3. **Slices als Einheit der Verifikationsbandbreite:** WIP-Limit und Worktree-Parallelität an Slice-Grenzen koppeln (ein Agent, ein Slice, ein Worktree). Das operationalisiert Sourcegraphs Befund zur Cross-Cutting-Blindheit: Cross-Slice-Änderungen sind als solche zu deklarieren und bekommen erhöhte Review-Autoritätsstufe.

4. **Archetyp-Defaults:**
   - *Interaktive Privatprodukte:* Django/FastAPI-Monolith oder Astro mit Server-Routen; SQLite+Litestream; PWA-Manifest ja, iOS-kritische Features nein; kein BFF.
   - *Daten-/Wissensplattform (NFL, Ontologien):* DDD light ernsthaft anwenden – Bounded Contexts Ingestion / Ontologie / Provenance / Serving als erzwungene Module; Pipelines als idempotente, einzeln per CLI ausführbare Stufen; Contract-first am Serving-API (OpenAPI-Snapshot-Gate); kein Local-first (servergenerierte Daten).
   - *Sensorik/Edge:* Store-and-Forward mit SQLite-Puffer, MQTT-Port, idempotente Ingestion; Kollektor als eigenes Deployable (Topologie, nicht Microservice).
   - *Mobile Companion (Expo):* Offline-first mit expo-sqlite; Sync zunächst selbstgebaut (Pull/Push, feldweises LWW, Server validiert semantisch), PowerSync als Pilot, sobald Mehrgeräte-Sync real wird; dünne Token-Handling-Route im bestehenden Backend statt BFF-Dienst.
   - *Infrastruktur-Transformation:* CLI-first (PowerShell-Module mit sauberen Exit-Codes und `-WhatIf`) – CLIs sind das beste ACI.

5. **v4.0-Validierung festhalten:** Spezifikationspflicht, Run-Manifeste und Autoritätsstufen entsprechen strukturell BriefingScripts, Merge-Readiness-Packs und CRP-Eskalation aus der SASE-Forschung – kein Umbau nötig, nur Begriffs-Mapping dokumentieren. Ergänzenswert aus derselben Quelle: Evidenzpflicht im Run-Manifest ausweiten (Testoutput, Statik-Report, ggf. Screenshot) und "Mentorship-as-Code" als Review-Kriterium für CLAUDE.md-Qualität.

6. **DRY-Politik präzisieren:** DRY hart für Domäneninvarianten/Konstanten, tolerierte Duplikation in Tests und Slice-Glue – dokumentiert als bewusste Regel, damit Agenten-Reviews nicht gegenläufig "refaktorisieren".

## Bewertungstabelle

| Methode/Technologie | Bewertung | Kurzbegründung |
|---|---|---|
| Modularer Monolith (erzwungene Grenzen) | jetzt empfohlen | Konsens für kleine Teams; maximiert Agenten-Sichtbarkeit |
| Microservices | überdimensioniert für Privatkontext | Lohnt ab ~50 Entwicklern; vervielfacht Agenten-Blindstellen |
| Vertical Slice Architecture | jetzt empfohlen | Kolokalisierter Kontext, natürliche Agenten-/WIP-Einheit |
| Clean Architecture (voll) | überdimensioniert für Privatkontext | Zeremonie/Indirektion ohne Gegenwert, schadet Greppability |
| Hexagonal light (selektive Ports) | jetzt empfohlen | Testnähte für hermetische Gates; nur an volatilen Rändern |
| DDD light (Contexts, Sprache, Aggregate) | sinnvoll unter Bedingungen | Voll lohnend bei Datenplattform; sonst minimal dosieren |
| Event-driven via DB-Queue/Outbox (SQLite/Postgres, pgmq) | jetzt empfohlen (bei Bedarf) | Auditierbar, wiederherstellbar, SQL-inspizierbar |
| Kafka/Broker-Infrastruktur | überdimensioniert für Privatkontext | Mehrwert (Consumer-Groups, Log-Retention) ungenutzt |
| API-/Contract-first (OpenAPI als geprüftes Artefakt) | jetzt empfohlen | Maschinenprüfbarer Vertrag für Agenten; FastAPI liefert Basis gratis |
| BFF als eigener Dienst | überdimensioniert für Privatkontext | Nur bei mehreren Client-Teams; Dünnform im Monolith genügt |
| PWA (Android/Desktop-Fokus) | sinnvoll unter Bedingungen | Stark auf Android/Desktop; iOS strukturell limitiert |
| Local-first Sync-Engine (PowerSync) | pilotgeeignet | Produktionsreif laut Praxisberichten; nur für Mobile Companion relevant |
| ElectricSQL | beobachten | Vielversprechend, dokumentierte Restkanten (Anf. 2026) |
| Zero, Triplit | beobachten | Zu wenig Produktionsvalidierung |
| CRDT-Bibliotheken (Yjs/Automerge) | sinnvoll unter Bedingungen | Nur bei echter Mehrgeräte-Kollaboration |
| Greppability-Regeln, Ein-Kommando-Verify, CLAUDE.md/AGENTS.md, ADRs | jetzt empfohlen | Direkt leistungswirksam für Agenten, geringe Kosten |
| Architektur-Fitness-Functions (import-linter u. ä.) | jetzt empfohlen | Deterministischer Schutz der Modulgrenzen gegen Agenten-Drift |
| SASE-Artefakte formal (BriefingScript/MRP-Terminologie) | beobachten | Forschungsroadmap; Kern in v4.0 bereits abgedeckt |
| SQLite + Litestream serverseitig | jetzt empfohlen | Etabliertes Muster; ideale Wiederherstellbarkeit auf eigenem VPS |
| MQTT + Store-and-Forward (SQLite-Puffer) | jetzt empfohlen | Kanonisches Edge-Muster, offline-robust, CLI-testbar |

## Quellenverzeichnis

1. [V] Anthropic, "Raising the bar on SWE-bench Verified with Claude 3.5 Sonnet" (ACI-Prinzipien), anthropic.com/research/swe-bench-sonnet, abgerufen 2026-07-28.
2. [V] Anthropic, "Best practices for Claude Code", code.claude.com/docs/en/best-practices, abgerufen 2026-07-28.
3. [V] Hao Li et al., "The Rise of AI Teammates in SE 3.0" (AIDev-Datensatz), arxiv.org/abs/2507.15003, abgerufen 2026-07-28.
4. [V] A. Hassan et al., "Agentic Software Engineering: Foundational Pillars and a Research Roadmap" (SASE), arxiv.org/html/2509.06216v1, abgerufen 2026-07-28.
5. [V] Thoughtworks Technology Radar, "AI-friendly code design" (Assess), thoughtworks.com/radar/techniques/ai-friendly-code-design, abgerufen 2026-07-28.
6. [V] Thoughtworks Technology Radar Vol. 34, "Codebase cognitive debt", thoughtworks.com/radar/techniques/codebase-cognitive-debt, abgerufen 2026-07-28.
7. [V] Sourcegraph, "Agentic Coding in 2026: A Practical Guide for Big Code", sourcegraph.com/blog/agentic-coding, abgerufen 2026-07-28.
8. [V] Micheál Reilly, "Software Architecture That Agents Actually Like", actuallymaybe.com (2026-01-30), abgerufen 2026-07-28.
9. [V] Moriz Büsing, "Greppability is an underrated code metric", morizbuesing.com, abgerufen 2026-07-28.
10. [V] AGENTS.md (Agentic AI Foundation / Linux Foundation), agents.md, abgerufen 2026-07-28.
11. [V] Martin Fowler, "MonolithFirst" (2015), martinfowler.com/bliki/MonolithFirst.html, abgerufen 2026-07-28.
12. [V] Java Code Geeks, "Microservices vs. Modular Monoliths in 2025", javacodegeeks.com (2025-12), abgerufen 2026-07-28.
13. [V] nadirbad.dev, "Vertical Slice vs Clean Architecture: A Practical Comparison" (2025), abgerufen 2026-07-28 (Inhalt nur teilweise extrahierbar).
14. [V] DevelopersVoice, "Domain Boundaries Without Ceremony: Hexagonal, Vertical Slice, and DDD Lite" (2025-10-24), developersvoice.com, abgerufen 2026-07-28.
15. [V] Gunnar Morling, "'You Don't Need Kafka, Just Use Postgres' Considered Harmful" (2025-11-03), morling.dev, abgerufen 2026-07-28.
16. [V] Marmelab, "Do you need a Backend For Frontend?" (2025-10-01), marmelab.com, abgerufen 2026-07-28.
17. [V] Ink & Switch, "Local-first software: You own your data, in spite of the cloud" (2019), inkandswitch.com/essay/local-first, abgerufen 2026-07-28.
18. [V] Smashing Magazine, "The Architecture of Local-First Web Development" (2026-05), smashingmagazine.com, abgerufen 2026-07-28.
19. [V] MobiLoud, "Do Progressive Web Apps Work on iOS? The Complete Guide for 2026", mobiloud.com, abgerufen 2026-07-28.
20. [S] Anthropic, "Building Effective AI Agents", anthropic.com/research/building-effective-agents.
21. [S] Anthropic, "Writing effective tools for AI agents", anthropic.com/engineering/writing-tools-for-agents.
22. [S] Sam Newman, "Backends For Frontends", samnewman.io/patterns/architectural/bff/.
23. [S] Microsoft Azure Architecture Center, "Backends for Frontends Pattern", learn.microsoft.com.
24. [S] GitGuardian, "Stop Leaking API Keys: The BFF Pattern Explained", blog.gitguardian.com.
25. [S] Augment Code, "What Is Spec-Driven Development?" und "API Contract Testing with Agent-Authored Specs", augmentcode.com.
26. [S] FlowFuse, "Store-and-Forward at the Edge: Buffering Production Data During Network Outages" (2025-11), flowfuse.com.
27. [S] Tiger Data, "MQTT to PostgreSQL: Architecture, Database Options, and Implementation Paths", tigerdata.com.
28. [S] Actual AI, "ADRs for Coding Agents: Architectural Context, Optimized", actual.ai; sowie F. Feroz, "AGENTS.md vs Architecture Decision Records" (2026), ai.gopubby.com.
29. [S] onidel.com, "LiteFS vs Litestream vs rqlite vs dqlite on VPS in 2025"; matthewswong.com, "SQLite Litestream Replication in Production Guide"; Changelog, "SQLite's web renaissance".
30. [S] kmoppel.github.io, "Postgres, Kafka and event queues" (2025-11).
