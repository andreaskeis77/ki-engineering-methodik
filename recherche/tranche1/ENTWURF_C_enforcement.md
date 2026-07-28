# Operating Model und Lifecycle-Referenzmodell — Entwurf C: Enforcement-first

**Stand:** 2026-07-28 · **Status:** Entwurf als Entscheidungsgrundlage für Methodik v5 (schreibt v4.0 nicht um; Delta je Baustein in Abschnitt 14) · **Grundlage:** Gesamtsynthese v2 inkl. Konfliktentscheide K1–K4, Addenda A04a/A17–A20, Portfolio-Analyse 2026-07-28, Zielsystem HP EliteDesk 800 G6 · **Perspektive:** Durchsetzung zuerst — jede Regel wird von ihrem Mechanismus her entworfen.

---

## 1. Executive Summary

Dieses Referenzmodell beantwortet die Frage des Forschungsauftrags (Abschnitt 14) von der Durchsetzungsseite her: Ein Operating Model für einen Solo-Chefarchitekten mit autonomen Agenten ist genau so belastbar wie seine technisch erzwungenen Regeln — alles andere ist Bitte, nicht Grenze. Der Sweep hat das empirisch entschieden: Deterministisches Enforcement (Hooks, Permission-Rules, Sandbox, CI, Fitness Functions) schlägt promptbasierte Disziplin; Kontextdateien sind advisory. Deshalb beginnt dieses Modell mit der Verbindlichkeits-Taxonomie **E/N/I** (erzwungen/normativ/informativ) und dem Kernsatz: **Jede E-Regel hat einen benannten technischen Mechanismus; eine Regel ohne Mechanismus ist höchstens N.** Die Autoritätsstufen A0–A5 werden zur **Zustandsmaschine** je Projekt und Task-Klasse: Aufstieg evidenzbasiert (Golden-Task-Evals, pass^k) und menschlich freigegeben, Abstieg automatisch über ein Fehlerbudget. Die Windows-Autonomie-Matrix W1–W4 ist der normative Kern der Umgebungsfrage; der Lifecycle erhält die zwei Pflichtschritte Spec-Reconciliation und Learn; Betriebs-, Scheduler- und Kosten-Layer werden vollwertige Modellteile mit dem Heimserver als Zielsystem. Drei Zeremonieprofile (LIGHT/STANDARD/HIGH-RISK) skalieren den Apparat je Archetyp und Slice — als Antwort auf die Portfolio-Warnung vor Governance-Overhead. Wo Mechanik nicht möglich oder nicht erwünscht ist (Produkturteil, Designfreigabe, Architekturambiguität), bleibt der Mensch bewusst die Instanz; dort gilt der Promotion-Pfad: Text, der wiederholt versagt, wird Physik — Text, der Urteilskraft trägt, bleibt Text.

## 2. Leitidee und Designprinzipien

**Leitidee: Text wird Physik.** Regeln altern in Prosa; sie überleben als Mechanismus. Das Modell kennt drei Verbindlichkeitsstufen:

- **E (erzwungen):** Die Regel ist ohne Mechanismus nicht existent. Zulässige Mechanismen: Hook (PreToolUse-Deny/Ask, Stop-Gate, Audit, Kill-File), Permission-Rule/`--allowedTools`/`dontAsk`, Sandbox-Profil (WSL2 Strict), OS-Konto/NTFS/DB-Rolle, Egress-Firewall/Netz-Allowlist, CI-Gate, Branch Protection, Held-out-Suite, Fitness Function, Spend-Limit/`--max-turns`, Skill mit `disable-model-invocation`, sowie die Matrix-Zellen aus Addendum 20 (Umgebungswahl selbst ist ein Mechanismus).
- **N (normativ-advisory):** verbindlicher Text in AGENTS.md/Verfassung, ADR-Regeln, Checklisten. N-Regeln werden gemessen; eine **zweimal verletzte N-Regel geht in den Promotion-Pfad** (Learn-Schritt) und wird zu E oder bewusst zu I herabgestuft.
- **I (informativ):** on-demand-Doku, Begründungen, Beispiele. Kostet Kontext nur bei Bedarf.

**Designprinzipien:**

1. **Mechanismus-Pflicht:** Jede E-Regel steht mit ihrem Mechanismus im **Enforcement-Register** (neues Artefakt, Abschnitt 6). Das Register wird quartalsweise per **Gate-Probe** getestet: Ein harmloser, absichtlich regelwidriger Versuch muss nachweislich blockiert werden. Enforcement, das nie geprüft wird, erodiert wie Prosa.
2. **Asymmetrie der Autonomie:** Abstieg ist mechanisch (Fehlerbudget), Aufstieg ist menschlich (Evidenz schlägt vor, Andreas entscheidet). Kein Agent und kein Skript erhöht je eine A-Stufe.
3. **Umgebung ist Regel:** Das Tripel (Gate, Schreibwirkung, Umgebung) aus W1–W4 entscheidet vor jeder inhaltlichen Diskussion, wo ein Lauf überhaupt stattfinden darf. Die native Windows-Sandbox kommt nicht („not planned") — das ist dauerhafte Planungsannahme, kein Übergangszustand.
4. **Right-Sizing durch Profile:** LIGHT/STANDARD/HIGH-RISK skalieren Artefakte und Gates je Slice, nicht je Projekt. Der Maßstab ist die Review-Bandbreite eines einzelnen Menschen — der Engpass ist Verifikation, nicht Erzeugung (Evidenzblock A1–A8).
5. **Mechanik dient dem Produkt:** Drei Urteile werden bewusst **nie** mechanisiert: das Produkturteil („verbessert das den Alltag von Andreas und Karen?"), die Designfreigabe (Screenshot-Baselines ändern sich nur nach menschlichem Blick) und die Risikoakzeptanz. Diese bleiben dauerhaft N — ohne Promotion-Pfad. Enforcement schützt die Outcome-Schleife, es ersetzt sie nicht.
6. **Messdisziplin:** Entscheidungen stützen sich auf Artefakt-Metriken und eigene Evals — nie auf gefühlte Produktivität (Wahrnehmungs-Mess-Lücke, mehrfach repliziert) und nie auf öffentliche Benchmark-Scores (Regel B1–B5). Für Recherche gilt die Statusquellen-Hierarchie: Ankündigung ≠ Vollzug.

## 3. Lifecycle

Das Phasenmuster ist Konsensstand: **Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn**, ergänzt um die zwei Pflichtschritte **Spec-Reconciliation** (nach jedem Merge) und einen expliziten **Learn-Schritt**. Enforcement-first heißt: Jeder Phasenübergang ist ein Gate mit benanntem Mechanismus.

| Phase | Ergebnis-Artefakt | Übergangs-Gate | Mechanismus (E) bzw. Norm (N) |
|---|---|---|---|
| Research | Recherche-Notiz, Quellenlage | Statusquellen-Hierarchie eingehalten | N (Regelvorgabe für Recherche-Agenten; B1–B5) |
| Specify | SPEC mit EARS-Kriterien + Annahmenregister | Akzeptanz binär prüfbar; offene Annahmen als `[NEEDS CLARIFICATION]` | N + CI-Lint auf SPEC-Schema (E, leichtgewichtig) |
| Plan | Execution Plan (risikogerecht), Slice-Schnitt, Profilwahl LIGHT/STANDARD/HIGH-RISK | Modus-/A-Stufen-/Umgebungs-Empfehlung liegt vor | N; Umgebungswahl per Matrix A/B (E: Sandbox-/Settings-Profil wird geladen) |
| Execute+Verify | Code + Tests + grünes lokales Gate | Ein-Kommando-Verify grün; Red-first beobachtet (ab A3 Protokollpflicht) | E: Stop-Hook/lokale Gates; Sandbox-Profil je W-Zelle |
| Review | geprüfter Diff, Zweitmeinung | frischer Reviewer (nur Diff+Kriterien); Requestor approved nie selbst | E: Branch Protection (Review-Pflicht); Reviewer-Agent read-only per Tool-Allowlist |
| Ship | Merge/Release, Deploy | CI-Gate-Hierarchie inkl. Held-out grün; A4 attended; Deploy deterministisch | E: CI required checks, Held-out nur in CI, Branch Protection; A5 Zwei-Schritt |
| **Reconcile (Pflicht)** | aktualisierte SPEC/ADR/STATUS, `project-state.yaml` | Spec-Code-Drift = Defekt: Code korrigieren oder Spec versioniert ändern | E: CI-Konsistenzcheck Status/Version/Tag; generierte README-Statussektion |
| Operate | Betriebsreport, Fehlerbudget-Stand | Observability-Minimum liefert; Backup-Alter < Schwelle | E: Scheduled Health-Report (W2), Dead-Man-Switch, Restore-Probe als A5-Gate |
| **Learn (Pflicht)** | Eval-Task aus realem Fehler; E/N/I-Promotion-Entscheid; Outcome-Notiz | jede Agenten-Panne wird Golden Task; jeder wiederholte N-Verstoß wird Promotion-Kandidat | N (Ritual, monatlich); Eval-Suite selbst ist E-Grundlage künftiger Aufstiege |

Die Outcome-Schleife läuft quer dazu: Nach jeder Roadmap-Phase ein kurzes menschliches Produkt-Review (Nutzung real angesehen, nicht Metriken allein). Sie ist bewusst unmechanisiert (Prinzip 5).

## 4. Rollenmodell Mensch/Agenten

**Mensch (Andreas, Chefarchitekt):** Ziele, Anforderungen, Prioritäten, Architekturentscheide, Risikoakzeptanz, alle A4/A5-Freigaben, Produkt- und Designurteil, Eigentum an Verfassung und Enforcement-Register. Die Anthropic-Telemetrie (≈70 % Planungsentscheidungen beim Menschen, ≈80 % Ausführungsentscheidungen beim Agenten) ist die realistische Arbeitsteilung — das Modell baut sie nach, statt sie zu bekämpfen.

**Agentenrollen sind Berechtigungs- und Kontextgrenzen, keine Jobtitel.** Der Katalog wird auf fünf Kernrollen verschlankt, jede als versionierter Agent im Methodik-Plugin mit Tool-Allowlist (Mechanismus: `agents/*.md` mit `allowed-tools`, Deny-Rules, Modellwahl):

| Rolle | Berechtigung | Kontextregel |
|---|---|---|
| **Lead/Planner** | A0–A2 im Auftrag; einziger Integrator; Owner von Shared Contracts/Schema/Lockfiles | voller Aufgaben-Kontext |
| **Implementer** | A1–A2 im Worktree, disjunkte Datei-Ownership | Slice-Kontext, kein Held-out-Zugriff |
| **Reviewer** | read-only (A0), nie Requestor derselben Änderung | frischer Kontext: nur Diff + Kriterien (eng gescopet gegen Reviewer-Overfitting) |
| **Explorer/Researcher** | A0, read-only, ggf. Netz | ephemer; Ergebnisse als Artefakt |
| **Ops-Agent** | Profil `ops-readonly` (W2, unattended) bzw. `ops-runbook` (attended, Writes nur als Skill) | Kontextdiät, Haiku/Sonnet |

Zwei E-Regeln dazu: (1) **Requestor-Approval-Verbot** — der erzeugende Agent gibt nie frei (Branch Protection + getrennte Identitäten: Bot-Account, fine-grained PATs). (2) **Rollenprofile sind Plugin-Bestandteil** — kein Ad-hoc-Agent mit Vollrechten; neue Rollen brauchen Eigentümerfreigabe und Registry-Eintrag.

## 5. Autonomie- und Eskalationsmodell

### 5.1 A-Stufen als Zustandsmaschine

Der Zustand ist das Tupel **(Projekt, Task-Klasse) → A-Stufe**, persistiert in `project-state.yaml` und von dort in die Permission-/Sandbox-Profile geladen (Mechanismus: Settings-Profil je Stufe im Plugin; die Stufe *ist* das Profil, kein Satz). Task-Klassen nach der Stanford-Matrix:

- **TK1** Greenfield / niedrig-mittel: Deckel A3 (hier liegen die 30–35 %-Gewinne)
- **TK2** Brownfield / einfach: Deckel A3, enger Diff
- **TK3** Brownfield / komplex: Deckel A1–A2, kleiner Slice, tiefer Review (Effekt ≈0/negativ, Rework-Faktor 2,6)
- **TK4** Kritisch (Auth, PII, Migrationen, Infrastruktur, Signing): attended, A5-Regime, HIGH-RISK-Profil

**Aufstieg (menschlich, evidenzbasiert):** Kandidat wird eine Stufe, wenn die projekteigene Eval-Suite auf der betreffenden Task-Klasse **pass^k (k=3–5)** über der Schwelle liegt, die Rework-Quote stabil/fallend ist und das Fehlerbudget des Quartals unangetastet blieb. Andreas entscheidet; die Entscheidung wird als ADR mit Evidenzverweis festgehalten.

**Abstieg (mechanisch, Fehlerbudget):** Vorschlagswerte je Projekt und Quartal — Budget verbraucht bei: 2 Defekt-Escapes in Betrieb/Held-out nach Merge, **oder** 1 Gate-Umgehungsversuch (`--no-verify`, Testabschwächung), **oder** 1 Sicherheits-/Trifecta-Verstoß. Konsequenz: automatische Degradierung um eine Stufe für zwei Wochen, Feature-Arbeit pausiert zugunsten Stabilisierung, Pflicht-Learn-Eintrag. Mechanismus: Budgetzähler im `project-state.yaml`, ausgewertet vom Session-Start-Hook (lädt nur noch das degradierte Profil).

### 5.2 Umgebungsregel W1–W4 (normativer Kern)

Wörtlich aus Addendum 20 übernommen: **W1** attended — jede Umgebung bis A5 (Zwei-Schritt Plan → Freigabe → Ausführung), Hooks/Deny-Rules als Pflicht-Zweitschicht. **W2** unattended read-only (A0; M0/M1) — nativ Windows zulässig nur mit vollständigem Kompensationspaket K+P+H+E+C (Servicekonto ohne Adminrechte, NTFS-ACLs, read-only-DB-Rollen, lesende Allowlist im `dontAsk`-Modus, Audit-/Kill-File-Hooks, Egress-Firewall, ENV-Scrub). **W3** unattended schreibend (A1–A3; M2) — nur mit prozessgebundener OS-Isolation (WSL2-Sandbox Strict-Profil, Devcontainer/VM, ephemerer CI-Runner, Anthropic-Cloud); nativ nur als **Runbook-Ausnahme** (ein benanntes, idempotentes, reversibles Skript als Skill mit `disable-model-invocation`, Rate-Limit, Audit, Rollback-Pfad). **W4** A4 (Merge/Promotion) und jede A5-Fähigkeit: **nie unattended, in keiner Umgebung.** Matrizen A (A-Stufen × E1–E5) und B (M-Klassen × E1–E5) gelten als Anhang; die Zellen sind selbst Enforcement (Umgebungswahl vor Laufbeginn). Die offene **M2-Lockerungsoption** (unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel) ist Eigentümerentscheidung OE-1.

Cloud-Routines laufen promptlos und sind strukturell auf das A3-Äquivalent gedeckelt; zulässig nur unter der vollständigen K4-Bedingungsliste (M0/M1, Konnektorenliste leer bzw. serverseitig read-only, keine Secrets im Environment, Netz nie Full, nur private Repos, Output nur `claude/`-Branches, **kein GitHub-Konnektor**, Ergebnisprüfung vor Weiterverwendung, Identitäts-Akzeptanz).

### 5.3 Orchestrierung an A-Stufen gekoppelt

Einzelsession (A0–A1) → Subagents Explore/Review (A0–A2) → Background/Worktree+PR (A2–A3, nur E2/E3) → Workflows (A3-Deckel, Resume-Pflicht, Budget) → Agent Teams (nur read-lastige Piloten). Höhere Orchestrierungsstufe nie über der freigegebenen A-Stufe der Task-Klasse.

### 5.4 Abbruch und Eskalation

**Abbruchmechanismen (E):** Kill-File (Hook prüft je Tool-Use), `--max-turns`/Token-Budget, Workflow-Warnschwellen, Zeitbox, Fenster-/Spend-Limits. **Abbruchregeln (N→E-promovierbar):** Stagnationsregel „zwei Runden ohne messbaren Fortschritt → Stopp mit Zwischenergebnis"; Abbruchgrund ist Run-Manifest-Pflichtfeld. **Eskalation (Safety Park):** bei fehlender Autorität, Architekturambiguität, unbekanntem Seiteneffekt, Sicherheits-/Datenrisiko, fremdem Rot, erschöpftem Budget oder knappem Kontext — mit Ergebnisstand, genau einem Wiederaufnahmeschritt und deklarierten Annahmen. Fragen-Kopplung: Annahmen deklarieren statt raten (+8 pp belegt); ab A3 werden offene Annahmen zu blockierenden Fragen.

## 6. Artefaktkanon mit E/N/I

Jedes Artefakt mit Eigentümer, Pflege-Trigger und Drift-Schutz; der Drift-Schutz ist der eigentliche Enforcement-Punkt.

| Artefakt | Stufe | Eigentümer | Pflege-Trigger | Drift-Schutz (Mechanismus) |
|---|---|---|---|---|
| **AGENTS.md-Verfassung** (<200 Zeilen, jede Regel E/N/I-markiert) + dünne CLAUDE.md-Brücke (`@AGENTS.md`) | N (verweist auf E-Mechanismen) | Andreas | Regeländerung mit Version/Scope/Sunset | Zeilen-Lint in CI; Pruning-Zyklus quartalsweise |
| **Enforcement-Register** (E-Regel → Mechanismus → letzte Gate-Probe) | E-Katalog | Andreas | jede neue/promovierte E-Regel | Gate-Probe quartalsweise; Regel ohne bestandene Probe wird sichtbar rot |
| **SPEC** (EARS-Kriterien, Non-Scope, Annahmenregister) | N; Akzeptanzkriterien werden E via Tests | Lead (Entwurf), Andreas (Freigabe) | vor jedem nicht-trivialen Item; Reconcile nach Merge | SPEC-Schema-Lint; Held-out-Suite prüft Spec-Ebene |
| **ADR** (agentenoptimiert, mit ausführbarem Check wo möglich) | N; Check ist E | Andreas | Architektur-/Vertragsentscheidung | referenzierte Fitness Function (import-linter, dependency-cruiser) in CI |
| **Run-Manifest** (Pflichtfelder: Evidenz, Trifecta-Deklaration, Kosten-Soll/Ist, Abbruchgrund) | E | erzeugender Agent | jeder autonome/parallele Lauf | `claude -p --bare --json-schema`; CI verweigert Agent-PR ohne Manifest |
| **project-state.yaml** (Status, Reifegrade, A-Stufen je TK, Fehlerbudget, aktive PRs) | E | Lead pflegt, Andreas freigibt Stufen | jeder Merge (Reconcile) | CI-Konsistenzcheck; README-Statussektion generiert, nie manuell |
| **Spike-Karte + Experiment-Log** | N | Explorer/Lead | vor jedem Spike | Branch-TTL/Löschzwang (Abschnitt 9) |
| **dataset.yaml** (Quellen, Lizenz/Opt-out, Schema, Qualitätsgates) | N; Gates E | Lead Daten | neue Quelle/Schemaänderung | Pandera/pydantic-Gates in CI |
| **DESIGN.md** + Tokens | N | Andreas (Geschmacksurteil) | neue Screens/Komponenten | Screenshot-Baseline-Änderung nur nach menschlicher Freigabe (Review-Pflicht auf Baseline-Pfade) |
| **Runbooks** (Ops) | E in Ausführung | Andreas | neue Betriebsaufgabe | Skill mit `disable-model-invocation`, `allowed-tools` exakt, Rate-Limit, Audit |
| **Held-out-Abnahmesuite** (5–20 Spezifikationstests) | E | Andreas (agentenfern) | Spec-Änderung | nur CI; agentenunsichtbar (siehe 8.2) |
| **Eval-Suite** (20–50 Golden Tasks, Kanarien-Subset 5–10) | E-Grundlage der Zustandsmaschine | Andreas | Learn-Schritt speist ein | versioniert im Plugin-Repo; nightly Kanarien |

Verteilmechanismus des Kanons ist das **private Claude-Code-Plugin** (Marketplace-Repo: Hooks = A-Stufen/Gates, Skills = Modi/Runbooks, Agents = Rollen, Settings = Profile) — versioniert identisch über alle 11 Projekte statt kopierter CLAUDE.md-Fragmente.

## 7. Informationsflüsse, Entscheidungs- und Freigabepunkte

**Wahrheitshierarchie** (aus v4.0 übernommen): Recht/Plattform/technische Grenzen → aktuelle Eigentümerfreigabe → ADRs/Verträge → Projektverfassung → Methodik-Defaults → Repo/CI/Laufzeit als Ist-Wahrheit ohne legitimierende Kraft. Neu ist die Transportform: Der maschinenlesbare Projektzustand (`project-state.yaml`) ist das Rückgrat des Informationsflusses — Agenten lesen Zustand, nicht Erinnerung; gespeicherte Freigaben sind historische Nachweise, keine fortgeltende Autorität (Session-Start bestätigt Modus und Stufe).

**Freigabepunkte (abschließende Liste):** (1) Spec-Freigabe nicht-trivialer Items; (2) Profil-/Moduswahl je Roadmap-Phase (SPRINT nur nach ausdrücklicher Aktivierung, Charter, ein Start-SHA); (3) PR-Review und A4-Merge — immer menschlich, Branch Protection als Mechanismus; (4) A5 im Zwei-Schritt (Plan → Freigabe → Ausführung), capability-scoped je Lauf; (5) Design-/Experience-Freigabe (Baselines); (6) A-Stufen-Aufstieg (5.1); (7) Regel-Promotion E/N/I. GitHub-Environment-Gates stehen in privaten Repos erst ab Enterprise nicht zur Verfügung — das mobile Freigabe-Gate läuft über **Remote Control** (Permission-Prompts aufs Pixel 8) und `workflow_dispatch`. Mobile Asymmetrie als E-Regel: freigeben, stoppen, reviewen ja; destruktive Aktionen nie (Mechanismus: `requiresUserInteraction`-Tools verweigern One-Tap; keine A5-Skills mobil auslösbar).

**Konfliktregel:** Widersprüche werden nicht willkürlich aufgelöst — read-only belegen, Auswirkung nennen, bei normativem Konflikt parken (N mit Audit-Spur).

## 8. Parallelisierung und Verifikation

### 8.1 WIP-Limit und Slice

Der Engpass ist Prüfkapazität (A1–A8: 46,4 % Ablehnungsquote agentischer Bug-Fix-PRs überwiegend aus Prozessgründen; −23 pp Merge-Rate ohne menschlichen Review; granularere PRs; steigende Prüflast auch ohne Tempogewinn; „almost right, but not quite" als Hauptfriktion). Konsequenz: **Maximal 2–3 offene, ungeprüfte Agenten-PRs** portfolio-weit. Der **Slice** (Vertical Slice) ist die Einheit von Parallelität *und* Review: ein Worktree je Implementer, disjunkte Ownership, PR als Integrationsvertrag, seriell integriert durch den Lead. Start als gemessene N-Regel; Promotion-Kandidat: PreToolUse-Hook auf `gh pr create`, der bei erreichtem Limit verweigert (OE-6). Bei Review-Stau wird Generierung gedrosselt, nie Prüftiefe.

### 8.2 Gate-Hierarchie (E, in dieser Reihenfolge)

1. **Statik:** Ruff+pyright (strict), Formatter — schnellstes deterministisches Signal, lokal als Hook, entscheidend in CI.
2. **Tests:** Units/Contracts/Integration; Property-based (Hypothesis) und Schemathesis für APIs; Red-first mit Rot-Beweis ab A3.
3. **Fitness Functions:** Architektur-Invarianten (Modulgrenzen, Import-Regeln) als ausführbare ADR-Checks — Schutz gegen Erosion (GitClear-Befunde).
4. **Held-out-Abnahmesuite:** 5–20 Spezifikationstests auf Integrationsebene, **agentenunsichtbar, nur CI** — die SpecBench-Konsequenz (sichtbare Tests sind sättigbar; ~27 pp Divergenz pro Verzehnfachung). Mechanismus ehrlich benannt: `permissions.deny` auf das Verzeichnis ist stringbasiert und nur in der Sandbox hart; robust ist ein **separates privates Repo**, das ausschließlich CI auscheckt (OE-5).
5. **Menschliche Freigabe:** Branch Protection mit Review-Pflicht; KI-Review ersetzt sie nie (empirisch nicht belastbar).

**Zweitmeinungs-Gate:** unabhängiger Reviewer mit frischem Kontext für jeden Agenten-PR; getrennte Test-/Code-Autoren gezielt bei HIGH-RISK. **Audits statt Dauerbetrieb:** Mutation Testing quartalsweise auf Kernmodulen; ACH-Muster (Kritiker injiziert Bugs, Suite muss fangen) als Pilot; Continuous-Cleanup-Lauf wöchentlich; lokale Erosions-Signale (Duplikation, Churn) in der Kennzahlen-Baseline. **Zwei harte Regeln:** *Testreparatur ist Codeänderung* (gleicher Review-Pfad; Agenten schwächen nie eigenmächtig Tests ab — Hook auf Testdatei-Mutation ohne zugehörige Spec-Referenz als Ask) und *Flaky-Quarantäne* mit Ursachenklassifikation statt Retry-bis-grün.

## 9. Experimentierkreislauf

Jeder Spike beginnt mit einer **Spike-Karte**: Hypothese, messbares Erfolgskriterium, Zeit-/Token-Box, vorab fixierte Entscheidungsregel (übernehmen/verwerfen/weiterer Spike). Der Agent kann gegen das Kriterium selbst verifizieren — das macht Spikes autonomietauglich. **Entsorgungsregel als Mechanismus:** Spike-Branches tragen ein TTL; Parallel-Varianten unterliegen dem Löschzwang (nur eine überlebt, CI-Job meldet überfällige Spike-Branches). Ergebnisse landen im Experiment-Log; übernommene Spikes werden im Standardmodus stabilisiert und getestet, nie direkt promoted. Die **Eval-Suite** ist der zweite Kreislauf: 20–50 Golden Tasks aus realen Fehlern (klein starten), Grader-Trias, balancierte Sets inkl. Negativfällen („Agent muss eskalieren"), Kanarien-Subset nightly (Haiku/Sonnet, billig), Vollsuite vor Modell-/Prompt-/Verfassungsänderungen; **pass^k als Zuverlässigkeitsmetrik** für autonome Pfade, pass@k nur für Fähigkeitsvergleiche. Produktexperimente (UX-Varianten, Feature-Wert) enden dagegen immer in einem menschlichen Urteil — Metriken informieren, entscheiden nicht (Prinzip 5).

## 10. Traceability und Evidence Chain

Dreistufig, nach Konsequenz des Pfads:

1. **Überall:** Commit-Trailer (Agent, Modell, Task-Referenz) und PR-Evidenz (Ziel/Scope, betroffene Anforderungen/ADRs, Tests+Resultate, Risiken, Rollback, offene Owner-Entscheidung). Mechanismus: commit-msg-Hook + PR-Template + CI-Check auf Pflichtfelder.
2. **Bei Auto-Deploy-Pfaden:** Run-Manifest + Artefakt-Attestation (GitHub Artifact Attestations, auch in privaten Repos) — Build-Provenance als Ein-Schritt-Feature; Deploy-Ausführung deterministisch (Pipeline, Tailscale WIF, Release-Verzeichnis, Auto-Rollback), nie agentisch.
3. **Nur bei Bedarf:** OTel-Spans (GenAI-Feldnamen noch nicht einfrieren — Status Development).

Run-Manifest und Provenance-Kern teilen ein Schema (PROV-angelehnt: Activity mit Agent-Identität, Modell-ID, Prompt-Hash, Inputs, Ergebnis, Kosten, Trifecta-Feld). Die EARS-IDs der SPEC sind der Anker Spec→Test→Run: Akzeptanzkriterium referenziert Test-ID, Test-ID erscheint im Manifest. Damit ist je Änderung beantwortbar: welche Anforderung, welche Entscheidung, welcher Agent, welche Tests, welche Evidenz, wer geprüft, wer freigegeben.

## 11. Betriebs-Layer

Zielsystem ist der dokumentierte **HP EliteDesk 800 G6** (i5-10500T, 32 GB, 2×512 GB NVMe, Windows 11 Pro; WSL2-fähig, VT-x-BIOS-Prüfung offen; kein ECC, kein RAID — **Backup-Disziplin ist die Redundanz**; D: als Daten-/Backup-Laufwerk; Dauerbetrieb auf LAN umstellen). Verhältnis zum bestehenden Windows-VPS ist Eigentümerentscheidung OE-3.

**SRE light:** Fehlerbudget (5.1) ist die Autonomie-Drossel — Betriebsvorfälle degradieren mechanisch. Progressive Rollouts und Feature-Flags nur wo reversibel nötig; kein IDP, kein Voll-OTel, keine Container-Pflicht auf Windows.

**Ops-Agent-Stufenplan 0–3** (je Stufe vier Wochen Bewährung vor der nächsten):

- **Stufe 0 (unattended, W2, jetzt):** `svc-claude`-Servicekonto ohne Adminrechte + `agent_ro`-DB-Rolle; täglicher Health-/Log-/DB-Report als Windows Scheduled Task, headless `claude -p --bare --json-schema` auf API-Key; Benachrichtigung nur bei Befund; Kill-File + Audit-Hook ab Tag 1; Egress-Firewall pro Dienstkonto praktisch validieren.
- **Stufe 1 (attended):** Admin-Sessions via OpenSSH/VS-Code-Remote (Tailscale SSH fällt als Windows-Ziel aus → Windows-OpenSSH + Tailscale-ACLs, Audit serverseitig); erste Runbook-Skills: Dienst-Neustart, Log-Triage, pg_dump-Verify.
- **Stufe 2 (selektiv unattended):** genau **ein** reversibles Runbook unattended (Runbook-Ausnahme W3) mit Rate-Limit, Audit, Rollback-Pfad.
- **Stufe 3 (beobachten):** Routines/Cloud-Scheduling für Ops, Windows-Admin-MCPs — quartalsweise neu bewerten (heute nicht belastbar).

**DB-Zugriffsnormen (E):** Postgres MCP Pro restricted + `agent_ro`; DuckDB-MCP read-only als Analysefront; SQLite/DuckDB per CLI-Allowlist (`sqlite3 -readonly`); Directus-nativer MCP nur mit dediziertem User und **aktivierter Delete-Protection** (default-off!). Rechte werden im Zielsystem erzwungen, nicht im Prompt.

**Backup als A5-Gate (E):** restic/Litestream-Triade, append-only-Ziele, Agent ohne Schreibrecht auf Backup-Pfade (NTFS), automatisierte Restore-Proben mit Dead-Man-Switch (Healthchecks) — ohne aktuelle Restore-Probe (<30 Tage) keine A5-Freigabe auf Daten-/Infrastrukturfähigkeiten (ATLAS-T0101-Konsequenz).

**Observability-Minimum:** JSON-Log-Schema, Uptime Kuma (Außensicht) + Healthchecks (Dead-Man), Claude als Diagnose-*Konsument* der Logs.

**Notausschalter-Katalog (jede Zeile mit Mechanismus, getestet per Gate-Probe):** Kill-File (Hooks prüfen je Tool-Use) · Scheduled-Task-Deaktivierung · PAT-/Key-Rotation (Bot-Identität) · Workspace-Spend-Limit auf 0 · Tailscale-ACL-Sperre des Agentenkontos · Sandbox-`failIfUnavailable` (ohne Sandbox kein unattended Write-Start).

## 12. Scheduler- und Kosten-Layer

### 12.1 Scheduler-Zuordnungsregel

| Ebene | Permission-Profil | Kontext/Kosten | Zulässige Aufgabentypen |
|---|---|---|---|
| **`/loop`** (sessiongebunden, 7-Tage-Expiry) | erbt Session-Permissions | Session-Kontext läuft mit | PR-Babysitting, CI-Fix-Nachlauf, Deploy-Beobachtung — nur solange attended erreichbar |
| **Desktop Scheduled Task** (lokal) | per-Task-Permission-Mode, widerrufbare Tool-Freigaben | voller Kontext je Feuerung → Kontextdiät, Haiku/Sonnet | lokale Wartung mit Gates, Reports, Worktree-isolierte Routinepflege |
| **Cloud-Routine** (promptlos!) | keine Prompts — nur K4-Bedingungsliste, strukturell A3-Deckel | zieht still aus Plan-Kontingent | nächtliche Repo-Pflege, Doku-Drift-Erkennung, PR-Vorreview in privaten Repos; Konnektorenliste vor Anlage leeren |
| **Windows Scheduled Task + Headless** (Server) | W2-Kompensationspaket, `--allowedTools` lesend, `dontAsk` | API-Key mit Spend-Limit, exakte Kosten via `total_cost_usd` | Ops-Stufe 0: Health-/Log-/DB-Report; später genau ein Runbook (Stufe 2) |

**Remote Control** ist der attended-Kanal dazu: Permission-Prompts mobil beantworten, Läufe stoppen — mit der Positiv-/Negativliste als E-Regel (7). Merken: „Push when actions required" aktivieren; Routines melden grünen Status auch bei inhaltlichem Misserfolg — Ergebnisprüfung bleibt Pflicht.

### 12.2 Kosten-Layer

In Dollar ist agentische Arbeit billig (kompletter Recherche-Sweep: einstelliger Dollarbetrag zu API-Preisen), knapp sind Abo-Fenster. Konsequenzen als Modellbestandteil:

- **Struktur:** Max 5x als Fundament; Usage Credits mit Monats-Cap 20–40 USD als Überlauf; separater Console-API-Key mit Workspace-Spend-Limit (Start 25 USD/Monat) für CI/SDK/Unattended; Batch-API (−50 %) für Massenläufe; Max 20x erst nach zwei Monaten dokumentierter Wochenfenster-Erschöpfung. Sonnet-5-Promo endet 31.08.2026 (+50 % einplanen).
- **Planung:** Tokenfaktoren Chat 1× → Einzelagent ≈4× → Teams ≈7× → Multi-Agent ≈15×; **Fanout-Kriterium:** nur wenn Aufgabenwert ≥ 10–15× Tokenkosten *und* ein Verifier existiert; Modell-Upgrade schlägt Token-Verdopplung; ein schwerer Workflow je 5h-Fenster (Max 5x: zwei bis drei).
- **Enforcement (Caps auf drei Ebenen):** Werkzeug (`--max-turns`, Workflow-Größe, `/effort`), Konto (Spend-Limits, Credits-Cap), Prompt (Stagnationsregel, Abbruch mit Zwischenergebnis-Pflicht).
- **Run-Manifest-Pflichtfelder:** Kosten-Soll vor dem Lauf (Modellklasse, maxTurns, Token-/Zeitbudget), Ist danach (`total_cost_usd`, Tokens, Abbruchgrund). **Resume-Pflicht** für jeden Mehragentenlauf: ein Artefakt je Agent sofort auf Disk (der 0,6-Mio.-Token-Verlust des Erstlaufs war ein Prozess-, kein Preisproblem). Monatliches Kosten-Review (5 Minuten, `/usage` + Console).

## 13. Archetyp-Profile

Die Zeremonie skaliert **je Slice**, nicht je Projekt (Antwort auf die Governance-Overhead-Warnung der Portfolio-Analyse: Tischatlas/Boxscore zeigen, wie Governance Kontext überlädt und kleine Änderungen verteuert).

| Profil | Artefakte | Gates | Autonomie |
|---|---|---|---|
| **LIGHT** | Spec-Kurzform (Outcome + 3–5 EARS-Zeilen), kein Execution Plan; Run-Manifest automatisch (headless JSON) | Statik + Tests | bis Matrix-Deckel der TK; Reviews gebündelt |
| **STANDARD** | voller Kanon (6) | volle Gate-Hierarchie inkl. Held-out | evidenzbasiert bis A3 |
| **HIGH-RISK** | + Zweitmeinung Pflicht, getrennte Test-/Code-Autoren, Migrations-/Rollback-Plan | + Security-Fokusgates (XSS/Log Injection), aktuelle Restore-Probe | attended; A5 Zwei-Schritt |

**Zuordnung je Archetyp (Default, Slices können abweichen):**

- **A — Interaktive Privatprodukte** (capsule, joes-journal, tischatlas): STANDARD; UX-Slices enden immer im menschlichen Experience-Gate (DESIGN.md, Baselines); Auth-/PII-Slices HIGH-RISK; typisch A2–A3.
- **B — Daten-/Wissensplattformen** (boxscore, curio, new_nfl): STANDARD; zusätzlich dataset.yaml, Provenance-Invarianten, Held-out prioritär (höchste Autonomie, größtes Selbstbestätigungsrisiko); TK1-lastig → evidenzbasierter A3-Regelbetrieb; Content-Refresh-Promotion als deterministische CI-Pipeline statt agentischem A4 (OE-2).
- **C — Sensorik/Edge** (wlan → funkatlas): LIGHT für Explorations-/Hardware-Slices (attended am Gerät), STANDARD ab Produktisierung; Langzeitmessung läuft über den Betriebs-Layer (Scheduled Reports).
- **D — Infrastruktur-Transformation** (server-migration): HIGH-RISK durchgehend; Writes nur als Runbook-Skills; Inventar/Analyse unattended read-only (W2) zulässig; niemals SPRINT.
- **E — Mobile Companion** (capsule-app): STANDARD schlank (Härtung M1–M3: OpenAPI-Client, Maestro-Smoke, CI-Build); Signing/Distribution HIGH-RISK — Keystore-Verlust ist identitätszerstörend; **Limited Distribution Account im August 2026 registrieren** (Termin); Art.-50-Transparenzzeile als billiges Default.

## 14. Delta zu v4.0

| Baustein | v4.0 | Dieses Referenzmodell |
|---|---|---|
| Verbindlichkeit | Kap. 14: „CLAUDE.md erzwingt nichts technisch" als Hinweis | E/N/I-Taxonomie, Enforcement-Register, Gate-Probe, Promotion-Pfad als System |
| A-Stufen | statisch je Freigabe (Kap. 5/7) | Zustandsmaschine je (Projekt, Task-Klasse); Evidenz-Aufstieg, Fehlerbudget-Abstieg; Rework als Pflichtmetrik |
| Umgebungsregel | „WSL2 ab A3" pauschal | W1–W4-Tripel + Matrizen A/B; native Sandbox dauerhaft nicht verfügbar; Routines-Bedingungsliste |
| Lifecycle | Arbeitszyklus Kap. 9 ohne Nach-Merge-Schritt | + Spec-Reconciliation (Pflicht) + Learn-Schritt (Evals, Promotion) |
| Qualität | hermetische Gates, Test-first | + Fitness Functions als Gate, Held-out-Suite (nur CI), Mutation-/ACH-Audits, Flaky-Quarantäne, Testreparatur-Regel |
| Rollen | breiter Katalog | 5-Rollen-Kern als versionierte Agents mit Tool-Allowlists; Requestor-Approval-Verbot |
| Betrieb | Kap. 25 dünn | SRE light, Ops-Stufenplan 0–3, DB-Normen, Backup-Gate, Notausschalter-Katalog, Heimserver als Zielsystem |
| Kosten | verstreute Kostengrenzen (Kap. 22) | vollwertiger Layer: Manifest-Pflichtfelder, drei Cap-Ebenen, Tokenfaktoren, Fanout-Kriterium, Abo-/API-Split, Resume-Pflicht |
| Scheduler | nicht geregelt | Zuordnungsregel über vier Ebenen mit Permission-/Kontext-/Kostenprofil |
| MCP | Steckbrief nennt Zielrevision 2026-07-28 | Korrektur auf **2025-11-25**; „2026-ready"-Designregeln (Handles statt Sessions, keine Roots/Sampling/Logging/DCR); Umstellungstrigger statt Datum |
| Verteilung | kopierte CLAUDE.md je Projekt | privates Plugin-Marketplace-Repo, versioniert über 11 Projekte |
| Evals | Kap. 27 als Backlog | tragende Säule des Autonomie-Modells (pass^k, Kanarien, Learn-Zufluss) |
| Zeremonie | Modi STANDARD/SPRINT/HYBRID | zusätzlich LIGHT/STANDARD/HIGH-RISK je Slice und Archetyp; SPRINT erhält prüfbare Eintrittsbedingungen |

## 15. Einführungs-Reihenfolge

Vier Stufen, jede mit Exit-Kriterium; Reihenfolge folgt dem Prinzip „erst Mechanismus, dann Autonomie":

1. **Fundament (Woche 1–2):** Plugin-Skeleton mit bestehenden v4.0-Regeln; E/N/I-Etikettierung der Verfassung; Enforcement-Register v0; Kostenrahmen (Credits-Cap, API-Key mit Spend-Limit); MCP-Steckbrief-Korrektur; WSL2-Sandbox Strict auf dem Laptop; Kill-File- und Audit-Hooks; Portfolio-Sofortmaßnahmen (server-migration privat). *Exit:* erste Gate-Probe bestanden — eine E-Regel blockiert nachweislich.
2. **Gates und Evidenz (Woche 3–6):** Branch Protection in allen aktiven Repos; Run-Manifest-Schema an headless gekoppelt; Commit-Trailer-Hook; Held-out-Suiten in zwei Projekten (boxscore, NFL-Plattform); `project-state.yaml` + CI-Konsistenzcheck; WIP-Zählung sichtbar. *Exit:* ein Merge mit vollständiger Evidence Chain Stufe 1.
3. **Betrieb und Scheduler (Woche 5–10, überlappend):** Ops-Stufe 0 auf dem Heimserver; Notausschalter-Katalog getestet; Backup-Triade + erste Restore-Probe; Scheduler-Piloten (`/loop`, ein Desktop Task mit Kontextdiät). *Exit:* zwei Wochen stabiler Health-Report + bestandene Restore-Probe.
4. **Evidenzbasierte Autonomie (ab Woche 8):** Eval-Suite klein (20 Tasks aus realen Fehlern), Kanarien nightly; erste dokumentierte A-Auf-/Abstufung nach Evidenz; Routines-Pilot nur nach OE-4; erstes Mutation-Audit. *Exit:* eine Stufenentscheidung mit ADR und Evidenzverweis.

## 16. Offene Eigentümer-Entscheidungen

1. **OE-1 — M2-Lockerung:** Unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel zulassen (Addendum-20-Option) oder strikte M0/M1-Regel für alles Unattended behalten? (Konservative Alternative: behalten; Kosten: weniger nächtliche Automatisierung.)
2. **OE-2 — Boxscore-Auto-Promotion:** Der etablierte Boxscore-Pfad „Agent merged und deployt bei Grün" kollidiert mit W4. Optionen: (a) Merges künftig attended (Remote Control macht das mobil billig), (b) Content-Refresh als deterministische CI-Pipeline ohne LLM im Promotionspfad, vorab einmalig freigegeben. Empfehlung des Entwurfs: (b) für reine Datenaktualisierung, (a) für Code.
3. **OE-3 — Serverrollen:** Aufgabenteilung Heimserver (EliteDesk) vs. bestehender Windows-VPS; welches System ist Ziel des Ops-Piloten Stufe 0 und des `server-migration`-Vorhabens?
4. **OE-4 — Routines-Pilot:** überhaupt starten? Wenn ja, erster Kandidat (nächtliche Repo-Pflege, Doku-Drift, PR-Vorreview) — jeweils nur nach vollständiger K4-Bedingungsliste, Konnektorenliste leer.
5. **OE-5 — Held-out-Ablage:** separates Verzeichnis mit Deny-Regel (bequem, aber nur in Sandbox hart) oder separates privates Repo nur für CI (robust, mehr Pflege)? Entwurfsempfehlung: separates Repo für die zwei Autonomie-Projekte, Deny-Verzeichnis für den Rest.
6. **OE-6 — WIP-Limit-Härte:** als gemessene N-Regel belassen oder zum Hook promovieren (Blockade von `gh pr create` ab 3 offenen Agenten-PRs)?
7. **OE-7 — Fehlerbudget-Parameter:** Vorschlagswerte bestätigen oder anpassen (Budgetgröße je Quartal, Degradierungsdauer zwei Wochen, Wiederaufstieg über pass^k-Schwelle).
8. **OE-8 — Abo-Konfiguration:** Max 5x + Credits-Cap (20–40 USD) + API-Spend-Limit (25 USD) bestätigen; Termin für die Max-20x-Prüfung (frühestens nach zwei Monaten `/usage`-Evidenz).
9. **OE-9 — LIGHT-Grenzen:** Welche Projekte dürfen dauerhaft im LIGHT-Profil laufen (Kandidat: funkatlas-Exploration), und wer löst den Wechsel nach STANDARD aus (Vorschlag: erster realer Nutzer-Betrieb)?

---

*Selbstprüfung der Perspektive: Die Enforcement-Brille birgt die Gefahr, dass Mechanik den Sinn erschlägt. Gegengewichte sind eingebaut — Prinzip 5 (drei dauerhaft unmechanisierte Urteile), die Outcome-Schleife im Lifecycle, das menschliche Experiment-Urteil (Abschnitt 9) und die Profil-Skalierung, die LIGHT-Arbeit bewusst von Apparat freihält. Umgekehrt gilt: Jede hier vorgeschlagene E-Regel ist mit einem heute verfügbaren Mechanismus benannt; wo der Mechanismus schwach ist (stringbasierte Deny-Rules außerhalb der Sandbox, WIP-Limit), ist die Schwäche ausgewiesen statt kaschiert.*
