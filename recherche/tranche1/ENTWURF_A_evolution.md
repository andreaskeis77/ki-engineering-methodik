# Operating Model und Lifecycle-Referenzmodell — Entwurf A: EVOLUTION

**Stand:** 2026-07-28 · **Status:** Entwurf zur Eigentümerentscheidung (Tranche 1, Forschungsauftrag Abschnitt 14)
**Perspektive:** Evolution — chirurgisches Delta auf Methodik v4.0, keine Neuschreibung. Nummernstabilität nach Methodik 26.7: Neues ausschließlich als neue Unterabschnitte am Kapitelende oder als In-place-Schärfung bestehender Unterabschnitte.
**Grundlage:** Gesamtsynthese v2 (inkl. Konfliktentscheide K1–K4), Addenda A04a/A17–A20, Dossiers D01–D16, Portfolio-Analyse, Methodik v4.0, operative Verfassung `CLAUDE.md` v4.0, Heimserver-Steckbrief.

---

## 1. Executive Summary

Der Recherche-Sweep bestätigt die Methodik v4.0 in ihren tragenden Entscheidungen: Autoritätsstufen A0–A5, Modi STANDARD/SPRINT/HYBRID, Tranchen, Spezifikationspflicht, hermetische Gates, Verifikationsbandbreite als WIP-Limit, Run-Manifeste, Safety Park und HANDBACK sind extern validiert; bei Provenance ist v4.0 dem Feld voraus. Ein Neubau wäre deshalb Churn ohne Evidenz. Dieses Referenzmodell ist stattdessen ein **Delta-Paket aus rund 20 neuen Unterabschnitten und rund 15 In-place-Schärfungen**, das die belegten Lücken schließt: die Windows-Autonomie-Matrix W1–W4 als normativer Kern, zwei neue Lifecycle-Pflichtschritte (Spec-Reconciliation, Learn), die Doppelkonditionierung der Autoritätsstufen (Evidenz + Task-Klasse), die Verbindlichkeitstaxonomie E/N/I, die Held-out-Abnahmesuite, ein vollwertiger Betriebs-Layer auf dem HP-Heimserver sowie Scheduler- und Kosten-Layer. Jede neue Regel benennt ihren Enforcement-Mechanismus (Hook, Permission-Rule, Sandbox, CI, Manifest-Pflichtfeld) oder ist ausdrücklich advisory. Die Querschnittsthemen erhalten je genau **eine normative Heimat** in der bestehenden Kapitelstruktur und werden andernorts nur referenziert — das ist die eingebaute Kontrolle gegen den Flickenteppich. Das Paket ist als Version 4.1 adoptierbar, ohne eine einzige Kapitelnummer zu verschieben; ob es als 4.1 in Kraft tritt oder als Bauplan in einen v5-Neuschnitt eingeht, ist Eigentümerentscheidung E10.

## 2. Leitidee und Designprinzipien

**Leitidee:** Das Operating Model ist die Methodik v4.0 plus das, was der Sweep bewiesen hat — nicht mehr. Bewährte Begriffe bleiben Referenzanker; neue Befunde docken an bestehende Kapitel an.

- **P1 — Delta statt Neubau.** Neue Inhalte nur als Unterabschnitte am Kapitelende oder In-place-Schärfung; keine Umnummerierung (26.7). Sofortige Adoptierbarkeit schlägt konzeptionelle Eleganz.
- **P2 — Verbindlich ist nur, was erzwungen wird.** Jede Regel trägt künftig eine E/N/I-Stufe (erzwungen / normativ-advisory / informativ, neu 26.8); jede neue Regel dieses Referenzmodells benennt ihren Enforcement-Mechanismus oder gilt als N.
- **P3 — Verifikationsbandbreite ist die knappe Ressource.** Nicht Tokens (in Dollar billig, A19), sondern die Review-Tiefe eines Solo-Menschen limitiert. Alle Parallelitäts-, Scheduler- und Kostenregeln sind darauf normiert (Evidenzblock A1–A8 statt METR-Punktschätzer).
- **P4 — Autonomie ist verdient, entziehbar und task-klassenabhängig.** Doppelkonditionierung: eigener Eval-Nachweis (pass^k) und Task-Klassen-Staffelung; Fehlerbudget als Drossel.
- **P5 — Right-Sizing über Zeremonie-Profile.** LIGHT/STANDARD/HIGH-RISK skalieren Artefakt- und Gate-Umfang je Archetyp und Task; Antwort auf die Portfolio-Warnung vor Governance-Overhead (Tischatlas/Boxscore). Zeremonie-Profil und Arbeitsmodus sind orthogonal.
- **P6 — Keine instabilen Zahlen als Fundament.** Benchmark-Regel B1–B5, Statusquellen-Hierarchie „Ankündigung ≠ Vollzug", keine Steuerung über gefühlte Produktivität (Wahrnehmungs-Mess-Lücke).
- **P7 — Kein Artefakt ohne Eigentümer und Pflege-Trigger.** Was niemand pflegt, wird gestrichen oder auf I gestuft (neu 3.4).
- **Anti-Flickenteppich-Regel:** je Querschnittsthema eine Heimat — W-Matrix → 22.10, Kosten → 22.7/21.6, Scheduler → 11.8, E/N/I → 26.8, Betrieb → 25.8–25.10, Archetypen → 4.5. Andere Kapitel verweisen nur.

## 3. Lifecycle

Der Konsens-Makrozyklus (Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn) existiert in v4.0 bereits fast vollständig — er wird nicht neu eingeführt, sondern auf die vorhandenen Kapitel gemappt und um zwei Pflichtschritte ergänzt:

| Referenzphase | v4.0-Heimat | Delta |
|---|---|---|
| Research | 5.4 Read-only Onboarding, 9.2 Recon | unverändert |
| Specify | 9.6 Spezifikationsgetriebener Ablauf | geschärft: EARS-Notation, Annahmenregister (Vorlage 28.13) |
| Plan | 9.3/9.4 Planstufen, Execution Plan | geschärft: Kosten-Soll und Review-Budget als Planfelder |
| Execute+Verify | 9.2 Tranchen-Zyklus, 18 Gates | Gate-Hierarchie in 18.7 präzisiert (s. Abschnitt 8) |
| Review | 9.2 Review, 10.8 Verifier | Zweitmeinungs-Gate verbindlich ab R2 |
| Ship | 24 Git/CI, 25 Release | unverändert; A4/A5 bleiben attended (W4) |
| **Reconcile** | **fehlt** | **neu 9.7 — Pflichtschritt nach jedem Merge** |
| Operate | 25.7 Betrieb (dünn) | ausgebaut zu 25.8–25.10 (Abschnitt 11) |
| **Learn** | 27.5 nur implizit | **neu 9.8 — verbindlicher Rückfluss** |

**Neu 9.7 — Spec-Reconciliation nach Merge.** Kein Framework löst Spec-Drift nach dem Merge; Reconciliation wird sonst übersprungen (D01/D02). Regel: Nach jedem Merge in den Standard-Branch prüft ein read-only Reconcile-Schritt (Subagent mit frischem Kontext oder Checklistenpunkt, je Zeremonie-Profil): (1) erfüllt das gemergte Verhalten die EARS-Akzeptanzkriterien der Spec, (2) sind offene Annahmen bestätigt oder widerlegt, (3) ist die Spec-Version aktuell. Drei zulässige Ausgänge: `ok`, versioniertes Spec-Update, Defekt-Issue. **Enforcement:** Pflichtfeld `spec_reconciled` im Run-Manifest (21.6) und Punkt in der PR-Merge-Checkliste (24.2); im Profil HIGH-RISK zusätzlich CI-Check. LIGHT: Checkbox genügt.

**Neu 9.8 — Learn-Schritt.** Jeder klassifizierte Fehllauf (Triage-Taxonomie 21.6) erzeugt genau eines: einen Golden Task für die Eval-Suite (27.5), einen E/N/I-Promotion-Antrag für die verletzte Regel (26.8), ein Runbook-/Doku-Update — oder eine begründete Nichtaufnahme. Betriebsvorfälle speisen zusätzlich das Fehlerbudget (25.8). **Enforcement:** HANDBACK-Feld „Learn-Kandidaten" (Vorlage 28.7 ergänzt); Abarbeitung im monatlichen Review zusammen mit dem Kosten-Review (22.7). So wird aus realen Agentenfehlern systematisch Eval-Substanz statt Anekdote.

Der Tranchen-Standardzyklus 9.2 (`Recon → Plan → Tests/Contracts → Code → Verify → Review → Commit → Worklog`) bleibt wörtlich bestehen; Reconcile und Learn liegen oberhalb, auf Item- bzw. Projektebene.

## 4. Rollenmodell Mensch/Agenten

Kapitel 5.1 bleibt die Basis; der Sweep verlangt Verschlankung, nicht Erweiterung: **Rollen sind Kontext- und Berechtigungsgrenzen, keine Jobtitel** (D03). Persona-Kataloge (MetaGPT-Stil) bleiben ausgeschlossen.

**Mensch (Eigentümer/Chefarchitekt, Andreas):** Ziele, Prioritäten, Architekturentscheidungen, Risikoakzeptanz, Modus- und A-Stufen-Freigaben, A4/A5-Checkpoints, Design-Geschmacksurteil (15.5), Explain-back bei R2/R3 (5.5). Die Anthropic-Telemetrie (≈70 % der Planungs-, ≈80 % der Ausführungsentscheidungen beim jeweils anderen Partner) bestätigt diesen Schnitt.

**Agentenrollen-Kern (In-place-Schärfung 5.1 und 10.4):**

| Rolle | Berechtigungsgrenze | Technische Form |
|---|---|---|
| Lead/Planner | Plan, Contracts, Shared Files, serielle Integration | Hauptsession; einziger Schreiber auf Shared Files (10.5) |
| Implementer | disjunkte Pfade im Worktree, A1–A3 je Freigabe | Worktree-Session, Sandbox in W3-Umgebung |
| Reviewer/Verifier | read-only, nur Diff + Rubrik, frischer Kontext | Subagent mit Deny auf Write/Edit; eng gescoped (Reviewer-Overfitting) |
| Explorer/Recon | read-only Analyse, Fan-out | Subagent A0 |
| Ops-Agent | Betrieb, zwei Profile `ops-readonly`/`ops-runbook` | neu 25.9; W2 bzw. Runbook-Ausnahme |

Fachrollen aus 10.4 (Backend/Web/Android/Test/Security/UX) werden Scope-Etiketten des Implementers, keine eigenen Agentendefinitionen. **Enforcement:** Rollen werden als versionierte Agents mit Tool-Allowlists im Methodik-Plugin ausgeliefert (neu 26.9) — damit ist die Rollengrenze Permission, nicht Prompt. Das Copilot-Prinzip „Requestor darf nicht approven" wird Methodikregel: Der schreibende Agent reviewt nie sein eigenes Ergebnis (Selbstkorrektur-Illusion, 23–93 pp Asymmetrie, D07).

## 5. Autonomie- und Eskalationsmodell

A0–A5, M0–M4 und die Regel „unbeaufsichtigt endet vor A4" bleiben unverändert in Kraft. Drei Ergänzungen:

**(a) Neu 22.10 — Windows-Autonomie-Matrix als normativer Kern.** Die Grenzregel W1–W4 aus A20 wird wörtlich übernommen: **W1** attended in jeder Umgebung bis A5 (Zwei-Schritt Plan → Freigabe → Ausführung; Remote Control zählt als attended); **W2** unattended read-only nativ auf Windows nur mit vollständigem Kompensationspaket K+P+H+E+C (Servicekonto, NTFS-ACLs, read-only-DB-Rollen, lesende Allowlist im dontAsk-Modus, Audit-/Kill-File-Hooks, Egress-Firewall, Credential-Schutz); **W3** unattended schreibend nur mit prozessgebundener OS-Isolation (WSL2-Sandbox Strict-Profil, Devcontainer/VM, ephemerer CI-Runner, Anthropic-Cloud) — nativ Windows ausschließlich als Runbook-Ausnahme (ein benanntes, idempotentes, reversibles Skript als Skill mit `disable-model-invocation`); **W4** A4/A5 nie unattended, in keiner Umgebung. Planungsannahme dauerhaft: Die native Windows-Sandbox kommt nicht („not planned", Issue #46740). Matrizen A (A-Stufen × Umgebungen E1–E5) und B (M-Klassen × Umgebungen) sowie die Routines-Bedingungsliste werden Anhang **neu 23.12**. **Enforcement:** Sandbox-Konfiguration (`failIfUnavailable: true`), Permission-Profile je Umgebung im Plugin, Firewall/Kontenmodell auf dem Server; die Matrix selbst ist E-Stufe, weil jede Zeile einen technischen Mechanismus benennt. Die moderate M2-Lockerungsoption (unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel) wird **nicht** vorentschieden → Eigentümerentscheidung E1.

**(b) Neu 5.6 — Doppelkonditionierung der A-Stufen.** Autonomie wird je **(Projekt × Task-Klasse)** geführt, nicht pauschal je Projekt:

- *Task-Klassen-Startkorridor* (Stanford-100k-Matrix): Greenfield niedrig/mittel → bis A3; Greenfield komplex und Brownfield niedrig → A2–A3; Brownfield komplex → A1–A2 mit engem Diff-Review. **Rework-Faktor wird Pflichtmetrik** im Run-Manifest.
- *Evidenzbasierter Aufstieg:* Eine Stufe steigt erst, wenn (1) die „verdiente Autonomie" aus 5.5 dokumentiert ist (≥8–12 manuell geprüfte Läufe des Typs ohne Befund) und (2) die einschlägigen Golden Tasks **pass^k** (k=3–5) bestehen (Messinstrument neu 27.7: Golden-Task-Suite 20–50 Aufgaben aus realen Fehlern, Kanarien-Subset 5–10 nightly, Grader-Trias deterministisch vor LLM-Rubrik).
- *Fehlerbudget-Degradierung:* Gate-Verletzung, E-Regelverstoß oder Betriebsvorfall verbraucht Budget (Startwert: 2 Vorfälle/Monat je Projekt, E8); erschöpftes Budget senkt die A-Stufe der betroffenen Task-Klasse um eins, bis ein Eval-Nachweis den Wiederaufstieg trägt. Rework-Faktor > 2 über drei Tranchen wirkt wie ein Vorfall.
- *Orchestrierungskopplung:* Einzelsession (jede Stufe) → Subagents (ab A1) → Background/Worktree+PR (A2–A3, nur W3-Umgebungen) → Workflows/Agent Teams (nur read-lastig oder W3, Kosten-Check nach 22.7) → Routines (strukturell A3-Deckel, nur unter 23.12-Bedingungsliste).

**(c) Eskalation und Abbruch.** Safety Park (11.4) und HANDBACK (11.6) bleiben die Mechanismen; ergänzt wird: Abbruchgrund als Pflichtfeld im Run-Manifest nach der Triage-Taxonomie 21.6; Stagnationsregel „zwei Runden ohne neuen Stand oder neue Hypothese → Stopp" wird E-Stufe via `--max-turns`/Workflow-Warnschwellen; Eskalationskanäle je Gate-Typ: attended → Remote-Control-Push („Push when actions required"), unattended → Report + Benachrichtigung nur bei Befund, Notfall → Notausschalter-Katalog 25.10. Interaktive UAC-/Login-/Permission-Schritte bleiben Parkgründe (13, CLAUDE.md).

## 6. Artefaktkanon mit E/N/I

**Neu 26.8 — Verbindlichkeitstaxonomie.** Jede Regel und jedes Artefakt trägt eine Stufe: **E** (erzwungen: Hooks, Permission-Rules, Sandbox, CI, Branch-Protection, Manifest-Pflichtfelder), **N** (normativ-advisory: Verfassungstext, ADR-Regeln, Konventionen), **I** (informativ: Hintergrund, on-demand-Doku). **Promotion-Pfad:** Eine N-Regel, die zweimal nachweislich verletzt wurde (Learn-Schritt 9.8), wird in einen Hook/CI-Check überführt oder bewusst auf I abgestuft; das Register dafür ist der bestehende Regel-Lebenszyklus 26.5 (Feld `enforcement` ergänzt). Das TDAD-Paradox begründet die Richtung: prozedurale Prompts verschlechtern, deterministische Checks und kuratierter Kontext verbessern.

**Kanon-Erweiterung (In-place in Tabelle 3.2, plus neue Vorlagen 28.11–28.14):**

| Artefakt | Stufe | Eigentümer | Pflege-Trigger | Drift-Schutz |
|---|---|---|---|---|
| AGENTS.md-Verfassung (<200 Zeilen), CLAUDE.md als dünne Brücke via `@AGENTS.md` | N (Kern-Verbote als E gedoppelt) | Eigentümer | Regeländerung (26.5) | Zeilen-Limit-Check, Pruning im Learn-Review |
| SPEC je Item: EARS-Kriterien, Non-Scope, **Annahmenregister** (`[NEEDS CLARIFICATION]` statt raten) | N | Lead | vor Implementierung; bei Kurskorrektur | 9.7 Reconciliation |
| ADR mit ausführbarem Check, wo möglich (Fitness Function referenziert) | N→E je Check | Eigentümer | Architekturentscheidung | CI-Fitness-Functions |
| Run-Manifest (Pflichtfelder s. Abschnitt 10) | E | Agent (Schema im Plugin) | jeder autonome/parallele Lauf | JSON-Schema-Validierung |
| Spike-Karte + Experiment-Log | N | Eigentümer | jeder Spike (8.6) | Entsorgungsregel, Worktree-Löschzwang |
| dataset.yaml (Daten-Archetyp) | N | Lead Daten | neue Quelle/Schemaänderung | Pandera/pydantic-Gates |
| DESIGN.md + Tokens (UX) | N | Eigentümer | Designfreigabe 15.5 | Visual-Regression-Baseline |
| Runbooks als Skills (`disable-model-invocation`) | E (Form) | Eigentümer | Betriebsänderung | Skill-Review + Audit-Log |
| project-state.yaml (maschinenlesbarer Projektstand, Portfolio-Analyse 18.5) | N | Lead | jedes HANDBACK | README-Generierung daraus |

Held-out-Abnahmesuite und Eval-Suite sind Artefakte der Qualitäts- bzw. Autonomieschicht (Abschnitte 8 und 5). Die Umstellung CLAUDE.md → AGENTS.md-Import ist Eigentümerentscheidung E6 (betrifft alle 11 Projekte, reine Mechanik, aber Churn).

## 7. Informationsflüsse, Entscheidungs- und Freigabepunkte

Die Wahrheitshierarchie (CLAUDE.md Kap. 3) und der spezifikationsgetriebene Fluss bleiben: **SPEC als gepinnte Wahrheit → Execution Plan → Worker (disjunkte Ownership) → Pre-Integration-Gate → serielle Integration durch den Lead → Reviewer → Eigentümer.** Interpretationsfragen gehen an den Lead, nie in stille Annahmen (9.6); Annahmen werden im Annahmenregister deklariert (+8 pp belegt, D02).

**Freigabepunkte (unverändert, jetzt mit Kanal und Enforcement):**

| Checkpoint | Wer | Kanal | Enforcement |
|---|---|---|---|
| Modusfreigabe (SPRINT nur explizit), Sprint-Charter | Eigentümer | Terminal/Chat | N + Charter-Pflicht |
| A-Stufen-/A5-Capability-Freigabe je Lauf | Eigentümer | Terminal oder Remote Control | Permission-Prompts, Hooks |
| A4 Ready/Merge | Eigentümer | PR-Review, mobil nur per Positivliste | Branch-Protection, W4 |
| A5 Deploy/Live | Eigentümer | Zwei-Schritt, Ausführung deterministisch (Pipeline, workflow_dispatch) | CI-Gates, WIF-Deploy-Pfad |
| Design-Gate | Eigentümer | gerenderte Oberfläche (15.5) | Screenshot-Baseline-Sperre |
| Zweitmeinungs-Gate ab R2 | Verifier-Subagent vor Mensch | automatisch | Pflichtschritt im Plan (10.8) |

**Remote Control ist attended-Kanal** mit mobiler Asymmetrie (Positivliste: freigeben, reviewen, stoppen, Fragen beantworten; Negativliste: nichts Destruktives, kein A4/A5-Ersturteil bei komplexen Diffs, keine Konfigurationsänderung). Entscheidungen dokumentiert: ADRs (26.4) für Dauerhaftes, nummerierte offene Owner-Entscheidungen im Projektstand (`next_owner_checkpoint` in project-state.yaml); GitHub-Environment-Gates entfallen für private Repos (erst ab Enterprise) — das mobile Freigabe-Gate ersetzt sie.

## 8. Parallelisierung und Verifikation

Kapitel 10 bleibt tragfähig; vier Schärfungen operationalisieren den Evidenzblock A1–A8:

1. **WIP-Limit beziffert (In-place 10.8):** höchstens **2–3 offene, ungeprüfte Agenten-PRs** portfolio-weit (Startwert; endgültige Zahl E3). Neue Schreibfronten erst, wenn Reviews abfließen; bei Stau wird Generierung gedrosselt, nie Prüftiefe.
2. **Neu 10.9 — Slice-Regel:** Der Vertical Slice ist die Einheit von Parallelität *und* Review: ein Worker = ein Slice = ein PR, in einer konzentrierten Sitzung vollständig lesbar. Slices definieren Ownership-Grenzen natürlich; Shared Contracts bleiben beim Lead.
3. **Zweitmeinungs-Gate (In-place 10.8):** Der frische Verifier-Subagent (nur Diff + Rubrik) wird ab Risikoklasse R2 Pflicht, bleibt aber Vorstufe — menschliche Freigabe ist durch KI-Review nie ersetzbar (−23 pp Merge-Rate ohne menschlichen Review; Agent-only-Reviews rauschen).
4. **Gate-Hierarchie (In-place 18.7 + neu 18.11):** Statik (Ruff/pyright) → Tests inkl. Property-based/Schemathesis → Fitness Functions (import-linter/dependency-cruiser als drittes Gate gegen Erosion: Duplikation +81 %, Refactoring-Kollaps, GitClear) → **Held-out-Abnahmesuite (neu 18.11):** 5–20 Spezifikationstests je Projekt, agentenunsichtbar, nur in CI ausgeführt (SpecBench: sichtbare Tests werden gesättigt, verdeckte divergieren bis 97 %/0 %) → menschliche Freigabe. **Enforcement:** Held-out-Verzeichnis liegt außerhalb des Agenten-Checkouts (separates privates Repo oder CI-Secret-Checkout); lokale Hooks beschleunigen, CI entscheidet.

Audits ergänzen die Gates: Mutation Testing als Quartals-Audit und ACH-Muster (Bug-Injektion durch Kritiker-Agent) pilotweise (In-place 18.10). Zwei Regeln steigen auf E-Stufe: **„Testreparatur ist Codeänderung"** (ein Retry nur nach Codeänderung oder neuer dokumentierter Hypothese; Grader-Loop-Cap) und **Flaky-Quarantäne** (18.6: Marker, Ticket, Frist — kein Retry-bis-grün, Hook-geprüft).

## 9. Experimentierkreislauf

**Neu 8.6 — Experimentierkreislauf.** Jedes Experiment beginnt mit einer **Spike-Karte** (Vorlage 28.11): Hypothese, erwarteter Nutzen, messbares Erfolgskriterium, Zeit- und Token-Box, Entsorgungsregel. Ausführung isoliert im Worktree, markiert als explorativ (14.5 bleibt: Übernahme in Produktcode nur über den Standardzyklus mit Tests). Ergebnis in ein kumulatives **Experiment-Log**: übernehmen / anpassen / vollständig verwerfen — verworfene Worktrees werden gelöscht (Parallel-Varianten-Löschzwang gegen Prototyp-Drift). **Enforcement:** Spike-Karten-Pflicht ab Token-Box > 0,1 Mio. Tokens; Entsorgung wird im Learn-Review geprüft. Drei Sonderfälle: Best-of-N-Varianten nur mit hartem Verifier und Fanout-Kriterium (Wert ≥ 10–15× Tokenkosten, 22.7); Regel-/Skill-Experimente laufen als Agenten-Eval nach 27.5 (mit/ohne Änderung, frische Sessions, Passrate/Kosten); Produkt-Experimente hängen an der Outcome-Schleife 8.4. Damit deckt v4.1 den vollständigen Kreislauf Hypothese → Spike → Messung → Entscheidung → Übernahme/Entsorgung ab, ohne ein neues Framework einzuführen.

## 10. Traceability und Evidence Chain

**Dreistufig (In-place 21.6 und 24.2):**

1. **Überall (E):** Commit-Trailer (`Co-Authored-By`, Assisted-by-Konvention nach Zielprojekt-Policy) und PR-Evidenzblock: Ziel/Spec-Referenz, geänderte Pfade/Contracts, Gate-Ergebnisse, Risiken, Rollback — das bestehende Evidence Bundle der Portfolio-Analyse, als PR-Template erzwungen.
2. **Bei Auto-Deploy (E):** Run-Manifest + Artefakt-Attestation (GitHub Artifact Attestations, auch private Repos; SLSA-v1.2-Muster) — nur für Pfade mit A5-deploy-Automatisierung (heute: Boxscore-Muster).
3. **Bei Bedarf (I):** OTel-GenAI-Traces sammeln, nicht neu erfinden; Feldnamen nicht einfrieren (Status Development).

**Run-Manifest-Pflichtfelder (In-place 21.6, JSON-Schema im Plugin, an `claude -p --bare --json-schema` gekoppelt):** Run-ID, Modus, A-Stufe, Task-Klasse, Modell(e), Spec-/Plan-Referenz, Start-/End-SHA, berührte Pfade/Contracts, Gate-Ergebnisse, **Evidenz-Verweise**, **Trifecta-Deklaration** (welche der drei Kanten offen waren), **Kosten-Soll/Ist** (`total_cost_usd` bzw. Fensteranteil), **Rework-Feld**, **Abbruchgrund** (Taxonomie), `spec_reconciled`. Run-Manifest und Provenance-Kern der Datenplattformen (source/fetch/raw_artifact/transform_run/claim) teilen ein Schema — ein Agentenlauf ist eine PROV-Activity wie jede Transformation. EARS-IDs verketten Spec → Test → Run → PR: Traceability entsteht aus Namensdisziplin, nicht aus Werkzeugketten (keine RDF/Triple-Stores).

## 11. Betriebs-Layer

Operate war der dünnste Teil von v4.0; Zielsystem ist der dokumentierte HP EliteDesk 800 G6 (Windows 11 Pro, 6C/12T, 32 GB, 2×512 GB SSD, **kein ECC, kein RAID → Backup-Disziplin ist die Redundanz**; WSL2-fähig; Steuergeräte Latitude 7400 und Pixel 8).

**Neu 25.8 — SRE light.** (a) **Fehlerbudget als Autonomie-Drossel:** je Live-System ein einfaches Budget (Startwert: 2 nutzerwirksame Vorfälle oder 1 Datenvorfall pro Monat); erschöpft → Feature-Autonomie der betroffenen Task-Klassen sinkt eine A-Stufe, Kapazität geht in Stabilisierung (Kopplung an 5.6). (b) **Observability-Minimum:** strukturierte JSON-Logs mit Schema, Healthchecks mit Dead-Man's-Switch (Healthchecks.io-Muster) plus Außensicht (Uptime Kuma), Versions-/Statusendpunkt; Claude ist Diagnose-*Konsument* (read-only), nie Monitoring-Ersatz. (c) Progressive Rollouts und Feature-Flags nur, wo ein zweiter Nutzer existiert — Right-Sizing.

**Neu 25.9 — Ops-Agent-Stufenplan 0–3** (aus D16, matrixkonform):

| Stufe | Gate | Inhalt | Enforcement |
|---|---|---|---|
| 0 | unattended, W2 | täglicher Health-/Log-/DB-Report headless (Scheduled Task, JSON-Schema, Benachrichtigung nur bei Befund) | `svc-claude` ohne Adminrechte, NTFS-ACLs, `agent_ro`-Rolle, lesende Allowlist dontAsk, Audit-+Kill-File-Hook, Egress-Firewall |
| 1 | attended, W1 | Admin-Sessions mit Runbook-Skills: Dienst-Neustart, Log-Triage, pg_dump-Verify | ask-Modus für Writes, Audit |
| 2 | selektiv unattended | genau **ein** reversibles Runbook (z. B. definierter Dienst-Neustart bei Health-Fail); vier Wochen Bewährung je Runbook | Runbook-Ausnahme W3: Skill mit `disable-model-invocation`, Rate-Limit, Rollback-Pfad |
| 3 | beobachten | Cloud-Scheduling/Routines für Ops, Windows-MCPs | quartalsweise Neubewertung, keine Bindung |

**DB-Zugriffsnormen (Teil von 25.9):** Postgres nur über restricted-MCP + `agent_ro`-Rolle; SQLite/DuckDB per CLI-Allowlist (`sqlite3 -readonly`); Directus über nativen MCP mit dediziertem User und **aktivierter Delete-Protection** (default-off!); Rechte werden im Zielsystem erzwungen, nie im Prompt. Fernzugriff: Windows-OpenSSH + Tailscale-ACLs (Tailscale SSH fällt als Windows-Ziel aus).

**Backup als Autonomie-Gate (In-place 25.5):** restic/Litestream-Triade, append-only-Ziel, Agentenkonto ohne Schreibrecht auf Backups, automatisierte Restore-Probe mit Dead-Man's-Switch — **bestandene Restore-Probe ist Vorbedingung jeder A5-Automatisierung** (ATLAS T0101: Datenzerstörung via Agententool).

**Neu 25.10 — Notausschalter-Katalog:** Kill-File (Hook-geprüft, Stufe 0 ab Tag 1), Deaktivierung der Scheduled Tasks/Routines, PAT-/Key-Rotation, Egress-Sperre per Firewall-Regel, physisches Netz-Trennen als letzte Stufe; mobile Freigabe-Asymmetrie gilt auch hier (stoppen immer, destruktiv nie). Jeder Schalter mit dokumentiertem Test-Datum.

## 12. Scheduler- und Kosten-Layer

**Neu 11.8 — Scheduler-Zuordnungsregel.** Vier Ebenen, je Aufgabe genau eine:

| Ebene | Umgebung/W | Permission-Profil | Kontext/Kosten | Zulässige Aufgabentypen |
|---|---|---|---|---|
| `/loop` (Session-Cron) | wie Session, W1 | erbt Session-Permissions | Session-Kontext läuft weiter | Deploy-/PR-Babysitting, kurzes Nachhalten im selben Vorgang |
| Desktop Scheduled Task | lokal, W1/W2 | per-Task-Permission-Mode | voller Kontext je Feuerung → **Kontextdiät + Haiku/Sonnet Pflicht** | lokale wiederkehrende Checks, Reports, Repo-Hygiene attended-nah |
| Cloud-Routine | E4, promptlos | **keine Prompts** — nur unter Bedingungsliste 23.12; strukturell A3-Deckel | Plan-Kontingent, still | nächtliche Repo-Pflege, Doku-Drift, PR-Vorreview — nur private Repos, Konnektorenliste leer, kein GitHub-Konnektor |
| Windows Scheduled Task + Headless (`claude -p --bare --json-schema`) | E1 Server, W2 | Kompensationspaket K+P+H+E+C, dontAsk-Leseliste | **API-Key** mit Spend-Limit, exakte Kosten je Lauf | Ops-Agent Stufe 0, Massen-/Batch-SDK-Jobs |

Merkregeln: Was Schreibwirkung braucht, gehört nicht in promptlose Ebenen (W3/W4); was täglich feuert, braucht Kontextdiät, sonst frisst es still das Wochenfenster; Remote Control ist keine Scheduler-Ebene, sondern der mobile attended-Kanal.

**Kosten-Layer (In-place 22.7 geschärft; Manifest-Felder in 21.6):**

- **Abo-/API-Split:** Max 5x (100 USD/Monat) als Fundament; Usage Credits mit Monats-Cap 20–40 USD als Überlauf; separater Console-API-Key mit Workspace-Spend-Limit (Start 25 USD/Monat) für CI, SDK und alles Unattended; Max 20x erst nach zwei Monaten dokumentierter Wochenfenster-Erschöpfung laut `/usage` (E4). Sonnet-5-Promo endet 31.08.2026: +50 % einplanen.
- **Tokenfaktor-Heuristik für die Soll-Schätzung:** Chat 1× → Einzelagent ≈4× → Agent Teams ≈7× → Multi-Agent-Fanout ≈15×; Modell-Upgrade schlägt Token-Verdopplung. **Fanout-Kriterium:** nur wenn Aufgabenwert ≥ 10–15× Tokenkosten *und* ein Verifier existiert.
- **Caps auf drei Ebenen (E):** Werkzeug (`--max-turns`, Workflow-Größe, `/effort`), Konto (Spend-Limits, Credits-Cap), Prompt/Prozess (Stagnationsregel, Abbruch bei Budgetstand mit Zwischenergebnis-Pflicht).
- **Resume-Pflicht (E):** Jeder Mehragentenlauf schreibt ein Artefakt je Agent sofort auf Disk und ist resumierbar — der versenkte 0,6-Mio.-Token-Erstlauf des Sweeps ist der Referenzfehler. Faustregel: ein schwerer Workflow je 5h-Fenster.
- **Monatliches Kosten-Review** (5 Minuten, zusammen mit Learn-Review): `/usage`, Console-Usage, Actions-Minuten. Budget-Soll vor dem Lauf, Ist danach — beides Pflichtfelder im Run-Manifest.

## 13. Archetyp-Profile

**Neu 4.5 — Zeremonie-Profile und Archetyp-Zuordnung.** Antwort auf die Portfolio-Warnung (17.3: Governance-Overhead überlädt Kontext, verteuert Kleinständerungen): Der Artefakt- und Gate-Umfang skaliert über drei Profile, **orthogonal zu den Modi** (das Profil bestimmt *wie viel* Zeremonie, der Modus *wie gearbeitet* wird). Das Profil folgt primär der Task-Klasse und Risikoklasse, nicht allein dem Projekt — auch ein HIGH-RISK-Projekt erledigt einen Tippfehler im LIGHT-Profil.

| Profil | Pflichtartefakte | Gates | Reconcile/Learn |
|---|---|---|---|
| LIGHT | Spec-Block im Item, Worklog | Statik + targeted Tests, Ein-Kommando-Verify | Checkbox im PR |
| STANDARD | SPEC (EARS + Annahmen), Execution Plan, Run-Manifest, PR-Evidenzblock | volle Gate-Hierarchie inkl. Fitness Functions | Reconcile-Schritt, Learn-Kandidaten im HANDBACK |
| HIGH-RISK | zusätzlich ADR-Pflicht, Zweitmeinungs-Gate, Held-out-Suite, Zwei-Schritt-Freigaben | zusätzlich Security-Fokusgates, Restore-Probe aktuell | eigener Reconcile-Lauf, Vorfall → Fehlerbudget |

**Default-Zuordnung der fünf Archetypen** (je Projekt bestätigen, E9):

| Archetyp (Beispiele) | Profil-Default | A-Korridor (Task-Klassen-abhängig) | Archetyp-Pflichten |
|---|---|---|---|
| A Interaktives Privatprodukt (capsule, joes-journal, tischatlas) | STANDARD; UI-Iterationen LIGHT | A2–A3; A4 attended | Design-Gate 15.5, Auth-/PII-Regeln, Backup |
| B Daten-/Wissensplattform (new_nfl, boxscore, curio) | STANDARD; Pipelines HIGH-RISK-nah | bis A3 unattended in W3; Auto-Merge-Pfad nur mit Held-out-Suite + Attestation | dataset.yaml, Provenance-Kern, Held-out-Suite zuerst hier |
| C Sensorik/Edge (wlan → funkatlas) | LIGHT bis STANDARD | A1–A3; Hardware-Tests attended | Gerätetests real, Offline-Betrieb, Langzeitmessung |
| D Infrastruktur-Transformation (server-migration) | HIGH-RISK | A0–A1 unattended (nur Diagnose, W2); alles Schreibende W1/Runbook | Inventar, Rollback-Pfad, Least Privilege, Runbook-Skills |
| E Mobile Companion (capsule-app) | STANDARD | A2–A3; Release attended | Signing-Runbook, Limited Distribution Account (08/2026 registrieren), API-Contract-Tests |

Der Boxscore-Auto-Merge-/Auto-Deploy-Pfad bleibt legitim, wird aber an die drei OpenAI-Voraussetzungen als prüfbare Eintrittsbedingung gebunden (mechanisch erzwungene Invarianten, triviales Rollback, Cleanup-Läufe) — sonst Rückfall auf Owner-Checkpoint vor Merge.

## 14. Delta zu v4.0

Vollständige Delta-Liste (N=neu als Unterabschnitt, S=In-place-Schärfung; jede Zeile trägt ihren Enforcement-Mechanismus):

| # | Baustein | Anker | Art | Enforcement |
|---|---|---|---|---|
| 1 | Zeremonie-Profile + Archetyp-Zuordnung | 4.5 | N | Profilwahl im Execution Plan, Plugin-Templates |
| 2 | Doppelkonditionierung A-Stufen, Rework-Metrik | 5.6 | N | Eval-Gate 27.7, Manifest-Feld, Fehlerbudget |
| 3 | Rollenkern verschlankt, Requestor-approvt-nie | 5.1/10.4 | S | Agents mit Tool-Allowlists im Plugin |
| 4 | Experimentierkreislauf, Spike-Karte, Experiment-Log | 8.6 | N | Token-Box, Löschzwang, Learn-Review |
| 5 | Spec-Reconciliation nach Merge | 9.7 | N | Manifest-Feld, Merge-Checkliste, CI bei HIGH-RISK |
| 6 | Learn-Schritt (Fehler → Evals, Verstöße → Promotion) | 9.8 | N | HANDBACK-Feld, Monatsreview |
| 7 | EARS + Annahmenregister in der Spec | 9.6 | S | Spec-Vorlage 28.13 |
| 8 | WIP-Limit beziffert (2–3 PRs), Zweitmeinungs-Gate ab R2 | 10.8 | S | Planpflicht, PR-Zählung |
| 9 | Slice-Regel | 10.9 | N | Ownership-Schnitt im Plan |
| 10 | Scheduler-Zuordnungsregel (4 Ebenen) | 11.8 | N | Permission-Profile je Ebene, API-Key-Split |
| 11 | Held-out-Abnahmesuite | 18.11 | N | agentenunsichtbares Repo, nur CI |
| 12 | Gate-Hierarchie inkl. Fitness Functions; Testreparatur-Regel, Flaky-Quarantäne auf E | 18.5–18.7, 18.10 | S | CI-Reihenfolge, Hooks |
| 13 | Statusquellen-Hierarchie + Benchmark-Regel B1–B5 | 20.7 | N | Recherche-Skill-Vorgabe |
| 14 | Run-Manifest-Pflichtfelder (Evidenz, Trifecta, Kosten, Rework, Abbruchgrund, spec_reconciled) | 21.6 | S | JSON-Schema-Validierung |
| 15 | Kosten-Layer (Split, Faktoren, Caps, Resume, Review) | 22.7 | S | Spend-Limits, `--max-turns`, Schema |
| 16 | Windows-Autonomie-Matrix W1–W4 | 22.10 | N | Sandbox-Profil, Kontenmodell, Firewall |
| 17 | MCP-Zielrevision 2025-11-25, 2026-ready-Regeln, Umstellungstrigger | 23.3 + CLAUDE.md-Steckbrief (dort steht noch 2026-07-28 — korrigieren) | S | Registry-Prüfpunkt, Designregel-Checkliste |
| 18 | Matrizen A/B + Routines-Bedingungsliste | 23.12 | N | Routine-Anlage-Checkliste, Konnektoren leer |
| 19 | Commit-Trailer/PR-Evidenzblock | 24.2 | S | PR-Template, CI-Check |
| 20 | Backup append-only + Restore-Probe als A5-Gate | 25.5 | S | Kontotrennung, Dead-Man's-Switch |
| 21 | SRE light, Fehlerbudget als Drossel | 25.8 | N | Budget-Zähler im Portfolio-Stand |
| 22 | Ops-Agent-Stufenplan 0–3, DB-Zugriffsnormen | 25.9 | N | svc-Konto, agent_ro, MCP-restricted, Allowlists |
| 23 | Notausschalter-Katalog, mobile Asymmetrie | 25.10 | N | Kill-File-Hook, getestete Schalter |
| 24 | E/N/I-Taxonomie mit Promotion-Pfad | 26.8 | N | Regel-Registry-Feld 26.5 |
| 25 | Methodik als privates Claude-Code-Plugin | 26.9 | N | versioniertes Marketplace-Repo |
| 26 | pass^k, Golden Tasks, Kanarien, Fehlerbudget-Messung | 27.7 | N | Eval-Suite in CI/nightly |
| 27 | Vorlagen: Spike-Karte, Run-Manifest-Schema, SPEC, project-state.yaml | 28.11–28.14 | N | Plugin-Distribution |

Nicht übernommen (bewusst, synthese-konform): Microservices/Kafka/Vault/Triple-Stores/IDPs, SaaS-Evals, Agenten-Flotten, lokale GPU-Inferenz als Primärpfad, KI-Review als Freigabeersatz, Tailscale SSH auf Windows, GitHub-Environment-Gates privat, METR-Punktschätzer und absolute Benchmark-Scores als Entscheidungsgrundlage.

## 15. Einführungs-Reihenfolge

Drei Wellen, jede mit Erfolgskriterium; kein Big Bang:

- **Welle 1 — Regel- und Konfigurationsänderungen (Woche 1–2):** W-Matrix 22.10/23.12 in Kraft setzen, MCP-Steckbrief korrigieren (2025-11-25), Kostenrahmen einrichten (Credits-Cap, API-Key mit Spend-Limit), Run-Manifest-Schema mit neuen Pflichtfeldern, Notausschalter einrichten und testen, WIP-Limit und Stagnationsregel scharf. *Erfolg:* alle laufenden Projekte referenzieren die neuen Abschnitte; ein Testlauf produziert ein schema-valides Manifest.
- **Welle 2 — Struktur (Monat 1):** Methodik-Plugin paketieren (Hooks=Gates, Skills=Modi/Runbooks, Agents=Rollenkern, Settings) und in 2–3 Projekten aktivieren; E/N/I-Inventur aller Bestandsregeln; Spec-Reconciliation und Learn-Schritt aktivieren; Held-out-Suite für new_nfl und eine zweite Datenplattform; Ops-Agent Stufe 0 auf dem Heimserver (svc-claude, agent_ro, Kill-File ab Tag 1); Zeremonie-Profile den 11 Projekten zuordnen. *Erfolg:* erster Monat mit Learn-Review; Held-out-Suite hat mindestens eine Divergenz sichtbar gemacht oder grün bestätigt.
- **Welle 3 — Evidenzbetrieb (Quartal):** Golden-Task-Suite auf 20–50 Aufgaben, pass^k-basierte Auf-/Abstiege beginnen; Routines-Pilot streng nach Bedingungsliste (falls E5 positiv); Ops-Stufe 1–2 (erstes Runbook mit vier Wochen Bewährung); Mutation-/ACH-Audit auf 1–2 Kernmodulen; Kennzahlen-Baseline je Projekt steht (Durchlaufzeit, Rework, Defekt-Escape, Duplikat-Signale, Eval-Ergebnisse). *Erfolg:* mindestens ein evidenzbasierter A-Stufen-Wechsel ist dokumentiert.

## 16. Offene Eigentümer-Entscheidungen

1. **E1 — M2-Lockerungsoption:** unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel zulassen — oder strikte M0/M1-Regel behalten (konservative Alternative).
2. **E2 — Server-Rollenverteilung:** Aufgabenteilung Heimserver vs. bestehender Windows-VPS (was läuft wo; Verhältnis zum server-migration-Vorhaben).
3. **E3 — WIP-Limit-Zahl:** 2 oder 3 offene ungeprüfte Agenten-PRs portfolio-weit.
4. **E4 — Kostenrahmen bestätigen:** Max 5x + Credits-Cap-Höhe (20–40 USD) + API-Spend-Limit (25 USD); Upgrade-Kriterium für Max 20x.
5. **E5 — Routines-Pilot:** ja/nein; falls ja, erster Kandidat (Repo-Pflege, Doku-Drift oder PR-Vorreview) unter der Bedingungsliste 23.12.
6. **E6 — AGENTS.md-Umstellung:** CLAUDE.md jetzt zur dünnen Brücke machen oder erst mit v5.
7. **E7 — A3-unattended-Vorabfreigaben:** welche Repos erhalten die exakte Vorabfreigabe für Push/Draft-PR aus W3-Umgebungen.
8. **E8 — Fehlerbudget-Parameter:** Startwerte für Vorfalls- und Rework-Schwellen je Projektklasse.
9. **E9 — Archetyp-Profil-Zuordnung:** Bestätigung je Projekt; insbesondere ob der Boxscore-Auto-Merge-Pfad die drei Eintrittsbedingungen bereits erfüllt.
10. **E10 — Inkraftsetzung:** Delta-Paket als Methodik v4.1 übernehmen (Changelog in Kapitel 2, Regel-Lebenszyklus 26.5) oder als Bauplan für einen v5-Neuschnitt behandeln.
