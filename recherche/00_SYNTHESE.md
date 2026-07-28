# Gesamtsynthese: State-of-the-Art-Sweep KI-natives Software- und Systems-Engineering

**Version 2.0** — Stand: 2026-07-28. Ersetzt `00_SYNTHESE_v1_basis13.md` (archiviert; nur aus Dossiers 01–13 gebaut).
Grundlage: **alle 16 Sweep-Dossiers** (D01–D16: Lifecycle, Artefakte, Orchestrierung, MCP, Architektur, Plattform/Betrieb, Qualität, Experimente/Evals, UX, Android, Daten, Sicherheit, Quellenregister, Claude-Ökosystem, OpenAI/weitere Anbieter, Server-/DB-Administration) **plus die fünf Klärungs-Addenda** (A04a MCP-Spec-Status, A17 Empirie-Anker-Korrekturen, A18 fehlende Organisationen/OSS-Praxis, A19 Kostenmodell, A20 Windows-Autonomie-Matrix). Die vier Konfliktlinien aus `00_KRITIK_UND_LUECKEN.md` sind entschieden (Abschnitt 2).
Kontext: Andreas' Methodik v4.0 — Chefarchitekt-Mensch plus autonome Claude-Code-Agenten, 11 private anspruchsvolle Projekte, Windows-Laptop plus eigener Windows-VPS, Tailscale/Cloudflare, Maßstab professionell ohne Enterprise-Overhead. Diese Synthese verdichtet; Detailbelege stehen in den Einzeldossiers (zitiert als D01–D16 bzw. A04a/A17–A20).

---

## 1. Executive Summary

Der vollständige Sweep über 16 Felder plus fünf Klärungs-Addenda zeigt ein 2026 konsolidiertes Bild: Der KI-native Lifecycle (Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn) ist Branchen- und Forschungskonsens, und die Methodik v4.0 wird in ihren Kernentscheidungen — Autoritätsstufen, Spezifikationspflicht, hermetische Gates, Kontext-Engineering, Run-Manifeste, Verifikationsbandbreite — breit bestätigt, bei Provenance ist sie dem Feld sogar voraus (D01, D05, D07, D11, D13). Der wichtigste übergreifende Befund bleibt: Der Engpass ist Verifikation und Review, nicht Codeerzeugung — jetzt auf ein robustes Ankerbündel gestellt (AIDev-Ablehnungsraten, Review-Wirkungsstudien, Stanford-100k-Matrix, OSS-Maintainer-Reaktionen) statt auf den nicht mehr zitierfähigen METR-Punktschätzer (A17, A18). Zweitens gilt: Verbindlich ist nur, was deterministisch erzwungen wird (Hooks, Permission-Rules, CI, Sandbox, Fitness Functions); Kontextdateien sind advisory (D01, D02, D06, D14). Drittens sind Selbstbestätigung und Selbstkorrektur-Illusion quantifiziert — nötig sind Held-out-Abnahmetests, Rollentrennung mit frischem Kontext und menschliche Freigabe; KI-Review ersetzt sie nicht (D03, D07). Die vier offenen Konfliktlinien sind entschieden: MCP-Zielrevision bleibt 2025-11-25 (die 2026er-Revision war zum Stichtag nur Release Candidate — Lehre: Ankündigung ist kein Vollzug); die METR-−19 % ist durch das Evidenzbündel A1–A8 plus Stanford-Matrix ersetzt, robust bleibt allein die Wahrnehmungs-Mess-Lücke; Benchmarks werden nur noch nach der Regel B1–B5 zitiert (Trend und Within-Study ja, absolute Fähigkeit nein); und die Windows-Autonomie-Grenze ist als Matrix normiert — attended nativ bis A5, unattended read-only nativ mit Kompensationspaket, unattended schreibend nur mit OS-Isolation, A4/A5 nie unattended, Cloud-Routines (promptlos!) nur unter enger Bedingungsliste und strukturell auf A3 gedeckelt (A04a, A17, A20). Neu gegenüber v1 ist die Plattform- und Ökosystem-Ebene: Das Claude-Ökosystem ist ein dreischichtiger Automatisierungs-Stack (Consumer-Oberflächen, Claude Code als Harness, Agent SDK/API) mit drei sauber getrennten Scheduler-Ebenen, Remote Control als mobilem Freigabe-Terminal und Plugins als Verteilmechanismus der Methodik (D14); MCP ist zugleich der Anti-Lock-in-Hebel über alle Anbieter, da OpenAI, Google und Microsoft darauf konvergieren — ein eigener Server läuft in allen Clients (D15). Für den Windows-VPS ist das Betriebsmodell „Agent auf dem Server" (Claude Code headless als Scheduled Task, read-only-Start) heute belastbar; Tailscale SSH fällt als Windows-Ziel aus, DB-Zugriff läuft über restricted-/read-only-MCPs bzw. CLI-Allowlists, Directus bringt den reifsten Verwaltungs-MCP mit (D16). Das Kostenmodell entdramatisiert die Tokenfrage: In Dollar ist agentische Arbeit billig (ein kompletter Recherche-Sweep: einstelliger Dollarbetrag zu API-Preisen), knapp sind die Abo-Fenster — Konsequenz: Max 5x als Fundament, Usage Credits als Überlauf, separater API-Key für CI und Unattended, Kostenfelder ins Run-Manifest (A19). Was der Methodik fehlt, ist klar umrissen: Spec-Reconciliation, Held-out-Suiten, eigene Eval-Suite mit pass^k und evidenzbasiertem A-Auf-/Abstieg nach Task-Klassen, E/N/I-Verbindlichkeitstaxonomie, Erosions-Gegenkräfte, Experiment-Protokoll, Annahmenregister, Betriebs- und Kosten-Layer, Upstream-Etikette und die Paketierung als versioniertes Plugin. Überdimensioniert bleiben Enterprise-Ketten (Microservices, Kafka, Vault, Triple-Stores, IDPs, NIST-/ISO-Zertifizierungspfade, SaaS-Evals, Agenten-Flotten); lokale GPU-Inferenz ist als Coding-Primärpfad nicht konkurrenzfähig (A18). Die Tranche-1-Vertiefung kann jetzt auf stabilen Zahlen aufsetzen und soll daraus Operating Model und Lifecycle-Referenzmodell bauen — mit der Windows-Autonomie-Matrix, dem Kostenmodell und den Scheduler-Ebenen als neuen normativen Kernstücken.

---

## 2. Aufgelöste Konfliktlinien

### K1 — MCP-Spezifikationsstatus (Dossier 04 vs. 13)

**Entscheid: Dossier 13 hatte recht — Current ist 2025-11-25; die Revision 2026-07-28 war zum Prüfzeitpunkt nur Release Candidate (Website-Status „Draft"), nicht veröffentlicht** (A04a, dreifach belegt: Versioning-Seite, GitHub-Release-Tags, 404 auf der Revisions-URL). Dossier 04 hatte den angekündigten Release-Termin als Vollzug behandelt; die *inhaltlichen* Beschreibungen (Stateless Core, Extensions, OAuth-Härtung, Deprecations) sind am RC/Draft korrekt verifiziert, alle Handlungsempfehlungen 1–9 gelten fort. Konsequenzen: (a) CLAUDE.md-Steckbrief führt **2025-11-25 als Zielrevision**; Security-Best-Practices-Link auf die 2025-11-25-URL. (b) Eigene Server werden **„2026-ready"** entworfen: kein Reliance auf `Mcp-Session-Id`, Zustand über explizite Handles, keine Roots/Sampling/MCP-Logging in Neubauten — und (Neufund der Prüfung) **kein Dynamic Client Registration** in neuen OAuth-Flows (ebenfalls „Deprecated in 2026-07-28"). (c) Umgestellt wird nicht per Datum, sondern per **Umstellungstrigger**: Versioning-Seite führt 2026-07-28 als Current + Final-Tag im Repo + stabile SDKs + Claude-Code-Rollout. (d) Methodische Lehre für alle Folgearbeiten: **Ankündigung ≠ Vollzug; Statusquelle-Hierarchie Statusseite > Release-Tag > Changelog > Blog > Presse** — als Recherche-Regel in die Methodik.

### K2 — METR-Anker (Dossiers 03/07 vs. 08)

**Entscheid: Die −19 % ist als generalisierbarer Punktschätzer nicht mehr zitierfähig; die normativen Schlüsse (WIP-Limit, Metrikdisziplin) bleiben und stehen jetzt auf einem breiteren Ankerbündel** (A17). METR selbst stuft die umgebauten Folgedaten als „only very weak evidence" und untere Schranke ein (−18 % Originalkohorte, −4 % neue Entwickler, CIs über null); die Task-Substitution-Analyse zeigt formal, warum Task-Speedups nie 1:1 in Gesamtproduktivität übersetzen. **Robust überlebt die Wahrnehmungs-Mess-Lücke** (alle Prognosegruppen lagen falsch; Survey 2026: ~40 pp Überschätzung) — sie bleibt der Anker der Metrikdisziplin. Das WIP-Limit stützt sich neu auf A1–A8: 46,4 % Ablehnungsquote agentischer Bug-Fix-PRs überwiegend aus Prozessgründen; −23 pp Merge-Rate ohne menschlichen Review; granularere agentische PRs; DORA-Differenzierung 35–40 % vs. ~10 % nach Task-Klassen; CMU-Komplexitätsanstieg (+39 % kognitive Komplexität); Stack-Overflow-Vertrauensparadox; Anthropic-Praxisdaten. Ergänzend liefert die **Stanford-100k-Matrix** (A18) den besten Beleg für aufgabenklassenabhängige Autonomie: Greenfield/niedrig +30–35 % bis Brownfield/komplex ≈0/negativ, Rework-Faktor 2,6. Sprachregelung ab sofort: „METRs 2025-RCT zeigte eine Verlangsamung in einem spezifischen Setting; der aktuelle Effekt liegt um null mit großer Unsicherheit; robust ist die Wahrnehmungs-Mess-Lücke."

### K3 — Benchmark-Zitierregel (Dossiers 01/03 vs. 13)

**Entscheid: Einheitliche Regel B1–B5 für alle Dossiers und Folgearbeiten** (A17), begründet durch das SWE-Bench-Illusion-Paper (76 % vs. 53 % Pfad-Identifikation allein aus dem Issue-Text = Memorisierungsanteil). B1: vollständige Nennung (Benchmark + Subset + Scaffold + Zeitpunkt + Quelle). B2: stehender Memorisierungsvorbehalt. B3: Scores taugen für Trends auf demselben Benchmark, Vergleiche im selben Harness und Within-Study-Ablationen. B4: nie für absolute Fähigkeitsaussagen, Übertragung auf eigene Repos oder Cross-Harness-Vergleiche. B5: Entscheidungsgrundlage für Autonomie und Werkzeugwahl sind **eigene Golden-Task-Evals mit pass^k**, öffentliche Scores nur Kontext. Anwendung: Die 78,4 %-Angabe aus D01 ist als *Trendaussage* zulässig (agentisch vs. nicht-agentisch stagnierend), die Sampling-Zahlen aus D03 sind regelkonforme Within-Study-Ablationen — beide erhalten den B2-Vorbehalt.

### K4 — Windows-Autonomie-Grenze inkl. Routines (Dossiers 06/12 vs. 16; Routines aus 14)

**Entscheid: Kein Widerspruch, sondern zwei verschiedene Achsen — normiert als Matrix über das Tripel (menschliches Gate, Schreibwirkung, Umgebung)** (A20, verifiziert an Sandbox-, Routines-Doku und Issue #46740):

- **W1 — Attended** (Mensch beantwortet Prompts, auch via Remote Control): jede Umgebung zulässig, natives Windows eingeschlossen, bis A5 (dort Zwei-Schritt Plan → Freigabe → Ausführung).
- **W2 — Unattended read-only** (A0; M0/M1): **nativ auf Windows zulässig**, aber nur mit vollständigem Kompensationspaket — Servicekonto ohne Adminrechte + NTFS-ACLs + read-only-DB-Rollen (K), lesende Allowlist im `dontAsk`-Modus (P), Audit-/Kill-File-Hooks (H), Egress-Firewall (E), Credential-Schutz/ENV-Scrub (C). Das legitimiert den Ops-Agenten aus D16.
- **W3 — Unattended schreibend** (A1–A3; M2): nur mit prozessgebundener OS-Isolation (WSL2-Sandbox im Strict-Profil, Devcontainer/VM, ephemerer CI-Runner, Anthropic-Cloud); nativ Windows ausschließlich als eng definierte **Runbook-Ausnahme** (ein benanntes, idempotentes, reversibles Skript als Skill mit `disable-model-invocation`).
- **W4 — A4 (Merge/Promotion) und A5-Fähigkeiten: nie unattended**, in keiner Umgebung.

Verifizierte Planungsgrundlagen: Die native Windows-Sandbox **kommt nicht** (Feature-Request im April 2026 „not planned" geschlossen; Deny-Read-Regeln sind ohne Sandbox per Bash trivial umgehbar) — PowerShell-native Projekte bleiben dauerhaft auf Kompensation bzw. attended angewiesen. **Cloud-Routines laufen komplett ohne Permission-Prompts** und sind im Default unsicher konfiguriert (alle verbundenen Konnektoren inkl. Schreib-Tools aktiv; Konnektor-Traffic umgeht die Netz-Allowlist; Env-Vars sichtbar). Die Lethal-Trifecta-Bewertung ergibt: Routines sind **nur vertretbar**, wenn alle Bedingungen erfüllt sind — M0/M1-Fähigkeiten, Konnektorenliste leer bzw. nur serverseitig read-only, keine Secrets im Environment, Netz Trusted/Custom-minimal (nie Full), nur private Repos, Output nur auf `claude/`-Branches, kein GitHub-Konnektor (trüge Merge-Fähigkeit = A4). So beschnitten endet eine Routine strukturell beim A3-Äquivalent — konform zur v4.0-Regel „unattended endet vor A4". Terminologie-Korrektur zu D16: read-only mit Credentials ist M1, nicht M2. Offener Entscheidungspunkt für Andreas: die moderate M2-Lockerungsoption (unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel) annehmen oder die strikte M0/M1-Regel behalten.

---

## 3. Die wichtigsten übergreifenden Befunde (alle 16 Dossiers + Addenda)

1. **Konvergentes Lifecycle-Muster, divergentes Prozessgewicht; Spec Drift als ungelöstes Kernproblem.** Anthropic, GitHub Spec Kit, Kiro, OpenAI und die Forschung konvergieren auf dieselbe Artefaktkette (Konstitution → Spezifikation → Plan → Tasks → Verifikationsnachweis); Streit besteht nur über das Gewicht (Thoughtworks: SDD „Assess", Warnung vor Spec-Wänden). Kein Framework löst bisher die Divergenz von Spec und Code nach dem Merge — Reconciliation bleibt manuell und wird übersprungen (D01, D02).

2. **Verifikation ist der Engpass — jetzt mehrfach unabhängig belegt.** Statt des METR-Punktschätzers tragen die These: 46,4 % Ablehnung agentischer Bug-Fix-PRs (Prozess-, nicht Codegründe), −23 pp Merge-Rate ohne menschlichen Review, steigende Prüflast auch ohne Tempogewinn, Praktiker-Hauptfriktion „almost right, but not quite" (A17) — und als Feldexperiment die OSS-Community: curl beendet sein Bug-Bounty wegen AI-Slop-Flut, der Kernel verlangt Assisted-by-Kennzeichnung und menschliches Signed-off-by, Gentoo/NetBSD verbieten KI-Beiträge (A18). Wo Einreichung billig und Prüfung teuer wird, kollabieren offene Kanäle — die Verifikationsbandbreite als WIP-Limit („max. 2–3 offene, ungeprüfte Agenten-PRs") ist der Kernregler (D01, D03, D07).

3. **Deterministisches Enforcement schlägt promptbasierte Disziplin.** Hooks (PreToolUse-Deny, Stop-Gates mit 8-Block-Override), Permission-Rules, CI, Sandbox und Fitness Functions erzwingen; CLAUDE.md/AGENTS.md und ADR-Regeln beraten. Das TDAD-Paradox (prozedurale TDD-Prompts erhöhen Regressionen, Test-Impact-Kontext senkt sie um 70 %) misst den Unterschied. Daraus folgt die Verbindlichkeits-Taxonomie **E (erzwungen) / N (normativ-advisory) / I (informativ)** mit Promotion-Pfad für wiederholt verletzte N-Regeln (D01, D02, D06, D08, D14).

4. **Das Selbstbestätigungsproblem ist quantifiziert und braucht strukturelle Antworten.** SpecBench: sichtbare Tests werden gesättigt, verdeckte Spezifikationstests divergieren ~27 pp pro Verzehnfachung der Codegröße (Extremfall 97 %/0 %); ~65 % Kompositionsfehler. Wirksames Fünf-Elemente-Schema: Spec als Testquelle, Red-first mit Rot-Beweis, Rollentrennung Test-Autor/Implementierer, **Held-out-Abnahmetests** (agentenunsichtbar, nur CI), Mutation Testing als Stichproben-Audit (D07).

5. **Selbstkorrektur ist eine Illusion, unabhängige Zweitinstanz funktioniert — KI-Review ersetzt keine Freigabe.** Byte-identische Fehler werden 23–93 pp häufiger korrigiert, wenn als fremd präsentiert; der Reviewer-Subagent mit frischem Kontext (nur Diff + Kriterien) ist empirisch fundiert, aber eng zu scopen (Reviewer-Overfitting). Agent-only-Reviews: hoher Rauschanteil, niedrigere Merge-Raten; das Copilot-Prinzip „Requestor darf nicht approven" ist das Governance-Muster (D03, D07).

6. **Autonomie ist gestuft, wird verdient, wird entzogen — und ist task-klassenabhängig.** Google SRE (L0–L4, Progressive Authorization gegen Golden-Data-Evals, dynamische Degradierung), CISA/NSA-Guidance und SASE-Forschung validieren A0–A5 extern; Anthropic-Telemetrie liefert die Arbeitsteilung (~70 % Planungs- beim Menschen, ~80 % Ausführungsentscheidungen bei Claude). Neu: Aufstieg evidenzbasiert (eigene Golden-Task-Evals, pass^k statt pass@k, Degradierung über Fehlerbudget) **und nach Task-Klasse gestaffelt** — Stanford-Matrix: A3+ für Greenfield/niedrig-mittel, Brownfield-komplex bleibt A1–A2 mit engem Diff-Review, Rework als Pflichtmetrik (D01, D08, D12, D13, A17, A18).

7. **Kontext ist die knappe Ressource; kuratierte, schlanke Artefakte sind messbar besser.** AGENTS.md ist De-facto-Standard (Linux Foundation, 60k+ Projekte; Claude-Brücke per `@AGENTS.md`-Import). Empirie: menschlich kuratierte Kontextdateien +4 % Erfolg bzw. 20–28 % weniger Zeit/Tokens, auto-generierte schaden, jede Datei kostet 20 %+ — Regel: <200 Zeilen, nur Nicht-Ableitbares, Schichtung über rules/Skills/Links. Tool Search (Default) entschärft Toolkatalog-Kosten strukturell (D02, D04, D05, D14).

8. **Zwei legitime Kontrollregime — Regime-Wahl statt Dogma.** Ex ante (hermetische Gates: Anthropic, Thoughtworks) und ex post (minimale Merge-Gates + mechanisch erzwungene Architektur-Invarianten + Continuous Cleanup + triviales Rollback: OpenAI Harness Engineering) funktionieren beide. SPRINT bekommt die drei OpenAI-Voraussetzungen als prüfbare Eintrittsbedingung; HYBRID wird regelbasierte Archetyp-Zuordnung (D01).

9. **Agentenfreundliche Architektur ist gute Architektur mit verschobenen Prioritäten.** Modularer Monolith, Vertical Slices, Hexagonal light, DDD light, Greppability, Ein-Kommando-Verify <60 s, strict typing und maschinell erzwungene Modulgrenzen sind harte Leistungsfaktoren; Microservices/Kafka/volle Clean Architecture vervielfachen Agenten-Blindstellen. Slices sind die natürliche Einheit für Worktree-Parallelität und WIP-Limit (D05).

10. **Qualitätserosion ist messbar und braucht institutionalisierte Gegenkräfte.** GitClear (623 Mio. Änderungen): Duplikation +81 %, Refactoring-Anteil 21 %→3,8 %, Konnektivität −35 %; Veracode: Security-Pass-Rate stagniert bei ~55 %, XSS/Log Injection <20 %. Gegenmittel: Fitness Functions als drittes Gate, Continuous-Cleanup-Läufe, Parallel-Varianten mit Löschzwang, Security-Gates gezielt auf die schwachen Klassen, lokale Erosions-Signale (D05, D07, D08).

11. **Sicherheit: Architektur statt Detektion; Werkzeuge jetzt auch für Einzelpersonen.** Prompt Injection ist nicht zuverlässig detektierbar; wirksam sind Aufbrechen der Lethal Trifecta pro Lauf, deterministische Gates für konsequenzielle Aktionen, technische Egress-Kontrolle, eigene Agentenidentität mit kurzlebigen Tokens und Credential-Masking. Supply-Chain-Wurmwellen (Shai-Hulud, LiteLLM/Telnyx) begründen Lockfiles+Hashes, Cooldown 3–7 Tage, ignore-scripts, osv-scanner. Behörden-Guidance (NSA-CSI 20.05.2026, CISA) deckt sich fast eins zu eins mit der v4.0-Philosophie; ATLAS T0101 (Datenzerstörung via Agententool) macht append-only-Backups mit Restore-Proben zum A5-Gate (D04, D06, D12).

12. **MCP konsolidiert unter neutraler Governance und ist der Anti-Lock-in-Hebel — CLI-first bleibt trotzdem richtig.** Zielrevision 2025-11-25 (K1); eigene Server „2026-ready" bauen. Alle großen Anbieter konvergieren auf MCP (OpenAI Apps SDK/Developer Mode, Codex, Gemini CLI, Copilot Studio) — ein selbst gebauter Server läuft in allen Clients; strukturelle Differenz bleibt lokal-first (Claude/CLIs sprechen stdio im Tailnet) vs. cloud-first (ChatGPT verlangt öffentliche Remote-Server → für den VPS vorerst nein). Für Coding-Agenten mit Terminal sind CLIs 4–32× token-günstiger; MCP lohnt bei Multi-Client-Zugriff, Browser-Steuerung (Playwright) und als schmale, überwiegend read-only Fassade. Bezugsquellen: GitHub MCP Registry/Docker Catalog kuratiert; Smithery und Gemini-Extensions ungeprüft — Registry-Einträge verifizieren Namen, nicht Gutartigkeit (D04, D13, D15, A04a).

13. **Das Claude-Ökosystem ist ein dreischichtiger Automatisierungs-Stack, der die Methodik erstmals vollständig technisch durchsetzbar macht.** Schicht 1 Consumer (claude.ai, Desktop/Cowork, Chrome, Mobile), Schicht 2 Claude Code (Hooks mit 20+ Events, Plugins mit privaten Marketplaces, Skills mit `disable-model-invocation` und `allowed-tools`, Subagents, Worktrees, Headless `--bare --json-schema`), Schicht 3 Agent SDK/API. **Drei Scheduler-Ebenen** mit klarer Zuordnung: `/loop` (sessiongebunden, erbt Permissions), Desktop Scheduled Tasks (lokal, per-Task-Permission-Mode), Cloud-Routines (promptlos — nur unter K4-Bedingungen). **Remote Control** macht attended-Betrieb mobil: Permission-Prompts vom Handy, `requiresUserInteraction`-Tools verweigern One-Tap; die mobile Positiv-/Negativliste (freigeben/stoppen ja, destruktiv nie) bleibt Pflicht (D06, D14, A20).

14. **Server- und DB-Administration durch Agenten ist read-only heute belastbar, schreibend nur als Runbook.** Betriebsmodell „Agent auf dem Server": Claude Code läuft offiziell nativ auf Windows Server 2019+, headless per Scheduled Task mit Allowlist und JSON-Schema-Report — matrixkonform als W2. Tailscale SSH fällt als Windows-Ziel aus (nur Linux/macOS) → Windows-OpenSSH + Tailscale-ACLs, Audit serverseitig. DB-Standard: Postgres MCP Pro restricted + `agent_ro`-Rolle, MotherDuck/DuckDB-MCP read-only als Analysefront, SQLite/DuckDB per CLI-Allowlist (`sqlite3 -readonly`), Directus-nativer MCP mit dediziertem User (**Delete-Protection ist default-off → sofort aktivieren**). Runbooks als Skills mit `disable-model-invocation` sind die technische Form der A-Stufen; Windows-Admin-/WinRM-MCPs sind Kleinstprojekte ohne Reife. Einstiegs-Pilot in vier Stufen (Stufe 0: unattended Health-/Log-/DB-Report; Stufe 2: genau ein reversibles Runbook unattended) (D16, A20).

15. **Kostenmodell: In Dollar billig, in Abo-Fenstern knapp.** Verifizierte Tokenfaktoren: Chat 1× → Einzelagent ≈4× → Agent Teams ≈7× → Multi-Agent-Research ≈15×; Modell-Upgrade schlägt Token-Verdopplung. Der komplette Sweep dieses Programms (~2,5–3 Mio. Tokens) entspricht ~8–15 USD API-Listenpreis — der reale Engpass war das 5-Stunden-Fenster des Abos, und der größte Einzelverlust ein abgebrochener Lauf ohne Resume (~0,6 Mio. Tokens). Konsequenzen: Max 5x als Fundament, Usage Credits mit Monats-Cap statt vorschnellem 20x, separater Console-API-Key mit Spend-Limit für CI/SDK/Unattended, Batch-API −50 % für Massenläufe, Kosten-Soll/Ist ins Run-Manifest, Resume-fähige Workflows mit Artefakt je Agent, ein schwerer Workflow je Fenster als Faustregel. CI-Minuten sind gegenüber Tokenkosten vernachlässigbar (Faktor 10–100) (A19).

16. **Provenance und Evidence Chain werden Standard — die Methodik ist voraus.** Die Forschung verschiebt Bewertung zu Prozess-Accountability; W3C PROV bleibt das stabile Referenzmodell und wird relational implementiert (source/fetch/raw_artifact/transform_run/claim); Run-Manifest und Provenance-Kern teilen ein Schema; LLM-/VLM-Extraktionen sind gewöhnliche Activities mit Modell-ID und Prompt-Hash. SLSA v1.2 und GitHub Artifact Attestations (auch private Repos) liefern Artefakt-Provenance als Ein-Schritt-Feature; OTel-GenAI-Feldnamen noch nicht einfrieren (Status Development). Dreistufung: Commit-Trailer/PR-Evidenz überall; Run-Manifest + Attestation bei Auto-Deploy; OTel nur bei Bedarf (D01, D07, D11, D13).

17. **Die 2026er-Empirie differenziert, statt zu widerlegen — Selbstwahrnehmung ist als Steuerungsgröße unbrauchbar.** DORA: 35–40 % Gewinn bei einfachen vs. ~10 % bei komplexen Aufgaben, Change-Failure-Rate leicht steigend, Nutzen fließt über die sieben Kapazitäten (vollständig verifiziert: AI-Policy, Datenökosystem, KI-zugängliche Daten, Versionskontrolle, Small Batches, Nutzerzentrierung, interne Plattformen — als Selbst-Checkliste im Privatmaßstab lesbar). Wahrnehmungs-Mess-Lücke mehrfach repliziert; Benchmark-Regel B1–B5 gilt für alle Zahlen; Entscheidungen brauchen Artefakt-Metriken und eigene Evals (D08, A17).

18. **Pflichten und Bindungsrisiken am Rand des Portfolios sind terminiert.** EU AI Act Art. 50 gilt ab 02.08.2026 (vom Digital Omnibus ausdrücklich nicht verschoben; private nicht-kommerzielle Nutzung weitgehend ausgenommen — Transparenz trotzdem als billiges Default-Feature). Android Developer Verification: Enforcement ab 30.09.2026 (vier Länder), global 2027; **Limited Distribution Account (kostenlos, 20 Geräte) ab 08/2026 registrieren**; Keystore-Verlust wird „identitätszerstörend" → Signing-Runbook. Scraping: OLG Hamburg/LG München präzisieren TDM-Schranken → API-first, maschinenlesbare Opt-outs respektieren und protokollieren (Compliance-by-Provenance). Zwei Lock-in-Lektionen desselben Jahres: Kuzu-Archivierung (Primärspeicher nur auf Dekaden-Formaten) und Amazon-Q-Developer-EOL mit 12-Monats-Runway (Werkzeugbindung als reversibles Commitment führen; Artefakte portabel halten) (D10, D11, D12, D13, A18).

---

## 4. Was bestätigt die Methodik v4.0, was fordert sie heraus, was fehlt ihr

### 4.1 Breit bestätigt (beibehalten, teils schärfen)

- **Autoritätsstufen A0–A5**: extern validiert durch Google L0–L4/Progressive Authorization, CISA-Guidance, SASE-Stufen 0–5, Anthropic-Telemetrie (70/30 vs. 80/20) (D01, D08, D12, D13).
- **Spezifikationspflicht**: Branchenkonsens; Anthropic-Interview-Muster (AskUserQuestion → SPEC.md → frische Session) als Standardweg; binär verifizierbare Akzeptanzkriterien als Hebel (D01, D02).
- **Hermetische Test-Gates und Test-first** — als deterministische Gates (Stop-Hooks, CI), nicht als prozedurale TDD-Prompts; lokale Hooks beschleunigen, CI entscheidet (D01, D07).
- **Verifikationsbandbreite als WIP-Limit**: jetzt mehrfach unabhängig belegt (A17-Bündel, OSS-Feldevidenz) (D01, D03, A17, A18).
- **Run-Manifeste und Evidenzpflicht**: wörtlich bestätigt („show evidence rather than asserting success"; SASE-MRP); der Provenance-Forschung voraus (D01, D05, D07, D11).
- **Kontext-Engineering, kuratierte CLAUDE.md, M0–M4-Fähigkeitsklassen, Trust Boundaries, Least Agency**: durch Empirie, Spezifikation und Behörden-Guidance gedeckt; die Claude-Mechanismen (Scopes, `oauth.scopes`, per-Tool-Allow/Deny, `requiresUserInteraction`) bilden M0–M4 fast 1:1 ab (D02, D04, D12, D14).
- **Kapitel 15 (UX)**: Reihenfolge, Zustandsmatrix, Token-Schichten, Baseline-Governance, Designschleife entsprechen dem verifizierten Stand; Anthropics Generator/Evaluator-Harness bestätigt die Schleife (D09).
- **Drei-DB-Strategie, Playwright-Adapter, Provenance-Leitbild, raw→staging→marts**: Lehrbuchstand 2026 (D11).
- **Architektur-Defaults** (modularer Monolith, ein Repo, kein Kafka/Microservices): Konsens; SASE mappt v4.0-Bausteine fast eins zu eins (D05, D13).
- **Unattended endet vor A4**: durch die Routines-Analyse strukturell bestätigt — promptlose Pfade sind maximal A3-äquivalent beschneidbar (A20).

### 4.2 Herausgefordert (korrigieren oder präzisieren)

- **Gate-Philosophie als Universalprinzip**: Regime-Wahl je Archetyp explizit regeln; SPRINT braucht harte Eintrittsbedingungen (mechanische Invarianten, triviales Rollback, Cleanup-Läufe) (D01).
- **Test-Pass-Rate als Erfolgssignal**: sichtbare Tests sind sättigbar (SpecBench); ohne Held-out-Suite ist „alle Tests grün" trügerisch (D07).
- **Pauschale A-Stufen je Projekt**: Autonomie muss zusätzlich nach Task-Klasse gestaffelt werden (Stanford-Matrix: Brownfield-komplex ≈0/negativ, Rework 2,6×) (A17, A18).
- **Rollenkataloge/Persona-Denken**: Rollen sind Kontext- und Berechtigungsgrenzen (Lead/Implementer/Reviewer/Explorer), keine Jobtitel — Katalog verschlanken (D03).
- **KI-Review als Freigabeersatz**: nicht belastbar; menschliche Freigabe bleibt an A-Stufen gekoppelt (D07).
- **Windows-native als primäre Agenten-Laufzeit**: differenziert nach W1–W4; die native Sandbox kommt nicht („not planned") — dauerhafte Planungsannahme, nicht Übergangszustand (D06, D12, A20).
- **„WSL2 ab A3" als pauschale Regel**: präzisiert — maßgeblich ist das Tripel (Gate, Schreibwirkung, Umgebung); unattended read-only nativ ist mit Kompensationspaket zulässig (A20).
- **Selbstwahrnehmung als Steuerungsgröße**: durchgängig widerlegt; Artefakt-Metriken plus Task-Substitution-Argument (D08, A17).
- **GitHub-Environment-Gates in privaten Repos**: erst ab Enterprise — mobiles Freigabe-Gate über Remote-Control-Prompts und workflow_dispatch (D06).
- **MCP-Empfehlungen aus D04**: inhaltlich richtig, Reifegrad war überzeichnet; Zielrevision 2025-11-25, „2026-ready"-Designregeln, DCR-Deprecation ergänzt (A04a).
- **Benchmark-Nutzung**: nur noch nach B1–B5 (A17).
- **Formale MBSE-/RDF/OWL-Ambitionen**: Digital-Thread-Prinzip und PROV/SKOS-Vokabular ja, Werkzeugketten nein (D01, D11).

### 4.3 Was fehlt (neue Bausteine für v4.x/v5)

1. **Spec-Reconciliation als Lifecycle-Pflichtschritt** nach jedem Merge (OpenSpec-Delta-Denkweise) (D01, D02).
2. **Held-out-Abnahmesuite** je Projekt (5–20 Spezifikationstests, agentenunsichtbar, nur CI) — wichtigste Einzelneuerung (D07).
3. **Eigene Eval-Suite** (20–50 Golden Tasks aus realen Fehlern, Grader-Trias, pass^k, Kanarien-Subset) als Grundlage evidenzbasierten A-Auf-/Abstiegs — jetzt auch die B5-Konsequenz der Benchmark-Regel (D08, A17).
4. **Verbindlichkeits-Taxonomie E/N/I** mit Promotion-Pfad (D02).
5. **Windows-Autonomie-Matrix W1–W4 + Matrizen A/B** als normative Kapitel-22/23-Ergänzung, inkl. Routines-Bedingungsliste und Runbook-Ausnahme (A20).
6. **Kosten-Layer**: Budget-Soll/Ist im Run-Manifest, Caps auf drei Ebenen (Werkzeug/Konto/Prompt), Abo-Fenster-Planung, API-Key-Split, Resume-Pflicht für Mehragentenläufe, monatliches Kosten-Review (A19).
7. **Erosions-Gegenkräfte**: Continuous-Cleanup-Agent, Fitness Functions als Gate, Parallel-Varianten-Löschzwang, lokale GitClear-artige Signale (D01, D05, D08).
8. **Experiment-Protokoll**: Spike-Karten (Hypothese, Erfolgskriterium, Zeit-/Token-Box, Entsorgungsregel) plus Experiment-Log (D08).
9. **Annahmenregister**: [NEEDS CLARIFICATION], „Annahmen deklarieren statt raten", Fragen-Kopplung an A-Stufen (+8 pp belegt) (D02).
10. **EARS-artige Anforderungsnotation** als Traceability-Anker Spec→Test→Run (D01, D02).
11. **Trifecta-Feld im Run-Manifest** und konkrete Agentenidentität (Bot-Account, fine-grained PATs, Masking, ENV-Scrub) (D12).
12. **Backup-Härtung als Autonomie-Gate**: append-only-Ziele, Agent ohne Schreibrecht aufs Backup, automatisierte Restore-Proben mit Dead-Man-Switch als A5-Bedingung (D06, D12).
13. **Methodik als versioniertes Claude-Code-Plugin** (privates Marketplace-Repo: Hooks=A-Stufen, Skills=Modi/Runbooks, Agents=Rollen, Settings) statt kopierter CLAUDE.md-Fragmente (D06, D14).
14. **Betriebs-Layer**: SRE light (Rollouts, Feature-Flags, Fehlerbudget als Autonomie-Drossel), Observability-Minimum (JSON-Logs, Uptime Kuma + Healthchecks, Claude als Diagnose-Konsument), Ops-Agent-Profile („ops-readonly"/„ops-runbook"), Notausschalter-Katalog (Kill-File, Task-Deaktivierung, Key-Rotation), mobile Positiv-/Negativliste (D01, D06, D16).
15. **Scheduler-Zuordnungsregel**: welcher Aufgabentyp auf `/loop` vs. Desktop Task vs. Routine vs. Windows Scheduled Task + Headless gehört (D14, D16, A20).
16. **Upstream-Etikette** für OSS-Beiträge: Policy des Zielprojekts prüfen, Kennzeichnung nach Konvention (Assisted-by/Generated-By), nur Selbstverstandenes einreichen, keine agentischen Security-Reports (A18).
17. **Recherche-Regeln**: Statusquellen-Hierarchie („Ankündigung ≠ Vollzug") und Benchmark-Regel B1–B5 als Vorgaben für alle Recherche-Agenten (A04a, A17).
18. **Distribution & Signing Runbook** (Mobile-Archetyp; Limited Distribution Account 08/2026; Art.-50-Transparenzzeile), **UX-Ergänzungen** (Ein-Seiten-UX-Spec, DESIGN.md, getrennter Design-Evaluator) und **Daten-Bausteine** (Primärspeicher-Regel, dataset.yaml, bitemporales Spaltenpaar, Splink, SQLite-12-Schritte-Rezept) (D09, D10, D11, D12).

---

## 5. Konsolidierte Bewertungstabelle

Skala: **jetzt empfohlen / sinnvoll unter Bedingungen / pilotgeeignet / beobachten / überdimensioniert / nicht belastbar / überwiegend Marketing.** Kosten-Spalte aus A19, wo ableitbar („—" = kein spezifischer Kostenfaktor bzw. im Abo-Alltag enthalten; Faustformeln: 1 Mio. agentische Tokens ≈ 2,5–4 USD Sonnet- bzw. 7–10 USD Opus-Klasse; Fanout nur bei Aufgabenwert ≥ 10–15× Tokenkosten und vorhandenem Verifier).

| Methode / Technologie | Einordnung | Kosten (A19) | Kernbegründung (Dossier) |
|---|---|---|---|
| **Prozess & Artefakte** | | | |
| Lifecycle Specify→Plan→Execute+Verify→Review→Ship (+ Reconcile/Learn) | jetzt empfohlen | — | Branchen-/Forschungskonsens (D01) |
| Leichtgewichtige Interview-Specs, EARS-Kriterien, Change-Deltas | jetzt empfohlen | — | testbar, brownfield-tauglich (D01, D02) |
| AGENTS.md-Verfassung + dünne CLAUDE.md-Brücke, <200 Zeilen, E/N/I | jetzt empfohlen | senkt Kontextkosten 20 %+ | Standard-Governance, Empirie pro Kuratierung (D02) |
| Held-out-Abnahmetests (agentenunsichtbar, nur CI) | jetzt empfohlen | CI-Minuten vernachlässigbar | SpecBench-Konsequenz (D07) |
| Spike-Karten + Experiment-Log mit Entsorgungsregel; Annahmenregister | jetzt empfohlen | — | verhindert Prototyp-Drift; +8 pp Lösungsrate (D02, D08) |
| Benchmark-Regel B1–B5; eigene Golden-Task-Evals mit pass^k | jetzt empfohlen | Kanarien-Subset nightly: klein (Haiku/Sonnet) | Memorisierung belegt; Anbieter-Konsens (D08, A17) |
| Upstream-Etikette (Assisted-by, Projekt-Policies) | jetzt empfohlen | — | OSS-Feldevidenz (A18) |
| **Orchestrierung & Rollen** | | | |
| Writer/Reviewer-Split mit frischem Kontext; Zweitmeinungs-Gate | jetzt empfohlen | ≈2× Einzellauf | Selbstkorrektur-Asymmetrie (D03, D07) |
| Git-Worktrees + PR als Integrationsvertrag; Subagents Explore/Review | jetzt empfohlen | Subagent ≈ 4× Chat | Industriestandard (D03, D08) |
| WIP-Limit „max. 2–3 offene ungeprüfte Agenten-PRs" | jetzt empfohlen | — | Ankerbündel A1–A8 (D03, A17) |
| Dynamic Workflows (Skript-Orchestrierung, resumierbar) | pilotgeeignet | Sweep-Klasse 3–10 USD/Lauf; Resume-Pflicht | offiziell, auditierbar; Kosten messen (D03, A19) |
| Agent Teams (experimentell) | pilotgeeignet/beobachten | ≈7× Session | kein Resume; nur read-lastige Piloten (D03, D14, A19) |
| Best-of-N / kompetitive Agenten | sinnvoll unter Bedingungen | 3–10 USD (Opus-Klasse) je Problem | nur mit hartem Verifier (D03, A19) |
| Background-Agenten Issue→PR (Claude Code Action) | sinnvoll unter Bedingungen | 0,25–3 USD/Lauf (API-Key, --max-turns) | Review-Kapazität limitiert (D03, D06, A19) |
| MetaGPT/ChatDev-Personas, MultiDevin-Flotten | überdimensioniert | — | Forschungsartefakt bzw. Enterprise (D03) |
| „Multi-Agent = besser" | überwiegend Marketing | 15× Tokens ohne garantierten Mehrwert | MAST/Cognition widersprechen (D03) |
| **Claude-Ökosystem & Betrieb** | | | |
| Hooks als Policy-Enforcement; Permission-Rules | jetzt empfohlen | — | einziger deterministischer Pfad (D06, D14) |
| Methodik als privates Plugin-Marketplace | jetzt empfohlen | — | versionierte Verteilung über 11 Projekte (D06, D14) |
| Skills (disable-model-invocation, allowed-tools) als Runbook-Träger | jetzt empfohlen | Kontext nur on demand | technische Form der A-Stufen (D14, D16) |
| Headless `claude -p --bare` + `--json-schema` | jetzt empfohlen | exakte Kosten via total_cost_usd | reproduzierbar; Run-Manifest-Anschluss (D06, D14, D16) |
| Remote Control + Mobile-Freigaben | jetzt empfohlen | — | attended unterwegs; Research Preview, stabil dokumentiert (D06, D14) |
| Claude-Code-Sandbox in WSL2 (Strict-Profil, Masking, strictAllowlist) | jetzt empfohlen (W3-Voraussetzung) | — | OS-Enforcement; nativ Windows kommt nicht (D06, D12, A20) |
| Unattended read-only Ops-Agent nativ (Kompensationspaket K+P+H+E+C) | jetzt empfohlen (W2) | Kontextdiät; Haiku/Sonnet | matrixkonform; D16-Stufe 0 (D16, A20) |
| Desktop Scheduled Tasks | pilotgeeignet | voller Kontext je Feuerung → Diät | per-Task-Permissions, lokal (D14, A19) |
| Cloud-Routines | pilotgeeignet nur unter K4-Bedingungen | aus Plan-Kontingent, promptlos | Konnektoren-/Egress-Risiken; A3-Deckel (D14, A20) |
| `/loop` (Session-Cron) | sinnvoll unter Bedingungen | erbt Session | Deploy-/PR-Babysitting (D14) |
| Deploy-Pfad GitHub-Runner + Tailscale WIF + OpenSSH + Release-Verzeichnis + Auto-Rollback | jetzt empfohlen | CI-Minuten vernachlässigbar | secretless, ephemer, auditierbar (D06) |
| restic/Litestream + Restore-Proben + append-only (A5-Gate) | jetzt empfohlen | — | ATLAS T0101; Wurm-Lehren (D06, D12) |
| Uptime Kuma + Healthchecks kombiniert; JSON-Log-Schema | jetzt empfohlen | — | Außensicht + Dead-Man-Switch (D06) |
| Tailscale SSH zum Windows-Server; GitHub-Env-Gates privat | nicht belastbar | — | technisch nicht verfügbar (D06, D16) |
| Voll-OTel-Stack, IDP, Container-Prod auf Windows | überdimensioniert | — | Betriebslast ohne Nutzen (D06) |
| **Server-/DB-Administration (D16)** | | | |
| Postgres MCP Pro restricted + agent_ro-Rolle | jetzt empfohlen | — | read-only-Enforcement + DBA-Inspektion (D16) |
| DuckDB-MCP read-only als Analysefront; SQLite per CLI-Allowlist | jetzt empfohlen | — | weniger Moving Parts (D16) |
| Directus-nativer MCP (dedizierter User; Delete-Protection aktivieren) | jetzt empfohlen | — | reifster Verwaltungs-MCP im Stack (D16) |
| ssh-mcp vom Laptop (attended) | sinnvoll unter Bedingungen | — | Allowlist serverseitig (D16) |
| Windows-Admin-/WinRM-MCPs; unattended Prod-Writes | nicht belastbar | — | Kleinstprojekte; kein Gate (D16, A20) |
| GUI-Automation für Server-Ops | überdimensioniert/nur Notnagel | — | fehleranfällig, schlecht auditierbar (D16) |
| **MCP & Anbieter-Ökosysteme** | | | |
| CLI-first für Git/Dateien/Tests/DBs; MCP nur bei Mehrwert | jetzt empfohlen | 4–32× token-günstiger | Anthropic-eigene Praxis (D04, A19) |
| Playwright MCP für Browser-/UI-Prüfung | jetzt empfohlen | — | deterministisch, auditierbar (D04, D09) |
| Eigener schmaler Remote-MCP-Server (read-only Fassade, „2026-ready") | sinnvoll unter Bedingungen | Stateless-Design senkt Betrieb (RC-Design) | Multi-Client-Business-Case (D04, A04a) |
| AGENTS.md zusätzlich pflegen; GitHub-/Docker-MCP-Registry als Bezugsquelle | jetzt empfohlen | — | Anti-Lock-in; Kuratierung (D15) |
| Codex CLI als Zweitagent (attended, WSL2) | sinnvoll unter Bedingungen | über vorhandenes ChatGPT-Abo | Quervalidierung; Windows-Sandbox experimentell (D15) |
| Gemini CLI Free Tier (M0-Zweitmeinung); Jules | pilotgeeignet | kostenlos (1.000 Req/Tag bzw. 15 Tasks/Tag) | kein Vertrauen für Writes (D15) |
| ChatGPT-Anbindung des VPS (public Remote-MCP); ChatGPT Work | beobachten / vorerst nein | usage-metered | Exposition + Injection-Fläche; Governance-Ideen übernehmen (D15) |
| Smithery, Gemini-Extensions, ungeprüfte Community-MCPs | nicht belastbar | — | keine Kuratierung; Vorfallshistorie (D04, D15) |
| AgentKit/Copilot Studio/Workspace Studio; A2A; Enterprise-Auth | überdimensioniert | — | Enterprise-Probleme (D04, D15) |
| **Architektur, Qualität, Daten, UX, Mobile** | | | |
| Modularer Monolith + Vertical Slices + Hexagonal light + Ein-Kommando-Verify | jetzt empfohlen | — | agentenkritische Leistungsfaktoren (D05) |
| Fitness Functions (import-linter, dependency-cruiser) als Gate | jetzt empfohlen | — | Schutz gegen Drift/Cognitive Debt (D05, D08) |
| Ruff+pyright als Gate; Hypothesis-PBT; Schemathesis | jetzt empfohlen | — | schnellste deterministische Signale (D07) |
| Mutation Testing als Quartals-Audit; ACH-Muster (Bug-Injektion) | jetzt empfohlen / pilotgeeignet | — | objektiver Testwirksamkeitsnachweis (D07, A18) |
| Supply-Chain-Paket (Lockfile+Hashes, Cooldown 3–7 T., ignore-scripts, osv-scanner) | jetzt empfohlen | kostenlos | Antwort auf Wurmwellen (D07, D12) |
| Eigene Agentenidentität + Trifecta-Prüfung je Lauf | jetzt empfohlen | — | CISA/OWASP-Konsens (D12) |
| SQLite/DuckDB/PostgreSQL-Dreiteilung; Primärspeicher nur Dekaden-Formate | jetzt empfohlen | — | Kuzu-Lektion (D11) |
| Splink, Pandera/pydantic-Gates, dataset.yaml, Compliance-by-Provenance | jetzt empfohlen | — | Standardwerkzeuge; Rechtslage präzisiert (D11) |
| DuckLake (NFL); Crawl4AI; DuckPGQ; PowerSync; Logfire | pilotgeeignet | — | jung bzw. Teilkontexte (D05, D10, D11) |
| GraphRAG als Default | überwiegend Mode | Indexkosten hoch | oft schlechter als Vanilla RAG (D11) |
| DTCG v2025.10 + shadcn-Modell + Storybook 9 + DESIGN.md + getrennter Design-Evaluator | jetzt empfohlen | — | stabile Spec; Anti-Slop belegt (D09) |
| Expo/RN, Maestro, Obtainium, Limited Distribution Account (08/2026), Signing-Runbook | jetzt empfohlen | Account kostenlos | beste Agenten-Integration; Verification-Pflicht (D10) |
| Synthetische Nutzer als Testersatz; KI-Review als Freigabeersatz; Ralph-Loops ohne Gates; PI-Detektions-Guardrails als Primärkontrolle | nicht belastbar | — | jeweils empirisch widerlegt (D03, D07, D09, D12) |
| Lokale GPU-Inferenz als Coding-Primärpfad | nicht belastbar / beobachten | GPU-Anschaffung ≫ Plan-Kosten | ~30 Punkte Lücke; Wiedervorlage H1 2027 (A18) |
| NIST 800-218A, ISO 42001/5338, AgentCore, NIM, AlphaEvolve/CodeMender als Produkte | überdimensioniert | teils fünfstellig | Enterprise-Zuschnitt; Muster übernehmen (A18) |
| Microservices, Kafka, volle Clean Architecture, Vault, Triple-Stores, SaaS-Evals, Device Farms, BMAD | überdimensioniert | — | Enterprise-Probleme ohne Privatkontext (D03–D09, D11, D12) |
| Selbstberichtete Produktivitätsgewinne; Vendor-Review-Claims; „AI-native"-Autonomie-Narrative; „MCP ist tot"; „Trusted Publishing löst Supply Chain" | überwiegend Marketing | — | widerlegt bzw. unbelegt (D01, D03, D04, D07, D08, D12, A17) |

**Abo-/API-Rahmen (A19):** Max 5x (100 USD/Monat) als Arbeitsfundament; Usage Credits mit Monats-Cap 20–40 USD als Überlauf; separater Console-API-Key mit Workspace-Spend-Limit (Start 25 USD/Monat) für CI/SDK/Unattended; Sonnet-5-Promo-Preis endet 31.08.2026 (+50 % einplanen); Max 20x erst nach zwei Monaten dokumentierter Wochenfenster-Erschöpfung.

---

## 6. Priorisierte Konsequenzen

### Sofort (belegter Nutzen, geringer Aufwand)

1. **Windows-Autonomie-Matrix übernehmen** (W1–W4 als Kapitel-22-Ergänzung, Matrizen A/B als Anhang zu Kapitel 23); Entscheidung zur M2-Lockerungsoption treffen; autonome Entwicklungs-Läufe (A1–A3) nur noch in WSL2 mit Strict-Sandbox-Profil, PowerShell-native Projekte attended oder via CI (A20, D06, D12).
2. **VPS-Ops-Agent Stufe 0 freigeben**: `svc-claude`-Konto + `agent_ro`-Rolle, täglicher Health-/Log-/DB-Report headless mit JSON-Schema, Kill-File + Audit-Hook ab Tag 1; Directus-MCP mit dediziertem User und **aktivierter Delete-Protection**; Tailscale-Architektur korrigieren (OpenSSH statt Tailscale SSH) (D16, A20).
3. **Kostenrahmen setzen**: Max 5x + Usage Credits (Cap 20–40 USD) + separater API-Key (Spend-Limit 25 USD) für CI/SDK; Kosten-Soll/Ist-Felder ins Run-Manifest; Mehragentenläufe nur resume-fähig mit Artefakt je Agent; ein schwerer Workflow je 5h-Fenster (A19).
4. **MCP-Steckbrief fixieren**: Zielrevision 2025-11-25, Security-Best-Practices-URL aktualisieren, „2026-ready"-Designregeln (Handles statt Sessions, keine Roots/Sampling/Logging/DCR), Umstellungstrigger statt Datum; Statusquellen-Hierarchie und Benchmark-Regel B1–B5 als Recherche-Regeln in die Methodik (A04a, A17).
5. **Methodik als privates Claude-Code-Plugin paketieren** (Marketplace-Repo: Hooks=A-Stufen/Gates, Skills=Modi und Runbooks mit `disable-model-invocation`, Agents=Rollen mit Tool-Allowlists, Settings) — identisch über alle 11 Projekte; Remote Control mit „Push when actions required" aktivieren (D06, D14).
6. **AGENTS.md-Umstellung + E/N/I-Taxonomie** mit Promotion-Pfad; Pruning-Zyklus; Kompaktierungs-Direktiven; AGENTS.md zusätzlich für Fremd-Agenten (Codex/Gemini) pflegen (D02, D15).
7. **Held-out-Abnahmesuite** für NFL- und Datenplattformen; Red-first als Protokollpflicht ab A3; Reviewer eng scopen (D07).
8. **WIP-Limit, Worktree-Disziplin, Abbruchkriterien** (Stagnationsregel, Budgets, Evidenzpflicht) ins Run-Manifest; Spec-Reconciliation, EARS-Kriterien und Annahmenregister in die Spezifikationspipeline (D01, D02, D03).
9. **Supply-Chain-Paket und Agentenidentität**: Lockfiles+Hashes, Cooldown, ignore-scripts, osv-scanner-Gate; GitHub-Bot-Account mit fine-grained PATs; Trifecta-Feld im Run-Manifest; Backup-Triade mit Restore-Proben als A5-Gate; Deploy-Pfad auf Tailscale WIF (D06, D07, D12).
10. **Gate-Konsolidierung und Termine**: Ruff+pyright, Fitness Functions, axe-core, Schemathesis, Hypothesis; Security-Fokus XSS/Log Injection; Autonomie nach Task-Klassen staffeln (Stanford-Matrix); Eval-Suite klein starten; **Limited Distribution Account im August 2026 registrieren**; Art.-50-Transparenzzeile; Upstream-Etikette (D05, D07, D08, D09, D10, D12, A17, A18).

### Pilotieren (mit Erfolgskriterium und Messung)

- **Routines** streng nach K4-Bedingungsliste (Kandidaten: nächtliche Repo-Pflege, Doku-Drift, PR-Vorreview in privaten Repos; Konnektorenliste vor Anlage leeren) (D14, A20).
- **Ops-Agent Stufe 1–2**: attended Admin-Sessions mit Runbook-Skills („Dienst-Neustart", „Log-Triage", „pg_dump-Verify"); danach genau ein reversibles Runbook unattended mit Rate-Limit und vier Wochen Bewährung (D16).
- **Dynamic Workflows** für Repo-Audits/Migrationen; **Agent Teams** nur read-lastig (Parallel-Review, Bug-Hypothesen) (D03).
- **Codex CLI als Zweitagent** (attended, WSL2) zur Quervalidierung; **Gemini CLI Free Tier** für M0-Zweitmeinungen (D15).
- **ACH-Stil-Mutationsgate** (Kritiker-Agent injiziert Bugs, Testsuite muss sie fangen) auf 1–2 Kernmodulen; **Test-Impact-Kontext (TDAD)**; **Playwright Test Agents** mit Healer-Diff-Gate (D01, D07, D09, A18).
- **Continuous-Cleanup-Agent** als wöchentlicher Scheduled Run; **pass^k-Schwellen (k=3–5)** als Freigabemetrik; LLM-as-Judge nur mit Kalibrierpaket (D01, D08).
- **DuckLake** (NFL-Plattform), **Splink**-Erstläufe, **Crawl4AI**; **eigener schmaler MCP-Server** (read-only Fassade, „2026-ready") für Multi-Client-Zugriff (D04, D11, A04a).
- **Storybook 9 + DESIGN.md + Design-Evaluator**; **Best-of-N** für schwere testbare Probleme; **Claude Code GitHub Action** in zwei Projekten mit `--max-turns` und Spend-Limit; **capsule-app-Härtung M1–M3** (OpenAPI-Client, Maestro-Smoke, CI-Build, Signing-Runbook, Obtainium) (D03, D06, D09, D10).

### Beobachten (Radar, keine Bindung)

- **MCP-Revisionsvollzug** (Umstellungstrigger: Versioning-Seite Current + Final-Tag + stabile SDKs + Claude-Code-Rollout; Prüfrhythmus zunächst täglich/wöchentlich — der Release stand am Stichtag unmittelbar bevor); MCP Apps; Registry-Reife; Tailscale Aperture (A04a, D04, D15, D16).
- **METR-Folgeexperimente** (Fixed-Task, Developer-Level-Randomisierung), Stack-Overflow-2026-Survey, DORA-2026-Zyklus, weitere AIDev-Auswertungen (A17).
- **Lokale Inferenz**: Wiedervorlage H1 2027 mit Kriterium ≤32 GB VRAM und >60 % SWE-bench Verified unabhängig gemessen; bis dahin nur CPU-/iGPU-Nischen (Embeddings, Klassifikation) (A18).
- OTel-GenAI-Feldnamen, SASE-v3-Vokabular, Spec Kit Richtung 1.0, AGENTS.md-Formalisierung, ty/Pyrefly, wslc/WSL-Container, Tailscale Services/Peer Relays, ElectricSQL/Zero, KMP, Android Studio Agent Mode, DuckPGQ, Croissant, AIPREF (Zielabschluss 08/2026), EN 301 549 v4.1.1, Digital-Omnibus-Amtsblatt, CaMeL-Produktisierung, Infisical/OpenBao, ChatGPT Work (als Governance-Ideenquelle), Microsoft Agent Framework, Managed Agents, EnCompass, Debian-GR zu KI-Beiträgen (D01, D04–D15, A18).

---

## 7. Arbeitsauftrag an die Tranche-1-Vertiefung (Operating Model & Lifecycle-Referenzmodell)

Die Vertiefung recherchiert nicht neu, sondern überführt die folgenden Befunde und Addenda in ein konsistentes Operating Model plus Lifecycle-Referenzmodell, gemappt auf die fünf Projektarchetypen. Alle Zahlen sind jetzt konfliktbereinigt — die Addenda-Fassungen (A04a, A17–A20) sind maßgeblich, nicht die Ursprungsformulierungen der Dossiers 03/04/07.

1. **Lifecycle-Referenzmodell** auf das konvergente Phasenmuster ausrichten (Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn) und um zwei Pflichtschritte ergänzen: **Spec-Reconciliation nach Merge** und einen **Learn-Schritt**, der reale Agenten-Fehler in die Eval-Suite und Regelverstöße in den E/N/I-Promotion-Pfad einspeist (D01, D02, D08).
2. **Windows-Autonomie-Matrix als normativen Kern des Operating Model übernehmen**: die Grenzregel W1–W4 wörtlich, Matrizen A (A-Stufen × Umgebung E1–E5) und B (M-Klassen × Umgebung) als Anhang; Routines-Bedingungsliste und Runbook-Ausnahme als geprüfte Checklisten; die offene M2-Lockerungsoption als expliziten Entscheidungspunkt für Andreas ausweisen (A20).
3. **Autoritätsstufen doppelt konditionieren**: (a) evidenzbasierter Auf-/Abstieg über eigene Golden-Task-Evals, pass^k und Fehlerbudget-Degradierung; (b) Task-Klassen-Staffelung nach der Stanford-Matrix (Greenfield/Brownfield × Komplexität; Rework als Pflichtmetrik). Orchestrierungsstufen (Einzelsession → Subagents → Background/Worktree+PR → Workflows/Teams) an A-Stufen koppeln (D01, D03, D08, A17, A18).
4. **Scheduler-Zuordnungsregel ins Operating Model**: welcher Aufgabentyp auf `/loop`, Desktop Scheduled Task, Cloud-Routine oder Windows-Scheduled-Task+Headless läuft — mit den jeweiligen Permission-, Kontext- und Kostenprofilen; Remote Control als attended-Kanal mit mobiler Positiv-/Negativliste (D06, D14, D16, A19, A20).
5. **Kosten-Layer integrieren**: Budget-Soll/Ist als Run-Manifest-Pflichtfelder, Caps auf drei Ebenen, Tokenfaktor-Heuristik (1×/4×/7×/15×), Fanout-Kriterium (Wert ≥ 10–15× Kosten + Verifier), Abo-/API-Split (Max 5x + Credits + API-Key), Resume-Pflicht, monatliches Kosten-Review — Kostensteuerung ist Methodikbaustein, nicht Verwaltungsdetail (A19).
6. **Verifikationsbandbreite operationalisieren** mit dem neuen Evidenzblock A1–A8 statt METR-Punktschätzer: WIP-Limit als max. offene ungeprüfte Agenten-PRs, Slice als Einheit von Parallelität und Review, verschlankter Rollenkern (Chefarchitekt, Lead/Planner, Implementer worktree-isoliert, unabhängiger Reviewer read-only, Explorer) mit Tool-Allowlists als versionierte Agents; Zweitmeinungs-Gate als Methodikregel (D03, A17).
7. **Artefaktkanon mit Verbindlichkeits-Taxonomie konsolidieren**: AGENTS.md-Verfassung (<200 Zeilen, E/N/I), SPEC mit EARS und Annahmenregister, agentenoptimierte ADRs mit Checks, STATUS/Handover, Run-Manifest (PROV/OTel-angelehnt; Pflichtfelder: Evidenz, Trifecta, Kosten-Soll/Ist, Abbruchgrund), Spike-Karte/Experiment-Log, dataset.yaml, DESIGN.md, Distribution-&-Signing-Runbook, Ops-Runbook-Skills — jedes Artefakt mit Eigentümer, Pflege-Trigger und Drift-Schutz (D02, D08–D12, D16, A19).
8. **Qualitätsschicht neu schneiden**: Gate-Hierarchie Statik → Tests (inkl. PBT/Schemathesis) → Fitness Functions → Held-out-Suite (nur CI) → menschliche Freigabe; Audits (Mutation Testing, ACH-Muster, Cleanup-Läufe, Erosions-Signale); Regeln „Testreparatur ist Codeänderung" und Flaky-Quarantäne (D05, D07, D08, A18).
9. **Betriebs-Layer als vollwertigen Teil des Referenzmodells** ausarbeiten (Operate war der dünnste Teil von v4.0): SRE light (progressive Rollouts, Feature-Flags, Fehlerbudget als Autonomie-Drossel), Ops-Agent-Betriebsmodell mit Stufenplan 0–3 und Profilen „ops-readonly"/„ops-runbook", DB-Zugriffsnormen (restricted-/read-only-MCPs, CLI-Allowlists, Directus-Muster „Rechte im Zielsystem"), Backup/Restore-Probe als A5-Gate, Observability-Minimum, Notausschalter-Katalog, mobile Freigabe-Asymmetrie (D01, D06, D16, A20).
10. **Technisches Fundament festschreiben**: WSL2+Sandbox als W3-Laufzeitbedingung, natives Windows dauerhaft ohne Sandbox eingeplant, Methodik-Plugin als Verteilmechanismus, Run-Manifeste an `claude -p --bare --json-schema` gekoppelt, Deploy-Pfad Tailscale-WIF, Agentenidentität und Secrets-Regeln, MCP-Zielrevision 2025-11-25 mit „2026-ready"-Designregeln und definiertem Umstellungstrigger — das Operating Model benennt je Regel den Enforcement-Mechanismus (D06, D12, D14, A04a, A20).
11. **Evidence Chain dreistufig definieren** (Commit-Trailer/PR-Evidenz überall; Run-Manifest + Attestation bei Auto-Deploy; OTel nur bei Bedarf) mit gemeinsamem Schema von Run-Manifest und Provenance-Kern (D07, D11).
12. **Messdisziplin und Recherche-Regeln verankern**: Kennzahlen-Baseline je Projekt (Durchlaufzeit, Rework, Defekt-Escape, Duplikat-/Churn-Signale, Eval-Ergebnisse); explizites Verbot, Entscheidungen auf gefühlte Produktivität oder öffentliche Benchmark-Scores zu stützen (Wahrnehmungslücke, B1–B5); Statusquellen-Hierarchie „Ankündigung ≠ Vollzug" für alle künftigen Recherche-Läufe (D08, A04a, A17).

---

*Quellenlage: Alle tragenden Empirie-Anker sind an Primärquellen verifiziert (D13); die Konfliktlinien sind durch die Addenda A04a und A17–A20 mit eigenen Primärabrufen vom 2026-07-28 entschieden. Zu beachten: Der MCP-Release-Vollzug kann noch am Stichtag erfolgen (Umstellungstrigger, nicht Datum, ist maßgeblich); METR-Folgezahlen, Stack-Overflow-2026 und der DORA-2026-Zyklus stehen aus; der DORA-Vollreport (PDF) und einzelne Behörden-PDFs bleiben gated — betrifft Detailzahlen, keine Kernaussagen.*
