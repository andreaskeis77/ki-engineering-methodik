# Entwurf B — KI-natives Operating Model und Lifecycle-Referenzmodell (Perspektive: Lifecycle-first)

**Stand:** 2026-07-28 · **Status:** Eigenständiger Entwurf als Entscheidungsgrundlage für Methodik v5. Dieses Dokument schreibt v4.0 nicht um; je Baustein wird das Delta zu v4.0 benannt (Abschnitt 14). Grundlage: Gesamtsynthese v2 inkl. Konfliktentscheide K1–K4, Windows-Autonomie-Matrix (A20), Kostenmodell (A19), Portfolio-Analyse (bes. §15, §17.3, §18), Heimserver-Steckbrief.

---

## 1. Executive Summary

Das Referenzmodell ist **eine einzige Pipeline mit acht Phasen** — Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn — die in **drei Zeremonie-Profilen** (LIGHT / STANDARD / HIGH-RISK) konfiguriert wird und auf allen elf Projekten identisch läuft. Alles andere hängt an dieser Pipeline: Rollen sind Kontext- und Berechtigungsgrenzen je Phase; Autonomiestufen A0–A5 sind Fähigkeits-Deckel je Phase, doppelt konditioniert durch Task-Klasse und eigene Evidenz; die Windows-Autonomie-Matrix W1–W4 entscheidet, *wo* eine Phase unbeaufsichtigt laufen darf; Artefakte sind die Übergabeobjekte zwischen Phasen; Scheduler-Ebenen und Kostenbudgets sind Laufzeit-Eigenschaften einzelner Phasenschritte. Zwei Schritte sind neu und verpflichtend: **Spec-Reconciliation nach jedem Merge** (in Ship) und ein expliziter **Learn-Schritt**, der reale Agentenfehler in die Eval-Suite und Regelverstöße in den E/N/I-Promotion-Pfad einspeist — Learn ist der Motor des evidenzbasierten Autonomie-Auf- und -Abstiegs. Der Engpass des Systems ist nicht Codeerzeugung, sondern Andreas' Verifikationsbandbreite (Evidenzblock A1–A8); deshalb ist der zentrale Regler das WIP-Limit „maximal 2–3 offene ungeprüfte Agenten-PRs", die Einheit von Parallelität und Review ist der **Slice**, und LIGHT ist der ausdrückliche Default für alles Reversible (Anti-Governance-Overhead, Portfolio §17.3). Verbindlich ist nur, was deterministisch erzwungen wird: Jede E-Regel dieses Modells benennt ihren Enforcement-Mechanismus (Hook, Permission-Rule, Sandbox, CI, Branch-Protection); Verteilung erfolgt als versioniertes privates Claude-Code-Plugin. Der Betriebs-Layer (bislang dünnster Teil von v4.0) wird vollwertig: Ops-Agent-Stufenplan 0–3 auf dem HP-Heimserver, Fehlerbudget als Autonomie-Drossel, Backup-/Restore-Probe als A5-Gate, Notausschalter-Katalog. Acht Entscheidungen kann nur Andreas treffen; sie sind in Abschnitt 16 gesammelt, nicht vorweggenommen.

## 2. Leitidee und Designprinzipien

**Leitidee: Eine Pipeline, drei Konfigurationen, ein Lernkreis.** Nicht elf Projektprozesse und nicht fünf Archetyp-Methodiken, sondern ein Phasenmodell, dessen Parameter (Spezifikationstiefe, Gate-Umfang, Review-Tiefe, Autonomie-Deckel, Umgebung) pro Vorhaben konfiguriert werden. Das Modell muss in ein Diagramm passen (Abschnitt 3) und in einer Stunde lehrbar sein.

Designprinzipien:

1. **Right-Sizing vor Vollständigkeit.** Maßstab ist ein Solo-Mensch mit begrenzter Review-Bandbreite. Zeremonie folgt Risiko und Reversibilität, nie Projektgröße oder Gewohnheit. Jedes Pflichtartefakt hat eine LIGHT-Kurzform.
2. **Verbindlich ist nur Erzwungenes.** E/N/I-Taxonomie: E-Regeln haben einen benannten deterministischen Mechanismus; N-Regeln stehen in der Verfassung und werden bei Verstoß protokolliert; I ist Kontext. Kontextdateien sind advisory — das Modell verlässt sich nie auf Prompt-Disziplin allein.
3. **Der Mensch entscheidet seriell, Agenten arbeiten parallel darunter.** Andreas' etabliertes Muster (Portfolio §8.2) wird zur Architektur: genau eine Entscheidungsfront je Projekt; Parallelität nur unterhalb der letzten Freigabe.
4. **Autonomie wird verdient und entzogen — mit eigener Evidenz.** Keine Entscheidung auf Basis gefühlter Produktivität oder öffentlicher Benchmarks (Regel B1–B5, Wahrnehmungs-Mess-Lücke); Grundlage sind Golden-Task-Evals mit pass^k, Rework-Quote und Fehlerbudget.
5. **Jeder Lauf hinterlässt Evidenz und ist abbrechbar ohne Totalverlust.** Run-Manifest mit Pflichtfeldern, Resume-Fähigkeit, Abbruchgrund als Datum, kein Lauf ohne Zwischenartefakt.
6. **Stabile Fundamente:** MCP-Zielrevision 2025-11-25 mit „2026-ready"-Designregeln und Umstellungstrigger statt Datum; keine native Windows-Sandbox einplanen (dauerhaft „not planned"); Statusquellen-Hierarchie „Ankündigung ≠ Vollzug".

## 3. Lifecycle

### 3.1 Gesamtbild

```
            MAKRO (Vorhaben/Tranche)                       Freigaben (Mensch)  Gates (Maschine)
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│  P1 Research ──► P2 Specify ──► P3 Plan ──► P4 Execute+Verify ──► P5 Review ──► P6 Ship  │
│      ▲              │G1            │G2         │ Q1 Statik           │G3 Merge    │G4     │
│      │              ▼              ▼           │ Q2 Tests            ▼            ▼       │
│      │           SPEC(EARS)   Exec-Plan        │ Q3 Fitness      Reviewer     Reconcile   │
│      │           +Annahmen    +Budget-Soll     ▼ (je Slice)      (frisch,     + Deploy-   │
│      │                        +A-Stufe      Run-Manifest         read-only)     Pipeline  │
│      │                                                                            │       │
│      │                          P8 Learn ◄──────── P7 Operate ◄───────────────────┘       │
│      └── Evals, E/N/I-Promotion,   │G6              │G5  (Ops-Agent, Fehlerbudget,        │
│          A-Auf-/Abstieg ◄──────────┘                     Observability, Backup-Probe)     │
└──────────────────────────────────────────────────────────────────────────────────────────┘
   MIKRO: jeder Slice in P4 durchläuft denselben Kreis im Kleinen (Recon → Test rot → grün
   → Selbstverifikation → PR). WIP-Limit: max. 2–3 offene ungeprüfte Agenten-PRs.
```

Der Lifecycle existiert auf zwei Skalen: **Makro** (Vorhaben/Tranche, Tage bis Wochen) und **Mikro** (Slice, Minuten bis Stunden). Der Slice — ein vertikal geschnittenes, unabhängig testbares Arbeitspaket — ist die Einheit von Parallelität, Review und WIP-Zählung. Menschliche Freigabepunkte G1–G6 sind die einzigen Stellen, an denen Autorität erteilt wird; Maschinen-Gates Q1–Q4 sind deterministisch (CI/Hooks) und für Agenten nicht abschwächbar (E; Enforcement: Branch-Protection, Stop-Hooks, CI-Pflichtchecks, kein `--no-verify`).

### 3.2 Die acht Phasen

**P1 Research (Explore).** *Eingaben:* Ziel/Frage, `project-state.yaml`, bestehende Artefakte. *Artefakte:* Recon-Notiz, Spike-Karten (bei Experimenten), Einträge ins Annahmenregister. *Rollen:* Explorer-Agenten (read-only, fan-out-fähig), Mensch stellt die Frage. *Autonomie:* A0; unattended in jeder Umgebung zulässig (W2 nativ mit Kompensationspaket, Routines nur nach K4-Bedingungsliste). *Gates:* keine harten; N-Regeln B1–B5 und Statusquellen-Hierarchie gelten für jeden Recherche-Agenten. *Abbruch:* Zeit-/Token-Box aus der Spike-Karte; Ergebnis auch bei Abbruch als Artefakt.

**P2 Specify.** *Eingaben:* Recon-Ergebnis, Produktziel. *Verfahren:* Interview-Muster (Agent befragt Andreas via AskUserQuestion → SPEC.md → frische Session zur Umsetzung). *Artefakte:* SPEC mit EARS-Akzeptanzkriterien (WHEN/THE SYSTEM SHALL, je Kriterium eine REQ-ID als Traceability-Anker), Non-Scope, betroffene Verträge, **Annahmenregister** ([NEEDS CLARIFICATION] statt raten; Fragen-Kopplung an A-Stufen). *Rollen:* Mensch ist Autor der Absicht, Lead-Agent ist Interviewer und Schreiber. *Autonomie:* A0–A1 (nur Doku-Schreiben). *Gate G1:* Spec-Freigabe durch Andreas — in LIGHT ein Absatz mit 3–5 EARS-Kriterien im Issue, in STANDARD/HIGH-RISK eigenes Artefakt. *Abbruch:* ungeklärte Architekturambiguität → zurück nach P1 oder Park.

**P3 Plan.** *Eingaben:* freigegebene SPEC. *Artefakte:* Execution Plan (Slices, Parallelfronten, Ownership-Zuordnung), Modusempfehlung (STANDARD/SPRINT/HYBRID mit Begründung; SPRINT nie selbstaktiviert), **Task-Klassen-Einstufung** (Abschnitt 5) mit A-Stufen-Deckel, **Budget-Soll** (Modellklasse, maxTurns, Token-/Zeitbudget, Tokenfaktor-Schätzung 1×/4×/7×/15×, Fanout-Begründung nur bei Wert ≥ 10–15× Kosten plus vorhandenem Verifier). *Rollen:* Lead/Planner schlägt vor, Mensch entscheidet. *Gate G2:* Plan-, Modus-, Budget- und A-Stufen-Freigabe in einem Schritt; erteilte Stufen gelten je Lauf, gespeicherte Freigaben sind historische Nachweise. In LIGHT kollabieren G1+G2 zu einer Issue-Freigabe; der Plan steht in der PR-Beschreibung. *Abbruch:* kein sicherer Parallelschnitt → seriell arbeiten statt Koordinationsrisiko.

**P4 Execute+Verify.** *Eingaben:* Plan, A-Stufen, Worktree je Implementer. *Verfahren:* je Slice Test-first mit beobachtetem Rot (Red-Beweis im Run-Manifest), dann grün; Q1–Q3 laufen kontinuierlich lokal (Hooks) und verbindlich in CI; Bugfixes beginnen mit reproduzierender Regression. *Artefakte:* Diff, **Run-Manifest je Lauf** (Pflichtfelder Abschnitt 10), HANDBACK bei Parken. *Rollen:* Implementer (worktree-isoliert, disjunkte Ownership), Lead integriert seriell; Shared Contracts haben genau einen Owner. *Autonomie:* attended bis A5 in jeder Umgebung (W1); unattended schreibend (A1–A3) **nur** in W3-Umgebungen — WSL2-Sandbox Strict, Devcontainer/VM, ephemerer CI-Runner, Anthropic-Cloud; nativ Windows nur als Runbook-Ausnahme; A3 unattended nur mit exakter Vorabfreigabe je Ziel (E; Enforcement: Sandbox-Profil `failIfUnavailable`, Permission-Rules, Branch-Protection, Egress-Allowlist). *Abbruch:* Stagnationsregel (zwei Runden ohne messbaren Fortschritt → Stopp mit Zwischenstand), Budget-Cap, Safety Park bei fremdem Rot, fehlender Autorität, Sicherheits-/Datenrisiko oder knappem Kontext.

**P5 Review.** *Eingaben:* PR mit grünem Pre-Integration-Gate, Diff, Run-Manifest. *Verfahren:* (1) Reviewer-Agent mit frischem Kontext, read-only, nur Diff + Kriterien (eng gescopt gegen Reviewer-Overfitting); (2) **Zweitmeinungs-Gate** bei HIGH-RISK (zweites Modell/Codex attended); (3) menschlicher Review als bindendes Gate — KI-Review ersetzt keine Freigabe; Requestor approved nie selbst (Rollentrennung). *Gate G3:* Merge-Freigabe = A4, **immer attended** (W4; auch via Remote Control mobil). *WIP-Regel (E über Prozess + Dashboard):* nie mehr als 2–3 offene ungeprüfte Agenten-PRs; bei Stau wird Generierung gedrosselt, nicht Prüftiefe. *Abbruch:* Ablehnung erzeugt einen Learn-Eintrag (Grund als Datum), nicht nur einen neuen Versuch.

**P6 Ship.** Zwei Pflichtschritte nach jedem Merge: **(a) Spec-Reconciliation** — ein Agent gleicht Ist-Verhalten gegen SPEC ab und schlägt Delta vor (ADDED/MODIFIED/REMOVED, OpenSpec-Denkweise); Drift ist ein Defekt: Code korrigieren oder Spec bewusst versionieren; danach Statusupdate `project-state.yaml` (CI prüft Konsistenz README↔State). **(b) Release/Deploy** über deterministische Pipeline (Tailscale WIF, Release-Verzeichnis, Auto-Rollback) — der Agent bereitet vor, die Pipeline führt aus, die Auslösung ist A5 und attended (G4); bei den wenigen Auto-Deploy-Pfaden gilt Evidenzstufe 2 (Run-Manifest + Attestation, Abschnitt 10). *Abbruch:* Rollback ist Teil des Deploy-Pfads, nicht Improvisation.

**P7 Operate.** Vollständiger Betriebs-Layer in Abschnitt 11. Kernmechanik: der Betrieb erzeugt **Fehlerbudget-Signale**, die als Autonomie-Drossel direkt auf P4/P5 zurückwirken (G5: Betriebs-Freigaben für Runbooks und Ops-Stufenwechsel).

**P8 Learn.** Der zweite neue Pflichtschritt, getaktet (wöchentlich kurz, monatlich gründlich): (1) reale Agentenfehler und abgelehnte PRs werden zu **Golden Tasks** der Eval-Suite (Ziel 20–50 je Portfolio-Schwerpunkt, pass^k mit k=3–5, Kanarien-Subset nightly auf Haiku/Sonnet); (2) wiederholt verletzte N-Regeln durchlaufen den **E/N/I-Promotion-Pfad** (≥2 Verstöße mit Wirkung → E-Regel mit benanntem Enforcement; wirkungslose Regeln werden demotet — Kontext ist Budget); (3) Kennzahlen-Review (Rework-Quote, Defekt-Escape, Durchlaufzeit, Duplikations-/Churn-Signale, Eval-Trends, Kosten-Ist); (4) **A-Auf-/Abstiegsentscheide** je Task-Klasse (G6); (5) Methodik-Änderungen werden als Plugin-Version released. *Enforcement des Learn-Schritts selbst:* Scheduled Task erzeugt den Review-Stub; ein Merge-Kalendermonat ohne Learn-Protokoll ist ein Verstoß im Dashboard.

## 4. Rollenmodell Mensch/Agenten

Rollen sind **Kontext- und Berechtigungsgrenzen, keine Personas**; technisch versionierte Agents mit Tool-Allowlists im Methodik-Plugin (E; Enforcement: `allowed-tools`, Permission-Rules, getrennte Kontexte).

| Rolle | Träger | Phase | Rechte (Kern) | Kontext |
|---|---|---|---|---|
| **Chefarchitekt** | Andreas | alle Gates G1–G6 | einziger Inhaber von A4/A5-Erteilung, Risikoakzeptanz, Geschmacksurteil UX | Gesamtbild |
| **Lead/Planner** | Agent, attended | P2, P3, P4-Integration | Doku/Plan schreiben; Integration seriell; keine Merges | SPEC + Plan + Statusartefakte |
| **Implementer** | Agent | P4 | Schreiben nur im Worktree/Scope; Gates lokal ausführen; Push nur mit A3 | Slice-Kontext, frische Session |
| **Reviewer** | Agent | P5 | strikt read-only; strukturierte Findings | nur Diff + Kriterien, frischer Kontext |
| **Explorer/Researcher** | Agent | P1, P8 | read-only; Netz nach Allowlist | Frage + Quellenregeln (B1–B5) |
| **Ops-Agent** | Agent, headless | P7 | W2-Profil: read-only + Report-Ablage; Runbooks nur als Skills | Kontextdiät, JSON-Schema-Output |
| **Zweitmeinung** | Zweitmodell (Codex CLI attended/Gemini M0) | P5 (HIGH-RISK), P1 | read-only | nur Prüfgegenstand |

Der Mensch ist bewusst **nicht** Teil der Ausführungsschleife, sondern ihrer Regelung: Ziele, Prioritäten, Architektur, Freigaben, Abbruch, Beurteilung. Seine Review-Bandbreite ist die knappste Ressource des Systems; alle Parallelisierungsregeln (Abschnitt 8) sind daraus abgeleitet.

## 5. Autonomie- und Eskalationsmodell

**Grundgerüst:** A0–A5 wie v4.0 (extern validiert durch Google L0–L4, CISA, SASE). Neu ist die **doppelte Konditionierung**:

**(a) Task-Klassen-Deckel (Stanford-Matrix; Rework als Pflichtmetrik):**

| Task-Klasse | Beispiel | A-Deckel unattended | Review-Tiefe |
|---|---|---|---|
| T1 Greenfield, niedrig–mittel | neues isoliertes Modul, Adapter | bis A3 (in W3-Umgebung) | normal |
| T2 Greenfield hoch / Brownfield niedrig | neues Subsystem; kleine Bestandsänderung | A2–A3 | erhöht |
| T3 Brownfield mittel–hoch | Querschnittsänderung im Bestand | A1–A2 | enger Diff-Review |
| T4 kritische Pfade (Auth, Migrationen, Signing, Infra, PII) | — | A0–A1, attended | HIGH-RISK-Profil, Zweitmeinung |

**(b) Evidenzbasierter Auf-/Abstieg (entschieden in P8/G6):** Aufstieg einer Task-Klasse × Projekt-Kombination erfordert Golden-Task-Evidenz (Startwerte, von Andreas zu bestätigen: ≥20 Tasks, pass^3 ≥ 85 %, Rework-Quote unter Schwelle über 4 Wochen). **Abstieg ist automatisch**: Fehlerbudget gerissen oder zwei Escaped Defects → eine A-Stufe runter und Auto-Pfade pausiert, bis das Budget wiederhergestellt ist (Enforcement: Flag in `project-state.yaml`, das Hooks/CI auswerten). Öffentliche Benchmark-Scores sind nie Aufstiegsgrund (B5).

**Umgebungsbindung (normativer Kern, wörtlich aus A20 übernommen):** W1 attended — jede Umgebung bis A5 (A5 im Zwei-Schritt Plan → Freigabe → Ausführung); W2 unattended read-only — nativ Windows zulässig nur mit vollständigem Kompensationspaket K+P+H+E+C; W3 unattended schreibend — nur mit prozessgebundener OS-Isolation, nativ nur als Runbook-Ausnahme (ein benanntes, idempotentes, reversibles Skript als Skill mit `disable-model-invocation`); **W4: A4 und A5 nie unattended, in keiner Umgebung.** Matrizen A/B und die Routines-Bedingungsliste (K4) gelten als geprüfte Checklisten im Anhang der Methodik. Die **M2-Lockerungsoption** (unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel) ist offener Entscheidungspunkt E1 (Abschnitt 16).

**Orchestrierungsstufen an A-Stufen gekoppelt:** Einzelsession (jede Stufe, attended) → Subagents Explore/Review (A0-Anteile immer zulässig) → Background/Worktree+PR (setzt A2–A3, W3-Umgebung und Vorabfreigabe je Ziel voraus) → Workflows/Agent Teams (schreibende Workflows nur resumierbar und budgetiert; Teams nur read-lastige Piloten).

**Abbruch- und Eskalationsmechanismen (Katalog):** (1) Safety Park mit HANDBACK; (2) Stagnationsregel; (3) Budget-Abbruch mit Abbruchgrund-Pflichtfeld; (4) Kill-File + Audit-Hook für alles Unbeaufsichtigte (ab Tag 1); (5) Fehlerbudget-Degradierung; (6) Eskalationsleiter Agent → Lead → Mensch: Agenten parken statt raten, der Lead bündelt, nur der Mensch löst normative Konflikte; (7) Notausschalter-Katalog (Abschnitt 11); (8) Resume statt Neustart (Kostenregel).

## 6. Artefaktkanon mit E/N/I

Verbindlichkeit: **E** erzwungen (Mechanismus benannt), **N** normativ-advisory, **I** informativ. Jedes Artefakt hat Eigentümer, Pflege-Trigger und Drift-Schutz.

| Artefakt | Phase | Verbindlichkeit | Eigentümer | Pflege-Trigger | Drift-Schutz |
|---|---|---|---|---|---|
| AGENTS.md-Verfassung (<200 Zeilen, E/N/I-Marker; dünne CLAUDE.md-Brücke via `@AGENTS.md`) | alle | N (E-Anteile via Hooks/Settings) | Andreas | Learn-Beschluss | Plugin-Versionierung; Pruning-Zyklus |
| SPEC mit EARS + Annahmenregister | P2 | N; Akzeptanzkriterien werden E via abgeleitete Tests | Andreas (Inhalt), Lead (Form) | jede Verhaltensänderung | **Spec-Reconciliation nach jedem Merge** |
| Execution Plan + Budget-Soll | P3 | N | Lead | Scope-Änderung | Plan-Abweichung im Run-Manifest |
| ADRs mit ausführbaren Checks | P2/P3 | Entscheidung N, Check E (CI/Fitness Function) | Andreas | Architekturänderung | Check bricht Build bei Verstoß |
| **Run-Manifest** (Pflichtfelder: Evidenz/Red-Beweis, Trifecta-Deklaration, Kosten-Soll/Ist, Abbruchgrund) | P4–P6 | E (Schema-Validierung in CI; Quelle `claude -p --json-schema`/`total_cost_usd`) | ausführender Agent | jeder autonome/parallele Lauf | PR ohne valides Manifest nicht mergebar |
| Spike-Karte + Experiment-Log | P1 | N | Andreas/Explorer | jedes Experiment | Entsorgungsregel (Abschnitt 9) |
| `project-state.yaml` (maschinenlesbarer Status) | P6 | E (CI-Konsistenzcheck, README-Generierung) | Lead | jeder Merge/Statuswechsel | CI bricht bei Widerspruch |
| dataset.yaml (Datenplattformen) | P4 | N→E über Pandera/pydantic-Gates | Lead | Schema-Evolution | Gate bricht Pipeline |
| DESIGN.md + Tokens | P2/P4 | N; Baselines E (Screenshot-Gate nach Freigabe) | Andreas | Designfreigabe | Baseline-Änderung nur nach G-Freigabe |
| Runbooks als Skills (`disable-model-invocation`, `allowed-tools`) | P7 | E (Skill-Definition ist das Enforcement) | Andreas | Ops-Änderung | Versionierung im Plugin |
| Eval-Suite + Held-out-Abnahmesuite (agentenunsichtbar, nur CI) | P8 / Q4 | E (CI-only-Job; Pfad außerhalb Agenten-Checkout) | Andreas | Learn-Beschluss; neue reale Fehler | Agenten haben keinen Lesezugriff |
| HANDBACK/STATUS | P4/P5 | N | ausführender Agent | Parken/Laufende | Vorlagenpflicht |
| Distribution-&-Signing-Runbook (Mobile) | P6 | N (Schritte), E (Keystore-Zugriff nur attended) | Andreas | Release | Probe vor Store-Terminen |

## 7. Informationsflüsse, Entscheidungs- und Freigabepunkte

**Wahrheitshierarchie** (aus v4.0 übernommen): Recht/Plattformregeln → aktuelle Eigentümerfreigabe → ADRs/Verträge → Projektverfassung → Methodik-Defaults → Repo/CI/Laufzeit als Ist-Wahrheit ohne normative Kraft. Konflikte werden geparkt, nicht aufgelöst.

**Flussprinzip:** Artefakte fließen vorwärts (SPEC → Plan → Diff+Manifest → PR → Release → Betriebssignale), Evidenz fließt rückwärts (Betriebs- und Review-Befunde → Learn → Verfassung/Evals/A-Stufen). Sessions sind zustandslos; Projektgedächtnis liegt ausschließlich in versionierten Artefakten (Kompaktierungs-/Handoff-Punkte vor langen Läufen). Die Portfolio-Ebene liest aggregiert: `project-state.yaml` aller Repos + Run-Manifeste + CI-Status speisen eine kleine **Portfolio Control Plane** (privates Dashboard; Pilot) — dort wird auch das WIP-Limit portfolioweit sichtbar.

**Freigabepunkte (nur der Mensch):**

| Gate | Phase | Gegenstand | Bindung |
|---|---|---|---|
| G1 | P2 | Spec-Freigabe | LIGHT: Issue-Freigabe (G1=G2) |
| G2 | P3 | Plan + Modus + Budget + A-Stufen je Lauf | SPRINT nur hier aktivierbar |
| G3 | P5 | Merge (A4) | immer attended (W4), mobil zulässig |
| G4 | P6 | Deploy/Release/Store (A5-*) | Zwei-Schritt; capability-scoped je Lauf |
| G5 | P7 | Ops-Runbook-Freigaben, Stufenwechsel 0–3, Live-Zugriffe | attended; Bewährungsfristen |
| G6 | P8 | A-Auf-/Abstieg, E/N/I-Promotion, Profilwechsel, Plugin-Release | getaktet (monatlich) |

**Entscheidungsprozess-Regel:** Agenten empfehlen mit Begründung (Risikoklasse, Reversibilität, Verträge, Prüfbelege); Entscheidungen mit Langzeitfolgen werden als ADR persistiert; jede Freigabe gilt je Lauf und Ziel — gespeicherte Freigaben sind historische Nachweise, keine fortgeltende Autorität.

## 8. Parallelisierung und Verifikation

**Parallelisierung:** Einheit ist der Slice; Implementer arbeiten worktree-isoliert mit disjunkter Ownership; Shared Contracts/Schema/Lockfiles haben genau einen Owner; der Lead integriert seriell. Read-only-Arbeit (Recon, Review, Test-Läufe) parallelisiert frei; Schreibfronten limitiert das **WIP-Limit: maximal 2–3 offene ungeprüfte Agenten-PRs** (Ankerbündel A1–A8: 46,4 % Ablehnungsquote agentischer PRs aus Prozessgründen, −23 pp Merge-Rate ohne menschlichen Review, Rework-Faktor 2,6). Bei Review-Stau: Generierung drosseln, nie Prüftiefe. 3–5 aktive Worker sind Startwert unter Kosten-/Koordinationsbudget, kein Ziel.

**Gate-Hierarchie (Qualitätsschicht):**

1. **Q1 Statik** — Ruff+pyright (strict), Lint, Security-Checks auf die schwachen Klassen (XSS, Log Injection), Fitness-Vorstufen. Sekunden, lokal via Hooks, verbindlich in CI.
2. **Q2 Tests** — Units/Contracts/Integration inkl. Property-based (Hypothesis) und Schemathesis für APIs; Red-Beweis protokolliert; hermetisch mit Fixtures.
3. **Q3 Fitness Functions** — import-linter/dependency-cruiser, Modulgrenzen, Erosions-Signale (Duplikation, Konnektivität) als Gate, nicht als Bericht.
4. **Q4 Held-out-Abnahmesuite** — 5–20 Spezifikationstests je Projekt, **agentenunsichtbar, nur CI** (Antwort auf SpecBench: sichtbare Tests sind sättigbar). Divergenz sichtbar↔held-out ist ein Alarmsignal, kein Reparaturauftrag an den Agenten.
5. **Menschliche Freigabe** — G3; durch nichts ersetzbar.

**Audits (getaktet statt je Lauf):** Mutation Testing quartalsweise auf Kernmodulen; ACH-Muster (Kritiker injiziert Bugs, Suite muss fangen) als Pilot; Continuous-Cleanup-Lauf wöchentlich mit Löschzwang für Parallel-Varianten. **Regeln:** Testreparatur ist Codeänderung (gleiche Review-Pflicht; Tests nie „grün-gefixt"); Flaky-Quarantäne mit Ticket statt Retry-bis-grün (E; Enforcement: CI-Konfiguration, Hook gegen `--no-verify`).

## 9. Experimentierkreislauf

Experimente laufen **neben** der Produktpipeline, nie in ihr: Jede **Spike-Karte** trägt Hypothese, binäres Erfolgskriterium, Zeit-/Token-Box und **Entsorgungsregel** (Default: Branch wird gelöscht, Erkenntnis wandert ins Experiment-Log). Spike-Code wird nie direkt gemergt; Übernahme erfolgt ausschließlich über P2 (Spezifikation) und eine frische Implementierung — das verhindert Prototyp-Drift. Varianten-Vergleiche (Best-of-N, 2–3 Kandidaten, Opus-Klasse) nur bei hartem Verifier und Aufgabenwert ≥ 10–15× Tokenkosten; Verlierer-Varianten unterliegen dem Löschzwang. Methodik-Experimente (neue Werkzeuge, neue Regeln) durchlaufen denselben Kreis mit Erfolgskriterium und Messung — Einordnungen „pilotgeeignet/beobachten" aus der Synthese sind der Backlog dieses Kreislaufs.

## 10. Traceability und Evidence Chain

**Trace-Anker:** REQ-ID (EARS) → Test-ID → Run-Manifest → Commit-Trailer → PR → Release → Betriebssignal. Drei Evidenzstufen, right-sized:

1. **Stufe 1 — überall:** Commit-Trailer (Agent, Run-ID, Assisted-by-Konvention) und PR-Evidenzblock nach dem Evidence-Bundle-Schnitt der Portfolio-Analyse (Ziel/Scope, Anforderungen, ADRs, Tests+Ergebnis, Risiken, Kosten, Rollback, Doku-Update, offene Owner-Entscheidung). Enforcement: PR-Template + CI-Check auf Pflichtblock.
2. **Stufe 2 — bei Auto-Deploy-Pfaden:** Run-Manifest + GitHub Artifact Attestation (funktioniert in privaten Repos; SLSA-angelehnt) — das deployte Artefakt ist kryptografisch an Build und Manifest gebunden.
3. **Stufe 3 — OTel nur bei Bedarf** (GenAI-Feldnamen nicht einfrieren; Status Development).

**Gemeinsames Schema:** Run-Manifest und Provenance-Kern der Datenplattformen teilen ein Modell (W3C-PROV-angelehnt, relational: source/fetch/raw_artifact/transform_run/claim); LLM-/VLM-Extraktionen sind gewöhnliche Activities mit Modell-ID und Prompt-Hash. Run-Manifest-Pflichtfelder: Ziel/Scope, Start-/End-SHA, ausgeführte Gates mit Resultat, Red-Beweis, **Trifecta-Deklaration** (welche der drei Kanten offen waren, welche gebrochen wurde), **Kosten-Soll/Ist**, Umgebung (E1–E5), A-Stufen-Grundlage, **Abbruchgrund** (leer nur bei Normalende).

## 11. Betriebs-Layer

Zielsystem ist der dokumentierte **HP EliteDesk 800 G6** (i5-10500T, 32 GB, 2×512-GB-NVMe, Windows 11 Pro; WSL2-fähig; kein ECC/RAID — **Backup-Disziplin ist die Redundanz**; D: als Daten-/Backup-Laufwerk; Betriebsbedingung vor Ops-Pilot: LAN statt WLAN, Energie-/Autostart-Profil, SMART-Prüfung).

1. **SRE light:** je Live-System ein simples SLO (Erreichbarkeit + Kernfunktion) und ein **Fehlerbudget als Autonomie-Drossel**: Budget gerissen (Startwert: 2 Incidents/Monat oder wiederholter Nightly-Fail) → betroffenes Projekt fällt eine A-Stufe, Auto-Pfade pausieren, nur Fix-Arbeit bis Wiederherstellung (Enforcement: Flag in `project-state.yaml`, Hook-geprüft). Progressive Rollouts und Feature-Flags nur für die Live-Produkte, nicht als Portfolio-Pflicht.
2. **Ops-Agent-Stufenplan 0–3 (D16, matrixkonform):** **Stufe 0** unattended read-only nativ (W2): `svc-claude`-Servicekonto ohne Adminrechte, `agent_ro`-DB-Rolle, täglicher Health-/Log-/DB-Report headless (`claude -p --bare --json-schema`) ins Ops-Repo, Benachrichtigung nur bei Befund, Kill-File + Audit-Hook ab Tag 1, Egress-Firewall, ENV-Scrub. **Stufe 1** attended Admin-Sessions mit Runbook-Skills („Dienst-Neustart", „Log-Triage", „pg_dump-Verify"). **Stufe 2** genau **ein** reversibles Runbook unattended (Rate-Limit, Audit, Rollback-Pfad, vier Wochen Bewährung, dann nächstes). **Stufe 3** beobachten (Ops-Routines, Aperture, WinRM-MCPs — quartalsweise neu bewerten). Alert-Muster: Alert → unattended Diagnose (read-only) + Maßnahmenvorschlag → Mensch gibt frei → Runbook führt aus.
3. **DB-Zugriffsnormen:** Postgres MCP Pro restricted + `agent_ro`; DuckDB/MotherDuck-MCP read-only als Analysefront; SQLite per CLI-Allowlist (`sqlite3 -readonly`); Directus-nativer MCP mit dediziertem User und **sofort aktivierter Delete-Protection** (default-off). Schreibende DB-Arbeit nur attended oder als Runbook.
4. **Backup/Restore als Gate:** restic/Litestream, append-only-Ziele, **Agent ohne Schreibrecht aufs Backup**, automatisierte Restore-Proben mit Dead-Man-Switch. Regel: keine A5-Autorität für ein System ohne bestandene Restore-Probe (E; Enforcement: Freigabe-Checkliste + Probe-Timestamp in `project-state.yaml`).
5. **Observability-Minimum:** JSON-Logs nach Schema, Uptime Kuma (Außensicht) + Healthchecks.io (Dead-Man) kombiniert; Claude als Diagnose-*Konsument* (read-only). Kein OTel-Vollstack.
6. **Notausschalter-Katalog** (dokumentiert, geprobt, mobil auslösbar wo möglich): Kill-File (Hook-geprüft, stoppt alle unattended Läufe), Scheduled-Task-Deaktivierung, API-Key-Sperre/Rotation, PAT-Revoke des Bot-Accounts, Tailscale-ACL-Sperre, Firewall-Regel je Servicekonto. **Mobile Asymmetrie** (Remote Control): freigeben, reviewen, stoppen ja — destruktive oder neue-Scope-Aktionen nie vom Handy.

## 12. Scheduler- und Kosten-Layer

**Scheduler-Zuordnungsregel** (jede wiederkehrende Aufgabe wird genau einer Ebene zugeordnet; Neuzuordnung ist ein Learn-Beschluss):

| Ebene | Umgebung/Gate | Permission-Profil | Kontext-/Kostenprofil | Zulässige Aufgabentypen |
|---|---|---|---|---|
| `/loop` (Session-Cron) | W1 attended-nah | erbt Session | erbt Session; voller Kontext je Iteration | Deploy-/PR-Babysitting, Checks im Arbeitsfenster |
| Desktop Scheduled Task (lokal) | unattended, lokaler Dateizugriff | per-Task-Permission-Mode | voller Kontext je Feuerung → **Kontextdiät + Haiku/Sonnet Pflicht**; Abo-Fenster | lokale Repo-Hygiene, Berichte, Cleanup-Lauf (Pilot) |
| Cloud-Routine (E4) | **promptlos, kein Gate**; nur nach K4-Bedingungsliste; strukturell A3-gedeckelt | keine Prompts; Kontrollflächen: Repo/Branch/Netz/Konnektoren (vor Anlage leeren) | Plan-Kontingent; still | nächtliche Repo-Pflege, Doku-Drift-Erkennung, PR-Vorreview in privaten Repos (M0/M1) |
| Windows Scheduled Task + Headless (E1/W2) | unattended read-only mit K+P+H+E+C | Allowlist `dontAsk`, JSON-Schema | **API-Key** (exakte Kosten via `total_cost_usd`), Kontextdiät | Ops-Reports, SDK-Batch-Jobs auf dem Server |
| Remote Control | attended-Kanal (kein Scheduler) | Prompts aufs Pixel 8; `requiresUserInteraction` verweigert One-Tap | — | mobile Freigaben nach Positiv-/Negativliste |

**Kosten-Layer (A19):** (1) **Budget-Soll/Ist als Run-Manifest-Pflichtfelder** (Soll: Modellklasse, maxTurns, Token-/Zeitbudget; Ist: `total_cost_usd`/Tokens bzw. Fensteranteil, Abbruchgrund). (2) **Caps auf drei Ebenen:** Werkzeug (`--max-turns`, Workflow-Größe, `/effort`), Konto (Workspace-Spend-Limit, Credits-Monats-Cap), Prompt/prozedural (Stagnationsregel, Abbruch bei Budgetstand mit Zwischenergebnis-Pflicht). (3) **Tokenfaktoren** Chat 1× → Einzelagent ≈4× → Teams ≈7× → Multi-Agent ≈15×; **Modell-Upgrade schlägt Token-Verdopplung**; **Fanout nur** bei Aufgabenwert ≥ 10–15× Kosten und vorhandenem Verifier. (4) **Abo-/API-Split:** Max 5x als Fundament; Usage Credits mit Monats-Cap 20–40 USD als Überlauf; separater Console-API-Key mit Spend-Limit (Start 25 USD/Monat) für CI/SDK/Unattended; Batch-API −50 % für Massenläufe; Sonnet-5-Promo endet 31.08.2026 (+50 % einplanen); Max 20x erst nach zwei Monaten dokumentierter Fenster-Erschöpfung. (5) **Resume-Pflicht:** jeder Mehragentenlauf schreibt ein Artefakt je Agent und ist resumierbar — der 0,6-Mio.-Token-Verlust des Sweeps war ein Prozessproblem. (6) Faustregel ein schwerer Workflow je 5h-Fenster (Max 5x: 2–3); monatliches 5-Minuten-Kosten-Review in P8.

## 13. Archetyp-Profile

Profile sind **Konfigurationen derselben Pipeline**, gewählt **je Vorhaben** (nicht je Projekt auf ewig); jedes Projekt hat ein Default-Profil plus benannte HIGH-RISK-Zonen. Anti-Overhead-Regel (Portfolio §17.3): LIGHT ist der Default für alles Reversible; Artefakt-Budget LIGHT ≤ 1 Seite gesamt; wer STANDARD wählt, begründet es mit Risiko, nicht mit Gewohnheit.

| Parameter | LIGHT | STANDARD | HIGH-RISK |
|---|---|---|---|
| Spec | Issue-Absatz, 3–5 EARS-Kriterien | SPEC-Artefakt + Annahmenregister | + Migrations-/Rollback-Plan, Zweitmeinung auf Spec |
| Plan/Gates G1–G2 | eine Issue-Freigabe | getrennte G1/G2 | G2 mit explizitem Risk Envelope |
| Maschinen-Gates | Q1+Q2 | Q1–Q3 (+Q4 wo Suite existiert) | Q1–Q4 Pflicht |
| Review | Mensch liest Diff | Reviewer-Agent + Mensch | + Zweitmodell, getrennte Test-/Code-Autoren |
| A-Deckel (Task-Klasse beachtet) | bis A3 | bis A3, A4/A5 je Lauf | A0–A2; alles Weitere attended im Zwei-Schritt |
| Run-Manifest | Kurzform (auto aus Headless-JSON) | voll | voll + Attestation |
| Spec-Reconciliation | Sammelabgleich je Tranche | nach jedem Merge | nach jedem Merge, menschlich gegengelesen |

**Default-Zuordnung der fünf Archetypen:** **A Private Web Product** (capsule, joes-journal, tischatlas): STANDARD; HIGH-RISK-Zonen Auth, PII, Deploy; LIGHT für UI-Polish/Inhalte; Designabnahme bleibt menschliches Geschmacksurteil (G3-Zusatz). **B Data/Knowledge Platform** (boxscore, new_nfl, curio): STANDARD; Held-out-Suite und dataset.yaml-Gates prioritär (erste Q4-Kandidaten); LIGHT für Berichte/Notebooks; HIGH-RISK für Schema-Migrationen und Löschoperationen. **C Sensor/Edge** (wlan, funkatlas): STANDARD; Hardware-in-the-loop attended; unattended nur Simulation/Auswertung (W2). **D Infrastructure Transformation** (server-migration): durchgängig HIGH-RISK; W1/W2 only; jede Mutation als Runbook; Inventar vor Aktion. **E Mobile Companion** (capsule-app): STANDARD; HIGH-RISK-Zonen Signing/Keystore/Distribution (Signing-Runbook, Limited Distribution Account 08/2026, Art.-50-Transparenzzeile als billiges Default-Feature).

## 14. Delta zu v4.0

Das Modell ist ein Neuschnitt der **Darstellung**, nicht der Substanz: v4.0-Kapitel bilden fast vollständig auf die Phasen ab.

| v4.0-Kapitel | Landet in | Delta (neu/geändert) |
|---|---|---|
| 3 Wahrheitshierarchie, 26 Doku/Governance | §7, §6 | E/N/I-Taxonomie mit Promotion-Pfad; `project-state.yaml` mit CI-Check; Plugin statt kopierter Fragmente |
| 5 Arbeitsmodell/Autorität, 6 Risikoklassen, 7 Modi | §4, §5 | doppelte Konditionierung (Task-Klassen + Evidenz); W1–W4 als normative Umgebungsachse; Rollenkern verschlankt auf 5+2 |
| 9 Tranche/Execution Plan/Arbeitszyklus | P2–P4 | EARS-Pflicht, Annahmenregister, Budget-Soll in G2; **Spec-Reconciliation neu** |
| 10 Multi-Agent, 11 Long Runs | §8, P4 | Slice als Einheit; WIP-Limit hart beziffert; Resume-Pflicht |
| 18 Teststrategie/Gates, 19 Stabilisierung | §8 (Q1–Q4) | **Held-out-Suite neu**; PBT/Schemathesis; Fitness Functions als Gate; Mutation-Audit; Flaky-Quarantäne |
| 21 Debugging/Observability, 25 Release/Betrieb | P6, §11 | **Betriebs-Layer vollwertig neu**: Ops-Stufenplan, Fehlerbudget-Drossel, Restore-Probe als Gate, Notausschalter |
| 22 Security/Kosten, 23 MCP | §5, §12 | W-Matrix + Routines-Bedingungsliste; Kosten-Layer als Methodikbaustein; MCP-Steckbrief-Korrektur **2025-11-25** (v4.0-CLAUDE.md nennt 2026-07-28) + „2026-ready"-Regeln + Umstellungstrigger; M1-Terminologie-Korrektur |
| 27 Evals/Reifegrad | P8 | Golden Tasks aus realen Fehlern, pass^k, Kanarien-Subset; Learn als Pflichtphase mit Takt |
| ohne v4.0-Heimat | §12, §13 | Scheduler-Zuordnungsregel; Archetyp-Profile LIGHT/STANDARD/HIGH-RISK; Evidence-Stufen 1–3; Recherche-Regeln B1–B5/Statusquellen-Hierarchie |

## 15. Einführungs-Reihenfolge

Vier Wellen, jede mit Exit-Kriterium; Verteilung stets über das Plugin, damit alle elf Projekte identisch erben.

- **Welle 0 (Woche 1–2) — Fundament:** privates Plugin-Marketplace-Repo (Hooks=Gates/A-Stufen, Skills=Modi/Runbooks, Agents=Rollen, Settings); W-Matrix + Kostenrahmen + MCP-Steckbrief-Korrektur; Run-Manifest-Schema; Kill-File-Hook. *Exit:* zwei Projekte laufen mit Plugin v0.1.
- **Welle 1 (Woche 3–6) — Lifecycle-Pflichtschritte in zwei Piloten** (ein Web-STANDARD, z. B. tischatlas; eine Datenplattform mit erster Held-out-Suite, z. B. boxscore): EARS-Specs, Spec-Reconciliation, WIP-Limit, PR-Evidenzblock. *Exit:* fünf Merges vollständig durch die Pipeline; Kennzahlen-Baseline erhoben.
- **Welle 2 (Woche 7–10) — Betrieb und Messung:** Heimserver-Vorbedingungen (LAN, SMART, WSL2-Check), Ops-Agent Stufe 0, Scheduler-Zuordnung aller bestehenden wiederkehrenden Aufgaben, Eval-Suite mit ersten 20 Golden Tasks aus realen Fehlern, Restore-Probe. *Exit:* vier Wochen Ops-Report ohne Eingriff; Nightly-Kanarien läuft.
- **Welle 3 (Monat 3+) — Autonomie-Mechanik live:** erster evidenzbasierter A-Aufstieg (G6), Routines-Pilot streng nach K4, Ops Stufe 1→2, HIGH-RISK-Profil auf server-migration, Portfolio Control Plane als Read-Model. *Exit:* ein dokumentierter Auf- und ein Abstieg; Methodik v5 wird aus diesem Referenzmodell geschnitten.

## 16. Offene Eigentümer-Entscheidungen

1. **E1 — M2-Lockerungsoption:** unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel zulassen — oder strikte M0/M1-Regel behalten (konservative Alternative)?
2. **E2 — A4-Politik für bisherige Auto-Merge-Projekte (Boxscore):** W4 konsequent durchsetzen (Merge immer attended, ggf. One-Tap via Remote Control) — oder je Projekt eine dokumentierte Risikoakzeptanz-Ausnahme führen?
3. **E3 — Rollenteilung Heimserver vs. Windows-VPS:** welches System ist Ziel des Ops-Piloten Stufe 0, was läuft wo, Verhältnis zum `server-migration`-Vorhaben?
4. **E4 — Kostenrahmen-Zahlen bestätigen:** Max 5x, Credits-Cap 20–40 USD, API-Spend-Limit 25 USD, Termin des Monats-Reviews.
5. **E5 — Profil-Defaultmatrix und Q4-Reihenfolge:** Zuordnung aus §13 bestätigen; welche zwei Projekte erhalten zuerst eine Held-out-Suite?
6. **E6 — Schwellenwerte der Autonomie-Mechanik:** pass^k mit k=3 und 85 %, Rework-Schwelle, Fehlerbudget-Definition (2 Incidents/Monat) als Startwerte freigeben oder anpassen?
7. **E7 — Routines-Pilot:** ja/nein; falls ja, Bestätigung der Kandidaten (nächtliche Repo-Pflege, Doku-Drift, PR-Vorreview) und der K4-Checkliste als Anlagebedingung.
8. **E8 — Plugin-Governance:** Repo/Namensraum, SemVer-Politik, Regel „Methodik-Änderungen mergt nur Andreas" formal festschreiben?

---

*Quellenbasis: 00_SYNTHESE.md v2 (Konfliktentscheide K1–K4, Arbeitsauftrag 1–12), 20_windows_autonomie_matrix.md, 19_kostenmodell.md, 01/02/03/07/08/16 (gezielt), input/CLAUDE.md v4.0, input/KI_ENGINEERING_METHODIK.md (Kapitelstruktur), input/GitHub_Projektportfolio_Analyse_20260728.md §15/§17/§18, input/HEIMSERVER_HP_ELITEDESK_800_G6.md, input/KI_native_Software_Engineering_Zielbild_und_Forschungsauftrag.md §3/§5/§12/§14.*
