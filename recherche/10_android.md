# Android-Entwicklung für private Projekte: Ansatzwahl, Agenten, Tests, Build und Distribution ohne App Store

Stand: 2026-07-28. Quellenstatus-Konvention: **[V]** = URL am 2026-07-28 selbst abgerufen und inhaltlich geprüft; **[S]** = nur über Suchergebnisse belegt. Publikationsdaten der Quellen, soweit bekannt, im Quellenverzeichnis.

## Executive Summary

Die wichtigste Entwicklung 2026 ist nicht technischer, sondern regulatorischer Natur: Google erzwingt **Developer Verification** für App-Installationen auf zertifizierten Android-Geräten — ausdrücklich auch für Sideloading außerhalb jedes Stores. Enforcement beginnt am 30.09.2026 in Brasilien, Indonesien, Singapur und Thailand und wird 2027 global ausgerollt (also auch Deutschland); für Hobby-Entwickler gibt es ab August 2026 einen kostenlosen **Limited Distribution Account** (ohne Ausweis, unbegrenzt viele Apps, maximal 20 Geräte), ADB-Installationen bleiben unbeschränkt, und ein „Power-User-Flow" für unverifizierte Apps ist zugesagt. Für Andreas' Familienverteilung ist das gut lösbar, muss aber ab sofort als explizite Distributions- und Signing-Strategie geführt werden; F-Droid bezeichnet die Regelung als existenzielle Bedrohung. Beim Ansatzvergleich hat sich das Feld konsolidiert: React Native ist mit Expo als Framework-Standard und der New Architecture (ab Expo SDK 55 verpflichtend) technisch bereinigt; Flutter ist stabil, aber ohne Synergie zu Andreas' TypeScript-Portfolio; Kotlin Multiplatform hat mit Compose Multiplatform 1.8 (iOS stable seit 05/2025) den Enterprise-Pfad erreicht; PWA ist auf Android für Dashboard-artige Clients der legitime Default. Für die Agentenfrage ist Expo 2026 klar führend: offizielle AI-Agents-Dokumentation, Expo MCP Server (auch im Free Plan), ein Skills-Plugin und automatisch generierte `CLAUDE.md`/`AGENTS.md` machen Expo zum am besten agentifizierten Mobile-Stack; Android Studio zieht mit Agent Mode und „Bring Your Own Model" (inkl. Claude) nach, bleibt aber IDE-gebunden. Testseitig ist Maestro der pragmatische E2E-Standard (YAML-Flows, Accessibility-Ebene, visuelle Checks), Firebase Test Lab bietet kostenlose Tageskontingente; kommerzielle Device Farms sind für den Privatkontext überdimensioniert. Beim Build gilt: `eas build --local` läuft nicht auf Windows (nur macOS/Linux, WSL2 inoffiziell) — Mobile-Builds gehören daher in GitHub Actions, mit selbstverwaltetem Keystore, dessen Sicherung durch die Verification-Registrierung noch kritischer wird. Konkrete Empfehlung: **capsule-app auf Expo weiterführen, nicht wechseln**, aber methodisch härten (OpenAPI-Client + Contract-Tests, expo-sqlite, Maestro-Smoke, CI-Build, Obtainium-Verteilung) — und jedes neue Mobile-Bedürfnis zuerst gegen die Frage „reicht eine PWA?" prüfen.

## 1. Der regulatorische Wendepunkt: Google Developer Verification 2026/2027

Google verlangt künftig, dass Apps auf **zertifizierten Android-Geräten** (praktisch alle Geräte mit Play Services außerhalb Chinas) von **verifizierten Entwicklern** stammen — unabhängig vom Vertriebskanal, also auch bei direktem APK-Sideloading und in Drittstores ([V] Google-Hilfe „Understanding Android developer verification"). Die verifizierte Zeitleiste ([V] Android Authority, 2026-06-19; [V] Google-Hilfe):

- **Juni 2026:** Ausrollen eines Systemdienstes zur Verifikation über Google System Updates (die „Android Developer Verifier"-App war ab 03/2026 sichtbar, [S] 9to5Google), noch ohne Enforcement.
- **August 2026:** Start der **Limited Distribution Accounts** für Hobbyisten und Studierende: kostenlos, ohne Ausweispflicht, unbegrenzt viele Apps, Verteilung an **bis zu 20 Geräte**.
- **30.09.2026:** Enforcement in Brasilien, Indonesien, Singapur, Thailand; unverifizierte Apps erfordern „extra steps" bei der Installation.
- **2027:** Globale Ausweitung auf alle zertifizierten Geräte — damit auch Deutschland.

Der volle Account kostet 25 USD und erfordert Ausweisverifikation (Organisationen zusätzlich D-U-N-S). Explizit ausgenommen bleiben laut Google **ADB-Installationen** (Entwickler-Workflow) und Enterprise-Managed-Devices; zusätzlich ist ein „advanced flow" angekündigt, mit dem erfahrene Nutzer unverifizierte Apps nach Risikobestätigung installieren können ([V] Google-Hilfe). Die Regelung erfasst neben Play auch Galaxy Store, GetApps u. a. ([V] Android Authority).

Die Gegenposition: F-Droid nennt das Programm in einem offenen Brief (2026-02-24) eine Verwandlung Androids in eine „locked-down platform", hält Googles „sideloading is not going away" für „simply untrue", rät Entwicklern von der Teilnahme ab und fordert regulatorisches Eingreifen ([V] f-droid.org; [S] The New Stack, BleepingComputer: „existenzielle Bedrohung" für alternative Stores). Unabhängig von der Bewertung ist die praktische Konsequenz für Privatentwickler: **Distribution wird ein zu planendes Artefakt.** Wichtig ist auch die Nebenwirkung auf das Signing: Die Registrierung bindet Paketname und Signaturzertifikat an eine Entwickleridentität — der Verlust des Keystores wird damit endgültig von „ärgerlich" zu „identitätszerstörend".

**Einordnung für Andreas:** Deutschland ist erst 2027 betroffen; der Limited Account (20 Geräte ≫ Familienbedarf) plus ADB als Entwicklerpfad löst das Problem vollständig und kostenlos. Registrierung ab August 2026 einplanen, Geräteliste führen.

## 2. Ansatzvergleich: Nativ, KMP, Flutter, React Native/Expo, PWA

**Nativ (Kotlin + Jetpack Compose)** bleibt der Referenzpfad mit der besten Plattformintegration, langfristig stabilster Toolchain (Gradle, Android Studio) und dem reifsten Testinstrumentarium. Kosten für Andreas: ein kompletter zweiter Sprach-/Build-Stack (Kotlin/JVM/Gradle) ohne Code- oder Wissens-Sharing mit dem Astro/TypeScript- und Python-Portfolio.

**Kotlin Multiplatform / Compose Multiplatform:** CMP 1.8.0 hat Compose für iOS am 08.05.2025 für **stable und production-ready** erklärt (Feature-Parität für gängige Fälle, Accessibility, Startzeiten „comparable to native") ([V] JetBrains-Blog); die Roadmap (08/2025, [V]) zeigt Swift Export noch experimentell (stable „2026 geplant"), KMP-IDE-Plugin künftig auch für Windows/Linux (ohne iOS-Run-Configs), Compose for Web erst Beta. KMP ist der richtige Weg für Teams, die aus der Kotlin-Welt kommen — für Andreas ohne Kotlin-Basis und ohne akuten iOS-Bedarf: beobachten.

**Flutter** ist technisch solide (Releases 3.35–3.41, Impeller-Renderer; [S] docs.flutter.dev, blog.flutter.dev) mit einer 2026er-Roadmap im Zeichen von Konsolidierung ([S]). Es bleibt aber ein dritter Sprachraum (Dart) ohne jede Synergie zu Andreas' Stack und ohne bestehenden Prototyp — ein Wechsel dorthin wäre reiner Umbau ohne Nutzen.

**React Native / Expo:** Das Ökosystem hat sich auf Expo als Framework konsolidiert ([S] State of React Native 2025). Expo SDK 54 (09/2025, [V] Changelog) bringt RN 0.81/React 19.1, ist die **letzte Version mit Legacy Architecture** (SDK 55 wird New-Architecture-only; 75 % der SDK-53-Projekte auf EAS nutzen sie bereits), liefert vorkompilierte iOS-Frameworks (drastisch kürzere Clean Builds), eine **stabile expo-sqlite-API inkl. SQLite-Extensions wie sqlite-vec**, React Compiler im Default-Template und Android-16-Targeting. Für Andreas relevant: TypeScript-Synergie mit Astro-Projekten, ein bestehender funktionierender Prototyp, und — siehe Abschnitt 3 — die mit Abstand beste offizielle Agentenunterstützung.

**PWA (und Capacitor als Mittelweg):** Auf Android sind PWAs 2026 tragfähig: Installation, Push, Background Sync, Offline via Service Worker, ein einziges Deployable mit Instant-Updates; harte Grenzen bleiben gated Native-APIs, iOS-Zweitklassigkeit und Storage-Eviction-Randfälle ([V] Our Code World, 2026-07-01, mit der brauchbaren Regel „Default to PWA. Make the team justify leaving it."). Capacitor ist der legitime Zwischenschritt, wenn eine Web-Codebasis Store-Distribution oder einzelne Native-APIs braucht. Das deckt sich mit dem Befund in `recherche/05_architektur.md` (PWA als Default für Heimnetz-Dashboards; iOS-Grenzen bei Push/Background-Sync).

## 3. Agentenunterstützung: Welcher Stack ist 2026 am besten „agentifiziert"?

Das ist für Andreas' Methodik die entscheidende Frage, und die Antwort ist eindeutig:

**Expo ist der einzige Mobile-Stack mit offizieller First-Party-Agenteninfrastruktur** ([V] docs.expo.dev/agents): (1) **Expo Skills** — ein Plugin mit Expo-spezifischen Instruktionen und Slash-Commands für bekannte gute Muster (SDK-Upgrades, EAS Workflows, native UI via Jetpack Compose/SwiftUI, API-Routes); (2) der **Expo MCP Server** mit Live-Zugriff auf Dokumentation, EAS-Build-Historie und Update-Channels (inzwischen im Free Plan, [S] Expo-Changelog); (3) `create-expo-app` generiert automatisch `AGENTS.md`, `CLAUDE.md` und `.claude/settings.json` passend zur SDK-Version. Explizit unterstützt: **Claude Code**, Codex, Cursor; Agenten können Simulator-Screenshots aufnehmen, Build-Logs lesen und SDK-kompatible Pakete installieren. Das ist genau das Feedback-Loop-Muster, das Andreas' Methodik (hermetische Gates, Verifikationsbandbreite) voraussetzt.

**Google zieht für den nativen Pfad nach:** Android Studio „Otter 3" (01/2026, [V] Android Developers Blog) macht den **Agent Mode** semi-autonom (App deployen, Screens inspizieren, Screenshots, Logcat lesen, Änderungen am laufenden Gerät verifizieren), führt **BYOM** ein — ausdrücklich inkl. **Anthropic Claude** über API-Key sowie lokale Modelle via Ollama/LM Studio — und bietet „Journeys" (E2E-UI-Tests in natürlicher Sprache), Compose-Generierung aus Mockups, A11y-Fixes und MCP-Client-Support. Einschränkung: Das ist an die IDE gebunden; ein headless-/CLI-getriebener Claude-Code-Workflow, wie Andreas ihn fährt, ist mit Gradle zwar möglich, aber ohne die Expo-artige Paketierung.

**Querschnittsprinzip:** Agentenproduktivität auf Mobile hängt weniger am Framework als an drei Dingen — schnelle deterministische Checks (tsc, ESLint, Unit-Tests), maschinenlesbare E2E-Artefakte (Maestro-YAML ist für Agenten exzellent les- und schreibbar) und Screenshot-Zugriff auf Emulator/Gerät (Expo-Agents und Android Studio Agent Mode bieten beides; generische mobile-MCP-Server existieren, [S]). TypeScript gibt Claude Code zudem denselben Werkzeugkasten wie in Andreas' Astro-Projekten — ein Leitplanken-Set statt zwei.

## 4. Gemeinsames Backend, Offline-first und Synchronisierung

**Ein Backend, mehrere Clients:** Die FastAPI liefert die OpenAPI-Spezifikation code-first; sobald mit der App ein zweiter Konsument existiert, sollte daraus ein **typisierter TS-Client generiert** werden (z. B. openapi-typescript/hey-api) und das eingefrorene Schema per **Contract-/Snapshot-Test** gegen Drift gesichert werden — konsistent mit dem Befund in `recherche/05_architektur.md`. Ein separates BFF ist bei einem Solo-Betreiber Overhead; Token-Handling gehört serverseitig.

**Offline-Stufenmodell für RN/Expo (2026er Praxisstand):**
1. **Cache-only:** TanStack Query mit Persistenz — für reine Browse-Companions ausreichend.
2. **Lokale Wahrheit:** **expo-sqlite (stabile API, SDK 54)** + Drizzle ORM als etablierter Pfad ([S] React Native Relay 2026, Expo-Doku [V] via Changelog); selbstgebauter Pull/Push-Sync mit Last-Write-Wins-Zeitstempeln bleibt für Einzelnutzer-Apps die auditierbarste Lösung.
3. **Echter Multi-Device-Sync:** **PowerSync** hat einen produktionsreifen React-Native/Expo-SDK ([S] docs.powersync.com) — pilotgeeignet, aber erst bei echtem Bedarf; CRDT-Bibliotheken nur bei Kollaboration.

Auf dem nativen Pfad bleibt **Room** der Standard für lokale Persistenz — für Andreas nur relevant, falls je ein Kotlin-Projekt entsteht. Für capsule-app konkret wichtig: eine **Upload-Queue mit Idempotenzschlüsseln** für Foto-Ingest offline — das schließt direkt an die Capsule-v2-Lektionen zu Idempotenz und Provenance an. Bemerkenswert: expo-sqlite unterstützt jetzt **sqlite-vec**, d. h. lokale Vektor-Suche für KI-Features auf dem Gerät ist ohne Zusatzinfrastruktur möglich ([V] SDK-54-Changelog).

## 5. Testen, Build/CI und Signing

**Testpyramide Mobile:** Unit-/Komponententests mit Jest + React Native Testing Library; E2E mit **Maestro** ([V] docs.maestro.dev): arbeitet auf der Accessibility-Ebene ohne Codeänderung, eine YAML-Suite für Android und iOS, testet das fertige Binary ohne npm-Abhängigkeiten, voll kompatibel mit Expo-Dev-Builds und EAS Workflows; Elemente werden über sichtbaren Text oder stabile `testID`s adressiert. Maestro bietet inzwischen auch **Visual Testing** (Screenshot-Assertions) ([S] maestro.dev-Blog). Detox bleibt Alternative, ist aber aufwendiger. Positiver Nebeneffekt: Weil Maestro auf der Accessibility-Ebene arbeitet, erzwingt es saubere Semantik — ergänzt um Androids Accessibility Scanner (manuell) und `eslint-plugin-react-native-a11y` ([S]) ergibt das ein pragmatisches A11y-Minimum.

**Screenshot-Tests nativ:** Auf dem Kotlin/Compose-Pfad sind **Roborazzi** (JVM/Robolectric), **Paparazzi** und Googles Compose Preview Screenshot Testing der Stand der Technik ([S] Vergleiche ProAndroidDev/droidcon, roborazzi-Repo) — Referenzwissen, falls je nativ gebaut wird; für Expo übernimmt Maestro-Visual-Testing die E2E-nahe Variante.

**Emulator und Device Farms:** Emulator-Tests im CI laufen auf GitHub-Actions-Linux-Runnern mit KVM (z. B. `reactivecircus/android-emulator-runner`, [S]). **Firebase Test Lab** bietet im kostenlosen Spark-Plan **10 virtuelle + 5 physische Testläufe pro Tag** (Blaze: 1 $/h virtuell, 5 $/h physisch) ([V] Firebase-Doku) — als gelegentlicher Realgeräte-Check sinnvoll. Kommerzielle Device Farms (BrowserStack u. a.) sind für ein Privatportfolio mit eigenen Geräten überdimensioniert.

**Build und CI:** EAS Build (Cloud) ist bequem, hat aber Free-Tier-Kontingente und Warteschlangen ([S] expo/fyi). Wichtig für Andreas' Windows-Umgebung: **`eas build --local` unterstützt nur macOS und Linux; Windows ist nicht unterstützt, WSL ungetestet-inoffiziell** ([V] Expo-Doku). Zudem gelten lokal Einschränkungen (kein Caching, keine Secret-Env-Vars, Credentials selbst verwalten). Konsequenz: Der reproduzierbare, auditierbare Standardpfad ist ein **GitHub-Actions-Workflow (ubuntu-latest)** — entweder `eas build --local` im Runner oder `expo prebuild` + Gradle ganz ohne EAS-Abhängigkeit. Das passt direkt an Andreas' Run-Manifest-Praxis (Build-Artefakt + Manifest + Checksumme).

**Signing:** Ohne Play Store gibt es kein Play App Signing — der **selbstverwaltete Keystore ist die einzige Identität** der App. Praxis: Keystore einmalig erzeugen, base64-codiert als GitHub-Actions-Secret, Signatur via Gradle/apksigner ([S] gängige Praxis, Appcircle-Guide). Mit Developer Verification wird das Zertifikat Teil der registrierten App-Identität — ein **Signing-Runbook mit Offline-Backup des Keystores** (z. B. verschlüsselt an zwei Orten) ist ab jetzt Pflichtartefakt.

## 6. Distribution ohne öffentlichen App Store

Optionen, sortiert nach Eignung für den Privatkontext:

1. **GitHub Releases + Obtainium** — Obtainium installiert und aktualisiert Apps direkt aus Releases (GitHub, GitLab, Codeberg, F-Droid-Repos, direkte APK-Links); aktiv gepflegt (v1.4.3 vom 16.04.2026, 310 Releases) ([V] GitHub-Repo); private GitHub-Repos sind per API-Key/PAT nutzbar ([S]). Leichtgewichtig, selbstbestimmt, mit Update-Benachrichtigung — der beste Kanal für 2–20 Familiengeräte.
2. **Direkter APK-Link hinter eigener Infrastruktur** (Tailscale/Cloudflare Access) — maximal privat, aber ohne Update-Automatik; gut als Fallback.
3. **Firebase App Distribution** — TestFlight-ähnliches Tester-Management für APKs, kostenlos ([S] Firebase-Doku) — funktional, aber zusätzliche Google-Kopplung.
4. **EAS Internal Distribution** — Ad-hoc-Installationslinks aus dem Expo-Ökosystem ([S]) — bequem, aber Vendor-gebunden.
5. **Google Play (Internal/Closed Testing)** — für neue persönliche Konten gilt weiterhin die **„12 Tester über 14 Tage"-Regel** für Produktionszugang ([S] mehrere übereinstimmende 2026-Quellen) — für Privat-Apps unattraktiver Prozess-Overhead.
6. **Eigenes F-Droid-Repo** — technisch möglich, aber Aufwand plus unklare Zukunft des gesamten F-Droid-Modells unter Developer Verification ([V] F-Droid-Brief).

**Verification-Auswirkung auf alle Kanäle:** Ab Enforcement (DE: 2027) müssen auch per Obtainium/APK installierte Apps von registrierten Entwicklern stammen, sonst greifen Warn-/Blockade-Flows; ADB bleibt frei, der Power-User-Flow ist als Ventil angekündigt, aber noch nicht final spezifiziert ([V] Google-Hilfe, [V] Android Authority). Der Limited Distribution Account deckt Andreas' Bedarf ab.

## Konsequenzen für Andreas' Methodik und Projekte

1. **capsule-app: weiterführen auf Expo — nicht wechseln, nicht auf PWA zurückbauen.** Begründung: funktionierender Prototyp (SDK 54, RN 0.81) existiert; TypeScript-Synergie mit Astro; beste First-Party-Agentenunterstützung aller Mobile-Stacks; Kamera-/Foto-Ingest und künftige Offline-Nutzung sprechen gegen eine reine PWA; Flutter/KMP wären Umbau ohne Nutzen. Ein Wechsel wäre nur bei zwei Signalen zu prüfen: Expo/RN-Ökosystembruch (unwahrscheinlich, Konsolidierung läuft) oder Andreas entwickelt echten Kotlin-Bedarf.
2. **Härtungsplan M1–M2 → M3 (konkret):** (a) SDK-55-Migrationscheck (New-Architecture-only) früh durchführen; (b) OpenAPI-generierter typisierter Client gegen die Capsule-FastAPI + Contract-Snapshot-Test als CI-Gate; (c) durchgängige `testID`-Vergabe und 3–5 Maestro-Smoke-Flows (Start, Login, Wardrobe-Liste, Detail, Suche) — zunächst nicht-blockierend, nach Stabilisierung blockierend; (d) expo-sqlite-Cache plus Upload-Queue mit Idempotenzschlüsseln; (e) CI-Build in GitHub Actions (prebuild + Gradle oder `eas --local`), Artefakt + Run-Manifest; (f) eigener Keystore mit dokumentiertem Offline-Backup (Signing-Runbook); (g) Verteilung über GitHub Releases + Obtainium an die Familiengeräte.
3. **Neues Pflichtartefakt „Distribution & Signing Runbook"** für den Archetyp Mobile Companion: Keystore-Herkunft/-Backup, Verteilkanal, Geräteliste (20er-Limit des Limited Accounts), Update-Prozess, Verification-Status. Termin: **Limited Distribution Account im August 2026 registrieren** — deutlich vor DE-Enforcement 2027.
4. **PWA-first-Prüffrage in die Methodik aufnehmen:** Jede mobile Anforderung durchläuft zuerst „reicht installierbare Web-App?". Für FunkAtlas-/Sensorik-Dashboards: ja (PWA). Für Companions mit Kamera, Offline-Garantien oder Push-Zuverlässigkeit: Expo-Buildpfad.
5. **Agenten-Setup erweitern:** Expo Skills und Expo MCP Server in die Claude-Code-Konfiguration aufnehmen und nach Andreas' MCP-Fähigkeitsklassen einstufen (Doku-Lesen ~M1; EAS-Zugriff mit Build-/Deploy-Wirkung höher, entsprechend Leitplanken). Die von `create-expo-app` generierte `CLAUDE.md` mit der eigenen CLAUDE.md-Struktur zusammenführen, nicht doppeln.
6. **Verifikationsbandbreite respektieren:** Emulator-/E2E-Tests sind teuer und flaky-anfällig — als eigenes Gate mit kleinem, kuratiertem Flow-Set führen (WIP-Limit), Realgeräte-Matrix nur punktuell via Firebase Test Lab (Gratiskontingent), keine Device-Farm-Abos.

## Bewertungstabelle

| Methode/Technologie | Einordnung | Begründung (Kurzform) |
|---|---|---|
| Expo/React Native (New Architecture) | **jetzt empfohlen** | Prototyp existiert; TS-Synergie; beste offizielle Agentenintegration; konsolidiertes Ökosystem |
| PWA für Dashboard-Clients (Android) | **jetzt empfohlen** (als Default-Prüfstein) | Install/Push/Offline auf Android tragfähig; minimaler Betrieb; iOS-Grenzen beachten |
| Capacitor | sinnvoll unter Bedingungen | Web-Codebasis + einzelne Native-APIs; für Andreas derzeit ohne Anwendungsfall |
| Kotlin + Jetpack Compose (nativ) | sinnvoll unter Bedingungen | Referenzqualität, aber zweiter Sprach-Stack ohne Portfolio-Synergie |
| Kotlin Multiplatform / Compose Multiplatform | beobachten | CMP-iOS stable (05/2025), Swift Export erst 2026, Toolchain schwer; ohne Kotlin-Basis kein Nutzen |
| Flutter | sinnvoll unter Bedingungen; für Andreas nicht empfohlen | solide, aber dritter Sprachraum, kein Bestand, keine Agenten-First-Party-Infrastruktur |
| Maestro (E2E + Visual) | **jetzt empfohlen** | YAML, Accessibility-Ebene, Expo-kompatibel, agentenfreundlich |
| Detox | derzeit nicht nötig | höherer Setup-Aufwand ohne Mehrwert gegenüber Maestro im Privatkontext |
| Roborazzi/Paparazzi | sinnvoll unter Bedingungen | nur auf nativem Compose-Pfad relevant |
| Firebase Test Lab (Spark) | sinnvoll unter Bedingungen | 10 virtuelle/5 physische Läufe pro Tag gratis; punktuelle Realgeräte-Checks |
| Kommerzielle Device Farms | überdimensioniert für den Privatkontext | eigene Geräte + Emulator decken den Bedarf |
| EAS Build (Cloud) | sinnvoll unter Bedingungen | bequem, aber Kontingente/Queues und Vendor-Kopplung |
| GitHub-Actions-Build (prebuild+Gradle bzw. eas --local) | **jetzt empfohlen** | reproduzierbar, auditierbar, Windows-Problem umgangen |
| Obtainium + GitHub Releases | **jetzt empfohlen** | aktiver, leichtgewichtiger privater Update-Kanal |
| Firebase App Distribution | sinnvoll unter Bedingungen | Tester-Komfort gegen Google-Kopplung |
| Google Play für Privat-Apps | überdimensioniert für den Privatkontext | 12-Tester/14-Tage-Regel, Review-Prozesse ohne Gegenwert |
| Eigenes F-Droid-Repo | derzeit nicht belastbar | Aufwand + existenzielle Unsicherheit unter Verification |
| Limited Distribution Account (Google) | **jetzt empfohlen** (Registrierung ab 08/2026) | kostenlos, 20 Geräte, löst Verification für den Familienkreis |
| expo-sqlite + Drizzle (Offline) | jetzt empfohlen (bei Offline-Bedarf) | stabile API, sqlite-vec, auditierbarer Eigen-Sync möglich |
| PowerSync (RN/Expo) | pilotgeeignet | produktionsreifer SDK, aber erst bei echtem Multi-Device-Sync |
| Android Studio Agent Mode / Journeys | beobachten | stark, aber IDE-gebunden; nur bei nativem Pfad relevant |

## Quellenverzeichnis

1. [V] Google, „Understanding Android developer verification", support.google.com/android-developer-console/answer/16561738 — abgerufen 2026-07-28.
2. [V] Android Authority, „Android's sideloading changes are getting closer as Google shares new timeline" (2026-06-19) — abgerufen 2026-07-28.
3. [V] F-Droid, „An Open Letter Opposing Android Developer Verification" (2026-02-24) — abgerufen 2026-07-28.
4. [V] Expo Changelog, „Expo SDK 54" (2025-09-10) — abgerufen 2026-07-28.
5. [V] Expo Docs, „AI agents and Expo overview" (docs.expo.dev/agents) — abgerufen 2026-07-28.
6. [V] Expo Docs, „Run EAS Build locally with local flag" — abgerufen 2026-07-28.
7. [V] Android Developers Blog, „LLM flexibility, Agent Mode improvements … Android Studio Otter 3" (2026-01) — abgerufen 2026-07-28.
8. [V] JetBrains Blog, „Compose Multiplatform 1.8.0 … iOS Is Stable and Production-Ready" (2025-05-08) — abgerufen 2026-07-28.
9. [V] JetBrains Blog, „Kotlin Multiplatform Roadmap" (2025-08) — abgerufen 2026-07-28.
10. [V] Maestro Docs, „React Native" (docs.maestro.dev) — abgerufen 2026-07-28.
11. [V] Firebase Docs, „Usage levels, quotas, and pricing for Test Lab" — abgerufen 2026-07-28.
12. [V] GitHub, ImranR98/Obtainium (v1.4.3, 2026-04-16) — abgerufen 2026-07-28.
13. [V] Our Code World, „PWA vs Capacitor vs Native: Choosing an App Architecture in 2026" (2026-07-01) — abgerufen 2026-07-28.
14. [S] 9to5Google, „New ‚Android Developer Verifier' app coming to phones" (2026-03-30).
15. [S] Help Net Security, „Google sets timeline for Android developer verification enforcement" (2026-06-19).
16. [S] The New Stack / BleepingComputer, F-Droid: Verification als „existenzielle Bedrohung" (2026).
17. [S] Expo Changelog, „The Expo MCP Server is now available on the Free plan".
18. [S] Expo Docs, „Expo Skills for AI agents" (docs.expo.dev/skills).
19. [S] developer.android.com, „Agent Mode | Android Studio".
20. [S] docs.flutter.dev, Release Notes 3.35/3.38; blog.flutter.dev „What's new in Flutter 3.38"; „Flutter 2026 Roadmap"-Berichte.
21. [S] Software Mansion, „State of React Native 2025" (results.stateofreactnative.com).
22. [S] maestro.dev Blog, „Introducing Visual Testing in Maestro".
23. [S] Vergleiche Paparazzi/Roborazzi/Compose Preview Screenshot Testing (ProAndroidDev, droidcon Academy, takahirom/roborazzi).
24. [S] docs.powersync.com, „React Native & Expo SDK"; React Native Relay, „Offline-First RN: SQLite + Drizzle 2026".
25. [S] Firebase Docs, „Firebase App Distribution"; Appcircle, „Android App Distribution"-Guide.
26. [S] Übereinstimmende 2026-Quellen zur Google-Play-Regel „12 Tester / 14 Tage" für persönliche Konten (u. a. testerscommunity.com, testfi.app).
27. [S] expo/fyi, „EAS Build queues" (GitHub).
