# KI-native Software- und Systems-Engineering-Methodik
## Zielbild, Kontext und Forschungsauftrag

**Stand:** 28. Juli 2026  
**Auftraggeber und fachliche Leitung:** Andreas  
**Dokumentzweck:** Ausgangsbasis für eine systematische Recherche und den Aufbau einer professionellen, KI-nativen Software- und Systems-Engineering-Methodik für private Softwareprojekte.

---

## 1. Executive Summary

Ziel ist der Aufbau eines modernen, professionellen und zugleich pragmatischen Engineering-Systems für private Softwareprojekte.

Andreas übernimmt dabei die Rollen:

- Auftraggeber
- Product Owner
- Chefarchitekt
- fachliche Entscheidungsinstanz
- Risiko- und Freigabeverantwortlicher

KI-Agenten sollen innerhalb klar definierter Grenzen möglichst selbstständig:

- Anforderungen analysieren und präzisieren
- Lösungsalternativen entwickeln
- Architekturen entwerfen und bewerten
- Software implementieren
- Tests erzeugen und ausführen
- Fehler analysieren und beheben
- Experimente durchführen
- Varianten vergleichen
- Dokumentation aktualisieren
- Pull Requests vorbereiten
- Qualitätsnachweise erzeugen
- Deployments vorbereiten oder kontrolliert ausführen

Das langfristige Ziel ist kein bloßer Einsatz einzelner KI-Werkzeuge, sondern ein durchgängiger, nachvollziehbarer und reproduzierbarer **KI-nativer Software- und Systems-Engineering-Lifecycle**.

Dieser Lifecycle soll den gesamten Weg abdecken:

1. Problem und Ziel verstehen
2. Anforderungen strukturieren
3. Architektur entwickeln
4. Risiken und Annahmen bewerten
5. Umsetzung planen
6. Implementieren
7. automatisiert verifizieren
8. experimentell validieren
9. deployen
10. beobachten
11. verbessern, anpassen oder verwerfen

---

# 2. Ausgangskontext

## 2.1 Persönlicher und methodischer Hintergrund

Andreas hat Informatik studiert und einen Masterabschluss in Software Engineering.

Der methodische Hintergrund umfasst unter anderem:

- objektorientierte Softwareentwicklung
- Entwurfsmuster
- Test-first Development
- Test-driven Development
- Requirements Engineering
- Systems Engineering
- Architekturarbeit
- Governance
- methodische Entwicklung komplexer technischer und organisatorischer Systeme

Die intensive Beschäftigung mit professionellem Software Engineering erfolgt heute vor allem aus fachlichem Interesse, Neugier und dem Wunsch, moderne KI-gestützte Engineering-Methoden praktisch zu erproben.

Der Anspruch ist daher bewusst höher als bei typischen Hobbyprojekten. Die Projekte sollen zwar pragmatisch und beherrschbar bleiben, aber methodisch sauber, professionell und nach dem aktuellen Stand der Technik entwickelt werden.

---

## 2.2 Aktuelle Entwicklungsumgebung

Die heutige Entwicklungsumgebung besteht im Wesentlichen aus:

- Windows-Entwicklungslaptop
- Visual Studio Code als primäre Arbeitsoberfläche
- Claude Code beziehungsweise vergleichbaren Coding-Agenten
- GitHub als privates Repository
- lokaler Windows-Server als Deployment-Ziel
- Remote-Zugriff auf den Server über Tailscale
- überwiegend webbasierte Benutzeroberflächen
- künftig zusätzlich Android-Anwendungen
- private, nicht kommerzielle Nutzung
- typischer Nutzerkreis: Andreas und gegebenenfalls Karen

Die Nutzung des Terminals ist bisher eher funktional und begrenzt. Visual Studio Code ist deshalb die bevorzugte Arbeitsumgebung, weil es eine komfortable grafische Oberfläche bietet und Terminal, Quellcode, Git und Agentenwerkzeuge integriert.

---

## 2.3 Typische Projektcharakteristik

Die Projekte sind:

- privat
- nicht kommerziell
- klein bis mittelgroß
- meist lokal oder im Heimnetz betrieben
- teilweise über Tailscale erreichbar
- nicht auf hohe öffentliche Skalierung angewiesen
- trotzdem fachlich und technisch anspruchsvoll
- datengetrieben
- häufig mit Weboberflächen
- potenziell künftig mit Android-Apps
- geeignet für experimentelle KI-gestützte Entwicklung

Wichtig ist daher eine Methodik, die professionell ist, aber keine unnötige Enterprise-Komplexität erzeugt.

---

# 3. Übergeordnetes Zielbild

## 3.1 Zielzustand

Es soll ein Engineering-System entstehen, in dem Andreas hauptsächlich:

- Ziele definiert
- Anforderungen formuliert
- Prioritäten setzt
- Architekturentscheidungen trifft
- Risiken bewertet
- Freigaben erteilt
- Ergebnisse beurteilt

KI-Agenten sollen möglichst viel operative Arbeit übernehmen.

Dazu gehören insbesondere:

- Analyse
- Planung
- Implementierung
- Test
- Debugging
- Dokumentation
- Review
- Experiment
- Verbesserung
- Deployment-Vorbereitung
- Qualitätssicherung

Der Mensch soll nicht jede technische Detailarbeit selbst ausführen müssen, sondern die Entwicklung steuern, spezifizieren und kontrollieren.

---

## 3.2 Gewünschtes Mensch-KI-Arbeitsmodell

Das Ziel ist eine klare Arbeitsteilung.

### Mensch

Der Mensch verantwortet:

- Produktziele
- fachliche Prioritäten
- Architekturprinzipien
- wichtige Systementscheidungen
- Akzeptanz von Risiken
- Freigaben
- Abbruch oder Fortführung von Experimenten
- finale Beurteilung von Benutzerfreundlichkeit und Nutzen

### KI-Agenten

KI-Agenten übernehmen:

- Analyse von Anforderungen
- Identifikation von Widersprüchen und Lücken
- Erarbeitung von Lösungsoptionen
- Architekturvorschläge
- Implementierung
- automatisierte Tests
- statische Analyse
- Fehlerbehebung
- Dokumentation
- Pull-Request-Erstellung
- technische Reviews
- Variantenvergleiche
- Benchmarking
- kontrollierte Experimente

---

## 3.3 Autonomie mit Leitplanken

KI-Agenten sollen möglichst autonom arbeiten, aber nicht unkontrolliert.

Erforderlich sind deshalb:

- klare Arbeitsaufträge
- definierte Rollen
- begrenzte Berechtigungen
- nachvollziehbare Entscheidungen
- reproduzierbare Ausführung
- überprüfbare Ergebnisse
- Quality Gates
- Abbruchkriterien
- menschliche Freigabepunkte
- vollständige Änderungsnachweise

Autonomie soll gezielt dort eingesetzt werden, wo sie Geschwindigkeit und Qualität erhöht.

Menschliche Kontrolle bleibt erforderlich, wenn:

- Risiken hoch sind
- Architekturentscheidungen langfristige Folgen haben
- sensible Daten betroffen sind
- Sicherheitsgrenzen verändert werden
- Anforderungen widersprüchlich sind
- erhebliche technische Schulden entstehen könnten
- ein Experiment über den vereinbarten Rahmen hinausgeht

---

# 4. Zentrale Forschungsfrage

Wie sieht im Jahr 2026 ein professioneller, KI-nativer Software- und Systems-Engineering-Lifecycle für kleine, anspruchsvolle Softwareprojekte aus, bei dem ein menschlicher Chefarchitekt die Richtung vorgibt und KI-Agenten einen möglichst großen Teil der Analyse, Implementierung, Qualitätssicherung und Weiterentwicklung übernehmen?

---

# 5. Teilfragen

Die zentrale Forschungsfrage wird in mehrere Teilfragen zerlegt.

## 5.1 Methodik

- Welche etablierten Software- und Systems-Engineering-Methoden eignen sich weiterhin?
- Welche Methoden müssen für KI-Agenten angepasst werden?
- Welche neuen KI-nativen Methoden entstehen?
- Wie verbindet man Requirements Engineering, Architektur, Entwicklung, Test und Betrieb?
- Wie schafft man durchgängige Traceability?

## 5.2 Zusammenarbeit zwischen Mensch und KI

- Wie müssen Anforderungen formuliert werden?
- Welche Informationen benötigt ein Agent dauerhaft?
- Wie wird Projektwissen strukturiert?
- Wie werden Entscheidungen dokumentiert?
- Wie werden Annahmen, Unsicherheiten und offene Fragen behandelt?
- Wie verhindert man Kontextverlust zwischen Sessions?
- Wie werden Konflikte zwischen Agenten gelöst?
- Welche Tätigkeiten dürfen Agenten autonom durchführen?
- Wo sind explizite Freigaben erforderlich?

## 5.3 Agentenorganisation

- Ist ein universeller Agent ausreichend?
- Wann sind spezialisierte Agenten sinnvoll?
- Wie funktionieren Planner-Worker-Reviewer-Modelle?
- Wie kann parallele Agentenarbeit organisiert werden?
- Wie werden Ergebnisse zusammengeführt?
- Wie kann unabhängige Verifikation erfolgen?
- Wie lassen sich Agentenschleifen begrenzen?

## 5.4 Architektur

- Welche Softwarearchitekturen sind für kleine KI-gestützte Projekte geeignet?
- Wann ist ein modularer Monolith besser als Microservices?
- Wie wichtig sind Clean Architecture, Hexagonal Architecture oder Vertical Slice Architecture?
- Wie werden Architekturen agentenfreundlich?
- Wie bleiben Systeme testbar, verständlich und evolvierbar?

## 5.5 Qualität

- Wie kann KI-generierter Code objektiv geprüft werden?
- Welche Tests sind erforderlich?
- Wie können Tests autonom generiert und ausgeführt werden?
- Wie verhindert man, dass Agenten nur Tests schreiben, die ihre eigene Implementierung bestätigen?
- Wie kann eine unabhängige Zweitprüfung aussehen?
- Wie werden Architektur- und Sicherheitsregeln automatisiert geprüft?

## 5.6 Experimente

- Wie können Agenten kleine technische Experimente durchführen?
- Wie werden Hypothesen und Erfolgskriterien definiert?
- Wie werden Varianten verglichen?
- Wie verhindert man, dass Experimente das stabile System beschädigen?
- Wie werden Ergebnisse übernommen oder vollständig verworfen?

## 5.7 Daten und Ontologien

- Wann reicht eine relationale Datenbank?
- Wann sind Dokumentendatenbanken sinnvoll?
- Wann bringen Graphdatenbanken oder Ontologien einen Mehrwert?
- Wie werden Datenherkunft, Qualität und Versionierung organisiert?
- Wie werden externe Quellen bewertet?
- Wie werden Konflikte und Dubletten erkannt?

## 5.8 Benutzeroberflächen

- Wie werden Weboberflächen professionell spezifiziert?
- Welche Methoden helfen ohne eigene Designausbildung?
- Wie werden Designvarianten erzeugt und verglichen?
- Wie können visuelle Tests automatisiert werden?
- Wie werden Accessibility und Responsive Design geprüft?
- Wie können Web und Android gemeinsame Designprinzipien verwenden?

## 5.9 Betrieb

- Wie werden Anwendungen reproduzierbar gebaut?
- Welche Rolle spielen Docker, Docker Compose und Dev Containers?
- Wie werden Deployments auf einem lokalen Windows-Server automatisiert?
- Wie funktionieren Rollback, Backup und Restore?
- Wie werden Anwendungen beobachtet?
- Welche Aufgaben können über Smartphone oder Browser gesteuert werden?

---

# 6. Forschungsauftrag

## 6.1 Auftrag

Es soll eine umfassende, strukturierte und quellenbasierte Untersuchung des aktuellen Stands von KI-nativem Software- und Systems Engineering durchgeführt werden.

Die Untersuchung soll:

- den Stand der Technik erfassen
- praktische Best Practices identifizieren
- Forschungsansätze bewerten
- Marketingaussagen von belastbaren Methoden unterscheiden
- geeignete Technologien und Werkzeuge vergleichen
- ein auf Andreas zugeschnittenes Zielbild entwickeln
- eine schrittweise Einführung ermöglichen

Die Recherche soll nicht bei einer bloßen Übersicht enden. Sie soll zu einem praktisch einsetzbaren Engineering-System führen.

---

## 6.2 Betrachtete Organisationen und Quellen

Zu untersuchen sind insbesondere Primärquellen und Veröffentlichungen von:

- Anthropic
- OpenAI
- Google
- Google DeepMind
- Microsoft
- GitHub
- NVIDIA
- Amazon Web Services
- Meta
- Linux- und Open-Source-Communities
- Stanford University
- Massachusetts Institute of Technology
- Carnegie Mellon University
- University of California, Berkeley
- weiteren führenden Software-Engineering- und KI-Forschungsgruppen
- Standardisierungsgremien
- relevanten Open-Source-Projekten

Bevorzugte Quellen:

- offizielle Dokumentationen
- Forschungsarbeiten
- Konferenzbeiträge
- Standards
- technische Referenzarchitekturen
- offizielle Engineering-Blogs
- öffentliche Repositories
- Benchmarks
- Evaluationen
- wissenschaftliche Vergleichsstudien

Sekundärquellen können zur Orientierung verwendet werden. Zentrale Aussagen sollen nach Möglichkeit über Primärquellen verifiziert werden.

---

# 7. Forschungsfelder

## 7.1 KI-nativer Engineering-Lifecycle

Zu untersuchen sind:

- AI-native Software Development Lifecycle
- agentenbasierte Softwareentwicklung
- Spec-driven Development
- Requirements-driven Development
- Architecture-driven Development
- Test-driven Development
- Behavior-driven Development
- Continuous Discovery
- Continuous Delivery
- DevSecOps
- Platform Engineering
- Site Reliability Engineering
- Systems Engineering für softwareintensive Systeme
- digitale Threads
- Traceability
- kontinuierliche Verifikation und Validierung

Gesucht wird ein Lifecycle-Modell, das Anforderungen, Architektur, Code, Tests, Betrieb und Lernen miteinander verbindet.

---

## 7.2 Mensch-KI-Kommunikation und Projektgedächtnis

Zu untersuchen sind geeignete Artefakte und Kommunikationsformen:

- Projektverfassung
- Produktvision
- Systemkontext
- Qualitätsziele
- Architekturprinzipien
- Architekturentscheidungen
- User Stories
- Use Cases
- Akzeptanzkriterien
- Definition of Ready
- Definition of Done
- Risiko- und Annahmenregister
- Agent Instructions
- Projektgedächtnis
- Handover-Dokumente
- Entscheidungsprotokolle
- Qualitätsberichte
- Testberichte
- Änderungsprotokolle

Es soll geklärt werden, welche Artefakte verbindlich sind und wie sie gepflegt werden.

---

## 7.3 Agentenrollen und Orchestrierung

Zu untersuchen sind mögliche Agentenrollen:

- Requirements Agent
- Architecture Agent
- Implementation Agent
- Test Agent
- Security Agent
- Data Agent
- UX Agent
- Reviewer Agent
- Release Agent
- Documentation Agent
- Experiment Agent

Zu bewerten sind:

- Einzelagenten
- spezialisierte Agenten
- hierarchische Agentensysteme
- Planner-Worker-Reviewer-Modelle
- konkurrierende Lösungsagenten
- unabhängige Review-Agenten
- parallele Entwicklung
- Git-Branches
- Git Worktrees
- kontrollierte Integration
- autonome Schleifen
- klare Abbruchbedingungen

---

## 7.4 MCP und Tool-Integration

Das Model Context Protocol soll sachlich und ohne Marketingüberhöhung untersucht werden.

Zu klären ist:

- Welche Probleme löst MCP tatsächlich?
- Wann ist MCP besser als CLI, REST API oder SDK?
- Wie können Agenten auf GitHub, Dateien, Datenbanken, Browser und Tests zugreifen?
- Wie werden Berechtigungen beschränkt?
- Wie werden Tool-Aufrufe protokolliert?
- Wie wird Prompt Injection verhindert?
- Wann sind eigene MCP-Server sinnvoll?
- Wann erzeugt MCP unnötige Komplexität?
- Welche Alternativen oder konkurrierenden Standards existieren?

MCP ist nicht das Ziel, sondern ein möglicher Baustein der Integrationsarchitektur.

---

## 7.5 Softwarearchitektur

Zu untersuchen sind:

- modularer Monolith
- Clean Architecture
- Hexagonal Architecture
- Vertical Slice Architecture
- Domain-driven Design
- Event-driven Architecture
- Microservices
- API-first Development
- Contract-first Development
- Backend-for-Frontend
- lokale Architekturen
- hybride Architekturen
- Progressive Web Apps
- Android-Apps
- Offline-first
- Synchronisierung

Bewertungskriterien:

- Einfachheit
- Verständlichkeit
- Wartbarkeit
- Testbarkeit
- Agentenfreundlichkeit
- lokale Betreibbarkeit
- Wiederherstellbarkeit
- Sicherheit
- Lock-in
- Evolutionsfähigkeit

---

## 7.6 Entwicklungs- und Deployment-Plattform

Zu untersuchen sind:

- Visual Studio Code
- Claude Code
- weitere Coding-Agenten
- GitHub
- GitHub Actions
- Docker
- Docker Compose
- Dev Containers
- Infrastructure as Code
- lokale Paketverwaltung
- Reverse Proxies
- Tailscale
- automatisierte Deployments
- Rollbacks
- Backup und Restore
- Observability
- Logging
- Monitoring
- Tracing
- Fehleranalyse

Die Lösung soll zur vorhandenen Windows-Umgebung passen und darf nicht unnötig komplex werden.

---

## 7.7 Qualitätssicherung

Zu untersuchen sind:

- statische Analyse
- Typprüfung
- Linting
- Formatting
- Unit Tests
- Property-based Testing
- Mutation Testing
- Contract Tests
- Integrationstests
- Datenbanktests
- API-Tests
- End-to-End-Tests
- visuelle Regressionstests
- Accessibility-Tests
- Performance-Tests
- Stabilitätstests
- Security-Tests
- Dependency-Prüfungen
- Supply-Chain-Prüfungen
- KI-basierte Reviews
- unabhängige Zweitagenten-Prüfung

Bewertet werden soll insbesondere:

- funktionale Korrektheit
- Verständlichkeit
- Wartbarkeit
- Architekturkonformität
- Sicherheitsrisiken
- unnötige Komplexität
- Testqualität
- Dokumentationsqualität
- Reproduzierbarkeit

---

## 7.8 Evidence Chain und Traceability

Für jede relevante Änderung soll nachvollziehbar sein:

- welche Anforderung umgesetzt wurde
- welche Entscheidung zugrunde lag
- welche Dateien verändert wurden
- welcher Agent die Änderung vorgenommen hat
- welche Tests ausgeführt wurden
- welche Ergebnisse erzielt wurden
- welche Risiken verbleiben
- welche Qualitätsgrenzen geprüft wurden
- wer oder welcher Agent die Änderung überprüft hat
- wer die Freigabe erteilt hat

Ziel ist eine durchgängige Evidence Chain von der Anforderung bis zum Deployment.

---

## 7.9 Experimentiermethodik

Ein professionelles Experiment soll enthalten:

1. Hypothese
2. erwarteten Nutzen
3. messbare Erfolgskriterien
4. begrenzten technischen Spike
5. isolierte Implementierung
6. automatisierte Evaluation
7. Variantenvergleich
8. dokumentiertes Ergebnis
9. Entscheidung
10. Übernahme, Anpassung oder vollständiges Verwerfen

Zu untersuchen sind:

- technische Spikes
- Proofs of Concept
- Prototyping
- Feature Flags
- Branches
- Git Worktrees
- temporäre Testumgebungen
- Benchmarking
- Architecture Fitness Functions
- Evaluation Harnesses
- Golden Datasets
- Regression-Evaluationen
- LLM-Evaluationen

Experimente sollen schnell und preiswert sein, aber das stabile System nicht gefährden.

---

## 7.10 UI- und UX-Engineering

Zu untersuchen sind:

- User-centered Design
- Jobs to be Done
- User Journeys
- Personas
- Task Analysis
- Informationsarchitektur
- Wireframes
- interaktive Prototypen
- Design Systems
- Component Libraries
- Accessibility by Design
- Responsive Design
- Usability-Heuristiken
- automatisierte UI-Tests
- visuelle Regression
- Screenshot-Vergleiche
- browsergestützte Agententests
- synthetische Nutzer
- modellbasierte UI-Tests

Zu klären ist:

- Wie lassen sich Oberflächen ohne professionelle Designausbildung spezifizieren?
- Wie können Agenten Varianten erzeugen?
- Wie werden Inkonsistenzen verhindert?
- Wie können Web und Android gemeinsame Designprinzipien nutzen?
- Welche UX-Prüfungen können automatisiert werden?
- Wo bleibt menschliche Beurteilung unverzichtbar?

---

## 7.11 Android-Entwicklung

Zu untersuchen sind:

- native Android-Entwicklung
- deklarative UI
- Progressive Web Apps
- hybride Frameworks
- Cross-Platform-Frameworks
- gemeinsame Backend-APIs
- Offline-first
- lokale Datenspeicherung
- Synchronisierung
- Emulator-Tests
- Device Farms
- Screenshot-Tests
- Accessibility-Tests
- interne Distribution ohne öffentlichen App Store

Bewertet werden soll insbesondere:

- Entwicklungsaufwand
- Wartbarkeit
- Testbarkeit
- Agentenunterstützung
- Betriebsaufwand
- Offline-Fähigkeit
- langfristige Zukunftsfähigkeit

---

## 7.12 Datenarchitektur und Ontologien

Zu untersuchen sind:

- relationale Datenbanken
- dokumentenorientierte Datenbanken
- Graphdatenbanken
- Wissensgraphen
- Ontologien
- Taxonomien
- semantische Modelle
- Metadatenmanagement
- Master Data Management
- Datenqualität
- Datenherkunft
- Provenance
- Versionierung
- Schema-Evolution
- Datenvalidierung
- Entity Resolution
- Dublettenerkennung
- zeitabhängige Daten
- Quellenbewertung

Es soll klar unterschieden werden zwischen:

- Technologien mit echtem Mehrwert
- Technologien mit situativem Nutzen
- überdimensionierten Ansätzen
- rein modischen Begriffen

---

## 7.13 Datenerfassung aus Webseiten und Quellen

Zu untersuchen sind:

- offizielle APIs
- strukturierte Webdaten
- Web Scraping
- Browser Automation
- Dokumentextraktion
- PDF-Extraktion
- OCR
- Änderungsüberwachung
- Datenbereinigung
- Normalisierung
- Quellenvergleich
- Vertrauensbewertung
- Konflikterkennung
- Speicherung von Rohdaten
- Speicherung abgeleiteter Daten
- rechtliche Grenzen
- technische Grenzen
- Robots-Regeln
- Nutzungsbedingungen
- Caching
- Aktualisierungsstrategien

Ein gespeicherter Fakt sollte möglichst auf Folgendes zurückgeführt werden können:

- Quelle
- Abrufzeitpunkt
- Rohdaten
- Transformationsschritte
- Qualitätsbewertung
- Version

---

## 7.14 Sicherheit und Datenschutz

Zu untersuchen sind:

- Least Privilege
- Secrets Management
- Authentisierung
- Autorisierung
- Tailscale
- sichere Agentenberechtigungen
- isolierte Ausführungsumgebungen
- Prompt-Injection-Schutz
- Dependency Pinning
- Software Bill of Materials
- Provenance
- Signierung
- Schwachstellenprüfung
- Audit Logs
- sichere Backups
- Notfallwiederherstellung
- Schutz vor schädlichen Abhängigkeiten

Die Sicherheitsarchitektur soll professionell, aber der privaten Nutzung angemessen sein.

---

## 7.15 Remote-Steuerung und Smartphone-Nutzung

Zu untersuchen ist, wie Entwicklungs- und Betriebsprozesse sicher gesteuert werden können über:

- Visual Studio Code
- Browser
- Remote-Desktop
- GitHub Issues
- Pull Requests
- Chat-Oberflächen
- Agentenoberflächen
- Smartphone
- Tailscale-geschützte Dienste

Zu klären ist:

- Welche Aktionen sind mobil sinnvoll?
- Wie können Agentenaufträge mobil erteilt werden?
- Wie können Freigaben erteilt werden?
- Wie werden Tests und Deployments überwacht?
- Welche Aktionen sollten mobil bewusst nicht möglich sein?
- Wie verhindert man riskante Änderungen durch vereinfachte Oberflächen?

---

# 8. Bewertungsmodell

Jede Methode und Technologie soll bewertet werden nach:

- technischer Reife
- wissenschaftlicher Evidenz
- praktischer Evidenz
- Einsatzfähigkeit im Jahr 2026
- Nutzen für kleine private Projekte
- Komplexität
- Wartungsaufwand
- Lernaufwand
- Kosten
- Datenschutz
- Sicherheit
- Herstellerabhängigkeit
- Automatisierbarkeit
- Agentenfähigkeit
- Testbarkeit
- Reproduzierbarkeit
- Zukunftsfähigkeit

Die Ergebnisse sollen eingeordnet werden als:

- jetzt empfohlen
- sinnvoll unter bestimmten Bedingungen
- für ein Pilotprojekt geeignet
- beobachten
- für die aktuelle Situation überdimensioniert
- derzeit nicht belastbar
- überwiegend Marketing

---

# 9. Erwartete Ergebnisse

Die Recherche soll zu folgenden Ergebnissen führen:

1. State-of-the-Art-Übersicht
2. Zielbild eines KI-nativen Engineering-Lifecycles
3. Rollenmodell für Mensch und KI-Agenten
4. Referenzarchitektur für die Entwicklungsumgebung
5. Referenzarchitektur für Deployment und Betrieb
6. empfohlene Toolchain
7. Vergleich wichtiger Alternativen
8. Qualitäts- und Teststrategie
9. Experimentiermethodik
10. Daten- und Ontologiestrategie
11. UI- und UX-Strategie
12. Android-Strategie
13. Sicherheits- und Berechtigungsmodell
14. Projektgedächtnis- und Kommunikationsmodell
15. standardisierter Projektablauf
16. Reifegradmodell
17. schrittweise Einführungs-Roadmap
18. Liste relevanter Forschungslücken
19. Bewertung zukünftiger Entwicklungen
20. konkrete Anwendung auf bestehende Projekte

Für jede Empfehlung soll dokumentiert werden:

- welches Problem sie löst
- welchen konkreten Nutzen sie bringt
- welche Nachteile entstehen
- welche Voraussetzungen gelten
- welche Kosten und Aufwände entstehen
- ob sie sofort eingeführt werden sollte
- ob sie pilotiert werden sollte
- ob sie lediglich beobachtet werden sollte

---

# 10. Geplanter Forschungs- und Einführungsablauf

## Tranche 1: Zielbild und methodisches Fundament

Fokus:

- KI-nativer Lifecycle
- Mensch-KI-Rollenmodell
- Autonomiestufen
- Projektartefakte
- Projektgedächtnis
- Entscheidungen
- Freigaben
- Experimente
- Traceability

Ergebnis:

**Operating Model und Lifecycle-Referenzmodell**

---

## Tranche 2: Entwicklungsplattform und Toolchain

Fokus:

- Visual Studio Code
- Claude Code
- GitHub
- Branching
- Git Worktrees
- MCP
- CLI
- APIs
- Docker
- Dev Containers
- CI/CD
- Tailscale
- Windows-Server
- Remote-Steuerung

Ergebnis:

**Referenzarchitektur der AI Engineering Workbench**

---

## Tranche 3: Qualität, Verifikation und Governance

Fokus:

- Teststrategie
- statische Analyse
- Architekturregeln
- unabhängige Reviews
- Security Gates
- Evidence Chains
- autonome Fehlerbehebung
- Qualitätsmetriken

Ergebnis:

**Quality Engineering Framework**

---

## Tranche 4: Daten, Quellen und Ontologien

Fokus:

- Datenarchitektur
- relationale Datenbanken
- Dokumentdatenbanken
- Graphdatenbanken
- Ontologien
- Provenance
- Webdaten
- APIs
- Scraping
- Quellenbewertung
- Versionierung

Ergebnis:

**Data and Knowledge Engineering Framework**

---

## Tranche 5: UI, UX und Android

Fokus:

- Designprozess
- Designsystem
- Accessibility
- Browser-Tests
- visuelle Regression
- Android-Architektur
- Cross-Platform-Optionen
- mobile Tests
- interne Distribution

Ergebnis:

**Experience Engineering Framework**

---

## Tranche 6: Integration in eine Gesamtmethodik

Fokus:

- projektübergreifende Standards
- zentrale Agentenanweisungen
- Projektinitialisierung
- standardisierte Artefakte
- Rollen
- Quality Gates
- Handover-Verfahren
- Reifegradmodell
- Einführungs-Roadmap

Ergebnis:

**Wiederverwendbare KI-native Software- und Systems-Engineering-Methodik**

---

# 11. Leitprinzipien

Die Methodik soll:

- professionell sein
- pragmatisch bleiben
- keine unnötige Enterprise-Komplexität erzeugen
- nachvollziehbar sein
- auditierbar sein
- reproduzierbare Entwicklungsumgebungen ermöglichen
- lokale und private Nutzung unterstützen
- offene Standards bevorzugen
- KI-Agenten kontrollierte Autonomie geben
- klare menschliche Entscheidungspunkte enthalten
- Experimente ermöglichen
- das stabile System schützen
- Anforderungen, Architektur, Code und Tests verbinden
- über mehrere Projekte wiederverwendbar sein
- Fehler und Unsicherheiten sichtbar machen
- Risiken explizit behandeln
- Wissen langfristig erhalten
- schrittweise eingeführt werden können

---

# 12. Architektonische Grundannahme

Die Einführung einzelner Technologien darf nicht am Anfang stehen.

Die sinnvolle Reihenfolge lautet:

1. Operating Model
2. Informations- und Wissensmodell
3. Lifecycle
4. Rollen und Verantwortlichkeiten
5. Architekturprinzipien
6. Qualitätsmodell
7. Toolchain
8. Automatisierung
9. Agentenautonomie
10. kontinuierliche Verbesserung

MCP, Docker, Claude Code, GitHub, Android oder einzelne Agentenframeworks sind Bausteine. Sie sind nicht das eigentliche Ziel.

Die entscheidenden Fragen sind:

- Welche Entscheidungen darf ein Agent treffen?
- Welche Informationen gelten als verbindlich?
- Wie werden Ergebnisse geprüft?
- Wie werden Fehler erkannt?
- Wie werden Risiken begrenzt?
- Wann muss ein Mensch eingreifen?
- Wie bleibt die Entwicklung reproduzierbar?
- Wie wird Wissen über Sessions und Projekte hinweg erhalten?

---

# 13. Gewünschtes Endprodukt

Das Endprodukt soll eine praktisch nutzbare Methodik sein, die in neue und bestehende Projekte übernommen werden kann.

Dazu gehören voraussichtlich:

- ein allgemeines Methodikhandbuch
- eine standardisierte Projektstruktur
- eine zentrale Agentenanweisungsdatei
- Vorlagen für Anforderungen
- Vorlagen für Architekturentscheidungen
- Vorlagen für Experimente
- Vorlagen für Handover-Dokumente
- Quality Gates
- CI/CD-Standards
- Teststandards
- Daten- und Provenance-Standards
- UI- und UX-Standards
- Sicherheitsrichtlinien
- Reifegradmodell
- Projektstart-Checkliste
- Release-Checkliste
- Betriebs- und Wiederherstellungsleitfaden

---

# 14. Nächster Arbeitsschritt

Der erste konkrete Forschungsblock soll sich auf das methodische Fundament konzentrieren.

## Nächster Forschungsauftrag

**Entwicklung eines KI-nativen Operating Models und Lifecycle-Referenzmodells für kleine, anspruchsvolle Softwareprojekte.**

Dabei sollen zunächst geklärt werden:

- Rollen von Mensch und Agenten
- Autonomiestufen
- Projektartefakte
- Informationsflüsse
- Entscheidungsprozesse
- Freigabepunkte
- Parallelisierung
- Verifikation
- Experimentierkreisläufe
- Traceability
- Abbruch- und Eskalationsmechanismen

Erst danach sollen Toolchain, MCP, Docker, CI/CD und konkrete Technologien systematisch eingeordnet werden.

---

# 15. Kurzform des Forschungsziels

> Gesucht wird eine professionelle, KI-native Software- und Systems-Engineering-Methodik, in der ein menschlicher Chefarchitekt Ziele, Anforderungen, Architektur und Freigaben steuert, während KI-Agenten innerhalb klarer Leitplanken möglichst autonom analysieren, planen, implementieren, testen, debuggen, experimentieren, dokumentieren und verbessern. Die Methodik soll für kleine private Projekte geeignet, technisch modern, reproduzierbar, sicher, auditierbar und über mehrere Projekte wiederverwendbar sein.
