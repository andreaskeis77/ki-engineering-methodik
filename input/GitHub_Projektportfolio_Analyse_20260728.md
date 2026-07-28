# Analyse des GitHub-Projektportfolios von Andreas

## Anwendungslandschaft, Reifegrad, Komplexität und Arbeitsweise im Kontext einer KI-nativen Engineering-Methodik

**Analysestichtag:** 28. Juli 2026  
**GitHub-Konto:** [`andreaskeis77`](https://github.com/andreaskeis77)  
**Umfang:** 11 öffentlich sichtbare, selbst verantwortete Repositories  
**Zweck:** Verständnis des realen Anwendungskontexts für den Forschungsauftrag „KI-native Software- und Systems-Engineering-Methodik“

---

# 1. Auftrag und Ziel dieser Analyse

Diese Analyse betrachtet das gesamte aktuell sichtbare GitHub-Projektportfolio von Andreas nicht primär als Methodikvergleich, sondern als **empirischen Anwendungskontext** für den übergeordneten Forschungsauftrag.

Untersucht werden insbesondere:

- welche Arten von Software- und Systems-Engineering-Projekten bereits entstanden sind,
- welche fachlichen Probleme damit gelöst werden,
- wie groß und komplex die Projekte tatsächlich sind,
- welche Entwicklungs- und Betriebsmodelle verwendet werden,
- wie weit die Projekte vom Konzept bis zum produktiven Betrieb gereift sind,
- welche wiederkehrenden Architektur-, Daten-, Qualitäts- und Betriebsprobleme auftreten,
- wie Andreas heute mit KI-Agenten arbeitet,
- welche Anforderungen sich daraus an eine zukünftige KI-native Engineering-Methodik ergeben.

Alle Projekte sind private, nicht kommerzielle Vorhaben. „Produktiv“ bedeutet in diesem Bericht daher nicht marktfähig oder kommerziell skalierbar, sondern:

> Das System wird im vorgesehenen privaten Nutzungskontext real betrieben, liefert einen stabilen Nutzen und besitzt einen nachvollziehbaren Betriebs-, Änderungs- und Wiederherstellungspfad.

---

# 2. Untersuchungsbasis und Grenzen

## 2.1 Analysierte Repositories

Zum Analysestichtag waren folgende elf Repositories des Kontos sichtbar:

1. [`boxscore`](https://github.com/andreaskeis77/boxscore)
2. [`capsule`](https://github.com/andreaskeis77/capsule)
3. [`capsule-app`](https://github.com/andreaskeis77/capsule-app)
4. [`curio`](https://github.com/andreaskeis77/curio)
5. [`fritz_old`](https://github.com/andreaskeis77/fritz_old)
6. [`funkatlas`](https://github.com/andreaskeis77/funkatlas)
7. [`joes-journal`](https://github.com/andreaskeis77/joes-journal)
8. [`new_nfl`](https://github.com/andreaskeis77/new_nfl)
9. [`server-migration`](https://github.com/andreaskeis77/server-migration)
10. [`tischatlas`](https://github.com/andreaskeis77/tischatlas)
11. [`wlan`](https://github.com/andreaskeis77/wlan)

## 2.2 Ausgewertete Evidenz

Die Analyse stützt sich auf:

- Repository-Metadaten und Sichtbarkeit,
- README-Dateien,
- `PROJECT_STATE`-, Architektur-, Roadmap- und Betriebsdokumente,
- `CLAUDE.md` und vergleichbare operative Projektverfassungen,
- aktuelle und jüngere Commit-Beschreibungen,
- Pull Requests und deren Beschreibungen,
- dokumentierte Testzahlen, Quality Gates und Release-Stände,
- dokumentierte Deployment-, Backup-, Restore- und Sicherheitsmodelle.

Wichtige Primärbelege sind im Bericht direkt verlinkt.

## 2.3 Nicht Bestandteil dieser Analyse

Nicht durchgeführt wurden:

- vollständige lokale Klonung und Ausführung aller Repositories,
- unabhängige Reproduktion aller Testläufe,
- vollständiger Line-by-Line-Code-Review,
- Penetrationstest,
- vollständiger Secret- oder Datenschutz-Audit,
- Prüfung der realen Erreichbarkeit aller produktiven Systeme,
- Bewertung der Korrektheit jeder fachlichen Berechnung.

Die dokumentierten Testergebnisse und Betriebszustände wurden daher als Repository-Evidenz bewertet, nicht als unabhängig reproduzierte Zertifizierung.

---

# 3. Executive Summary

Das Portfolio ist deutlich anspruchsvoller als eine Sammlung kleiner Hobby-Skripte. Es bildet bereits eine **private, KI-gestützt entwickelte Anwendungs- und Systemlandschaft** mit mehreren unterschiedlichen Systemklassen:

- produktive Webanwendungen,
- datenintensive Analyseplattformen,
- Wissens- und Provenance-Systeme,
- lokale Sensor- und Monitoring-Anwendungen,
- Infrastruktur- und Migrationsprojekte,
- ein beginnendes mobiles Frontend.

Die Projekte decken fast alle Themen des geplanten Forschungsauftrags bereits praktisch ab:

- Requirements und Architektur,
- autonome Agentenarbeit,
- Dateningestion und Quellenadapter,
- relationale Datenbanken und DuckDB,
- Ontologien und Taxonomien,
- Provenance und versioniertes Wissen,
- Web- und UI-Engineering,
- CI, Tests und Quality Gates,
- Windows-Deployment,
- Tailscale und Cloudflare,
- Backups und Restore-Drills,
- Kosten- und Modell-Evaluationen,
- experimentelle Entwicklung,
- mobile App-Entwicklung.

## 3.1 Zentrale Erkenntnis

Die zukünftige Methodik darf nicht für „ein typisches Projekt“ optimiert werden. Das Portfolio enthält mindestens vier deutlich verschiedene Archetypen:

1. **Interaktive private Produkte**  
   Beispiel: Capsule, Joe’s Journal, Tischatlas.

2. **Daten- und Wissensplattformen**  
   Beispiel: Boxscore, New NFL, Curio.

3. **Lokale Sensorik und technische Diagnosesysteme**  
   Beispiel: Fritz, WLAN, FunkAtlas.

4. **Infrastruktur- und Transformationsvorhaben**  
   Beispiel: Server Migration.

Hinzu kommt mit `capsule-app` ein fünfter, noch früher Archetyp:

5. **Mobiler Companion zu einem bestehenden Backend**

Eine professionelle KI-native Methodik muss daher **skalierbar und archetypabhängig** sein. Ein einheitlicher Prozess mit gleicher Dokumentations- und Gate-Tiefe für alle Projekte wäre ungeeignet.

## 3.2 Reifegrad des Portfolios

Das Portfolio reicht vom reinen Fundament bis zu weitgehend autonom betriebenen Systemen:

- **Sehr hohe Produkt- und Betriebsreife:** `boxscore`, `capsule`, `joes-journal`, `curio`
- **Hohe technische Plattformreife, aber teilweise noch begrenzte Nutzerprodukterfahrung:** `new_nfl`
- **Aktive Entwicklung auf dem Weg zum nutzbaren Produkt:** `tischatlas`, `funkatlas`
- **Code- oder Build-Prototyp mit noch nicht abgeschlossener Realabnahme:** `wlan`
- **Legacy-/Lernprojekt:** `fritz_old`
- **Früher Mobile-Prototyp:** `capsule-app`
- **Planungs- und Guardrail-Fundament:** `server-migration`

## 3.3 Stärkste wiederkehrende Fähigkeiten

Besonders ausgeprägt sind:

- dokumentierte Architekturentscheidungen,
- explizite Wahrheitshierarchien,
- nachvollziehbare Datenherkunft,
- Adapter- und Contract-Denken,
- Test-first- und Red-Green-Arbeit,
- harte Quality Gates,
- private-first Betriebskonzepte,
- Windows-/PowerShell-Operationalisierung,
- Tailscale-gestützter Admin-Zugang,
- kontrollierte KI-Agentenautonomie,
- Backup- und Wiederherstellungsdenken,
- experimentelle Modell- und Kostenvergleiche.

## 3.4 Wichtigste wiederkehrende Schwächen

Die größten portfolioweiten Probleme sind:

- starke Dokumentationsdrift bei schneller Agentenentwicklung,
- mehrere sich überholende Projektgenerationen ohne konsequente Archivierung,
- inkonsistente Versionierungs- und Releasepraktiken,
- teilweise überproportional umfangreiche Governance für kleine Projektphasen,
- fehlende gemeinsame Portfolio-Steuerung,
- ungleichmäßige UI- und Mobile-Testreife,
- Abhängigkeit von nativen Windows-Betriebsdetails,
- mehrere Repositories mit sensiblen Infrastrukturdetails, die nur vorübergehend öffentlich sein sollten,
- punktuell sehr hohe technische Reife bei gleichzeitig noch nicht vollständig geklärtem Nutzerwert.

---

# 4. Reifegradmodell für diese Analyse

Zur Einordnung wird ein bewusst einfaches sechsstufiges Modell verwendet.

| Stufe | Bezeichnung | Bedeutung |
|---|---|---|
| **M0** | Idee | Problem und erste Produktidee, noch keine belastbare Struktur |
| **M1** | Governed Concept | Anforderungen, Architektur, Entscheidungen und Roadmap sind strukturiert |
| **M2** | Executable Foundation | ausführbares Gerüst, Tests, Gates und erste vertikale Funktionen |
| **M3** | Usable Product | reales Produktverhalten und echter privater Nutzwert sind vorhanden |
| **M4** | Operated Product | stabiler Betrieb, Deployment, Security, Backup und Runbooks sind vorhanden |
| **M5** | Autonomous System | wiederkehrende Abläufe, Verifikation, Deployment oder Inhalte laufen weitgehend automatisch |

Die Stufe bewertet nicht die kommerzielle Marktreife, sondern die Eignung für den beabsichtigten privaten Betrieb.

---

# 5. Portfolioübersicht

| Repository | Fachlicher Zweck | Haupttechnologien | Reifegrad | Aktueller Charakter |
|---|---|---|---:|---|
| **boxscore** | private NFL-Wissens- und Vorhersageplattform | Python, DuckDB, Astro, TypeScript, Playwright, PowerShell | **M5** | produktiv, weitgehend automatisiert, P5/P6-Härtung |
| **capsule** | Wardrobe-, Ontologie-, Ingest- und Beratungsplattform | Python, FastAPI, Flask/Jinja, SQLite, OpenAI, PowerShell | **M4+** | produktiv, sehr funktionsreich, v2-Härtung |
| **capsule-app** | mobile Wardrobe-App gegen Capsule-API | Expo, React Native, TypeScript | **M1–M2** | früher funktionsfähiger Prototyp |
| **curio** | persönlicher, quellengestützter Wissenskompiler | Python, SQLite, FastAPI, Markdown, LLM-Provider | **M4** | MVP live, Provenance- und Review-fokussiert |
| **fritz_old** | erste Heimnetz-Diagnoseplattform | Python, SQLite, FastAPI | **M1–M2** | Legacy-Gerüst und Architekturvorläufer |
| **funkatlas** | Multi-Netz-WLAN-Analyse im Haus | Python, SQLite, lokale Probes, Windows | **M2** | aktive Nachfolgegeneration, M1-Abnahme offen |
| **joes-journal** | privates Gastro- und Restaurantjournal | Astro, TypeScript, Directus, PostgreSQL, IIS | **M4** | produktiv mit Redaktion und Auto-Rebuild |
| **new_nfl** | robuste NFL-Datenplattform | Python, DuckDB, Scheduler, FastAPI/CLI, PowerShell | **M4 technisch** | hochreife Datenplattform, Produktfokus schwächer |
| **server-migration** | sichere Migration Windows-VPS → Linux | PowerShell, Python, Inventarisierung, Guardrails | **M1** | P0-Planung und sichere Discovery |
| **tischatlas** | Restaurant-, Menü- und Quellenarchiv | Django, SQLite, uv, Playwright, axe | **M2→M3** | P1 als Draft-PR weitgehend implementiert |
| **wlan** | lokaler WLAN-/DSL-Sensor mit Dashboard und EXE | Python, SQLite, FastAPI, APScheduler, PyInstaller | **M2–M3 unklar** | code-/build-seitig weit, Realabnahme fehlt |

---

# 6. Einzelanalyse der Projekte

# 6.1 `boxscore`

## Produktidee

`boxscore` ist eine private, selbst gehostete NFL-Wissensplattform im Wiki-Stil. Das System verbindet:

- historische und aktuelle NFL-Daten,
- automatisch erzeugte Wochenrückblicke,
- Team- und Spielerseiten,
- Playoff-Simulationen,
- eigene Vorhersagemodelle,
- Experten- beziehungsweise Marktvergleich,
- eine statisch generierte Website,
- automatisierten Wochenbetrieb.

Die operative Projektverfassung beschreibt das System als Astro-SSG mit lokaler DuckDB und maximal automatisiertem Betrieb auf dem Windows-VPS.  
Quelle: [`CLAUDE.md`](https://github.com/andreaskeis77/boxscore/blob/main/CLAUDE.md)

## Architektur und Technik

- Python-Ingestion und Analyse
- DuckDB als alleinige Datenbank
- Medallion-ähnliche Datenverarbeitung
- Astro und TypeScript als statisches Webfrontend
- generierte Inhalte als versionierte Markdown-/JSON-Dateien
- Playwright, axe, Link-Checks und Performancebudgets
- PowerShell für Betrieb und Deployment
- Staging und Produktion als getrennte Verzeichnisse
- self-hosted GitHub-Actions-Runner auf dem VPS
- Tailscale-basierter Zugriff

Der dokumentierte Produktzustand `0.8.3` nennt unter anderem:

- 28 Saisons von 1999 bis 2026,
- 7.548 Spiele,
- rund 476.000 wöchentliche Spielerstatistikzeilen,
- über 11.000 generierte Seiten,
- vollständige Recaps für 2024 und 2025,
- Elo- und Monte-Carlo-Vorhersagen,
- Health Checks,
- Backup und Restore-Probe,
- Alerting,
- Auto-Deploy-Kette.

Quelle: [`product-state.json`](https://github.com/andreaskeis77/boxscore/blob/main/product-state.json)

## Reifegrad

**M5 – Autonomous System**

`boxscore` ist das im Portfolio am stärksten auf autonome Produkt- und Betriebsabläufe ausgerichtete Projekt. Es besitzt:

- Dateningestion,
- Modellberechnung,
- KI-Content-Generierung,
- Faktenverifikation,
- statischen Build,
- Staging,
- Smoke-Test,
- Promotion,
- Backup,
- Monitoring,
- wöchentlichen Betriebszyklus.

## Besondere Stärke

Das Projekt hat eine wichtige Erfahrung aus `new_nfl` explizit verarbeitet:

> Nicht zunächst jahrelang eine Datenplattform perfektionieren, sondern einen sichtbaren End-to-End-Vertical-Slice bauen.

Diese Experience-first-Entscheidung ist eine zentrale methodische Erkenntnis für den Forschungsauftrag.

## Risiken und offene Punkte

- Die Auto-Merge-/Auto-Deploy-Ambition ist hoch und verlangt sehr robuste Sicherheitsgrenzen.
- Ein aktueller Audit-Commit benannte die Kombination **öffentliches Repository + self-hosted Runner** als Blocker.
- Die Dokumente enthalten Betriebsnamen und interne Topologieinformationen.
- Das Projekt besitzt eine sehr umfangreiche eigene Governance und könnte zur Überoptimierung neigen.
- Die automatische redaktionelle Veröffentlichung ohne menschliches Review funktioniert nur, weil Zahlen- und Quellenclaims streng verifiziert werden. Qualitative Fehlurteile bleiben schwieriger prüfbar.
- `product-state.json` lag zuletzt bei `0.8.3`, während neuere Härtungs-Commits bereits weitergehen. Der maschinenlesbare Produktstand muss konsequent mitgezogen werden.

## Bedeutung für die künftige Methodik

`boxscore` ist der wichtigste Referenzfall für:

- agentengetriebene Vollautomatisierung,
- Evidence Chains,
- KI-generierte Inhalte mit Fakten-Gates,
- autonomes Deployment,
- Kosten-Caps,
- parallele Agentenarbeit,
- produktorientierte Vertical Slices,
- Daten- und Textwahrheiten in getrennten Systemen of Record.

---

# 6.2 `capsule`

## Produktidee

Capsule beziehungsweise Wardrobe Studio ist ein lokal entwickeltes Wardrobe-, Ontologie-, Ingest- und Beratungssystem. Das Projekt verwaltet einen realen Kleidungsbestand und umfasst:

- strukturierte Kleidungsstücke pro Nutzer,
- Bilder und Metadaten,
- Ontologie- und Taxonomiezuordnung,
- Webdashboard und Adminoberfläche,
- API-Zugriff,
- Batch- und Foto-Ingest,
- KI-gestützte Analyse,
- Kostenbeobachtung,
- Custom-GPT-Integration,
- parallele Entwicklung einer mobilen App.

Quelle: [`README.md`](https://github.com/andreaskeis77/capsule/blob/main/README.md)

## Architektur und Technik

- Python
- FastAPI als API
- historisch zusätzlich Flask-/Dashboard-Schichten
- SQLite
- HTML/Jinja-Templates
- Ontologieverzeichnis und Mappings
- OpenAI-Modelle für Foto- und Beratungsfunktionen
- Windows-VPS
- Cloudflare Tunnel
- Tailscale für Adminzugriff
- GitHub Actions
- PowerShell-Deployment
- umfangreiche Runbooks und Handover-Dokumente

Der aktuelle Projektstatus beschreibt eine Codeversion `2.0.0-dev`, während ein historischer Release-Marker `v1.1.22` und nur ein Git-Tag `v0.1.0` existieren.  
Quelle: [`docs/PROJECT_STATE.md`](https://github.com/andreaskeis77/capsule/blob/main/docs/PROJECT_STATE.md)

## Reifegrad

**M4+ – Operated Product mit hohem Funktionsumfang**

Capsule ist real genutzt, produktiv betrieben und besitzt:

- API und Webzugriff,
- echten Datenbestand,
- Security- und Quality-Gates,
- dokumentierte Betriebs- und Recovery-Pfade,
- reale KI-Kosten,
- wiederholte Datenimporte,
- Produktionshärtung.

## Besondere Stärke

Capsule ist der reichhaltigste Referenzfall für die **evolutionäre Entwicklung eines KI-gestützten Privatprodukts**. Das Projekt enthält reale Lernschleifen zu:

- Modellvergleich,
- Bildanalyse,
- Batch-Ingest,
- Kostenmessung,
- Datenkorrekturen,
- Ontologien,
- API-Verträgen,
- Datenhygiene,
- produktiver KI-Integration.

Die dokumentierten Model-Evaluationen sind besonders wertvoll. Modelle wurden nicht nur nach subjektiver Qualität ausgewählt, sondern anhand echter Bildordner, Ground Truth, Kosten und Fehlertypen verglichen.

## Technische Schulden und Risiken

Das eigene v2-Review benennt offen:

- fehlende beziehungsweise historisch unvollständige UI-Gates,
- mehrere Wahrheiten für Bilder,
- Ontologie-Drift,
- fehlende Idempotenz und Provenienz in älteren API-Pfaden,
- 54 Shim-Dateien,
- doppelte Modulstrukturen,
- Dashboard-zu-API-Loopback statt gemeinsamem Service Layer,
- unvollständige frühere Betriebsresilienz,
- inkonsistente Versionsstrategie.

Diese Offenheit ist positiv. Sie zeigt jedoch auch, dass die frühe agentengestützte Funktionsentwicklung schneller war als die Architektur- und Betriebsdisziplin.

## Bedeutung für die künftige Methodik

Capsule ist der wichtigste Referenzfall für:

- Brownfield-Härtung,
- technische Schuld nach schneller KI-Entwicklung,
- Ontologien und Taxonomien,
- multimodale KI,
- Kosten- und Modellevaluation,
- Datenmigration und Datenhygiene,
- API-Vertrag als gemeinsame Basis für Web und App,
- Umgang mit echten privaten Nutzerdaten.

---

# 6.3 `capsule-app`

## Produktidee

`capsule-app` ist die mobile Ergänzung zu Capsule. Die jüngsten Commits zeigen:

- Wardrobe-Browser,
- Listen- und Detaildarstellung gegen die Capsule-API,
- Tab-Navigation,
- Dashboard,
- Suche und Filter,
- redaktionelles Redesign.

Das Projekt basiert auf Expo und React Native.

## Architektur und Technik

- Expo SDK 54
- React Native 0.81
- React 19
- TypeScript
- Expo Router
- React Navigation
- Expo Image
- Google Fonts
- Android-, iOS- und Web-Startpfade

Quelle: [`package.json`](https://github.com/andreaskeis77/capsule-app/blob/main/package.json)

## Reifegrad

**M1–M2 – früher funktionsfähiger Prototyp**

Die App besitzt bereits konkrete Funktionen. Die Engineering-Reife ist jedoch klar niedriger als beim Backend:

- README ist noch weitgehend das generische Expo-Template.
- Es sind nur wenige Commits vorhanden.
- Im `package.json` ist nur Linting als Quality-Script sichtbar.
- Unit-, Integrations-, UI-, Emulator- oder End-to-End-Tests sind nicht erkennbar.
- Eine dokumentierte Release-, Signing-, Distribution- oder Offline-Strategie fehlt.
- Die Verbindung zum kanonischen API-Vertrag ist fachlich vorhanden, aber nicht als automatisierter Contract-Test belegt.

## Bedeutung für die künftige Methodik

`capsule-app` ist der zentrale Ausgangspunkt für den Forschungsstrang:

- Android-Entwicklung,
- Cross-Platform-Entscheidungen,
- mobile UI-Tests,
- Emulator- und Device-Farm-Tests,
- API-Contract-Tests,
- interne App-Distribution,
- mobile Freigabeprozesse,
- Offline- und Synchronisationsstrategien.

Die App zeigt zugleich, dass die heutige Methodik für Web- und Backend-Projekte weiter entwickelt ist als für Mobile.

---

# 6.4 `curio`

## Produktidee

Curio ist ein persönliches, quellengestütztes Wissenssystem. Es versteht sich ausdrücklich nicht als Chatbot mit Speicher und nicht als bloßes RAG-System, sondern als:

> versionierter Wissenskompiler, der aus Quellen, Notizen, Daten und Beobachtungen stabile Wissensobjekte erzeugt.

Quelle: [`README.md`](https://github.com/andreaskeis77/curio/blob/main/README.md)

Die Architektur umfasst:

- Capture,
- unveränderliches Roharchiv,
- Extraktion,
- Registry,
- LLM-Proposals,
- Human Review,
- Markdown-Wiki,
- Read Models,
- Suche und Browse-UI.

## Architektur und Technik

- Python
- SQLite mit Registry- und Audit-Tabellen
- Markdown als publiziertes Wissensformat
- FastAPI und Jinja
- Mock-, Anthropic- und OpenAI-Modi
- strukturierte Scouts für Updates
- Golden Evaluations
- Bundle-Build
- Windows-VPS
- WinSW-Service
- Cloudflare Tunnel
- Backup und Restore-Drill

Der dokumentierte Stand nennt Version `0.9.0-pilot-content`, Live-Betrieb und 286 Tests.  
Quelle: [`docs/PROJECT_STATE.md`](https://github.com/andreaskeis77/curio/blob/main/docs/PROJECT_STATE.md)

## Reifegrad

**M4 – Operated Product**

Der MVP ist technisch und betrieblich abgeschlossen. Pilotinhalte sind live, die Update-Scout-Mechanik ist implementiert, und der Betrieb besitzt Backup- und Wiederherstellungsevidenz.

## Besondere Stärke

Curio ist der stärkste Portfoliofall für:

- Quellenprovenienz,
- Claim- und Proposal-Modell,
- Human-in-the-Loop-Review,
- unveränderliche Rohdaten,
- Hashes und Receipts,
- Freshness,
- kontrollierte Wissenssynthese,
- versioniertes Markdown,
- Trennung von Rohquelle, Vorschlag und publizierter Wahrheit.

Das Projekt ist damit unmittelbar relevant für den Forschungsauftrag zu:

- Ontologien,
- Wissensgraphen,
- Provenance,
- RAG-Alternativen,
- Quellenbewertung,
- Aktualisierung von Wissen,
- Agentenänderungen mit Review.

## Dokumentationsproblem

Das Statusdokument enthält widersprüchliche Aussagen:

- am Anfang: MVP vollständig live,
- später in einer alten Aufzählung: Live-VPS-Deployment existiere noch nicht,
- anschließend erneut: Deployment und Restore-Drill seien abgeschlossen.

Der reale spätere Abschnitt ist plausibel aktueller, die veraltete Aussage wurde aber nicht entfernt. Dies ist ein typisches Beispiel für **additiv fortgeschriebene Statusdokumente, die intern widersprüchlich werden**.

## Bedeutung für die künftige Methodik

Curio sollte als Referenzarchitektur für den gesamten Forschungsstrang „Daten, Wissen, Ontologie und Provenance“ dienen.

---

# 6.5 `fritz_old`

## Produktidee

`fritz_old` ist die erste Generation einer lokalen Diagnoseplattform für das Heimnetz. Ziel war, nicht nur einzelne Speedtests durchzuführen, sondern kontinuierlich technische Messdaten zu sammeln und Ursachen unterscheiden zu können:

- Provider-/DSL-Probleme,
- WLAN- oder Mesh-Backhaul,
- Client-Roaming,
- lokale Upload-Last.

Quelle: [`README.md`](https://github.com/andreaskeis77/fritz_old/blob/main/README.md)

## Architektur und Technik

- Python 3.12
- FastAPI-Statusseite
- SQLite/WAL
- geplante TR-064-Adapter
- aktive Messungen über Ping, Speedtest und iperf3
- Medallion-Modell `raw → staging → marts`
- Adapter-Contracts
- lokaler Windows-Betrieb
- hermetische Tests
- Secret-Scan

Das technische Konzept ist fachlich umfangreich und recherchiert verschiedene Open-Source-Alternativen.  
Quelle: [`docs/TECHNISCHES_KONZEPT.md`](https://github.com/andreaskeis77/fritz_old/blob/main/docs/TECHNISCHES_KONZEPT.md)

## Reifegrad

**M1–M2 – Governed Concept / Executable Foundation**

Das README beschreibt P0 mit Paket, Schema, Statusseite und Quality Gate, aber noch ohne echten Gerätezugriff oder Dauerdienst.

## Bedeutung

Das Projekt ist weniger als aktuelles Produkt wichtig, sondern als **Architektur- und Lernvorläufer**. Daraus wurden später übernommen:

- Medallion-Schichten,
- Adapter-Contracts,
- deterministische Diagnose,
- 1-Writer-Prinzip,
- Backup als Nachweis,
- PII-Hashing,
- read-only Routerzugriff.

## Problem

Das Repository heißt weiterhin `fritz_old`, ist aber nicht als archiviert markiert. Seine Rolle als historischer Vorläufer ist in den Nachfolgern dokumentiert, auf Portfolioebene jedoch nicht formal geregelt.

---

# 6.6 `wlan`

## Produktidee

`wlan` ist die zweite Generation der Heimnetzüberwachung. Es soll als Windows-Anwendung beziehungsweise `wlan.exe` dauerhaft laufen und:

- FRITZ!Box und Repeater read-only auslesen,
- aktive Latenzprobes durchführen,
- Daten in SQLite und zeitgestempelte Logs schreiben,
- ein lokales Dashboard und Tray bereitstellen,
- beim Login automatisch starten.

Quelle: [`README.md`](https://github.com/andreaskeis77/wlan/blob/main/README.md)

## Architektur und Technik

- Python 3.12
- `fritzconnection` / TR-064
- SQLite/WAL
- FastAPI auf Loopback
- APScheduler
- PyInstaller
- lokale Web-UI
- System Tray
- PowerShell-Task-Runner
- CI, Dependabot und Secret-Scan

## Reifegrad

**M2–M3, aber operativ nicht verlässlich bestimmbar**

Das Statusdokument behauptet einerseits:

- P0 bis P5 abgeschlossen,
- 50 Tests grün,
- `wlan.exe` erfolgreich gebaut,
- Dashboard, Tray und Autostart vorhanden.

Im Abschnitt „Bekannte Lücken“ steht dagegen, dieselben Komponenten seien noch geplant und nicht gebaut.  
Quelle: [`docs/PROJECT_STATE.md`](https://github.com/andreaskeis77/wlan/blob/main/docs/PROJECT_STATE.md)

Diese interne Inkonsistenz verhindert eine belastbare Einstufung. Zusätzlich fehlt die reale Abnahme gegen die echte FRITZ!Box.

## Bedeutung

`wlan` zeigt zwei typische Probleme agentengetriebener Entwicklung:

1. **Code-Fortschritt kann Statusdokumente überholen.**
2. **Hermetisch grüne Tests ersetzen keine Realumgebungsabnahme.**

## Portfolioentscheidung

Da `funkatlas` ausdrücklich Nachfolger ist, sollte `wlan` entweder:

- als abgeschlossene technische Zwischenstufe archiviert werden, oder
- mit einem eindeutigen Abschlussstatus versehen werden.

Ein dritter parallel weiterentwickelter Netzwerkmonitor wäre nicht sinnvoll.

---

# 6.7 `funkatlas`

## Produktidee

FunkAtlas ist die dritte Generation und erweitert die Perspektive von einem einzelnen FRITZ!-Netz auf eine **Multi-Netz-Analyseplattform** für das Haus:

- Telekom-DSL-/FRITZ!-Netz,
- separates 5G-/Netgear-/FRITZ!-Netz,
- mehrere Probes auf verschiedenen Geräten,
- später Android-Probes,
- zentrale Korrelation,
- Vorher-/Nachher-Experimente bei Optimierungen.

Quelle: [`docs/PROJECT_STATE.md`](https://github.com/andreaskeis77/funkatlas/blob/main/docs/PROJECT_STATE.md)

## Architektur und Technik

- Python 3.12
- verteilte Probe-Logik
- SQLite
- `netsh`-basierte WLAN-Messung
- Ping und DNS
- Supervisor und Nachtlauf
- Heartbeat und Device-ID
- hermetische Standardtests
- Live-Netzwerktests opt-in
- read-only Routerprinzip
- CI und Git-Hooks

## Reifegrad

**M2 – Executable Foundation**

M0 ist abgeschlossen. M1 ist code-seitig fertig und besitzt einen grünen Live-Smoke. Offen sind:

- Energieprofil-Checkliste,
- eine vollständige Nachtmessung,
- operative Abnahme.

Der dokumentierte Stand nennt 86 Tests und mehrere Review-Panels.

## Besondere Stärke

FunkAtlas ist ein guter Referenzfall für **experimentelles Systems Engineering**:

- Messhypothesen,
- verteilte Sensoren,
- reale Hardware,
- Vorher-/Nachher-Messungen,
- hermetische Tests versus Live-Tests,
- lange Laufzeiten,
- Geräteidentität,
- Ausfall- und Timeoutverhalten.

## Bedeutung für die künftige Methodik

Dieses Projekt benötigt andere Gates als eine Webanwendung. Die Methodik muss unterstützen:

- Hardware-in-the-Loop,
- Langzeittests,
- opt-in Netzwerktests,
- Betrieb auf mehreren Endgeräten,
- verteilte Messdaten,
- unvollständige oder firmwareabhängige Schnittstellen,
- experimentelle Abnahme.

---

# 6.8 `joes-journal`

## Produktidee

Joe’s Journal ist eine private Gastro-Plattform für „Zum Fettigen Joe“:

- Restaurant- und Küchenerlebnisse,
- Cocktails,
- Artikel,
- Bilder und Galerien,
- persönlicher redaktioneller Stil,
- private Veröffentlichung.

Quelle: [`README.md`](https://github.com/andreaskeis77/joes-journal/blob/main/README.md)

## Architektur und Technik

- Astro 5 mit TypeScript
- statische Generierung
- Directus 11 als CMS
- SQLite lokal, PostgreSQL produktiv
- Vitest
- Playwright und axe
- Design Tokens
- IIS auf Windows-VPS
- Cloudflare Tunnel und Access
- Tailscale-Admin
- automatische Rebuilds nach Inhaltsänderungen
- Backupskripte

Der dokumentierte Betriebsstand beschreibt eine reale Live-Inbetriebnahme, Directus-Administration und automatischen Poll-Rebuild.  
Quelle: [`docs/DEPLOY_STATE.md`](https://github.com/andreaskeis77/joes-journal/blob/main/docs/DEPLOY_STATE.md)

## Reifegrad

**M4 – Operated Product**

Das System ist produktiv nutzbar. Besonders relevant sind:

- private Access-Schicht,
- echte redaktionelle Oberfläche,
- statisches, robustes Frontend,
- automatische Inhaltsaktualisierung,
- Bild- und Galeriehandling,
- Produktionsdatenbank.

## Besondere Stärke

Joe’s Journal ist ein sehr guter Fall für:

- Experience-first-Entwicklung,
- Designsysteme,
- redaktionelle UX,
- Trennung von CMS und statischem Frontend,
- private Veröffentlichung,
- Content-Build-Pipelines.

Es diente später ausdrücklich als Blaupause für `boxscore`.

## Risiken und Betriebsprobleme

- Die Dokumentation enthält konkrete öffentliche IP-, Host-, E-Mail- und Servicenamen.
- Das Repo musste auf dem VPS teilweise in administrativer PowerShell betrieben werden, weil Dateirechte ungünstig gesetzt waren. Das ist ein operativer Geruch.
- RDP-Härtung und externe Backup-Automatisierung waren im letzten dokumentierten Stand noch offen.
- Directus, PostgreSQL, IIS, Cloudflare und Scheduled Tasks ergeben für ein privates Produkt bereits eine relativ große Betriebsfläche.

## Bedeutung für die künftige Methodik

Joe’s Journal ist die wichtigste Referenz für:

- visuelle Produktqualität,
- redaktionelle Systeme,
- CMS-Integration,
- Design Tokens,
- UI- und Accessibility-Tests,
- Content Deployment.

---

# 6.9 `new_nfl`

## Produktidee

New NFL ist eine robuste private NFL-Datenplattform mit:

- metadata-driven Ingestion,
- Source-Adaptern,
- Raw Landing,
- Staging,
- Core- und Mart-Schichten,
- Scheduler,
- Observability,
- Provenance,
- Backup und Replay,
- lokaler und VPS-basierter Analyseoberfläche.

Quelle: [`README.md`](https://github.com/andreaskeis77/new_nfl/blob/main/README.md)

## Architektur und Technik

- Python
- DuckDB
- CLI und Plugin-Registry
- zahlreiche Datenquellen und Slices
- Scheduler über Windows Scheduled Tasks
- Health-Probes
- Backup und Restore
- Datenprovenienz
- Network-Smokes getrennt von Standardtests
- umfangreiche ADRs und Handover-Dokumentation

Der Status nennt:

- 490 grüne Tests,
- 8 separate Netzwerktests,
- 7 primäre Datenslices,
- tägliche Scheduled Tasks,
- vier grüne Betriebstage,
- realen Backup-/Restore-Drill,
- `v1.0.0-laptop`,
- Migration auf den VPS.

Quelle: [`docs/PROJECT_STATE.md`](https://github.com/andreaskeis77/new_nfl/blob/main/docs/PROJECT_STATE.md)

## Reifegrad

**M4 technisch – hochreife Plattform, Produktreife darunter**

Technisch ist `new_nfl` sehr weit:

- Datenpipelines,
- Scheduler,
- Provenance,
- Health,
- Backup,
- Wiederherstellung,
- Tests,
- reale Betriebsvalidierung.

Gleichzeitig wird es in `boxscore` selbst als Beispiel dafür genannt, wie man in Ingestion und Plattformbau steckenbleiben kann, ohne schnell genug ein sichtbares Produkt zu liefern.

## Besondere Stärke

Das Projekt ist ein ausgezeichneter Referenzfall für:

- metadata-driven Architecture,
- Datenpipeline-Design,
- Schema-Drift,
- bitemporale Modellierung,
- Plugin-Registries,
- Replay und Determinismus,
- Betriebsbeobachtung,
- Long-running Agent Work.

## Zentrale Lehre

Technische Plattformreife ist nicht identisch mit Produktreife.

Die künftige Methodik muss daher sicherstellen:

- Jede Datenplattform besitzt früh einen echten Nutzer-Vertical-Slice.
- Infrastrukturarbeit wird am sichtbaren Nutzen gespiegelt.
- Datenbreite wird nicht zum Selbstzweck.
- Ein Reifegradmodell trennt Plattform-, Produkt- und Betriebsreife.

---

# 6.10 `server-migration`

## Projektidee

`server-migration` ist kein Nutzerprodukt, sondern ein Systems-Engineering-Vorhaben zur möglichen Migration eines produktiv genutzten Windows-VPS auf Linux.

Das Projekt beginnt bewusst nicht mit Migration, sondern mit:

- Inventarisierung,
- Performancebaseline,
- Guardrails,
- Risikoanalyse,
- Zieloptionen,
- reproduzierbarer Discovery.

Quelle: [`README.md`](https://github.com/andreaskeis77/server-migration/blob/main/README.md)

## Architektur und Arbeitsmodell

- PowerShell-Inventarisierung
- Python-Secret-Scan
- rohe, gitignorierte Inventare
- freigegebene bereinigte Daten
- maschinell ableitbare Dokumentation
- strikte Arbeitsverzeichnisgrenzen
- Claude-Code-Permissions
- Negativtests der Guardrails
- keine Agenten-Elevation
- menschliche Kontrolle über Veröffentlichung
- 72-Stunden-Performancebaseline

## Reifegrad

**M1 – Governed Concept**

Es wurde noch nichts migriert. Der Wert liegt in der professionellen Vorbereitung und der getesteten Begrenzung des Agenten.

## Besondere Stärke

Das Projekt ist der stärkste Fall für **KI-Agenten auf einer produktiven Infrastruktur mit realem Schadenspotenzial**.

Besonders relevant sind:

- Nicht-Admin-Ausführung als echte OS-Grenze,
- Deny-Regeln nur als zweite Verteidigung,
- Arbeitsraumisolation,
- Negativtests,
- getrennte Roh- und freigegebene Inventare,
- menschliche Freigabe vor riskanten Schritten.

## Kritischer Befund: öffentliche Sichtbarkeit

Das README sagt ausdrücklich:

> Das Repository muss privat sein, weil ein Serverinventar eine Landkarte der Angriffsfläche ist.

Zum Analysestichtag war das Repository öffentlich sichtbar. Auch wenn Rohinventare gitignoriert sind, enthält das Repository:

- Systempfade,
- Produktionsprojektnamen,
- Service- und Sicherheitslogik,
- Guardrail-Details,
- geplante Inventarisierungsfelder.

**Empfehlung:** Dieses Repository nach Abschluss der Analyse sofort wieder auf privat setzen. Vorher sollte zusätzlich die gesamte Git-Historie auf unbeabsichtigte Infrastruktur- oder Secret-Artefakte geprüft werden.

## Bedeutung für die künftige Methodik

`server-migration` ist die Referenz für:

- Agentensicherheit,
- Least Privilege,
- Sandbox- und Workspace-Grenzen,
- destructive Operations,
- attended execution,
- Systems Engineering,
- Infrastructure Discovery,
- negative Sicherheitsprüfungen.

---

# 6.11 `tischatlas`

## Produktidee

Tischatlas soll ein lokal betriebenes, visuell hochwertiges Restaurant-, Menü- und Quellenarchiv werden. Geplant beziehungsweise in P1 umgesetzt sind:

- Restaurantkatalog,
- Dossiers,
- Suche und Filter,
- Quellenhistorie,
- versionierte Speise-, Menü-, Wein- und Getränkekarten,
- Preisveränderungen,
- kontrollierte URL-Aufnahme,
- private Besuchsdaten,
- responsive und barrierearme Oberfläche.

Quelle: [`README.md`](https://github.com/andreaskeis77/tischatlas/blob/main/README.md)

## Architektur und Technik

- Django 5.2
- modularer Monolith
- serverseitige Templates
- SQLite-first
- uv
- Python 3.14
- progressive htmx-Option
- Playwright und axe
- Ruff, mypy und Django Checks
- Gitleaks und Linkprüfung
- Windows- und Ubuntu-CI
- sehr stark abgesicherter Datenbanklebenszyklus

## Aktueller Entwicklungsstand

Der Default-Branch enthält das abgeschlossene P0B-Scaffold. Der aktive Draft-PR #4 enthält bereits den P1-Full-Slice:

- fünf kuratierte Restaurants,
- Domänenmodell,
- Offline-Import,
- Django-Admin,
- Katalog,
- Dossiers,
- Quellenstatus,
- 92 Unit-, 86 Integrations- und 12 UI-Tests,
- visuelle und inhaltliche Eigentümerabnahme noch offen.

Quelle: [Pull Request #4](https://github.com/andreaskeis77/tischatlas/pull/4)

## Reifegrad

**M2→M3 – Executable Foundation auf dem Weg zum nutzbaren Produkt**

Tischatlas ist das aktuell beste Beispiel für einen methodisch kontrollierten Übergang:

- von Konzept und Wireframes,
- über Scaffold und Datenbanksicherheit,
- zu einem vollständigen vertikalen P1-Slice.

## Besondere Stärke

- Identität wird nicht aus Adresse oder Ähnlichkeit abgeleitet.
- Menükarten bleiben Dokumente und werden nicht vorschnell atomisiert.
- Preise müssen entweder korrekt normalisiert oder explizit als mehrdeutig markiert sein.
- Anbieterbewertungen werden nicht zu einer Scheingenauigkeit aggregiert.
- Michelin-403 wird nicht umgangen.
- Quellen, Unsicherheit und Attribution sind Teil des Domänenmodells.

Das ist fachlich sauberes Domain- und Data-Engineering.

## Risiko

Der technische und governancebezogene Aufwand ist bereits im frühen Projektstadium sehr hoch. Die Methodik muss verhindern, dass:

- der sichere Datenbanklebenszyklus,
- das Methodikarchiv,
- Link- und SHA-Prüfungen,
- umfangreiche Governance

mehr Aufwand erzeugen als der eigentliche Nutzerwert.

## Bedeutung für die künftige Methodik

Tischatlas ist ein zentraler Referenzfall für:

- Spec-driven Development,
- Domain Modeling,
- Source Provenance,
- Web Extraction,
- dokumentzentrierte Datenmodelle,
- UI-Wireframe-Checkpoints,
- kontrollierte Agentenautonomie,
- serielles Owner-Gating.

---

# 7. Fachliche Projektlandschaft

Die Projekte lassen sich in drei große Interessenfelder gliedern.

## 7.1 Persönliche Informations- und Wissenssysteme

- Capsule
- Capsule App
- Curio

Charakteristisch sind:

- private personenbezogene Daten,
- strukturierte Wissensmodelle,
- Ontologien und Taxonomien,
- multimodale Daten,
- KI-gestützte Klassifikation und Synthese,
- hohe Anforderungen an Provenance und Review.

## 7.2 Kultur-, Freizeit- und Analyseprodukte

- Boxscore
- New NFL
- Joe’s Journal
- Tischatlas

Charakteristisch sind:

- starke persönliche Interessen als Produktdomäne,
- externe Quellen und Ingestion,
- redaktionelle oder analytische Darstellung,
- hochwertige Benutzeroberflächen,
- versionierte Inhalte,
- langfristig wachsende Wissensbestände.

## 7.3 Private Infrastruktur und technische Systeme

- Fritz Old
- WLAN
- FunkAtlas
- Server Migration

Charakteristisch sind:

- reale Hardware und Netzwerke,
- Betriebssystem- und Infrastrukturnähe,
- Messungen und Langzeitbeobachtung,
- Sicherheits- und Zugriffsgrenzen,
- read-only Prinzipien,
- Hardware-in-the-Loop,
- hohe Bedeutung von Betriebs- und Recovery-Wissen.

---

# 8. Was das Portfolio über Andreas’ Arbeitsweise zeigt

## 8.1 Rolle als Chefarchitekt und Product Owner

Andreas arbeitet nicht primär als manueller Programmierer. Die wiederkehrende Rolle ist:

- Problemgeber,
- Requirements Engineer,
- Systemarchitekt,
- Entscheider,
- Freigabeinstanz,
- Qualitäts- und Risiko-Owner.

KI-Agenten übernehmen zunehmend:

- Recherche,
- Planung,
- Implementierung,
- Tests,
- Review,
- Debugging,
- Dokumentation,
- Deploymentvorbereitung,
- teilweise Betrieb.

Dieses Rollenmodell entspricht bereits weitgehend dem gewünschten Forschungsziel.

## 8.2 Serielles Entscheiden, intern paralleles Arbeiten

Portfolioübergreifend ist ein konsistentes Muster erkennbar:

- Andreas möchte einen klaren nächsten Auftrag.
- Eigentümerentscheidungen und Checkpoints werden seriell getroffen.
- Nach Freigabe darf der Agent größere Phasen autonom durcharbeiten.
- Innerhalb einer Phase dürfen unabhängige Pakete parallelisiert werden.
- Merge, Produktion, Datenmutation und Kosten bleiben stärker kontrolliert.

Das ist ein gutes Grundmodell:

> Serielle menschliche Steuerung, parallele maschinelle Ausführung.

## 8.3 Dokumente als externes Projektgedächtnis

Fast jedes Projekt besitzt Kombinationen aus:

- `CLAUDE.md`,
- `PROJECT_STATE`,
- Roadmap,
- ADRs,
- Architekturkonzept,
- Working Agreement,
- Handoff,
- Runbook,
- Release Notes.

Das zeigt, dass ein LLM-gestütztes Projekt ohne externes Gedächtnis nicht ausreichend stabil bleibt.

## 8.4 Test-first und harte Gates

Die Commit- und PR-Beschreibungen zeigen häufig:

- Red-first,
- Regressionstest pro Bugfix,
- Gates werden nicht aufgeweicht,
- reale Fehler werden als neue Tests festgehalten,
- Offline- und Netzwerktests werden getrennt,
- UI- und Accessibility-Prüfungen werden zunehmend Standard.

## 8.5 Lernen durch Projektgenerationen

Mehrere Projekte sind direkte Lernketten:

### NFL

`new_nfl` → `boxscore`

- New NFL perfektionierte die Datenplattform.
- Boxscore übernahm die technischen Erkenntnisse.
- Gleichzeitig wurde Experience-first als Korrektur eingeführt.

### Heimnetz

`fritz_old` → `wlan` → `funkatlas`

- Fritz Old entwickelte Architekturprinzipien.
- WLAN baute eine breitere lokale Anwendung.
- FunkAtlas erweitert auf mehrere Netze, Geräte und Experimente.

### Wardrobe

`capsule` → `capsule-app`

- Capsule stellt Backend, Datenmodell und API.
- Capsule App erprobt den mobilen Zugang.

Diese Lernketten sind wertvoll. Sie benötigen aber eine formale Methode für:

- Harvest,
- Ablösung,
- Archivierung,
- übernommene Entscheidungen,
- bewusst verworfene Ansätze.

---

# 9. Architektur- und Technologielandschaft

## 9.1 Sprachen und Frameworks

### Python-dominiert

Python ist die zentrale Sprache für:

- APIs,
- Dateningestion,
- CLI,
- Sensorik,
- Datenbanken,
- Tests,
- Automatisierung,
- KI-Integration.

Verwendete Webframeworks:

- FastAPI,
- Django,
- historisch Flask/Jinja.

### TypeScript und Web

TypeScript wird für moderne Oberflächen genutzt:

- Astro in Joe’s Journal und Boxscore,
- React Native/Expo in Capsule App,
- Directus-SDK und Buildskripte in Joe’s Journal.

### PowerShell

PowerShell ist ein zentraler Bestandteil der Plattform:

- Bootstrap,
- Quality Gates,
- Deployment,
- Scheduled Tasks,
- Serviceverwaltung,
- Backup,
- Migration,
- Guardrails.

Das Portfolio ist damit nicht nur Windows-kompatibel, sondern **Windows-nativ operationalisiert**.

## 9.2 Datenbanken

### SQLite

Verwendet in:

- Capsule,
- Curio,
- WLAN/FunkAtlas,
- Tischatlas,
- lokale Entwicklung von Joe’s Journal.

Stärken im Portfolio:

- lokale Einfachheit,
- portable Dateien,
- kontrollierte Backups,
- geringe Betriebskosten.

### DuckDB

Verwendet in:

- New NFL,
- Boxscore.

Stärken:

- analytische Abfragen,
- große lokale Datenmengen,
- einfache Dateiarchitektur,
- gute Passung für private Analyseplattformen.

### PostgreSQL

Verwendet in:

- produktivem Joe’s Journal.

Begründung:

- CMS-Backend,
- relationale Redaktion,
- produktiver Directus-Betrieb.

## 9.3 Architekturpatterns

Wiederkehrend sind:

- modularer Monolith,
- Adapter je Quelle,
- Contract-basierte Ingestion,
- `raw → staging → marts`,
- klare System-of-Record-Entscheidungen,
- statische Webgenerierung,
- API-first für gemeinsame Frontends,
- Statusseiten,
- read-only Schnittstellen zu Infrastruktur,
- externe Konfiguration statt Hardcoding.

## 9.4 Docker und Container

Docker spielt in den analysierten Projekten bislang kaum eine Rolle. Der Betrieb erfolgt überwiegend nativ auf Windows.

Das ist keine automatische Schwäche. Für die private Umgebung bietet nativer Betrieb:

- direkten Zugriff auf Scheduled Tasks,
- einfache PowerShell-Integration,
- geringe zusätzliche Abstraktion,
- Tailscale- und Cloudflare-Nähe.

Es entstehen aber Nachteile:

- Umgebungsdrift,
- Node- und Python-Versionskonflikte,
- Dateirechteprobleme,
- schwerer reproduzierbare Deployments,
- höhere Kopplung an Windows.

Für den Forschungsauftrag sollte Docker daher differenziert betrachtet werden:

- **Dev-/Test-Reproduzierbarkeit:** wahrscheinlich hoher Nutzen.
- **Produktionsbetrieb aller Projekte:** nicht automatisch sinnvoll.
- **Hardware- und Windows-nahe Projekte:** teilweise ungeeignet.
- **Astro-/API-/Datenbankprojekte:** wahrscheinlich sinnvoll pilotierbar.

## 9.5 MCP

MCP ist in den Projekten nicht als tragendes Architekturprinzip sichtbar.

Die reale Agentenintegration erfolgt heute überwiegend über:

- Repositorydateien,
- `CLAUDE.md`,
- CLI-Befehle,
- Git und GitHub,
- PowerShell,
- lokale Dateisysteme,
- APIs,
- Browser- und Testwerkzeuge.

Das ist ein wichtiger Befund:

> Die aktuelle Methodik ist bereits agentenfähig, ohne dass MCP notwendig war.

MCP sollte daher im Forschungsauftrag nicht als Voraussetzung behandelt werden, sondern als möglicher Standardadapter für ausgewählte Toolzugriffe.

---

# 10. Qualitäts- und Testlandschaft

## 10.1 Stärken

Das Portfolio besitzt für private Projekte ungewöhnlich starke Qualitätssicherung:

- pytest,
- Ruff,
- mypy,
- Django Checks,
- Vitest,
- Playwright,
- axe,
- Linkprüfungen,
- Secret-Scans,
- Contract-Tests,
- Network-Smokes,
- Datenkonsistenzprüfungen,
- Backup-/Restore-Drills,
- Buildbudgets,
- Health-Probes,
- Regressionstests pro Fehler.

## 10.2 Unterschiedliche Testreife

### Sehr hoch

- Boxscore
- New NFL
- Tischatlas
- Curio

### Hoch, aber historisch nachgerüstet

- Capsule
- Joe’s Journal

### Solide für frühen Systemstand

- FunkAtlas
- Fritz Old

### Unklar oder dokumentarisch widersprüchlich

- WLAN

### Noch schwach

- Capsule App
- Server Migration bezüglich Anwendungscode; dort stehen stattdessen Guardrail-Tests im Vordergrund.

## 10.3 Zentrales Risiko: Agent testet seine eigene Annahme

Viele Tests werden von demselben Agenten erzeugt, der die Implementierung schreibt. Dagegen werden bereits mehrere Gegenmaßnahmen genutzt:

- unabhängige Review-Agenten,
- Red-first,
- Real-Smokes,
- Fixture- und Contract-Tests,
- Datenbank-Querchecks,
- Golden Datasets,
- Owner-Checkpoints,
- Restore-Drills.

Die künftige Methodik sollte diese Ansätze formalisieren:

1. Implementierungsagent
2. unabhängiger Verifikationsagent
3. maschinelle Gates
4. gezielte Realumgebungsprüfung
5. menschlicher Akzeptanzcheckpoint

## 10.4 Fehlende Portfolio-Norm

Die Tests sind je Projekt gut, aber nicht als gemeinsames Qualitätsmodell erkennbar. Es fehlt ein portfolioweiter Standard, der je Projekttyp festlegt:

- Mindestgates,
- optionale Gates,
- Realumgebungsnachweise,
- UI-Abnahme,
- Daten- und Provenance-Prüfung,
- Betriebs- und Restore-Evidenz.

---

# 11. Daten, Ontologien und Quellen

## 11.1 Portfolioweite Stärke

Daten sind in fast allen Projekten ein zentrales Architekturthema.

Besonders ausgereift sind:

- Quellenadapter,
- Rohdatenhaltung,
- Schema- und Contract-Prüfung,
- Provenance,
- versionierte Inhalte,
- Datenqualitätschecks,
- Claim-Verifikation,
- Entity-Identität,
- explizite Mehrdeutigkeit,
- Freshness,
- Replay.

## 11.2 Ontologie- und Taxonomieerfahrung

Capsule besitzt eine reale Ontologie-/Taxonomieschicht für Kleidung. Tischatlas modelliert Identität, Dokumente, Anbieter und Preise. Curio organisiert Wissen, Quellen, Proposals und Seiten.

Das zeigt:

- Ontologien werden nicht nur theoretisch betrachtet.
- Die praktische Herausforderung liegt weniger im Erstellen einer Taxonomie als in:
  - Versionierung,
  - Migration,
  - UI-Darstellung,
  - Datenbereinigung,
  - Default-Modi,
  - Konsistenz zwischen Daten und Code.

## 11.3 Provenance als Leitmotiv

Curio, Tischatlas, Boxscore und New NFL zeigen ein starkes gemeinsames Prinzip:

> Ein Wert oder Text ist erst belastbar, wenn Quelle, Transformation und Prüfpfad nachvollziehbar sind.

Das sollte ein Kernprinzip der späteren Gesamtmethodik werden.

## 11.4 Webdaten und externe Quellen

Die Projekte unterscheiden sinnvoll zwischen:

- offiziellen APIs,
- lokalen Fixtures,
- echten Netzwerktests,
- HTML-/Dokumentextraktion,
- nicht erlaubtem Umgehen von Zugriffssperren,
- offline reproduzierbaren Tests,
- manuell freizugebenden Live-Abrufen.

Tischatlas ist hier besonders sauber: Ein HTTP 403 wird als Grenze akzeptiert und nicht technisch umgangen.

---

# 12. UI-, UX- und Mobile-Reife

## 12.1 Web-UI

Die neueren Projekte zeigen eine deutliche Entwicklung:

- Joe’s Journal: Design Tokens, redaktionelle Marke, Astro, Playwright, axe.
- Boxscore: Wiki-Navigation, Suche, statische Performance, Accessibility.
- Tischatlas: freigegebene Wireframes, visuelles Leitbild, responsive UI-Tests.
- Curio: mobile-first Read-UI.
- Capsule: funktional umfangreich, aber UI-Tests wurden spät als Lücke erkannt.

## 12.2 Menschliche Geschmacksentscheidung

In mehreren Projekten wird explizit anerkannt:

- Funktion kann automatisiert geprüft werden.
- Visuelle Qualität und „Geschmack“ benötigen menschliche Abnahme.

Das ist sinnvoll. Eine KI-native UI-Methodik sollte unterscheiden zwischen:

- objektiv testbaren Eigenschaften,
- heuristisch bewertbaren Eigenschaften,
- menschlich zu entscheidender Produktästhetik.

## 12.3 Mobile

Mobile Engineering steht noch am Anfang:

- Capsule App ist funktional begonnen.
- FunkAtlas plant Android-Probes.
- Curio nennt PWA- und Offline-Ausbau als spätere Phase.

Fehlend sind bisher:

- etablierter Emulator-Testpfad,
- Device Matrix,
- mobile Screenshot-Baselines,
- App-Signing und interne Distribution,
- Offline-/Sync-Verträge,
- mobile Accessibility-Gates,
- Release-Evidence für Android.

Mobile muss deshalb ein eigener Forschungs- und Pilotstrang sein.

---

# 13. Betrieb, Deployment und Infrastruktur

## 13.1 Gemeinsame Betriebsplattform

Mehrere Projekte nutzen denselben oder einen ähnlichen Windows-VPS mit:

- Tailscale,
- Cloudflare Tunnel,
- Windows Scheduled Tasks,
- IIS oder lokale Services,
- PowerShell-Runbooks,
- lokale Datenbanken,
- Backupverzeichnisse.

Das schafft Synergien, aber auch ein **Shared-Fate-Risiko**:

- Änderungen an Firewall, Cloudflare, Node, Python oder Dateirechten können mehrere Projekte betreffen.
- Infrastrukturwissen ist über mehrere Repositories verteilt.
- Server Migration betrifft viele gleichzeitig laufende Systeme.

## 13.2 Positive Muster

- Adminzugriff über Tailscale
- keine offenen Inbound-Ports als Zielbild
- Cloudflare Access für private Weboberflächen
- separate Staging-/Produktionspfade in Boxscore
- Backup- und Restore-Drills
- Status- und Health-Seiten
- atomare Builds beziehungsweise Rollbacks
- dokumentierte Runbooks

## 13.3 Schwächen

- native, teilweise manuell konfigurierte Windows-Dienste und Tasks,
- unterschiedliche Betriebsmodelle je Projekt,
- teilweise Administrator-PowerShell als Voraussetzung,
- keine zentrale Service- und Portübersicht,
- uneinheitliche Deployment-Automatisierung,
- mehrere operative Hostnamen und Konten in öffentlichen Dokumenten,
- unklarer gemeinsamer Ressourcen- und Kapazitätsplan.

## 13.4 Konsequenz

Der Forschungsauftrag sollte neben Projektmethodik auch ein kleines **Private Platform Engineering Model** entwickeln:

- gemeinsamer Servicekatalog,
- Ports und Hostnames,
- Secrets,
- Deployments,
- Backups,
- Logs,
- Health,
- Abhängigkeiten,
- Ressourcen,
- Recovery-Reihenfolge.

---

# 14. Sicherheitsanalyse auf Portfolioebene

## 14.1 Positive Sicherheitsprinzipien

Wiederkehrend vorhanden:

- Least Privilege,
- keine Secrets im Repo,
- `.env` außerhalb Git,
- Secret-Scan,
- Tailscale,
- Cloudflare Access,
- read-only Routerzugriff,
- keine Agenten-Elevation,
- getrennte Arbeitsverzeichnisse,
- Backup vor Datenmutation,
- getestete Guardrails.

## 14.2 Kritische temporäre öffentliche Exposition

Alle elf Repositories waren für diese Analyse öffentlich geschaltet. Mehrere enthalten jedoch operative Details.

### Höchstes Risiko

- `server-migration`
- `joes-journal`
- `capsule`
- `boxscore`

Mögliche öffentlich sichtbare Informationen:

- Hostnamen,
- IP-Adressen,
- Tailscale-Namen,
- Windows-Pfade,
- Service- und Tasknamen,
- Kontonamen oder E-Mail-Adressen,
- Produktionsarchitektur,
- Backup- und Recoverypfade,
- Sicherheitsgrenzen,
- historische Hinweise auf Tokens oder Notification Topics.

Diese Informationen sind nicht automatisch Secrets, erleichtern aber Reconnaissance.

## 14.3 Empfohlene Sofortmaßnahme nach Abschluss der Analyse

1. Alle Repositories wieder privat setzen, die nicht bewusst öffentlich bleiben sollen.
2. `server-migration` mit höchster Priorität privat setzen.
3. Git-Historie mit Secret- und Infrastrukturindikatoren prüfen.
4. Öffentliche IPs, persönliche E-Mail-Adressen und interne Hostnamen aus kanonischer Dokumentation entfernen oder parametrisieren.
5. Bei Verdacht auf jemals veröffentlichte Tokens: rotieren, nicht nur aus dem aktuellen Branch löschen.
6. Self-hosted Runner und öffentliche Repositories strikt trennen oder durch harte GitHub-Sicherheitsgrenzen absichern.

---

# 15. Agenten- und Kommunikationsmodell

## 15.1 Bereits etablierte Elemente

Die Projekte enthalten bereits viele Bausteine eines KI-nativen Operating Models:

- operative Projektverfassung,
- kanonische Dokumente,
- Hierarchie der Wahrheit,
- Phasenfreigabe,
- Owner-Checkpoints,
- Agentenrollen,
- parallele Subagenten,
- Worktree-Isolation,
- Red-first,
- unabhängige Reviews,
- Kosten-Caps,
- Safety Parks,
- Handover,
- Evidence in PR-Beschreibungen.

## 15.2 Besonders reife Beispiele

### Boxscore

- freigegebene Phase als durchgehender Auftrag,
- parallele unabhängige Pakete,
- Agent merged und deployt bei Grün,
- Kosten- und Sicherheitsgrenzen.

### Tischatlas

- klare Autoritätsstufen,
- Draft-PR als Checkpoint,
- kein impliziter Merge,
- Mensch entscheidet visuelle und inhaltliche Abnahme.

### Server Migration

- Agent darf produktive Infrastruktur nur innerhalb getesteter Grenzen sehen und bedienen.

### Capsule

- echte Modell-Evaluation,
- Kostenbeobachtung,
- menschlich ausgelöste kostenpflichtige Aktionen.

## 15.3 Offene methodische Frage

Die Projekte verwenden zwei Autonomiemodelle:

1. **Hohe Autonomie bis Auto-Merge und Auto-Deploy**  
   Beispiel: Boxscore.

2. **Owner-Checkpoint vor Ready/Merge/Live**  
   Beispiel: Tischatlas und Server Migration.

Beide sind richtig – abhängig vom Risiko. Die künftige Methodik benötigt daher **risikobasierte Autonomiestufen**, nicht eine allgemeine Autonomieregel.

---

# 16. Portfolioübergreifende Stärken

## 16.1 Professionelle Ernsthaftigkeit

Die Projekte werden nicht als Wegwerfprototypen behandelt. Selbst private Systeme erhalten:

- Architektur,
- Tests,
- Security,
- Betriebswissen,
- Recovery,
- Versionierung.

## 16.2 Starke Traceability

Anforderungen, Entscheidungen, Code, Tests und Betrieb sind häufig verknüpft.

## 16.3 Lernorientierung

Fehler werden nicht nur behoben, sondern als:

- Regressionstest,
- ADR,
- Gotcha,
- Runbook-Ergänzung,
- Nachfolgeprojektentscheidung

festgehalten.

## 16.4 Daten- und Quellenkompetenz

Das Portfolio zeigt ungewöhnlich starke praktische Erfahrung mit:

- Datenpipelines,
- Quellenbewertung,
- Schema-Drift,
- Provenance,
- Datenqualität,
- Versionierung,
- Inhaltsverifikation.

## 16.5 Realer Betrieb

Mehrere Projekte haben echte:

- Domains,
- Tunnel,
- Scheduled Tasks,
- Backups,
- Restore-Drills,
- Produktionsdaten,
- Nutzeroberflächen.

Die Forschung kann daher an realen Systemen validiert werden.

---

# 17. Portfolioübergreifende Schwächen und Antipatterns

## 17.1 Dokumentationsdrift

Beispiele:

- Curio: gleichzeitig „live“ und „noch nicht deployed“.
- WLAN: Komponenten gleichzeitig „done“ und „noch nicht gebaut“.
- Capsule: Codeversion, Release-Marker und Git-Tag laufen auseinander.
- Boxscore: maschinenlesbarer Produktstand hinkt neueren Härtungscommits hinterher.
- Tischatlas: README auf `main` beschreibt P0B, aktive Produktrealität liegt in Draft-PR #4.

### Ursache

Agenten arbeiten schneller als manuell gepflegte Statusdokumente synchronisiert werden.

### Konsequenz

Künftige Methodik:

- maschinenlesbarer Status,
- generierte README-Abschnitte,
- CI-Prüfung auf Statuskonsistenz,
- klarer Unterschied zwischen `main`, aktiver PR und Live,
- keine additiven Statusdokumente mit widersprüchlichen Altabschnitten.

## 17.2 Projektneustarts statt kontrollierter Evolution

Die Ketten `fritz_old → wlan → funkatlas` und `new_nfl → boxscore` sind fachlich sinnvoll, erzeugen aber:

- redundante Repositories,
- unklare aktive Zuständigkeit,
- wiederholte Baselines,
- potenziell verlorene Erkenntnisse,
- Pflegeaufwand.

Es fehlt ein standardisierter **Project Succession Record**:

- Warum wurde der Vorgänger beendet?
- Was wurde übernommen?
- Was wurde bewusst verworfen?
- Welche Daten müssen migriert werden?
- Welches Repo ist kanonisch?
- Wann wird das alte Repo archiviert?

## 17.3 Governance-Overhead

Tischatlas und Boxscore besitzen bereits sehr umfangreiche Governance. Das ist für kritische Bereiche nützlich, kann aber:

- Agentenkontext überladen,
- Entscheidungen verlangsamen,
- methodische Dokumente zum Selbstzweck machen,
- kleine Änderungen unverhältnismäßig teuer machen.

Die Methodik braucht eine skalierende Zeremonie:

- LIGHT,
- STANDARD,
- HIGH-RISK.

## 17.4 Uneinheitliches Release Management

- Codeversionen, Tags, Release Notes und Live-Versionen sind nicht überall konsistent.
- Einige Projekte haben kaum Tags.
- Andere führen Versionsstände in JSON oder Dokumenten.
- Mobile besitzt noch keinen Releasepfad.

## 17.5 Fehlende Portfolioebene

Es gibt kein zentrales, maschinenlesbares Portfolio, das zeigt:

- Projektzweck,
- Owner,
- Status,
- aktives Repository,
- Vorgänger/Nachfolger,
- Live-System,
- Datenkritikalität,
- letzte Aktivität,
- nächste Entscheidung,
- Backupstatus,
- öffentliche/private Sichtbarkeit.

---

# 18. Konsequenzen für den Forschungsauftrag

Die Recherche sollte nicht abstrakt bei „State of the Art der KI-Entwicklung“ beginnen, sondern diese reale Landschaft als Testfeld verwenden.

## 18.1 Erforderliche Projektarchetypen

Die Methodik sollte mindestens Templates für folgende Archetypen entwickeln:

### A. Private Web Product

Beispiele:

- Capsule
- Joe’s Journal
- Tischatlas

Schwerpunkte:

- UX,
- API,
- Auth,
- Deployment,
- Datenschutz,
- Backup.

### B. Data and Knowledge Platform

Beispiele:

- New NFL
- Boxscore
- Curio

Schwerpunkte:

- Quellen,
- Adapter,
- Provenance,
- Schema-Evolution,
- Evaluation,
- automatische Inhalte.

### C. Local Sensor and Edge System

Beispiele:

- WLAN
- FunkAtlas

Schwerpunkte:

- Hardware,
- Live-Tests,
- Langzeitmessung,
- Offline-Betrieb,
- Device Identity,
- Betriebsausfälle.

### D. Infrastructure Transformation

Beispiel:

- Server Migration

Schwerpunkte:

- Guardrails,
- Least Privilege,
- Inventarisierung,
- Rollback,
- attended execution,
- destruktive Aktionen.

### E. Mobile Companion

Beispiel:

- Capsule App

Schwerpunkte:

- API-Contracts,
- Emulator,
- Device Tests,
- Offline,
- Signing,
- Distribution.

## 18.2 Risikobasierte Autonomiestufen

Empfohlenes Modell:

| Stufe | Agentenbefugnis | Typische Beispiele |
|---|---|---|
| **A0 – Advisory** | lesen, analysieren, Vorschlag erstellen | Architektur, Migrationseinschätzung |
| **A1 – Workspace Write** | Branch/Worktree ändern und testen | normale Features |
| **A2 – PR Delivery** | committen, pushen, Draft-PR erstellen | Tischatlas |
| **A3 – Controlled Merge** | bei grünen Gates mergen | risikoarme, reversible Änderungen |
| **A4 – Controlled Deploy** | Staging, Smoke, Promotion, Rollback | Boxscore |
| **A5 – High-Risk Attended** | produktive Daten/Infra nur mit Live-Freigabe | Server Migration, Datenhygiene |

## 18.3 Drei getrennte Reifegrade

Künftige Bewertungen sollten drei Dimensionen trennen:

1. **Produktreife** – hat der Nutzer realen Nutzen?
2. **Engineering-Reife** – sind Architektur und Qualität belastbar?
3. **Betriebsreife** – kann das System sicher betrieben und wiederhergestellt werden?

Beispiel:

- New NFL: Engineering hoch, Betrieb hoch, Produktwirkung mittel.
- Capsule App: Produktprototyp mittel, Engineering niedrig, Betrieb niedrig.
- Server Migration: Governance hoch, Produktreife nicht anwendbar.

## 18.4 Evidence Bundle pro Änderung

Ein standardisiertes Agentenergebnis sollte enthalten:

- Ziel und Scope,
- geänderte Anforderungen,
- betroffene Architekturentscheidungen,
- Dateien und Datenmigrationen,
- Tests und Ergebnisse,
- Risiken,
- Kosten,
- Realumgebungsnachweise,
- Rollback,
- Dokumentationsupdate,
- offene Owner-Entscheidung.

## 18.5 Machine-readable Project State

Jedes aktive Repo sollte eine kleine Datei besitzen, beispielsweise:

```yaml
schema_version: 1
project: tischatlas
lifecycle: active-development
product_maturity: M2
engineering_maturity: M4
operations_maturity: M1
active_branch: feat/p1-five-restaurants-full-slice
active_pr: 4
live: false
data_classification: private
autonomy_level: A2
predecessor: null
successor: null
last_verified: 2026-07-28
next_owner_checkpoint: P1 visual and content acceptance
```

Die README-Statussektion sollte daraus generiert werden.

## 18.6 Portfolio Control Plane

Zusätzlich sollte ein zentrales privates Portfolio-Repository oder Dashboard entstehen mit:

- allen Projekten,
- Reifegraden,
- aktiven PRs,
- CI-Status,
- Live-Health,
- Backups,
- Sicherheitsklassifikation,
- Nachfolgern,
- nächsten Entscheidungen,
- Agentenaufträgen.

Das wäre ein sinnvoller Anwendungsfall für:

- GitHub API,
- MCP oder direkte Connectoren,
- lokale Agenten,
- Smartphone-Freigaben,
- Tailscale-geschützte Oberfläche.

---

# 19. Priorisierte Empfehlungen

## 19.1 Sofort

1. `server-migration` wieder privat setzen.
2. Danach die übrigen nur für diese Analyse geöffneten Repositories wieder privat setzen.
3. Öffentliche Historie auf Secrets und sensible Infrastrukturdetails prüfen.
4. Bei `boxscore` die Sicherheit von Public Repo und self-hosted Runner klären.
5. Veraltete oder widersprüchliche `PROJECT_STATE`-Abschnitte in Curio und WLAN bereinigen.

## 19.2 Kurzfristig

1. Portfolioübersicht mit Projektstatus und Vorgänger-/Nachfolgerbeziehungen anlegen.
2. `fritz_old` und wahrscheinlich `wlan` als superseded/archived markieren.
3. Einheitliches, maschinenlesbares Projektstatusschema einführen.
4. Release- und Tagstrategie für Capsule harmonisieren.
5. Capsule App an den Engineering-Standard anbinden:
   - README,
   - API-Contract-Test,
   - Unit-Tests,
   - Emulator-Smoke,
   - UI-Screenshot-Test,
   - Build- und Distributionpfad.
6. Tischatlas-P1 nach dem menschlichen UI-/Inhaltscheckpoint abschließen, bevor weitere Infrastruktur vertieft wird.

## 19.3 Forschungsprogramm

Die erste Forschungsphase sollte auf Basis dieses Portfolios entwickeln:

1. Projektarchetypen
2. Risikobasierte Autonomiestufen
3. drei Reifegraddimensionen
4. Evidence-Bundle
5. maschinenlesbaren Projektstatus
6. Portfolio Control Plane
7. standardisierte Experimentmethodik
8. Agenten- und Toolberechtigungsmodell
9. Dev-/Test-Reproduzierbarkeit mit selektivem Docker-Einsatz
10. Mobile-Engineering-Pilot mit Capsule App

---

# 20. Gesamtbeurteilung

Das Portfolio zeigt, dass der geplante Forschungsauftrag nicht theoretisch ist. Andreas besitzt bereits eine kleine, heterogene, KI-gestützt entwickelte Systemlandschaft mit realen Nutzern, realen Daten und realem Betrieb.

Die Projekte demonstrieren:

- hohe methodische Ambition,
- ausgeprägte Systems-Engineering-Denkweise,
- starke Daten- und Provenance-Orientierung,
- wachsende Agentenautonomie,
- ernsthafte Qualitäts- und Betriebsdisziplin,
- Bereitschaft zum Experimentieren und Lernen.

Die wichtigste Herausforderung ist nicht mehr, KI überhaupt zum Programmieren zu verwenden. Diese Stufe ist bereits überschritten.

Die nächste Entwicklungsstufe lautet:

> Aus vielen gut dokumentierten, individuell entwickelten KI-Projekten ein konsistentes, risikobasiertes und skalierbares privates Engineering-Ökosystem zu machen.

Dazu muss die künftige Methodik insbesondere lösen:

- Wie viel Governance braucht welches Projekt?
- Wie wird der reale Produktnutzen früh sichtbar?
- Wie werden Agentenrechte nach Risiko gestaffelt?
- Wie bleiben Dokumentation und Live-Zustand synchron?
- Wie werden Projekte geerbt, abgelöst und archiviert?
- Wie werden Web, Daten, Infrastruktur und Mobile unter einem gemeinsamen Qualitätsmodell geführt?
- Wie entsteht eine zentrale Sicht auf die gesamte private Plattform?

Das Portfolio ist dafür ein außergewöhnlich geeignetes Forschungs- und Experimentierfeld.

---

# Anhang A – Wichtigste Quellen

## Boxscore

- [Repository](https://github.com/andreaskeis77/boxscore)
- [CLAUDE.md](https://github.com/andreaskeis77/boxscore/blob/main/CLAUDE.md)
- [Projektstand](https://github.com/andreaskeis77/boxscore/blob/main/docs/PROJEKT_STAND.md)
- [Product State](https://github.com/andreaskeis77/boxscore/blob/main/product-state.json)

## Capsule

- [Repository](https://github.com/andreaskeis77/capsule)
- [README](https://github.com/andreaskeis77/capsule/blob/main/README.md)
- [Project State](https://github.com/andreaskeis77/capsule/blob/main/docs/PROJECT_STATE.md)

## Capsule App

- [Repository](https://github.com/andreaskeis77/capsule-app)
- [README](https://github.com/andreaskeis77/capsule-app/blob/main/README.md)
- [package.json](https://github.com/andreaskeis77/capsule-app/blob/main/package.json)

## Curio

- [Repository](https://github.com/andreaskeis77/curio)
- [README](https://github.com/andreaskeis77/curio/blob/main/README.md)
- [Project State](https://github.com/andreaskeis77/curio/blob/main/docs/PROJECT_STATE.md)

## Fritz Old

- [Repository](https://github.com/andreaskeis77/fritz_old)
- [README](https://github.com/andreaskeis77/fritz_old/blob/main/README.md)
- [Technisches Konzept](https://github.com/andreaskeis77/fritz_old/blob/main/docs/TECHNISCHES_KONZEPT.md)

## FunkAtlas

- [Repository](https://github.com/andreaskeis77/funkatlas)
- [README](https://github.com/andreaskeis77/funkatlas/blob/main/README.md)
- [Project State](https://github.com/andreaskeis77/funkatlas/blob/main/docs/PROJECT_STATE.md)

## Joe’s Journal

- [Repository](https://github.com/andreaskeis77/joes-journal)
- [README](https://github.com/andreaskeis77/joes-journal/blob/main/README.md)
- [Deploy State](https://github.com/andreaskeis77/joes-journal/blob/main/docs/DEPLOY_STATE.md)

## New NFL

- [Repository](https://github.com/andreaskeis77/new_nfl)
- [README](https://github.com/andreaskeis77/new_nfl/blob/main/README.md)
- [Project State](https://github.com/andreaskeis77/new_nfl/blob/main/docs/PROJECT_STATE.md)

## Server Migration

- [Repository](https://github.com/andreaskeis77/server-migration)
- [README](https://github.com/andreaskeis77/server-migration/blob/main/README.md)

## Tischatlas

- [Repository](https://github.com/andreaskeis77/tischatlas)
- [README](https://github.com/andreaskeis77/tischatlas/blob/main/README.md)
- [Aktiver P1 Pull Request #4](https://github.com/andreaskeis77/tischatlas/pull/4)

## WLAN

- [Repository](https://github.com/andreaskeis77/wlan)
- [README](https://github.com/andreaskeis77/wlan/blob/main/README.md)
- [Project State](https://github.com/andreaskeis77/wlan/blob/main/docs/PROJECT_STATE.md)

---

# Anhang B – Empfohlene Statusbezeichnungen

Für die Portfoliosteuerung sollten Repositories künftig genau einen Lifecycle-Status führen:

- `idea`
- `concept`
- `active-development`
- `pilot`
- `operational`
- `maintenance`
- `paused`
- `superseded`
- `archived`

Vorläufige Einordnung:

| Repository | Empfohlener Lifecycle-Status |
|---|---|
| boxscore | `operational` |
| capsule | `operational` |
| capsule-app | `active-development` |
| curio | `operational` |
| fritz_old | `superseded` |
| funkatlas | `active-development` |
| joes-journal | `operational` |
| new_nfl | `maintenance` oder `paused`, abhängig von aktueller Absicht |
| server-migration | `concept` |
| tischatlas | `active-development` |
| wlan | `superseded` oder `pilot`, nach finaler Statusklärung |
