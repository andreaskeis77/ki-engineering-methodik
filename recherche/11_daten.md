# Dossier 11: Datenarchitektur, Ontologien, Wissensgraphen und Datenerfassung

Stand: 2026-07-28. Quellenstatus-Konvention: [V] = URL am 2026-07-28 selbst abgerufen und Inhalt geprueft; [S] = nur ueber Suchergebnisse/Sekundaerzitate belegt. Bewertungen beziehen sich auf Andreas' Massstab: professionell ohne Enterprise-Overhead, lokal betreibbar, agentenfreundlich, reproduzierbar, auditierbar.

## Executive Summary

Andreas' Drei-Datenbank-Strategie (SQLite fuer transaktionale Kleinprodukte, DuckDB fuer Analytik, PostgreSQL wo Concurrent Writes/CMS es verlangen) ist 2026 nicht Sonderweg, sondern Lehrbuchstand; alle drei Oekosysteme sind hochaktiv (SQLite 3.53.x, DuckDB 1.5.x, PostgreSQL 18). Die wichtigste Neuerung im Umfeld ist DuckLake 1.0 (04/2026): ein Lakehouse-Format, das alle Metadaten in einer SQL-Datenbank haelt und Snapshots, Time Travel und Schema-Evolution ueber Parquet-Dateien liefert — fuer die NFL-Plattform pilotwuerdig, nicht pflichtig. Bei Graphen ist die zentrale Lektion die ploetzliche Archivierung von KuzuDB (10/2025): eingebettete Nischen-Graphdatenbanken sind ein Nachhaltigkeitsrisiko; Graph-Anteile gehoeren als Kantentabellen in SQLite/DuckDB, mit rekursiven CTEs, NetworkX oder experimentell DuckPGQ als Abfrageschicht. Formale RDF/OWL-Ontologien lohnen erst bei echtem Interop- oder Reasoning-Bedarf; Andreas' leichtgewichtige Eigenmodelle sind fuer den Privatkontext die richtige Stufe — PROV- und SKOS-Konzepte als Vokabular uebernehmen, ohne Triple-Store. GraphRAG ist laut ICLR-2026-Benchmark haeufig schlechter als Vanilla RAG und lohnt nur fuer Multi-Hop- und Korpus-Zusammenfassungsfragen; fuer curio gilt: strukturierte SQL-Abfragen + klassisches RAG zuerst. W3C PROV bleibt das stabile Referenzmodell fuer Provenance, wird aber pragmatisch relational implementiert; Splink (auf DuckDB) ist der klare Standard fuer Entity Resolution; Pandera/pydantic schlagen Great Expectations im Kleinkontext. Rechtlich hat sich die Lage praezisiert: OLG Hamburg (12/2025, LAION) bestaetigt TDM-Schranken inkl. maschinenlesbarem Opt-out, LG Muenchen I (11/2025, GEMA/OpenAI) zieht bei Memorisierung im Modell die Grenze; fuer Andreas' nicht-kommerzielles Scraping heisst das: API-first, robots.txt/TDM-Vorbehalte technisch respektieren und protokollieren, keine Login-/Schrankenumgehung. Werkzeugseitig sind Playwright/Crawl4AI (lokal) fuer Erfassung, Docling/Marker/MinerU (gestuft) fuer PDF, changedetection.io fuer Aenderungsueberwachung und WARC/Hash-basierte Rohdatenarchive der Stand der Technik — alles kompatibel mit dem Leitbild, jeden Fakt auf Quelle, Abrufzeitpunkt, Rohdaten, Transformation und Version rueckfuehrbar zu machen.

## Teil 1: Datenarchitektur

### 1. SQLite/DuckDB/PostgreSQL 2026: Bestandsaufnahme

Alle drei Engines entwickeln sich zuegig weiter: SQLite steht bei 3.53.3 (06/2026) [S], mit inzwischen etabliertem `jsonb`, Strict Tables und dem Vektor-Extension-Oekosystem (sqlite-vec) [S]. PostgreSQL 18 ist regulaer erschienen [S]. DuckDB liegt bei 1.5.2 (04/2026) [S] und hat sich als Standard-Analytik-Engine fuer lokale Datenplattformen zementiert. Fuer Kleinprojekte gilt unveraendert: relational als Default; Dokumentenorientierung (MongoDB & Co.) bringt im Ein-Personen-Betrieb fast nie Mehrwert, weil JSON-Spalten in SQLite/Postgres denselben Zweck schemaflexibel und mit SQL-Zugriff erfuellen; dedizierte Graphdatenbanken siehe Abschnitt 2.

Die strategisch interessanteste Neuerung ist **DuckLake 1.0** (13.04.2026, produktionsreif erklaert) [V]: ein offenes Lakehouse-Format, das — anders als Iceberg/Delta — saemtliche Metadaten in einer normalen SQL-Datenbank haelt (DuckDB, SQLite oder PostgreSQL als Katalog), waehrend die Daten als Parquet liegen. Es bietet Snapshots/Time Travel, Schema-Evolution, Data Inlining fuer Kleinaenderungen und Iceberg-kompatible Partitionierung [V]. Fuer Andreas ist das relevant, weil es genau sein Muster `raw → staging → marts` mit eingebauter Versionierung und Zeitreisen formalisiert, ohne Cloud- oder Spark-Zwang. Einschraenkung: Fuer neue Projekte unterhalb der NFL-Groessenordnung bleibt eine einzelne DuckDB-Datei einfacher; DuckLake lohnt, wenn (a) Historie von Tabellenstaenden gebraucht wird, (b) mehrere Prozesse/Engines auf dieselben Daten sollen, oder (c) Parquet ohnehin das Austauschformat ist.

### 2. Graphdatenbanken: Die Kuzu-Lektion

KuzuDB, bis 2025 die vielversprechendste eingebettete Graphdatenbank ("DuckDB fuer Graphen"), wurde im Oktober 2025 ohne Vorwarnung archiviert; die Firma wechselte auf ein neues Produkt. Zusaetzlich waren die Speicherformate nie stabil — Nutzer mussten bei Updates exportieren/reimportieren [V]. Forks (LadybugDB) und Nachfolge-Kandidaten existieren [S], sind aber jung. Die verallgemeinerbare Lektion fuer die Methodik: **Persistenzformate von VC-finanzierten Nischen-Datenbanken sind ein Klumpenrisiko; Primaerspeicher gehoert auf Formate mit Dekaden-Perspektive** (SQLite, Parquet, PostgreSQL).

Fuer Graph-Workloads im Privatkontext heisst das: Kanten als normale Tabellen (`edge(src, dst, type, props…)`) in SQLite/DuckDB; Traversierung ueber rekursive CTEs oder — fuer Analysen — Export nach NetworkX. Der SQL:2023-Standard SQL/PGQ bringt Graph-Pattern-Matching (`MATCH`, `ANY SHORTEST`) in SQL; die DuckDB-Community-Extension **DuckPGQ** implementiert ihn, ist aber explizit Forschungsprojekt/Work-in-progress (CWI, ein Hauptentwickler) [V]. Einordnung: pilotgeeignet fuer Abfragen, niemals als Speicherformat-Abhaengigkeit (Extension liest normale DuckDB-Tabellen — genau deshalb ist das Risiko begrenzt). Neo4j & Co. sind fuer Andreas ueberdimensioniert (Serverbetrieb, JVM, Lizenzfragen) — der einzige Grund waere Cypher-Komfort, den SQL/PGQ zunehmend neutralisiert.

### 3. Ontologien: RDF/OWL vs. Property Graph vs. leichtgewichtige Eigenmodelle

Der Fachdiskurs 2025/2026 konvergiert auf eine pragmatische Linie [S]: **RDF/OWL lohnt, wenn (1) Daten mit Dritten ueber Vokabulare ausgetauscht werden, (2) offene-Welt-Reasoning/Inferenz gebraucht wird, (3) externe Ontologien (schema.org, SKOS-Thesauri, Wikidata) eingebunden werden sollen.** Property Graphs lohnen bei traversierungslastigen Abfragen mit Attributen an Kanten. Fuer alles andere — und das ist im Privatkontext die Regel — sind relationale Modelle mit kontrolliertem Vokabular die wartbarste Loesung. Eine Ontologie ist dabei nicht "RDF-Datei", sondern die explizite Festlegung von Typen, Relationen und Constraints [S] — die kann in SQL-DDL plus Referenztabellen leben.

Konkret fuer capsule (Wardrobe-Ontologie) und tischatlas: Das leichtgewichtige Eigenmodell in SQLite ist richtig. Aufwerten statt ersetzen: (a) kontrollierte Vokabulare als eigene Tabellen mit stabilen IDs, Synonymen und `broader/narrower`-Relationen (das ist SKOS-Semantik ohne SKOS-Serialisierung); (b) Export-Faehigkeit nach JSON-LD/schema.org als optionale Sicht, falls je Interop noetig wird; (c) Ontologie-Aenderungen als versionierte Migrationen mit ADR. Volles OWL-Reasoning (Klassifikation, Konsistenzpruefung via Reasoner) ist fuer die 11 Projekte durchweg ueberdimensioniert.

### 4. GraphRAG: Evidenz statt Mode

Die Benchmark-Lage ist ernuechternd fuer den Hype: Das ICLR-2026-Paper zu GraphRAG-Bench startet vom dokumentierten Befund, dass "GraphRAG frequently underperforms vanilla RAG on many real-world tasks", und vermisst systematisch, wann Graphstrukturen messbar helfen [V][V]. Ergebnislinie (konsistent mit der systematischen Evaluation arXiv:2502.11371 [S]): Vorteile bei Multi-Hop-Reasoning und korpusweiten Zusammenfassungsfragen ("global questions"); bei einfachem Faktenabruf gewinnt Vanilla RAG bei einem Bruchteil der Kosten, denn die LLM-basierte Graph-Extraktion beim Indexieren ist teuer. Microsofts LazyGraphRAG adressiert genau diese Indexkosten, indem Extraktion in die Abfragezeit verschoben wird [S].

Fuer curio (Wissenskompiler) und boxscore folgt daraus eine klare Prioritaet: (1) Strukturierte Fragen gegen strukturierte Daten mit SQL beantworten — Andreas hat bereits Datenmodelle, das schlaegt jede RAG-Variante in Praezision und Auditierbarkeit. (2) Fuer Textkorpora klassisches RAG (sqlite-vec/DuckDB-Embeddings) mit sauberem Chunking. (3) GraphRAG nur als Experiment fuer explizite Multi-Hop-Fragen ueber den Wissensbestand, idealerweise auf dem ohnehin vorhandenen Entitaeten-Graphen statt LLM-extrahierter Triples. Einordnung: GraphRAG als Default = Mode; entitaetsbasierte Verlinkung als Datenmodell = zeitloser Mehrwert.

### 5. Provenance: W3C PROV als Referenzmodell, relational implementiert

W3C PROV (PROV-DM, PROV-O, PROV-N) ist seit 30.04.2013 Recommendation und wird nicht aktiv weiterentwickelt [V] — das ist kein Manko, sondern Stabilitaet: Das Modell aus **Entity** (Datum/Artefakt), **Activity** (Prozess mit Zeitraum), **Agent** (Software/Person/Modell) und den Relationen `wasGeneratedBy`, `used`, `wasDerivedFrom`, `wasAttributedTo` bleibt die Lingua franca. Fuer Pipeline-Betrieb existiert daneben OpenLineage (Job/Run/Dataset mit Facets) als offener Betriebsstandard [S] — konzeptionell lehrreich, als Infrastruktur (Marquez etc.) fuer Andreas ueberdimensioniert.

**Stand der Technik fuer Andreas' Leitbild** ("jeder Fakt rueckfuehrbar auf Quelle, Abrufzeitpunkt, Rohdaten, Transformationen, Qualitaet, Version") ist ein relationaler PROV-Kern, den curio/new_nfl teilweise schon leben:

- `source` (Quelle, Vertrauensklasse, Lizenz-/Robots-Status, TTL),
- `fetch` = Activity (URL, Zeitstempel UTC, HTTP-Status, ETag/Last-Modified, Content-Hash, Scraper-Version),
- `raw_artifact` = Entity (unveraenderte Rohbytes, content-addressed via SHA-256, Pfad/Blob),
- `transform_run` = Activity (Git-SHA des Codes, Tool-/Modellversionen, Parameter, Input-/Output-Hashes) — bei LLM-Extraktion zusaetzlich Modell-ID, Prompt-Hash, Temperatur: das LLM ist ein PROV-Agent wie jeder andere,
- `claim`/`fact` = Entity mit `derived_from`-Kante auf raw_artifact und transform_run,
- `claim_source` (n:m) fuer Mehrquellen-Belege mit Konfidenz.

Das ist exakt die Datenbank-Entsprechung der Run-Manifeste der Methodik v4.0 — Run-Manifest und Provenance-Kern sollten dasselbe Schema teilen. Wer PROV-Konformitaet je nach aussen zeigen will, generiert PROV-JSON als Export-Sicht; niemand braucht dafuer einen Triple-Store.

### 6. Versionierung, Schema-Evolution, bitemporale Daten

**Schema-Evolution:** Werkzeugstandard bleibt Alembic (FastAPI/SQLAlchemy) bzw. Django-Migrations; fuer agentische Entwicklung wichtig sind die Regeln, nicht die Tools: additive, kleine, vorwaertsgerichtete Migrationen; Migrationen sind Code mit Review-Pflicht; jede Migration im Repo, hermetisch testbar gegen eine Wegwerf-Kopie der DB. SQLite-Spezifikum: eingeschraenktes `ALTER TABLE` erzwingt das 12-Schritte-Muster (neue Tabelle, Copy, Rename) — das sollte als Rezept in der Methodik stehen, weil Agenten hier notorisch fehlerhafte Abkuerzungen nehmen.

**Datenversionierung:** Dolt ("Git for Data", MySQL-kompatibel, Branch/Diff/Merge auf Zeilenebene) ist gereift und 2026 aktiv [S]; fuer Andreas aber nur "sinnvoll unter Bedingungen" — es ersetzt die Engine, statt sie zu ergaenzen. Naeher an seinem Stack liegen: DuckLake-Snapshots (Abschnitt 1), Parquet-Snapshots je Ingest-Lauf im raw-Layer, und schlichte, datierte SQLite-Dateikopien mit Hash im Manifest. DVC/lakeFS sind auf seine Groessenordnung ueberdimensioniert.

**Bitemporalitaet:** Vollstaendige bitemporale Systeme (XTDB, SQL:2011-Features in MSSQL/MariaDB) sind fuer die Projekte Overkill; das praxiserprobte Muster ist "poor man's bitemporal" in SQLite/DuckDB [S]: pro Faktzeile `valid_from/valid_to` (Realwelt-Gueltigkeit) plus `recorded_at/superseded_at` (Systemwissen), Updates nur als Insert + Supersede (Append-only). Genau dort, wo Andreas Korrekturen von Quelldaten nachvollziehen muss (NFL-Statistik-Korrekturen, Restaurant-Menue-Aenderungen), zahlt sich das Spaltenpaar-Muster aus — selektiv pro Tabelle einfuehren, nicht flaechig.

### 7. Datenvalidierung als Gate

Der 2025er-Ueberblick der Validierungslandschaft [V] bestaetigt die Arbeitsteilung: **pydantic v2** an allen Systemgrenzen (API-Input, Config, LLM-Output via Structured Outputs), **Pandera** fuer DataFrame-/Tabellen-Contracts (Polars/pandas, auch DuckDB-via-Arrow), **pointblank** als junger Beobachtungskandidat; **Great Expectations** ist durch Cloud-Ausrichtung und Konfigurations-Overhead fuer Kleinkontexte unattraktiv geworden [V]. Ergaenzend gehoeren SQL-basierte Assertions in die marts-Schicht (Row-Counts, Referenzintegritaet, Wertebereiche, Freshness) — das dbt-Test-Muster ohne dbt-Zwang, ausfuehrbar als ein CLI-Kommando. Methodisch entscheidend: Validierungsergebnisse sind Provenance-Daten (welcher Check, welche Version, bestanden/gefallen, wann) und gehoeren ins Run-Manifest; ein Kontrakt-Bruch stoppt die Pipeline vor dem marts-Layer (hermetisches Gate, kein Silent-Fix durch Agenten).

### 8. Entity Resolution und Dubletten

**Splink** (UK Ministry of Justice) ist der klare Open-Source-Standard: probabilistisches Fellegi-Sunter-Modell, unsupervised trainierbar, ~1 Mio. Records/Minute auf einem Laptop, und — entscheidend — **DuckDB und SQLite als Backends** [V]. Produktionsnachweise: UK Census 2021, NHS [V]. Vorgehensregel fuer die Methodik: (1) deterministische Schluessel und Normalisierung zuerst (loest im Privatkontext 90 %), (2) Splink fuer den probabilistischen Rest (Spieler-/Restaurant-/Produkt-Dubletten ueber Quellen hinweg), (3) unsichere Matches als explizite Review-Queue mit menschlicher Entscheidung — Merge-Entscheidungen sind auditierbare Ereignisse mit Provenance (wer/was hat wann mit welchem Score gemergt), niemals stille Ueberschreibungen. Alternativen (dedupe.io, Zingg) bieten im DuckDB-Stack keinen Vorteil [S].

### 9. Metadaten und Austauschformate

Fuer Datensatz-Metadaten existieren zwei relevante leichte Standards: **Frictionless Data Package v2** (06/2024: `datapackage.json` mit Table Schema, Checksums, Lizenz) [S] und **Croissant** (MLCommons, JSON-LD-Vokabular fuer ML-Datasets, von HuggingFace/Kaggle unterstuetzt) [S]. Empfehlung: kein schwergewichtiger Metadaten-Katalog (DataHub/OpenMetadata = Enterprise-Overhead), sondern eine `dataset.yaml`/`datapackage.json` je Quelle bzw. je Mart mit Schema, Eigentuemer, Lizenz/Robots-Status, TTL und Qualitaets-SLOs — maschinenlesbar genug, dass Agenten sie als Kontext nutzen koennen; Frictionless-kompatibel genug, dass Export trivial bleibt.

## Teil 2: Datenerfassung aus Webquellen

### 10. Rechtsrahmen DE/EU 2026

Die Rechtslage hat sich 2025/2026 durch zwei Leitentscheidungen praezisiert:

- **OLG Hamburg, 10.12.2025 (5 U 104/24, LAION/Kneschke)** [V]: Download urheberrechtlich geschuetzter Bilder zur Erstellung eines KI-Trainingsdatensatzes kann rechtmaessig sein; fuer nicht-kommerzielle Forschung greift § 60d UrhG breit, fuer TDM allgemein § 44b UrhG. Zentral: Der Nutzungsvorbehalt des Rechteinhabers wirkt nur, wenn er **maschinenlesbar** erklaert ist; rein natuerlichsprachliche Klauseln in Nutzungsbedingungen genuegten dem Gericht nicht. Die genaue Grenze der "Maschinenlesbarkeit" bleibt umstritten (das LG hatte 2024 obiter erwogen, auch natuerliche Sprache koenne KI-lesbar sein) — praktisch heisst Vorsicht: robots.txt **und** erkennbare textliche Vorbehalte respektieren.
- **LG Muenchen I, 11.11.2025 (42 O 14139/24, GEMA/OpenAI)** [V]: Die Memorisierung ganzer Songtexte im Modell und deren Wiedergabe im Output sind Vervielfaeltigungen, die § 44b nicht deckt; die TDM-Schranke traegt technische Zwischenkopien, nicht die dauerhafte Einverleibung von Werken ins Modell. Berufung laeuft [S]. Fuer Andreas (kein Modelltraining) mittelbar relevant: Bei LLM-Extraktion aus geschuetzten Texten keine woertlichen Volltexte speichern/publizieren, sondern Fakten, kurze Zitate mit Beleg und eigene Zusammenfassungen.

Praktischer Rahmen fuer Andreas' nicht-kommerzielle, private Systeme: (1) § 44b UrhG erlaubt Vervielfaeltigungen **rechtmaessig zugaenglicher** Werke fuer automatisierte Analyse; Loeschpflicht, wenn fuer den Zweck nicht mehr erforderlich — das dauerhafte Rohdatenarchiv stuetzt sich daher zusaetzlich auf Analysezweck-Fortdauer und im Zweifel auf § 53 (Privatkopie) fuer den rein privaten Bereich. (2) Maschinenlesbare Opt-outs (robots.txt, TDM Reservation Protocol, kuenftig AIPREF) sind zu respektieren und **der Pruefzeitpunkt zu protokollieren** — das ist zugleich die beste Absicherung und gelebte Provenance [V]. (3) Keine Umgehung technischer Schranken: Login-Walls, Paywalls, IP-Sperren, CAPTCHAs — Umgehung riskiert Vertrags- und ggf. Strafbarkeitsfragen; ausserdem Datenbankherstellerrecht (§ 87b: keine wesentlichen Teile fremder Datenbanken systematisch entnehmen) und DSGVO bei personenbezogenen Daten beachten. (4) APIs und lizenzierte Feeds sind stets die rechtlich sauberste Quelle. Die EU-AI-Act-Pflichten (Art. 53: TDM-Opt-out-Policy, Trainingsdaten-Zusammenfassung) treffen GPAI-Anbieter, nicht private Datensammler [V].

### 11. Opt-out-Signale: robots.txt heute, AIPREF morgen

Die IETF-Arbeitsgruppe **AIPREF** standardisiert derzeit ein Vokabular fuer KI-Nutzungspraeferenzen und dessen Anbindung an RFC 9309 (robots.txt) und HTTP-Header; Zielabschluss August 2026 [V]. Fuer die Methodik: Der Quellen-Adapter jeder Plattform prueft und archiviert bei jedem Crawl robots.txt (+ kuenftig AIPREF-Signale) mit Zeitstempel und Hash. Damit wird Compliance selbst zu einem auditierbaren Fakt im Provenance-Kern — Stand der Technik, den kaum jemand umsetzt, der aber exakt zu Andreas' Leitbild passt.

### 12. Erfassungshierarchie und Browser-Automation

Bewaehrte Prioritaet je Quelle: **offizielle API > strukturierte Daten in Seiten (JSON-LD/schema.org, Sitemaps, Feeds, eingebettete `__NEXT_DATA__`-artige JSON) > statisches HTML-Parsing > Browser-Automation**. Jede Stufe tiefer kostet Stabilitaet und Auditierbarkeit. Fuer die Browser-Stufe ist Playwright die Basis; darauf aufsetzend hat sich **Crawl4AI** (Open Source, lokal, LLM-freundliches Markdown, Extraction-Strategies) als beste Wahl fuer den Selbst-Betrieb etabliert, waehrend **Firecrawl** primaer als API-Dienst punktet (Anti-Bot-Handling ausgelagert, dafuer Kosten und Datenabfluss) [S]. Andreas' bestehende Playwright-Adapter (boxscore, tischatlas) sind damit bestaetigt; Crawl4AI lohnt als Pilot dort, wo Markdown-fuer-LLM-Extraktion gebraucht wird. Hoeflichkeitsregeln (Rate-Limits, identifizierender User-Agent, Off-Peak-Zeiten, Backoff) gehoeren als Default in den Adapter-Kontrakt [S].

### 13. Dokument- und PDF-Extraktion, OCR und VLM

Der 2026er-Werkzeugstand ist gut vermessen (OmniDocBench als Referenz-Benchmark [S]): **PyMuPDF4LLM** fuer native PDFs (CPU, sehr schnell), **Docling** (IBM, strukturierte Ausgabe, RAG-orientiert) und **Marker v2** als Allrounder, **MinerU** fuehrend bei komplexen Layouts/Scans (GPU empfohlen) [V][S]. VLM-basierte OCR (olmOCR, Mistral OCR, GPT/Gemini-Vision) liefert bei schwierigen Scans und Handschrift die besten Ergebnisse, ist aber teurer und — wichtig — **nicht deterministisch: VLM-Extraktion ist als Transform-Activity mit Modellversion und Prompt-Hash zu protokollieren, mit Konfidenz je Feld**. Empfohlene Stufung: (1) nativer Text-Layer (PyMuPDF), (2) bei Layout-/Scan-Problemen Docling/Marker lokal, (3) VLM nur fuer Restfaelle, mit Stichproben-Review. Extrahierte Tabellen validiert Pandera gegen den Quell-Kontrakt (Abschnitt 7).

### 14. Aenderungsueberwachung, Caching, Rohdatenarchiv

**Aenderungserkennung:** changedetection.io (31k+ Stars, self-hosted, Playwright-faehig, CSS/XPath/JSONPath-Selektoren, Diff-Ansichten, Benachrichtigungen, Zeitplaene) ist der Standard fuer "beobachte diese Seite" [V] — sinnvoll fuer tischatlas-Menuekarten oder Preisseiten. Fuer eigene Pipelines gilt das Schichtmodell: HTTP-Ebene (ETag/Last-Modified, Conditional Requests, `304`-Handling) → Inhalts-Ebene (SHA-256 ueber normalisierten Inhalt; nur bei Hash-Aenderung neue Version anlegen) → Feld-Ebene (Diff gegen letzte extrahierte Fakten, Aenderung als neues bitemporales Faktum). **Caching/TTL:** je Quellenklasse deklarieren (Spielplaene taeglich, historische Statistiken quasi-nie, Speisekarten woechentlich); Refresh-Politik gehoert in die `dataset.yaml`.

**Rohdatenarchiv:** Fuer Reproduzierbarkeit ist die Archivierung der Original-Response Stand der Technik; im Web-Archiv-Umfeld via **WARC/WACZ** (auch in Scrapy-Pipelines integrierbar [S]), im Kleinkontext genuegt funktional Aequivalentes: Rohbytes + vollstaendige Response-Header + Request-Metadaten, content-addressed (SHA-256), komprimiert, mit Fetch-Zeile im Provenance-Kern verknuepft. WARC lohnt, wenn ganze Seitenzustaende (inkl. Assets) beweisfest eingefroren werden sollen; fuer API-JSON reicht die Hash-Datei. Wissenschaftliche Best-Practice-Leitfaeden 2025 bestaetigen genau diese Kombination aus rechtlicher Pruefung, Rohdaten-Snapshot und dokumentierter Verarbeitung [S].

### 15. Quellenvergleich und Vertrauensbewertung

Fuer Mehrquellen-Fakten (NFL-Statistiken aus zwei Anbietern, Restaurantdaten aus Karte + Website) ist der Stand der Technik dreiteilig: (1) **Quellen-Ranking**: statische Vertrauensklasse je Quelle (offiziell > lizenzierter Aggregator > Community), deklariert in der Quellen-Metadatei; (2) **Claim-Ebene**: jeder Fakt traegt seine Belege (`claim_source` n:m, Wikidata-Muster "referenced claims"), Konflikte werden nicht stillschweigend aufgeloest, sondern als Konflikt-Datensatz materialisiert und nach deklarierter Regel entschieden (hoechste Vertrauensklasse gewinnt, Rest bleibt als abweichender Beleg sichtbar); (3) **dynamische Qualitaetssignale**: Frische, Schema-Validitaet der letzten N Laeufe, historische Korrekturrate der Quelle als einfacher Score. Aufwendige Truth-Discovery-Algorithmen aus der Forschung sind fuer Privatprojekte ueberdimensioniert; die deklarative Rangfolge + Konfliktprotokoll deckt den Bedarf und bleibt auditierbar.

## Konsequenzen fuer Andreas' Methodik und Projekte

1. **Provenance-Kern als wiederverwendbares Referenzschema kodifizieren** (source/fetch/raw_artifact/transform_run/claim/claim_source, PROV-Begriffe als Namenskonvention) und in curio, new_nfl/boxscore, tischatlas konvergieren lassen; Run-Manifeste und Provenance-Kern teilen ein Schema. LLM-/VLM-Extraktionen sind darin gewoehnliche Activities mit Modell-ID + Prompt-Hash + Konfidenz. Begruendung: Abschnitte 5, 13, 15.
2. **Primaerspeicher-Regel in die Methodik aufnehmen:** Persistenz nur auf Formaten mit Dekaden-Perspektive (SQLite, Parquet, PostgreSQL); Nischen-Engines (Graph-, Vektor-, Zeitreihen-Spezialisten) nur als abgeleitete, jederzeit neu erzeugbare Indizes. Die Kuzu-Archivierung ist der Beleg. Graph-Abfragen via rekursive CTEs/NetworkX, DuckPGQ als Pilot. Begruendung: Abschnitt 2.
3. **Kein GraphRAG als Default:** Fuer curio Reihenfolge SQL-ueber-Struktur → klassisches RAG (sqlite-vec) → GraphRAG-Experiment nur fuer Multi-Hop-/Korpusfragen, mit Vorher/Nachher-Messung auf eigenen Fragen. Begruendung: Abschnitt 4.
4. **DuckLake-Pilot fuer die NFL-Plattform** (Katalog: die vorhandene DuckDB/SQLite; Daten: Parquet): bringt Time Travel und Schema-Evolution fuer `raw → staging → marts` ohne neue Infrastruktur; Erfolgskriterium: vereinfachte Backfills/Snapshots gegenueber heutigem Stand. Kein Rollout auf kleinere Projekte. Begruendung: Abschnitte 1, 6.
5. **Validierung als Gate standardisieren:** pydantic an Raendern, Pandera-Kontrakte je Ingest-Adapter, SQL-Assertions je Mart; Kontraktbruch stoppt vor marts; Ergebnisse ins Run-Manifest. Great Expectations explizit als Nicht-Default fuehren. Begruendung: Abschnitt 7.
6. **Splink-auf-DuckDB als Standardwerkzeug fuer Entity Resolution** aufnehmen; Merge-Politik: deterministisch zuerst, probabilistisch mit Review-Queue, Merges als auditierbare Ereignisse. Einsatzkandidaten: Spieler-IDs (NFL), Restaurants (tischatlas/joes-journal). Begruendung: Abschnitt 8.
7. **Compliance-by-Provenance im Scraping-Adapter:** robots.txt/TDM-Signale (kuenftig AIPREF) bei jedem Lauf pruefen, archivieren, hashen; identifizierender User-Agent, Rate-Limits, keine Umgehung von Login/Paywall/CAPTCHA; API-first-Hierarchie als Spezifikationspflicht je Quelle; keine woertlichen Volltext-Speicherungen geschuetzter Texte im publizierten Teil. Rechtsgrundlage und Urteile (OLG HH 12/2025, LG Muenchen 11/2025) als Anker in der Methodik zitieren. Begruendung: Abschnitte 10-12.
8. **Bitemporales Spaltenpaar-Muster selektiv einfuehren** (`valid_from/valid_to` + `recorded_at/superseded_at`, Append-only) fuer korrekturanfaellige Fakten (NFL-Statistikkorrekturen, Menues/Preise); zugleich SQLite-Migrationsrezept (12-Schritte) als Agenten-Guardrail dokumentieren. Begruendung: Abschnitt 6.
9. **Leichte Metadaten-Pflichtdatei je Quelle/Mart** (`dataset.yaml`, Frictionless-kompatibel): Schema, Lizenz-/Robots-Status, TTL/Refresh, Vertrauensklasse, Qualitaets-SLOs — dient Agenten als Kontext und macht die Refresh-/Konfliktregeln deklarativ. Begruendung: Abschnitte 9, 14, 15.

## Bewertungstabelle

| Methode/Technologie | Einordnung fuer Andreas' Kontext |
|---|---|
| SQLite/DuckDB/PostgreSQL-Dreiteilung | jetzt empfohlen (Status quo bestaetigt) |
| DuckLake 1.0 | pilotgeeignet (NFL-Plattform); sonst beobachten |
| Dedizierte Graphdatenbank (Neo4j, Kuzu-Nachfolger) | ueberdimensioniert / derzeit nicht belastbar (Kuzu-Lektion) |
| Graph als Kantentabellen + rekursive CTEs/NetworkX | jetzt empfohlen |
| DuckPGQ (SQL/PGQ) | pilotgeeignet (nur Abfrageschicht, Forschungsstatus) |
| RDF/OWL-Volltoolchain (Triple-Store, Reasoner) | ueberdimensioniert fuer Privatkontext |
| Leichtgewichtige Eigen-Ontologie + SKOS-/PROV-Vokabular | jetzt empfohlen |
| GraphRAG als Default-RAG | ueberwiegend Mode; nur fuer Multi-Hop/Korpusfragen sinnvoll unter Bedingungen |
| Klassisches RAG mit sqlite-vec/DuckDB | jetzt empfohlen (nach SQL-first) |
| W3C PROV als relationales Referenzmodell | jetzt empfohlen |
| OpenLineage/Marquez als Infrastruktur | ueberdimensioniert; Konzepte beobachten |
| Dolt ("Git for Data") | sinnvoll unter Bedingungen (nur bei echtem Branch/Merge-Bedarf) |
| Bitemporales Spaltenpaar-Muster (append-only) | jetzt empfohlen (selektiv) |
| XTDB / SQL:2011-Bitemporalitaet | ueberdimensioniert |
| pydantic v2 + Pandera + SQL-Assertions | jetzt empfohlen |
| Great Expectations | ueberdimensioniert (Cloud-Drift, Konfig-Overhead) |
| Splink auf DuckDB | jetzt empfohlen |
| Frictionless Data Package v2 / dataset.yaml | jetzt empfohlen (leichtgewichtig) |
| Croissant (ML-Metadaten) | beobachten |
| API-first-Erfassungshierarchie | jetzt empfohlen |
| Playwright(-Adapter) fuer dynamische Seiten | jetzt empfohlen (Status quo bestaetigt) |
| Crawl4AI | pilotgeeignet (lokal, LLM-Markdown) |
| Firecrawl (API-Dienst) | sinnvoll unter Bedingungen (Anti-Bot noetig, Datenabfluss akzeptiert) |
| PyMuPDF4LLM → Docling/Marker → MinerU (gestuft) | jetzt empfohlen |
| VLM-OCR (olmOCR, Mistral OCR, Vision-APIs) | sinnvoll unter Bedingungen (Restfaelle, mit Provenance + Review) |
| changedetection.io | jetzt empfohlen |
| WARC/WACZ-Vollarchiv | sinnvoll unter Bedingungen; Hash-basiertes Rohdatenarchiv als Default |
| Truth-Discovery-Algorithmen | ueberdimensioniert; deklarative Quellenrangfolge + Konfliktprotokoll stattdessen |

## Quellenverzeichnis

1. [V] DuckLake 1.0 Announcement (2026-04-13) — https://ducklake.select/2026/04/13/ducklake-10/ (abgerufen 2026-07-28)
2. [S] DuckDB 1.5.2 Release — https://duckdb.org/2026/04/13/announcing-duckdb-152
3. [V] BigGo News: KuzuDB archiviert (10/2025) — https://biggo.com/news/202510130126_KuzuDB-embedded-graph-database-archived (abgerufen 2026-07-28)
4. [S] LadybugDB (Kuzu-Fork) — https://ladybugdb.com/
5. [V] DuckPGQ-Projektseite (CWI) — https://duckpgq.org/ (abgerufen 2026-07-28)
6. [S] DuckDB Guide: Graph Queries / SQL:2023 PGQ — https://duckdb.org/docs/current/guides/sql_features/graph_queries
7. [V] GraphRAG-Bench (ICLR 2026) — https://github.com/GraphRAG-Bench/GraphRAG-Benchmark (abgerufen 2026-07-28)
8. [V] Paper "When to use Graphs in RAG" — https://arxiv.org/abs/2506.05690 (abgerufen 2026-07-28)
9. [S] RAG vs. GraphRAG: A Systematic Evaluation — https://arxiv.org/html/2502.11371v3
10. [S] Microsoft Research: LazyGraphRAG — https://www.microsoft.com/en-us/research/blog/lazygraphrag-setting-a-new-standard-for-quality-and-cost/
11. [V] W3C PROV Overview — https://www.w3.org/TR/prov-overview/ (abgerufen 2026-07-28)
12. [S] OpenLineage-Dokumentation — https://openlineage.io/docs/
13. [S] Talisman: Choosing the Right Graph (RDF vs. LPG) — https://jessicatalisman.substack.com/p/choosing-the-right-graph
14. [S] Towards AI: When Do You Really Need RDF/OWL for Agentic AI (robots.txt-blockiert, nicht verifizierbar) — https://pub.towardsai.net/when-do-you-really-need-rdf-owl-for-agentic-ai-8ca3ef6fbcfe
15. [V] aeturrell: The data validation landscape in 2025 — https://aeturrell.com/blog/posts/the-data-validation-landscape-in-2025/ (abgerufen 2026-07-28)
16. [V] Splink-Dokumentation (MoJ) — https://moj-analytical-services.github.io/splink/index.html (abgerufen 2026-07-28)
17. [S] Tilores: Splink/Zingg/dedupe-Vergleich — https://tilores.io/content/best-open-source-entity-resolution-and-record-linkage-libraries-splink-zingg-dedupe-and-when-to-move-beyond-them/
18. [S] evalapply: Poor man's bitemporal data system in SQLite — https://www.evalapply.org/posts/poor-mans-time-oriented-data-system/index.html
19. [S] DoltHub: How to Version Control a Database (2026-01-07) — https://www.dolthub.com/blog/2026-01-07-how-to-version-control-a-database/
20. [S] Data Package v2 Release (2024-06-26) — https://datapackage.org/blog/2024-06-26-v2-release/
21. [S] Croissant: A Metadata Format for ML-Ready Datasets (ACM) — https://dl.acm.org/doi/10.1145/3650203.3663326
22. [S] SQLite Release 3.53.3 (2026-06-26) — https://sqlite.org/releaselog/3_53_3.html
23. [S] PostgreSQL 18 Release Notes — https://www.postgresql.org/docs/current/release-18.html
24. [S] sqlite-vec Releases — https://github.com/asg017/sqlite-vec/releases
25. [S] § 44b UrhG (Gesetzestext) — https://www.gesetze-im-internet.de/urhg/__44b.html
26. [V] Ferner: OLG Hamburg 5 U 104/24 (LAION, 2025-12-10) — https://www.ferner-alsdorf.de/ki-training-und-urheberrecht-zulaessigkeit-des-webscrapings-fuer-trainingsdatensaetze-olg-hh/ (abgerufen 2026-07-28)
27. [V] LTO: LG Muenchen I 42 O 14139/24 (GEMA/OpenAI, 2025-11-11) — https://www.lto.de/recht/nachrichten/n/42o1413924-lg-muenchen-i-gema-openai-chatgpt-songtexte-ki (abgerufen 2026-07-28)
28. [S] Verfassungsblog zur GEMA/OpenAI-Entscheidung — https://verfassungsblog.de/lg-munchen-gema-open-ai/
29. [S] Initiative Urheberrecht: OpenAI legt Berufung ein — https://urheber.info/diskurs/openai-legt-berufung-ein
30. [V] LAUSEN: TDM-Vorbehalt, technische Maschinenlesbarkeit — https://lausen.com/der-text-und-data-mining-vorbehalt-technische-umsetzung-der-maschinenlesbarkeit/ (abgerufen 2026-07-28)
31. [V] IETF AIPREF Working Group — https://datatracker.ietf.org/wg/aipref/about/ (abgerufen 2026-07-28)
32. [S] Capsolver: Crawl4AI vs Firecrawl 2026 — https://www.capsolver.com/blog/AI/crawl4ai-vs-firecrawl
33. [V] The Menon Lab: PDF-to-Markdown-Tools 2026 (Marker/Docling/MinerU/PyMuPDF4LLM) — https://themenonlab.blog/blog/best-open-source-pdf-to-markdown-tools-2026 (abgerufen 2026-07-28)
34. [S] OmniDocBench (CVPR 2025) — https://github.com/opendatalab/OmniDocBench
35. [S] MarkTechPost: Marker v2 Benchmark (2026-07-24) — https://www.marktechpost.com/2026/07/24/datalab-marker-v2-vs-mineru-docling-and-liteparse-benchmark-breakdown/
36. [V] changedetection.io (GitHub) — https://github.com/dgtlmoon/changedetection.io (abgerufen 2026-07-28)
37. [S] Brown et al.: Web scraping for research — Legal, ethical, institutional, and scientific considerations (Big Data & Society, 2025) — https://journals.sagepub.com/doi/10.1177/20539517251381686
38. [S] Questionmark Devs: Scrapy + WACZ-Archivierung — https://developers.thequestionmark.org/2025/02/06/scrapy-webarchive-introduction
39. [S] Scrapfly: Web Scraping Best Practices — https://scrapfly.io/blog/posts/web-scraping-best-practices
