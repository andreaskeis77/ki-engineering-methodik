# Operating Model und Lifecycle-Referenzmodell

**Version:** 1.0-Entwurf · **Stand:** 2026-07-28 · **Status:** Entscheidungsvorlage für Andreas (Tranche-1-Ergebnis gemäß Forschungsauftrag Abschnitt 10/14)

**Konstruktion:** Konsolidierte Fassung der drei konkurrierenden Entwürfe A (Evolution), B (Lifecycle-first), C (Enforcement-first) nach beiden Gutachten (J1 Praxis/Right-Sizing/Adoptierbarkeit; J2 Evidenz/Konsistenz/Enforcement). Trägerformat ist Entwurf A — das Delta-Paket auf die v4.0-Anker, von J1 gegen die reale Kapitelstruktur verifiziert. Systematisch eingearbeitet sind die Übernahme-Listen beider Gutachten: Right-Sizing, Didaktik und Vollständigkeit aus B; Enforcement-Härtung aus C. Alle von den Gutachten benannten Schwächen sind behoben, nicht übernommen (Fehlerliste in Abschnitt 14). **Grundlage:** Gesamtsynthese v2 inkl. Konfliktentscheide K1–K4, Addenda A04a/A17–A20, Dossiers D01–D16, Portfolio-Analyse 2026-07-28, Methodik v4.0, CLAUDE.md v4.0, Heimserver-Steckbrief. Herkunftsvermerk je Hauptbaustein im Anhang.

---

## 1. Executive Summary

Der Recherche-Sweep bestätigt die Methodik v4.0 in ihren tragenden Entscheidungen: Autoritätsstufen A0–A5, Modi STANDARD/SPRINT/HYBRID, Tranchen, Spezifikationspflicht, hermetische Gates, Run-Manifeste, Safety Park und HANDBACK sind extern validiert; bei Provenance ist v4.0 dem Feld voraus. Ein Neubau wäre Churn ohne Evidenz. Dieses Referenzmodell ist deshalb ein **Delta-Paket als Methodik v4.1**: rund 20 neue Unterabschnitte und rund 15 In-place-Schärfungen an verifizierten freien Ankern (Nummernstabilität nach 26.7), mit einer Regelschicht, die in zwei Wochen nebenher in Kraft tritt. Der v5-Neuschnitt entlang des Lifecycle-Denkmodells bleibt spätere Option aus Betriebserfahrung — diese Sequenz ist redaktionell entschieden, nicht mehr offen (vormals E10).

Inhaltlich schließt das Paket die belegten Lücken: die **Windows-Autonomie-Matrix W1–W4** als normativer Kern der Umgebungsfrage; zwei neue **Lifecycle-Pflichtschritte** (Spec-Reconciliation nach Merge, Learn); die **Doppelkonditionierung der A-Stufen** als Zustandsmaschine je (Projekt × Task-Klasse) — Aufstieg evidenzbasiert und menschlich, Abstieg mechanisch über ein Fehlerbudget; die **Verbindlichkeitstaxonomie E/N/I** mit Enforcement-Feldern im bestehenden Regel-Lebenszyklus und halbjährlicher Gate-Probe auf den tragenden E-Regeln; die **Held-out-Abnahmesuite**; einen vollwertigen **Betriebs-Layer** auf dem HP-Heimserver; **Scheduler- und Kosten-Layer**. Drei Zeremonie-Profile skalieren den Apparat, mit **LIGHT als beweislastfreiem Default für alles Reversible** — die direkte Antwort auf die Portfolio-Warnung vor Governance-Overhead (§17.3). Der Engpass des Systems ist nicht Codeerzeugung, sondern Andreas' Verifikationsbandbreite; zentraler Regler ist das WIP-Limit von 2–3 offenen ungeprüften Agenten-PRs.

Der härteste Konsistenzfall — der etablierte Boxscore-Auto-Merge gegen die E-Regel W4 („A4/A5 nie unattended") — wird W4-erhaltend aufgelöst: Content-Refresh als deterministische CI-Pipeline ohne LLM im Promotionspfad, Code-Merges attended via Remote Control (OE-2). Jede E-Regel benennt ihren Mechanismus oder heißt ehrlich N; drei Urteile bleiben dauerhaft unmechanisiert. Elf Entscheidungen kann nur Andreas treffen; sie stehen mit Empfehlungen in Abschnitt 16.

## 2. Leitidee und Designprinzipien

**Leitidee:** Das Operating Model ist die Methodik v4.0 plus das, was der Sweep bewiesen hat — getragen von Mechanismen, wo Text nachweislich versagt, und klein gehalten durch LIGHT als Normalfall.

- **P1 — Delta statt Neubau.** Neue Inhalte nur als Unterabschnitte am Kapitelende oder als In-place-Schärfung; keine Umnummerierung (26.7). Sofortige Adoptierbarkeit schlägt konzeptionelle Eleganz.
- **P2 — Verbindlich ist nur, was erzwungen wird — und ehrlich deklariert ist.** Jede Regel trägt eine E/N/I-Stufe (neu 26.8). Jede E-Regel benennt einen deterministischen Mechanismus (Hook, Permission-Rule, Sandbox, OS-Konto/DB-Rolle, Firewall, CI, Branch-Protection, Spend-Limit, Manifest-Schema) und besteht bei Inkraftsetzung eine Erstprobe. Was keinen Mechanismus hat, heißt N — Schein-E ist ausgeschlossen.
- **P3 — Verifikationsbandbreite ist die knappe Ressource.** Nicht Tokens (in Dollar billig), sondern die Review-Tiefe eines Solo-Menschen limitiert (Evidenzblock A1–A8 statt METR-Punktschätzer). Genau eine Entscheidungsfront je Projekt; Parallelität nur unterhalb der letzten Freigabe.
- **P4 — Autonomie ist verdient, entziehbar, task-klassenabhängig — und asymmetrisch.** Abstieg ist mechanisch (Fehlerbudget), Aufstieg ist menschlich (Evidenz schlägt vor, Andreas entscheidet als ADR). Kein Agent und kein Skript erhöht je eine A-Stufe.
- **P5 — Right-Sizing mit Beweislastumkehr.** LIGHT ist der Default für alles Reversible; Artefakt-Budget LIGHT ≤ 1 Seite gesamt; wer STANDARD wählt, begründet mit Risiko, nicht mit Gewohnheit. Zeremonie-Profil und Arbeitsmodus sind orthogonal: das Profil bestimmt, *wie viel* Zeremonie, der Modus, *wie* gearbeitet wird.
- **P6 — Keine instabilen Zahlen als Fundament.** Benchmark-Regel B1–B5, Statusquellen-Hierarchie „Ankündigung ≠ Vollzug", keine Steuerung über gefühlte Produktivität (Wahrnehmungs-Mess-Lücke).
- **P7 — Kein Artefakt ohne Eigentümer und Pflege-Trigger.** Was niemand pflegt, wird gestrichen oder auf I gestuft.
- **P8 — Schutzklausel.** Drei Urteile werden dauerhaft **nie** mechanisiert und haben keinen Promotion-Pfad: das Produkturteil, die Designfreigabe, die Risikoakzeptanz. Enforcement schützt die Outcome-Schleife, es ersetzt sie nicht.
- **Anti-Flickenteppich-Regel:** je Querschnittsthema genau eine normative Heimat — W-Matrix/Umgebungen → 22.10, Kosten → 22.7/21.6, Scheduler → 11.8, E/N/I → 26.8, Betrieb → 25.8–25.11, Profile → 4.5. Andere Kapitel verweisen nur.
- **Nomenklatur-Regel (entkollidiert):** Eigentümerentscheidungen heißen **OE-***; E/N/I bezeichnet ausschließlich Verbindlichkeitsstufen; Umgebungen tragen die IDs **E1–E5** mit Legende im Normtext (Abschnitt 5).

## 3. Lifecycle

Der Konsens-Makrozyklus **Research → Specify → Plan → Execute+Verify → Review → Ship → Operate → Learn** existiert in v4.0 fast vollständig; er wird auf die vorhandenen Kapitel gemappt und um zwei Pflichtschritte ergänzt:

| Referenzphase | v4.0-Heimat | Delta |
|---|---|---|
| Research | 5.4 Read-only-Onboarding, 9.2 Recon | unverändert; Recherche-Regeln B1–B5 gelten (20.7) |
| Specify | 9.6 Spezifikationsgetriebener Ablauf | geschärft: EARS-Kriterien mit REQ-IDs, Annahmenregister (28.13) |
| Plan | 9.3/9.4 Planstufen, Execution Plan | geschärft: Kosten-Soll, Task-Klasse, A-Deckel, Review-Budget als Planfelder |
| Execute+Verify | 9.2 Tranchen-Zyklus, 18 Gates | Gate-Hierarchie präzisiert (Abschnitt 8); Red-Beweis ab A3 |
| Review | 9.2, 10.8 Verifier | Zweitmeinungs-Gate ab Risikoklasse R2 |
| Ship | 24 Git/CI, 25 Release | A4/A5 attended (W4); deterministische Deploy-Pipeline |
| **Reconcile** | **fehlt** | **neu 9.7 — Pflichtschritt nach Merge** |
| Operate | 25.7 Betrieb (dünn) | ausgebaut zu 25.8–25.11 (Abschnitt 11) |
| **Learn** | 27.5 nur implizit | **neu 9.8 — verbindlicher Rückfluss mit Takt** |

**Gesamtbild (I-Stufe, Lehrbild, Vorlage 28.15; normativ sind allein die Kapitelanker, G/Q-Kürzel didaktisch):**

```
MAKRO (Vorhaben/Tranche)              G* = menschliche Freigabe · Q* = Maschinen-Gate
┌───────────────────────────────────────────────────────────────────────────────┐
│ Research ─► Specify ─► Plan ─► Execute+Verify ─► Review ─► Ship               │
│               │G1        │G2       │ Q1 Statik       │G3 Merge    │G4 Deploy  │
│               ▼          ▼         │ Q2 Tests        ▼            ▼           │
│           SPEC(EARS)  Exec-Plan    │ Q3 Fitness   Reviewer     Reconcile      │
│           +Annahmen   +Budget      ▼ Q4 Held-out  (frisch,    + determinist.  │
│                       +A-Stufe   Run-Manifest    read-only)     Pipeline      │
│                                                                    │          │
│      Learn ◄────────────────── Operate ◄───────────────────────────┘          │
│      │G6 A-Auf-/Abstieg,       │G5 Runbook-/Stufen-Freigaben                  │
│      ▼  E/N/I-Promotion        (Fehlerbudget, Backup-Probe, Reports)          │
│      Evals · Regeln · Kennzahlen-Baseline                                     │
└───────────────────────────────────────────────────────────────────────────────┘
MIKRO: jeder Slice durchläuft Recon → Test rot → grün → Selbstverifikation → PR.
WIP-Limit: maximal 2–3 offene ungeprüfte Agenten-PRs portfolio-weit.
```

**Neu 9.7 — Spec-Reconciliation nach Merge.** Kein Framework löst Spec-Drift nach dem Merge; ungeregelt wird Reconciliation übersprungen (D01/D02). Regel: Nach dem Merge prüft ein read-only-Reconcile-Schritt (Subagent mit frischem Kontext oder Checklistenpunkt, je Profil): (1) erfüllt das gemergte Verhalten die EARS-Akzeptanzkriterien, (2) sind offene Annahmen bestätigt oder widerlegt, (3) ist die Spec-Version aktuell, (4) ist `project-state.yaml` nachgeführt. Drei zulässige Ausgänge: `ok`, versioniertes Spec-Update, Defekt-Issue. **Right-sized:** LIGHT: Sammelabgleich je Tranche statt je Merge, Checkbox genügt; STANDARD: je Merge; HIGH-RISK: je Merge, menschlich gegengelesen, zusätzlich CI-Check. **Enforcement:** Pflichtfeld `spec_reconciled` im Run-Manifest (21.6), Punkt in der Merge-Checkliste (24.2), CI-Konsistenzcheck Status↔README.

**Neu 9.8 — Learn-Schritt.** Jeder klassifizierte Fehllauf (Triage-Taxonomie 21.6) und jeder abgelehnte Agenten-PR erzeugt genau eines: einen Golden Task für die Eval-Suite (27.7), einen E/N/I-Promotion-Antrag für die verletzte Regel (26.8), ein Runbook-/Doku-Update — oder eine begründete Nichtaufnahme. Betriebsvorfälle speisen das Fehlerbudget (25.8). Monatlich werden zusätzlich die Kennzahlen-Baseline (Durchlaufzeit, Rework-Quote, Defekt-Escape, Duplikations-/Churn-Signale, Eval-Trends, Kosten-Ist) und die A-Stufen-Entscheide behandelt; Methodik-Änderungen erscheinen als Plugin-Version. **Selbst-Enforcement:** Ein Scheduled Task erzeugt den Monats-Review-Stub; ein Merge-Kalendermonat ohne Learn-Protokoll wird im Statusreport sichtbar. Kosten- und Learn-Review sind zusammengelegt (Ziel: unter 30 Minuten pro Monat).

Der Tranchen-Standardzyklus 9.2 (`Recon → Plan → Tests/Contracts → Code → Verify → Review → Commit → Worklog`) bleibt wörtlich bestehen; Reconcile und Learn liegen oberhalb, auf Item- bzw. Projektebene.

## 4. Rollenmodell Mensch/Agenten

**Rollen sind Kontext- und Berechtigungsgrenzen, keine Jobtitel** (D03); Persona-Kataloge bleiben ausgeschlossen. **Mensch (Andreas, Eigentümer/Chefarchitekt):** Ziele, Prioritäten, Architekturentscheidungen, Risikoakzeptanz, Modus- und A-Stufen-Freigaben, alle A4/A5-Checkpoints, Design-Geschmacksurteil (15.5), Explain-back bei R2/R3 (5.5). Die Anthropic-Telemetrie (≈70 % der Planungs-, ≈80 % der Ausführungsentscheidungen beim jeweils anderen Partner) bestätigt den Schnitt: Der Mensch ist nicht Teil der Ausführungsschleife, sondern ihre Regelung.

**Agentenrollen-Kern (In-place-Schärfung 5.1/10.4), als versionierte Agents mit Tool-Allowlists im Methodik-Plugin (26.9):**

| Rolle | Berechtigungsgrenze | Technische Form |
|---|---|---|
| Lead/Planner | Plan, Contracts, Shared Files; einziger serieller Integrator; keine Merges | Hauptsession; einziger Schreiber auf Shared Files (10.5) |
| Implementer | disjunkte Pfade im Worktree; **A1–A3 je Freigabe** — A3 (Push/Draft-PR) nur mit exakter Vorabfreigabe je Ziel und nur in W3-Umgebung | Worktree-Session; Sandbox-Profil; kein Held-out-Zugriff |
| Reviewer/Verifier | strikt read-only; nie Requestor derselben Änderung | Subagent, Deny auf Write/Edit; nur Diff + Rubrik, frischer Kontext |
| Explorer/Recon | read-only Analyse, Fan-out, Netz nach Allowlist | Subagent A0, ephemer |
| Ops-Agent | Betrieb; Profile `ops-readonly` (W2, unattended) / `ops-runbook` (attended, Writes nur als Skill) | 25.9; Kontextdiät, Haiku/Sonnet |
| Zweitmeinung | read-only, nur Prüfgegenstand | Zweitmodell (Codex attended / Gemini M0), nur HIGH-RISK und Recherche |

Fachrollen (Backend/Web/Android/Test/Security/UX) sind Scope-Etiketten des Implementers, keine eigenen Agenten. Der Rollen-Widerspruch aus Entwurf C ist korrigiert: Der Implementer trägt den A3-Pfad, ausschließlich per Vorabfreigabe (OE-11). Zwei E-Regeln: (1) **Requestor-Approval-Verbot** — der erzeugende Agent gibt nie frei (Selbstkorrektur-Illusion, 23–93 pp Asymmetrie, D07); Mechanismus: Branch-Protection plus getrennte Identitäten — **Bot-Account mit fine-grained PATs** für alles Agentische. (2) **Rollenprofile sind Plugin-Bestandteil** — kein Ad-hoc-Agent mit Vollrechten; neue Rollen brauchen Eigentümerfreigabe.

## 5. Autonomie- und Eskalationsmodell

A0–A5, M0–M4 und „unbeaufsichtigt endet vor A4" bleiben in Kraft. Drei Bausteine kommen hinzu.

**(a) Neu 22.10 — Windows-Autonomie-Matrix W1–W4 als normativer Kern** (wörtlich aus A20): **W1** attended — jede Umgebung bis A5 (Zwei-Schritt Plan → Freigabe → Ausführung; Remote Control zählt als attended). **W2** unattended read-only (A0; M0/M1) — nativ Windows nur mit vollständigem Kompensationspaket K+P+H+E+C (Servicekonto ohne Adminrechte, NTFS-ACLs, read-only-DB-Rollen, lesende Allowlist im dontAsk-Modus, Audit-/Kill-File-Hooks, Egress-Firewall, ENV-Scrub). **W3** unattended schreibend (A1–A3; M2) — nur mit prozessgebundener OS-Isolation; nativ Windows ausschließlich als **Runbook-Ausnahme** (ein benanntes, idempotentes, reversibles Skript als Skill mit `disable-model-invocation`, Rate-Limit, Audit, Rollback-Pfad). **W4** A4 (Merge/Promotion) und jede A5-Fähigkeit: **nie unattended, in keiner Umgebung.** Planungsannahme dauerhaft: Die native Windows-Sandbox kommt nicht („not planned", Issue #46740). Die Matrix ist E-Stufe, weil jede Zeile einen technischen Mechanismus benennt (Sandbox `failIfUnavailable: true`, Permission-Profile, Kontenmodell, Firewall). Matrizen A (A-Stufen × Umgebungen) und B (M-Klassen × Umgebungen) stehen im Anhang **neu 23.12**.

**Umgebungslegende E1–E5 (normativ hier fixiert; 23.12 nutzt dieselben IDs):** **E1** Windows nativ (Heimserver/Clients) — W1/W2, Schreibendes nur als Runbook-Ausnahme; **E2** WSL2-Sandbox Strict (lokal) — W3-fähig; **E3** Devcontainer/VM (lokal) — W3-fähig; **E4** Anthropic Cloud (Cloud-Sessions/Routines) — W3-fähig, Routines nur nach Bedingungsliste; **E5** ephemerer CI-Runner (GitHub Actions) — W3-fähig. Background-/Worktree-Läufe mit Schreibwirkung laufen in E2/E3, CI-getriebene Läufe in E5.

**Cloud-Routines** laufen promptlos und sind strukturell auf das A3-Äquivalent gedeckelt; zulässig nur unter der vollständigen Bedingungsliste (K4, wörtlich): M0/M1-Werkzeuge; Konnektorenliste vor Anlage leer bzw. serverseitig read-only; keine Secrets im Environment; Netz nie Full; nur private Repos; Output nur auf `claude/`-Branches; **kein GitHub-Konnektor**; Ergebnisprüfung vor Weiterverwendung; Identitäts-Akzeptanz. Warnung (D14): **Routines melden grünen Status auch bei inhaltlichem Misserfolg** — die Ergebnisprüfung bleibt Pflicht. Die moderate **M2-Lockerungsoption** (unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel) wird nicht vorentschieden → OE-1.

**(b) Neu 5.6 — Doppelkonditionierung als Zustandsmaschine.** Autonomie wird je **(Projekt × Task-Klasse)** geführt und in `project-state.yaml` persistiert; ein Session-Start-Hook lädt daraus das Permission-/Sandbox-Profil — **die Stufe ist das Profil, kein Satz**. Task-Klassen (Stanford-Matrix, Rework als Pflichtmetrik): **TK1** Greenfield niedrig–mittel → Deckel A3 (hier liegen die 30–35-%-Gewinne); **TK2** Greenfield hoch / Brownfield einfach → A2–A3, erhöhte Review-Tiefe; **TK3** Brownfield komplex → A1–A2, kleiner Slice, enger Diff-Review (Effekt ≈0/negativ, Rework-Faktor 2,6); **TK4** kritische Pfade (Auth, PII, Migrationen, Infrastruktur, Signing) → attended, HIGH-RISK-Profil, Zweitmeinung.

- **Aufstieg (menschlich, evidenzbasiert):** Kandidat wird eine Kombination, wenn (1) „verdiente Autonomie" nach 5.5 dokumentiert ist (≥8–12 manuell geprüfte Läufe ohne Befund) und (2) die einschlägigen Golden Tasks **pass^k** (k=3–5) über der Schwelle liegen (Startwerte OE-7: ≥20 Tasks, pass^3 ≥ 85 %, Rework-Quote stabil über 4 Wochen). Andreas entscheidet; die Entscheidung wird als ADR mit Evidenzverweis festgehalten. Öffentliche Benchmark-Scores sind nie Aufstiegsgrund (B5).
- **Abstieg (mechanisch, Fehlerbudget):** Budget verbraucht bei **2 Defekt-Escapes** (Betrieb/Held-out nach Merge) **oder 1 Gate-Umgehungsversuch** (`--no-verify`, Testabschwächung) **oder 1 Sicherheits-/Trifecta-Verstoß**. Konsequenz: automatische Degradierung der betroffenen Task-Klasse um eine Stufe für zwei Wochen; Feature-Arbeit pausiert zugunsten Stabilisierung; Pflicht-Learn-Eintrag. Mechanismus: Budgetzähler in `project-state.yaml`, ausgewertet vom Session-Start-Hook.
- **Rework-Zurechnung (neu definiert, Auflage beider Gutachten):** Ein Folgelauf zählt als Rework, wenn sein Commit/PR per Trailer (`Rework-of: <Run-ID>`) oder identischer REQ-ID binnen 14 Tagen auf einen früheren Lauf verweist; den Trailer setzt der Lead bei der Triage. Ohne Referenz gilt die manuelle Schätzung im Monats-Learn-Review. Die Metrik ist damit halb-mechanisch und ehrlich als N-Datum geführt; „Rework-Faktor > 2 über drei Tranchen wirkt wie ein Vorfall" greift erst nach Bestätigung im Learn-Review.
- **Orchestrierungskopplung:** Einzelsession (jede Stufe, attended) → Subagents Explore/Review (ab A1) → Background/Worktree+PR (A2–A3, nur E2/E3, Vorabfreigabe je Ziel) → Workflows/Agent Teams (A3-Deckel, Resume-Pflicht, Budget; Teams nur read-lastige Piloten) → Routines (strukturell A3-Deckel, nur unter Bedingungsliste). Höhere Orchestrierungsstufe nie über der freigegebenen A-Stufe der Task-Klasse.

**(c) Eskalation und Abbruch.** Safety Park (11.4) und HANDBACK (11.6) bleiben die Mechanismen — parken statt raten bei fehlender Autorität, Architekturambiguität, unbekanntem Seiteneffekt, Sicherheits-/Datenrisiko, fremdem Rot, erschöpftem Budget, knappem Kontext. Ergänzt: Abbruchgrund als Manifest-Pflichtfeld (Taxonomie 21.6); Kill-File-Hook ab Tag 1 für alles Unbeaufsichtigte; Caps (`--max-turns`, Token-/Zeitbox, Spend-Limits) als E; die **Stagnationsregel** („zwei Runden ohne neuen Stand oder neue Hypothese → Stopp mit Zwischenergebnis") ist als Heuristik N — ihre Cap-Anteile sind E, die Beurteilung „kein Fortschritt" ist keine deterministische Größe. Eskalationsleiter Agent → Lead → Mensch; Kanäle je Gate-Typ: attended → Remote-Control-Push, unattended → Report mit Benachrichtigung nur bei Befund, Notfall → Notausschalter-Katalog 25.10. Annahmen werden deklariert statt geraten (+8 pp, D02); ab A3 werden offene Annahmen zu blockierenden Fragen.

## 6. Artefaktkanon mit E/N/I

**Neu 26.8 — Verbindlichkeitstaxonomie mit Prüfmechanik.** **E** erzwungen (deterministischer Mechanismus benannt), **N** normativ-advisory (Verfassungstext, ADR-Regeln, Checklisten; Verstöße werden protokolliert), **I** informativ (on-demand). **Promotion-Pfad:** Eine zweimal nachweislich verletzte N-Regel (Learn-Schritt) wird in einen Hook/CI-Check überführt oder bewusst auf I abgestuft — Kontext ist Budget; das TDAD-Paradox begründet die Richtung (prozedurale Prompts verschlechtern, deterministische Checks verbessern). **Kein eigenes Register-Dokument:** Der bestehende Regel-Lebenszyklus 26.5 erhält zwei Felder — `mechanismus` und `letzte_probe`. **Gate-Probe, right-sized:** Halbjährlich wird eine Stichprobe der 5–10 tragenden E-Regeln (Kill-File, Sandbox-`failIfUnavailable`, Branch-Protection, Held-out-CI-only, Spend-Limit, Directus-Delete-Protection, Backup-Schreibschutz) mit einem harmlosen, absichtlich regelwidrigen Versuch getestet — Enforcement, das nie geprüft wird, erodiert wie Prosa. Zusätzlich besteht jede neue oder promovierte E-Regel bei Inkraftsetzung eine Erstprobe (Welle-1-Exit). Eine Regel ohne bestandene Probe wird im Learn-Review sichtbar rot. **Schutzklausel (P8):** Produkturteil, Designfreigabe, Risikoakzeptanz sind dauerhaft N ohne Promotion-Pfad.

**Kanon (In-place Tabelle 3.2; Vorlagen neu 28.11–28.15; vollständigste Fassung nach Entwurf B):**

| Artefakt | Stufe | Eigentümer | Pflege-Trigger | Drift-Schutz |
|---|---|---|---|---|
| AGENTS.md-Verfassung (<200 Zeilen, Regeln E/N/I-markiert); CLAUDE.md als dünne Brücke via `@AGENTS.md` (OE-10) | N; Kern-Verbote als E gedoppelt | Andreas | Regeländerung (26.5) | Zeilen-Lint; Pruning im Learn-Review |
| SPEC (EARS-Kriterien mit REQ-IDs, Non-Scope, Annahmenregister `[NEEDS CLARIFICATION]`) | N; Akzeptanzkriterien werden E via Tests | Andreas (Inhalt), Lead (Form) | vor Implementierung; Kurskorrektur | Reconciliation 9.7; SPEC-Schema-Lint |
| Execution Plan + Budget-Soll | N | Lead | Scope-Änderung | Plan-Abweichung im Run-Manifest |
| ADR mit ausführbarem Check, wo möglich | Entscheidung N, Check E | Andreas | Architekturentscheidung | Fitness Function in CI |
| Run-Manifest (Pflichtfelder Abschnitt 10) | E | erzeugender Agent | jeder autonome/parallele Lauf | JSON-Schema-Validierung; Agent-PR ohne valides Manifest nicht mergebar |
| project-state.yaml (Status, A-Stufen je TK, Fehlerbudget, offene PRs, `next_owner_checkpoint`) | E | Lead pflegt, Andreas gibt Stufen frei | jeder Merge/HANDBACK | CI-Konsistenzcheck; README-Statussektion generiert, nie manuell |
| Spike-Karte + Experiment-Log | N (Pflicht ab 0,1-Mio-Token-Box) | Lead/Explorer | jeder größere Spike | Branch-TTL; Löschzwang (CI meldet überfällige Spike-Branches) |
| dataset.yaml (Datenplattformen) | N; Gates E | Lead Daten | neue Quelle/Schemaänderung | Pandera/pydantic-Gates in CI |
| DESIGN.md + Tokens | N | Andreas | Designfreigabe 15.5 | Baseline-Änderung nur nach menschlicher Freigabe |
| Runbooks als Skills | E (Form) | Andreas | Betriebsänderung | `disable-model-invocation`, exakte `allowed-tools`, Rate-Limit, Audit |
| Held-out-Abnahmesuite + Eval-Suite (Golden Tasks, Kanarien-Subset) | E | Andreas (agentenfern) | Spec-Änderung; Learn speist ein | nur CI; Ablage nach OE-5; nightly Kanarien |
| HANDBACK/STATUS | N | ausführender Agent | Parken/Übergabe | Vorlagenpflicht 28.7 (ergänzt um Feld „Learn-Kandidaten") |
| Distribution-&-Signing-Runbook (Mobile) | N (Schritte); E (Keystore-Zugriff nur attended) | Andreas | Release | Probe vor Store-Terminen |

Verteilmechanismus ist das **private Claude-Code-Plugin** (neu 26.9; Marketplace-Repo: Hooks = Gates/A-Stufen, Skills = Modi/Runbooks, Agents = Rollen, Settings = Profile) — versioniert identisch über alle elf Projekte statt kopierter CLAUDE.md-Fragmente; Methodik-Änderungen mergt nur Andreas.

## 7. Informationsflüsse, Entscheidungs- und Freigabepunkte

Die **Wahrheitshierarchie** (CLAUDE.md Kap. 3) bleibt: Recht/Plattformregeln → aktuelle Eigentümerfreigabe → ADRs/Verträge → Projektverfassung → Methodik-Defaults → Repo/CI/Laufzeit als Ist-Wahrheit ohne normative Kraft. Konflikte werden geparkt, nicht willkürlich aufgelöst. **Flussprinzip:** Artefakte fließen vorwärts (SPEC → Plan → Diff+Manifest → PR → Release → Betriebssignale), Evidenz fließt rückwärts (Betriebs- und Review-Befunde → Learn → Verfassung/Evals/A-Stufen). Sessions sind zustandslos; Projektgedächtnis liegt ausschließlich in versionierten Artefakten; `project-state.yaml` ist das maschinenlesbare Rückgrat — Agenten lesen Zustand, nicht Erinnerung. Gespeicherte Freigaben sind historische Nachweise, keine fortgeltende Autorität. Die Portfolio-Ebene liest aggregiert: **Portfolio Control Plane** (neu 25.11, Pilot ab Welle 3) als Read-Model aus `project-state.yaml` aller Repos + Run-Manifesten + CI-Status — dort werden WIP-Limit, Fehlerbudgets und Learn-Rückstände portfolio-weit sichtbar.

**Freigabepunkte (abschließend, nur der Mensch):**

| Checkpoint | Kanal | Enforcement |
|---|---|---|
| Spec-Freigabe nicht-trivialer Items; in LIGHT mit Plan-Freigabe zu **einer Issue-Freigabe** kollabiert | Terminal/Issue | N + Vorlage |
| Plan/Modus/Budget/A-Stufen je Lauf (SPRINT nur explizit, Charter, ein Start-SHA) | Terminal oder Remote Control | Permission-Prompts, Hooks |
| A4 Ready/Merge | PR-Review; mobil nur nach Positivliste | Branch-Protection, W4 |
| A5 Deploy/Release/Store | Zwei-Schritt; Ausführung deterministisch (Pipeline, `workflow_dispatch`, WIF) | CI-Gates; capability-scoped je Lauf |
| Design-/Experience-Gate | gerenderte Oberfläche (15.5) | Screenshot-Baseline-Sperre |
| Ops-Freigaben (Runbooks, Stufenwechsel 0–3) | attended, Bewährungsfristen | Skill-Definition, Audit |
| A-Auf-/Abstieg, E/N/I-Promotion, Plugin-Release | monatliches Learn-Review | ADR-Pflicht mit Evidenzverweis |

**Remote Control ist attended-Kanal** (keine Scheduler-Ebene) mit mobiler Asymmetrie als E-Regel: freigeben, reviewen, stoppen, Fragen beantworten — ja; nichts Destruktives, kein A4/A5-Ersturteil bei komplexen Diffs, keine Konfigurationsänderung — nie (Mechanismus: `requiresUserInteraction`-Tools verweigern One-Tap; keine A5-Skills mobil auslösbar). GitHub-Environment-Gates entfallen für private Repos (erst ab Enterprise); das mobile Freigabe-Gate ersetzt sie. Agenten empfehlen mit Begründung (Risikoklasse, Reversibilität, Verträge, Prüfbelege); Interpretationsfragen gehen an den Lead, nie in stille Annahmen.

## 8. Parallelisierung und Verifikation

1. **WIP-Limit beziffert (In-place 10.8):** höchstens **2–3 offene, ungeprüfte Agenten-PRs** portfolio-weit (Zahl OE-6). Evidenzanker A1–A8: 46,4 % Ablehnungsquote agentischer Bug-Fix-PRs überwiegend aus Prozessgründen, −23 pp Merge-Rate ohne menschlichen Review, Rework-Faktor 2,6, „almost right, but not quite" als Hauptfriktion. Bei Stau wird Generierung gedrosselt, nie Prüftiefe. **Ehrliche Verbindlichkeit:** gemessene N-Regel (Zählung via `project-state.yaml`/Control Plane) mit benannter Promotion-Option — PreToolUse-Hook, der `gh pr create` ab erreichtem Limit verweigert (OE-6). 3–5 aktive Worker sind Startwert unter Kosten-/Koordinationsbudget, kein Ziel.
2. **Neu 10.9 — Slice-Regel:** Der Vertical Slice ist die Einheit von Parallelität *und* Review: ein Worker = ein Slice = ein PR, in einer konzentrierten Sitzung vollständig lesbar. Slices definieren Ownership natürlich; Shared Contracts/Schema/Lockfiles haben genau einen Owner (Lead); Integration seriell.
3. **Zweitmeinungs-Gate (In-place 10.8), gestaffelt:** LIGHT — Mensch liest den Diff (Reviews bündelbar); STANDARD — frischer Verifier-Subagent (nur Diff + Rubrik) **Pflicht ab Risikoklasse R2**; HIGH-RISK — zusätzlich Zweitmodell und getrennte Test-/Code-Autoren. Menschliche Freigabe ist durch KI-Review nie ersetzbar; der Requestor approvt nie.
4. **Gate-Hierarchie (In-place 18.5–18.7 + neu 18.11), in dieser Reihenfolge:** **Q1 Statik** (Ruff+pyright strict, Security-Checks auf die schwachen Klassen XSS/Log-Injection; lokal als Hook, entscheidend in CI) → **Q2 Tests** (Units/Contracts/Integration, Property-based/Hypothesis, Schemathesis; Red-Beweis ab A3; hermetisch) → **Q3 Fitness Functions** (import-linter/dependency-cruiser als Gate gegen Erosion: Duplikation +81 %, GitClear) → **Q4 Held-out-Abnahmesuite (neu 18.11):** 5–20 Spezifikationstests je Projekt, **agentenunsichtbar, nur in CI** (SpecBench: sichtbare Tests werden gesättigt, verdeckte divergieren bis 97 %/0 %; ~27 pp Divergenz pro Verzehnfachung). **Differenzierte Ablage (OE-5):** separates privates CI-only-Repo für die zwei Autonomie-Projekte (boxscore, new_nfl); Deny-Verzeichnis für den Rest — mit ausgewiesener Schwäche: `permissions.deny` ist stringbasiert und nur in der Sandbox hart. Divergenz sichtbar↔held-out ist ein Alarmsignal, kein Reparaturauftrag an den Agenten → **menschliche Freigabe** als letztes Gate.

**Audits (getaktet statt je Lauf):** Mutation Testing quartalsweise auf Kernmodulen; ACH-Muster (Kritiker injiziert Bugs, Suite muss fangen) als Pilot; **Continuous-Cleanup-Lauf wöchentlich** mit Löschzwang für Parallel-Varianten (In-place 18.10). Zwei E-Regeln: **„Testreparatur ist Codeänderung"** (gleicher Review-Pfad; Hook stellt Testdatei-Mutation ohne Spec-Referenz auf Ask; Grader-Loop-Cap) und **Flaky-Quarantäne** (18.6: Marker, Ticket, Frist, Ursachenklassifikation — kein Retry-bis-grün).

## 9. Experimentierkreislauf

**Neu 8.6.** Jedes größere Experiment beginnt mit einer **Spike-Karte** (28.11): Hypothese, messbares Erfolgskriterium, Zeit-/Token-Box, vorab fixierte Entscheidungsregel (übernehmen/verwerfen/weiterer Spike). **De-minimis-Schwelle:** Pflicht erst ab Token-Box > 0,1 Mio. Tokens — kleine Exploration bleibt papierfrei (Befolgbarkeit im Portfolio mit viel Exploration). Ausführung isoliert im Worktree; der Agent kann gegen das Kriterium selbst verifizieren, das macht Spikes autonomietauglich. Ergebnis in das kumulative **Experiment-Log**; Spike-Code wird nie direkt gemergt — Übernahme nur über den Standardzyklus mit Spezifikation und Tests (gegen Prototyp-Drift); Spike-Branches tragen TTL, Verlierer-Varianten unterliegen dem Löschzwang (CI meldet Überfällige). Best-of-N (2–3 Kandidaten, Opus-Klasse) nur mit hartem Verifier und Fanout-Kriterium (Wert ≥ 10–15× Tokenkosten). Methodik-Experimente laufen als Agenten-Eval nach 27.7 (mit/ohne Änderung, frische Sessions, Passrate/Kosten). Produkt-Experimente enden immer im menschlichen Urteil — Metriken informieren, entscheiden nicht (P8).

## 10. Traceability und Evidence Chain

**Trace-Anker:** REQ-ID (EARS) → Test-ID → Run-Manifest → Commit-Trailer → PR → Release → Betriebssignal. Traceability entsteht aus Namensdisziplin, nicht aus Werkzeugketten (keine RDF/Triple-Stores). Drei Stufen, right-sized:

1. **Überall (E):** Commit-Trailer (Agent, Modell, Run-ID; Assisted-by-Konvention nach Zielprojekt-Policy) und PR-Evidenzblock nach dem Evidence-Bundle-Schnitt der Portfolio-Analyse: Ziel/Spec-Referenz, betroffene Anforderungen/ADRs, geänderte Pfade/Contracts, Gate-Ergebnisse, Risiken, Kosten, Rollback, Doku-Update, offene Owner-Entscheidung. Mechanismus: commit-msg-Hook, PR-Template, CI-Check auf Pflichtblock.
2. **Bei deterministischen Auto-Deploy-Pfaden (E):** Run-Manifest + **GitHub Artifact Attestation** (auch private Repos; SLSA-v1.2-Muster) — das deployte Artefakt ist kryptografisch an Build und Manifest gebunden. Gilt heute nur für den Boxscore-Content-Refresh nach OE-2-Mechanik; die Deploy-Ausführung ist immer Pipeline, nie agentisch.
3. **Bei Bedarf (I):** OTel-GenAI-Traces sammeln, nicht neu erfinden; Feldnamen nicht einfrieren (Status Development).

**Run-Manifest-Pflichtfelder (In-place 21.6; JSON-Schema im Plugin, gekoppelt an `claude -p --bare --json-schema`):** Run-ID, Modus, Profil, A-Stufe, Task-Klasse, Umgebung (E1–E5), Modell(e), Spec-/Plan-Referenz, Start-/End-SHA, berührte Pfade/Contracts, Gate-Ergebnisse mit Red-Beweis, Evidenz-Verweise, **Trifecta-Deklaration** (welche der drei Kanten offen waren), **Kosten-Soll/Ist** (`total_cost_usd` bzw. Fensteranteil), **Rework-Referenz**, **Abbruchgrund** (leer nur bei Normalende), `spec_reconciled`. Run-Manifest und Provenance-Kern der Datenplattformen teilen ein Schema (PROV-angelehnt: source/fetch/raw_artifact/transform_run/claim) — ein Agentenlauf ist eine Activity wie jede Transformation, mit Modell-ID und Prompt-Hash.

## 11. Betriebs-Layer

Zielsystem ist der dokumentierte **HP EliteDesk 800 G6** (i5-10500T 6C/12T, 32 GB, 2×512 GB NVMe, Windows 11 Pro, WSL2-fähig; **kein ECC, kein RAID → Backup-Disziplin ist die Redundanz**; D: als Daten-/Backup-Laufwerk). Betriebsbedingungen vor dem Ops-Piloten: LAN statt WLAN, Energie-/Autostart-Profil, SMART-Prüfung. Verhältnis zum bestehenden Windows-VPS → OE-3.

**Neu 25.8 — SRE light.** (a) Je Live-System ein einfaches SLO (Erreichbarkeit + Kernfunktion) und ein **Fehlerbudget als Autonomie-Drossel** (Kopplung an 5.6; Startwerte OE-7): Budget gerissen → betroffene Task-Klassen eine A-Stufe runter, Auto-Pfade pausieren, Kapazität in Stabilisierung. (b) **Observability-Minimum:** strukturierte JSON-Logs nach Schema, Healthchecks mit Dead-Man's-Switch plus Außensicht (Uptime Kuma), Versions-/Statusendpunkt; Claude ist Diagnose-*Konsument* (read-only), nie Monitoring-Ersatz; kein OTel-Vollstack. (c) Progressive Rollouts/Feature-Flags nur, wo ein zweiter Nutzer existiert.

**Neu 25.9 — Ops-Agent-Stufenplan 0–3** (je Stufe vier Wochen Bewährung): **Stufe 0** unattended W2, jetzt: `svc-claude`-Servicekonto ohne Adminrechte, `agent_ro`-DB-Rolle, täglicher Health-/Log-/DB-Report headless (`claude -p --bare --json-schema`, Windows Scheduled Task, API-Key), Benachrichtigung nur bei Befund, Kill-File + Audit-Hook ab Tag 1, Egress-Firewall je Dienstkonto praktisch validiert. **Stufe 1** attended: Admin-Sessions mit Runbook-Skills (Dienst-Neustart, Log-Triage, pg_dump-Verify); **Fernzugriff: Windows-OpenSSH + Tailscale-ACLs — Tailscale SSH fällt als Windows-Ziel aus**; Audit serverseitig. **Stufe 2** selektiv unattended: genau **ein** reversibles Runbook (Runbook-Ausnahme W3: Skill mit `disable-model-invocation`, Rate-Limit, Rollback-Pfad). **Stufe 3** beobachten: Ops-Routines, Windows-Admin-MCPs — quartalsweise neu bewerten, keine Bindung. Alert-Muster: Alert → unattended Diagnose (read-only) + Maßnahmenvorschlag → Mensch gibt frei → Runbook führt aus.

**DB-Zugriffsnormen (E, Teil von 25.9):** Postgres nur über restricted-MCP + `agent_ro`; DuckDB-MCP read-only als Analysefront; SQLite per CLI-Allowlist (`sqlite3 -readonly`); Directus über nativen MCP nur mit dediziertem User und **sofort aktivierter Delete-Protection** (default-off!). Rechte werden im Zielsystem erzwungen, nie im Prompt.

**Backup als Autonomie-Gate (In-place 25.5, E):** restic/Litestream-Triade, append-only-Ziele, Agentenkonto ohne Schreibrecht auf Backup-Pfade (NTFS), automatisierte Restore-Proben mit Dead-Man's-Switch. Regel: **ohne aktuelle Restore-Probe (<30 Tage) keine A5-Freigabe** auf Daten-/Infrastrukturfähigkeiten (ATLAS T0101: Datenzerstörung via Agententool).

**Neu 25.10 — Notausschalter-Katalog** (jeder Schalter mit dokumentiertem Test-Datum; die tragenden in der halbjährlichen Gate-Probe): Kill-File (Hook-geprüft je Tool-Use) · Deaktivierung Scheduled Tasks/Routines · PAT-Revoke/Key-Rotation der Bot-Identität · Workspace-Spend-Limit auf 0 · Tailscale-ACL-Sperre des Agentenkontos · Egress-Sperre per Firewall-Regel · Sandbox-`failIfUnavailable` (ohne Sandbox startet kein unattended Write) · physisches Netz-Trennen als letzte Stufe. Mobile Asymmetrie gilt auch hier: stoppen immer, destruktiv nie.

## 12. Scheduler- und Kosten-Layer

**Neu 11.8 — Scheduler-Zuordnungsregel.** Jede wiederkehrende Aufgabe gehört genau einer Ebene; Neuzuordnung ist ein Learn-Beschluss:

| Ebene | Umgebung/W | Permission-Profil | Kontext/Kosten | Zulässige Aufgabentypen |
|---|---|---|---|---|
| `/loop` (Session-Cron, 7-Tage-Expiry) | wie Session, W1 | erbt Session-Permissions | Session-Kontext läuft weiter | Deploy-/PR-Babysitting, Nachhalten im selben Vorgang, solange attended erreichbar |
| Desktop Scheduled Task (lokal) | W1/W2 | per-Task-Permission-Mode | voller Kontext je Feuerung → **Kontextdiät + Haiku/Sonnet Pflicht**; Abo-Fenster | lokale Checks, Reports, Repo-Hygiene, Cleanup-Lauf (Pilot) |
| Cloud-Routine (E4) | promptlos, strukturell A3-Deckel | keine Prompts — nur unter Bedingungsliste 23.12; Konnektorenliste vor Anlage leeren | Plan-Kontingent, still | nächtliche Repo-Pflege, Doku-Drift, PR-Vorreview — nur private Repos, kein GitHub-Konnektor |
| Windows Scheduled Task + Headless (E1, Server) | W2 | Kompensationspaket K+P+H+E+C, lesende Allowlist `dontAsk` | **API-Key** mit Spend-Limit; exakte Kosten via `total_cost_usd` | Ops-Stufe 0, SDK-/Batch-Jobs; später genau ein Runbook (Stufe 2) |

Merkregeln: Was Schreibwirkung braucht, gehört nicht in promptlose Ebenen (W3/W4). Was täglich feuert, braucht Kontextdiät, sonst frisst es still das Wochenfenster. Remote Control ist keine Scheduler-Ebene, sondern der mobile attended-Kanal.

**Kosten-Layer (In-place 22.7; Manifest-Felder 21.6):**

- **Abo-/API-Split:** Max 5x (100 USD/Monat) als Fundament; Usage Credits mit Monats-Cap 20–40 USD als Überlauf; separater Console-API-Key mit Workspace-Spend-Limit (Start 25 USD/Monat) für CI, SDK und alles Unattended; **Batch-API (−50 %) für Massenläufe**; Max 20x erst nach zwei Monaten dokumentierter Wochenfenster-Erschöpfung laut `/usage` (OE-8). Sonnet-5-Promo endet 31.08.2026: +50 % einplanen.
- **Tokenfaktor-Heuristik:** Chat 1× → Einzelagent ≈4× → Agent Teams ≈7× → Multi-Agent-Fanout ≈15×; Modell-Upgrade schlägt Token-Verdopplung. **Fanout-Kriterium:** nur wenn Aufgabenwert ≥ 10–15× Tokenkosten *und* ein Verifier existiert.
- **Caps auf drei Ebenen:** Werkzeug (`--max-turns`, Workflow-Größe, `/effort`) und Konto (Spend-Limits, Credits-Cap) sind E; die Prompt-/Prozess-Ebene (Stagnationsregel, Abbruch mit Zwischenergebnis-Pflicht) ist ehrlich N.
- **Resume-Pflicht (N, Promotion-Kandidat):** Jeder Mehragentenlauf schreibt ein Artefakt je Agent sofort auf Disk und ist resumierbar — der versenkte 0,6-Mio.-Token-Erstlauf des Sweeps war ein Prozess-, kein Preisproblem. Faustregel: ein schwerer Workflow je 5h-Fenster (Max 5x: zwei bis drei).
- **Monatliches Kosten-Review** (5 Minuten, im Learn-Review): `/usage`, Console-Usage, Actions-Minuten; Budget-Soll vor dem Lauf, Ist danach — beides Manifest-Pflichtfelder.

## 13. Archetyp-Profile

**Neu 4.5 — Zeremonie-Profile mit LIGHT-Default.** Der Artefakt- und Gate-Umfang skaliert über drei Profile, **je Vorhaben/Slice, nicht je Projekt auf ewig**, und orthogonal zu den Modi. **Default-Regel (Beweislastumkehr):** LIGHT für alles Reversible; Artefakt-Budget LIGHT ≤ 1 Seite gesamt; STANDARD nur mit Risikobegründung. Das Profil folgt Task- und Risikoklasse — auch ein HIGH-RISK-Projekt erledigt einen Tippfehler im LIGHT-Profil.

| Parameter | LIGHT | STANDARD | HIGH-RISK |
|---|---|---|---|
| Spec | Issue-Absatz, 3–5 EARS-Kriterien | SPEC-Artefakt + Annahmenregister | + Migrations-/Rollback-Plan, Zweitmeinung auf Spec |
| Freigaben | **eine Issue-Freigabe** (Spec+Plan kollabiert) | getrennte Spec-/Plan-Freigabe | + expliziter Risk Envelope |
| Maschinen-Gates | Statik + targeted Tests, Ein-Kommando-Verify | volle Hierarchie inkl. Fitness Functions (+Held-out, wo Suite existiert) | alle Gates Pflicht + Security-Fokusgates, Restore-Probe aktuell |
| Review | Mensch liest Diff (bündelbar) | Verifier-Subagent ab R2 + Mensch | + Zweitmodell, getrennte Test-/Code-Autoren |
| Run-Manifest | Kurzform (auto aus Headless-JSON) | voll | voll + Attestation |
| Reconciliation | Sammelabgleich je Tranche, Checkbox | nach jedem Merge | nach jedem Merge, menschlich gegengelesen |

**Default-Zuordnung der fünf Archetypen (je Projekt bestätigen, OE-9):**

- **A — Interaktive Privatprodukte** (capsule, joes-journal, tischatlas): STANDARD; UI-Polish/Inhalte LIGHT; HIGH-RISK-Zonen Auth, PII, Deploy; A2–A3, A4 attended; Design-Gate 15.5 bleibt menschliches Geschmacksurteil.
- **B — Daten-/Wissensplattformen** (boxscore, new_nfl, curio): STANDARD; dataset.yaml, Provenance-Kern, Held-out-Suite prioritär (höchste Autonomie, größtes Selbstbestätigungsrisiko); TK1-lastig → evidenzbasierter A3-Regelbetrieb in W3-Umgebungen; **Content-Refresh-Promotion als deterministische CI-Pipeline ohne LLM im Promotionspfad (einmalig freigegeben, W4 unberührt); Code-Merges immer attended — OE-2.** Berichte/Notebooks LIGHT; Schema-Migrationen und Löschoperationen HIGH-RISK.
- **C — Sensorik/Edge** (wlan → funkatlas): LIGHT für Explorations-/Hardware-Slices (attended am Gerät), STANDARD ab Produktisierung; unattended nur Simulation/Auswertung (W2); Langzeitmessung über den Betriebs-Layer.
- **D — Infrastruktur-Transformation** (server-migration): durchgängig HIGH-RISK; W1/W2 only; jede Mutation als Runbook; Inventar vor Aktion; Least Privilege; niemals SPRINT.
- **E — Mobile Companion** (capsule-app): STANDARD schlank; Signing/Keystore/Distribution HIGH-RISK (Keystore-Verlust ist identitätszerstörend); Signing-Runbook im Kanon; **Limited Distribution Account im August 2026 registrieren**; Art.-50-Transparenzzeile als billiges Default-Feature; API-Contract-Tests.

## 14. Delta zu v4.0

**Redaktionsentscheid Inkraftsetzung:** Das Paket tritt als **Methodik v4.1** in Kraft (Changelog in Kapitel 2, Regel-Lebenszyklus 26.5); ein v5-Neuschnitt entlang des Lifecycle-Denkmodells wird frühestens nach zwei Quartalen Betriebserfahrung aus diesem Referenzmodell geschnitten. Damit entfällt die Doppeldokumenten-Phase der Entwürfe B/C und die frühere Schwebe-Entscheidung E10.

**Delta-Liste (N = neuer Unterabschnitt, S = In-place-Schärfung; jede Zeile mit Enforcement):**

| # | Baustein | Anker | Art | Enforcement |
|---|---|---|---|---|
| 1 | Zeremonie-Profile, LIGHT-Default, Archetyp-Zuordnung | 4.5 | N | Profilwahl im Plan; Plugin-Templates; STANDARD-Begründungspflicht (N) |
| 2 | Doppelkonditionierung als Zustandsmaschine; Fehlerbudget-Trigger; Rework-Zurechnung | 5.6 | N | Session-Start-Hook lädt Profil aus project-state.yaml; Budgetzähler |
| 3 | Rollenkern 5+2; Requestor-Verbot; Agentenidentität (Bot-Account, fine-grained PATs) | 5.1/10.4 | S | Agents mit Tool-Allowlists; Branch-Protection; getrennte Identitäten |
| 4 | Experimentierkreislauf; Spike-Karte ab 0,1-Mio-Token-Box; TTL/Löschzwang | 8.6 | N | CI meldet überfällige Spike-Branches; Learn-Review |
| 5 | Spec-Reconciliation nach Merge (LIGHT: je Tranche) | 9.7 | N | Manifest-Feld; Merge-Checkliste; CI bei HIGH-RISK |
| 6 | Learn-Schritt mit Stub-Automation | 9.8 | N | Scheduled Task erzeugt Monats-Stub; HANDBACK-Feld |
| 7 | EARS + REQ-IDs + Annahmenregister in der Spec | 9.6 | S | Spec-Vorlage 28.13; SPEC-Schema-Lint |
| 8 | WIP-Limit 2–3 (N, Hook-Promotion OE-6); Zweitmeinung ab R2 | 10.8 | S | PR-Zählung im State; optional PreToolUse-Hook |
| 9 | Slice-Regel | 10.9 | N | Ownership-Schnitt im Plan |
| 10 | Scheduler-Zuordnungsregel (4 Ebenen + Merkregeln) | 11.8 | N | Permission-Profile je Ebene; API-Key-Split |
| 11 | Held-out-Abnahmesuite, differenzierte Ablage | 18.11 | N | CI-only; separates Repo (OE-5) bzw. Deny+Sandbox |
| 12 | Gate-Hierarchie inkl. Fitness Functions; Testreparatur-Regel (E); Flaky-Quarantäne (E); Mutation-/ACH-Audits; **Continuous-Cleanup wöchentlich** | 18.5–18.7, 18.10 | S | CI-Reihenfolge; Hooks; Audit-Takt |
| 13 | Statusquellen-Hierarchie + Benchmark-Regel B1–B5 | 20.7 | N | Recherche-Skill-Vorgabe |
| 14 | Run-Manifest-Pflichtfelder (inkl. Umgebung, Trifecta, Kosten, Rework-Referenz, Abbruchgrund, spec_reconciled) | 21.6 | S | JSON-Schema-Validierung |
| 15 | Kosten-Layer inkl. **Batch-API −50 %**, Caps, Resume (N), Monatsreview | 22.7 | S | Spend-Limits; `--max-turns`; Schema |
| 16 | W-Matrix W1–W4 + **E1–E5-Legende** | 22.10 | N | Sandbox-Profil; Kontenmodell; Firewall |
| 17 | MCP-Zielrevision **2025-11-25** (CLAUDE.md-Steckbrief nennt fälschlich 2026-07-28 — korrigieren); 2026-ready-Regeln (Handles statt Sessions; keine Roots/Sampling/Logging/DCR); Umstellungstrigger statt Datum; **M1-Korrektur** („read-only mit Credentials ist M1, nicht M2") | 23.3 | S | Registry-Prüfpunkt; Designregel-Checkliste |
| 18 | Matrizen A/B + Routines-Bedingungsliste (vollständig auch im Normtext 22.10) | 23.12 | N | Routine-Anlage-Checkliste; Konnektoren leer |
| 19 | Commit-Trailer + PR-Evidenzblock (inkl. Kosten-/Doku-Feld) | 24.2 | S | commit-msg-Hook; PR-Template; CI-Check |
| 20 | Backup append-only + Restore-Probe <30 Tage als A5-Gate | 25.5 | S | Kontotrennung; Dead-Man's-Switch; Probe-Timestamp im State |
| 21 | SRE light; Fehlerbudget als Drossel | 25.8 | N | Budget-Zähler; Hook-Auswertung |
| 22 | Ops-Stufenplan 0–3; DB-Normen; OpenSSH+Tailscale-ACLs | 25.9 | N | svc-Konto; agent_ro; MCP-restricted; Allowlists |
| 23 | Notausschalter-Katalog; mobile Asymmetrie | 25.10 | N | Kill-File-Hook; getestete Schalter |
| 24 | Portfolio Control Plane als Read-Model (Pilot) | 25.11 | N | generiert aus project-state.yaml + Manifesten + CI-Status |
| 25 | E/N/I-Taxonomie; Enforcement-Felder in 26.5; Gate-Probe; Schutzklausel | 26.8 | N | Felder `mechanismus`/`letzte_probe`; halbjährliche Probe |
| 26 | Methodik als privates Claude-Code-Plugin | 26.9 | N | versioniertes Marketplace-Repo; nur Andreas mergt |
| 27 | pass^k, Golden Tasks, Kanarien, Eval-Betrieb | 27.7 | N | Eval-Suite in CI/nightly |
| 28 | Vorlagen: Spike-Karte, Manifest-Schema, SPEC, project-state.yaml, Lifecycle-Schaubild (I) | 28.11–28.15 | N | Plugin-Distribution |

**Behobene Gutachten-Befunde (Fehlerliste):** (a) S-A1: Die Klausel „Auto-Merge-Pfad bleibt legitim / nur mit Held-out-Suite + Attestation" ist gestrichen und durch die OE-2-Mechanik ersetzt — W4 gilt ausnahmslos; eine deterministische Pipeline ohne LLM im Promotionspfad ist keine Agenten-Autonomie und berührt W4 nicht. (b) Schein-E beseitigt: WIP-Limit, Resume-Pflicht und Stagnations-Heuristik sind ehrlich N mit benannten Promotion-Pfaden; nur die Cap-Anteile sind E. (c) Bezeichner entkollidiert: OE-* für Entscheidungen, E1–E5 mit Legende im Normtext. (d) Kanon vervollständigt: HANDBACK/STATUS und Distribution-&-Signing-Runbook als Kanonzeilen. (e) Batch-API −50 % und Continuous-Cleanup-Lauf ergänzt. (f) Rollen-Inkonsistenz aus C korrigiert: Implementer A1–A3 je Freigabe, A3 explizit mit Vorabfreigabe verdrahtet. (g) Rework-Zurechnungsregel definiert statt mechanismenloser Pflichtmetrik. (h) Tailscale-SSH-Lücke geschlossen (OpenSSH + ACLs). (i) E10-Schwebe durch Redaktionsentscheid ersetzt.

**Nicht übernommen (bewusst, synthese-konform):** Microservices/Kafka/Vault/Triple-Stores/IDPs, SaaS-Evals, Agenten-Flotten, lokale GPU-Inferenz als Primärpfad, KI-Review als Freigabeersatz, Tailscale SSH als Windows-Ziel, GitHub-Environment-Gates in privaten Repos, METR-Punktschätzer und absolute Benchmark-Scores als Entscheidungsgrundlage. Aus den Entwürfen nicht übernommen: eigenständiges Enforcement-Register-Dokument samt Quartalsritual (→ 26.5-Felder, halbjährliche Probe), Reviewer-Pflicht je PR (→ Staffelung ab R2), Spike-Karten-Pflicht für jedes Experiment (→ De-minimis-Schwelle), sofortiger v5-Neuschnitt mit Doppeldokumenten-Phase (→ verschoben), P/G/Q-Nomenklatur als Normsprache (→ nur didaktisch im I-Schaubild).

## 15. Einführungs-Reihenfolge

Drei Wellen, jede mit Erfolgskriterium; kein Big Bang. Verteilung über das Plugin, damit alle elf Projekte identisch erben.

- **Welle 1 — Regeln und Konfiguration (Woche 1–2):** W-Matrix 22.10/23.12 in Kraft setzen; MCP-Steckbrief korrigieren (2025-11-25, M1-Korrektur); Kostenrahmen einrichten (Credits-Cap, API-Key mit Spend-Limit); Run-Manifest-Schema mit Pflichtfeldern; Kill-File- und Audit-Hooks; Notausschalter einrichten und testen; WIP-Limit und Stagnationsregel aktiv; `server-migration`-Repo privat stellen (Portfolio-Sofortmaßnahme); WSL2-Sandbox Strict auf dem Laptop. *Erfolg:* Alle laufenden Projekte referenzieren die neuen Abschnitte; ein Testlauf produziert ein schema-valides Manifest; **erste Gate-Probe bestanden** — eine E-Regel blockiert nachweislich.
- **Welle 2 — Struktur (Monat 1):** Methodik-Plugin paketieren und in zwei Piloten aktivieren (ein Web-STANDARD, z. B. tischatlas; eine Datenplattform, z. B. boxscore); E/N/I-Inventur aller Bestandsregeln (Felder `mechanismus`/`letzte_probe`); Spec-Reconciliation und Learn-Schritt aktiv inkl. Stub-Scheduled-Task; Held-out-Suiten für boxscore und new_nfl (Ablage nach OE-5); Branch-Protection in allen aktiven Repos; Bot-Account mit fine-grained PATs; Ops-Stufe 0 auf dem Heimserver (svc-claude, agent_ro, Egress-Validierung); Zeremonie-Profile den elf Projekten zuordnen (OE-9). *Erfolg:* Fünf Merges vollständig durch die Pipeline; erster Monats-Learn-Review hat stattgefunden; Held-out-Suite hat mindestens eine Divergenz sichtbar gemacht oder grün bestätigt; Kennzahlen-Baseline erhoben.
- **Welle 3 — Evidenzbetrieb (Quartal):** Golden-Task-Suite auf 20–50 Aufgaben aus realen Fehlern, Kanarien nightly; pass^k-basierte Auf-/Abstiege beginnen; Backup-Triade mit bestandener Restore-Probe; Ops-Stufe 1–2 (erstes Runbook mit vier Wochen Bewährung); Routines-Pilot streng nach Bedingungsliste (falls OE-4 positiv); Mutation-/ACH-Audit auf 1–2 Kernmodulen; Portfolio Control Plane als Read-Model-Pilot. *Erfolg:* Mindestens ein evidenzbasierter A-Aufstieg **und** ein mechanischer Abstieg sind mit ADR und Evidenzverweis dokumentiert.

## 16. Offene Eigentümer-Entscheidungen

1. **OE-1 — M2-Lockerung:** Unattended Writes in WSL2 mit deklarierter Vorabfreigabe je Tool+Ziel zulassen — oder strikte M0/M1-Regel für alles Unattended behalten? *Empfehlung:* konservativ starten (M0/M1), Neubewertung nach dem ersten Quartal mit Eval-Evidenz; Kosten der Konservativität: weniger nächtliche Automatisierung.
2. **OE-2 — Boxscore-Promotion:** Vorentscheidung des Modells bestätigen — Content-Refresh als deterministische CI-Pipeline ohne LLM im Promotionspfad (einmalig freigegeben, W4 unberührt, Attestation Pflicht); Code-Merges immer attended (Remote Control macht das mobil billig).
3. **OE-3 — Serverrollen:** Aufgabenteilung Heimserver (EliteDesk) vs. bestehender Windows-VPS; welches System ist Ziel des Ops-Piloten Stufe 0; Verhältnis zum `server-migration`-Vorhaben.
4. **OE-4 — Routines-Pilot:** ja/nein; falls ja, erster Kandidat (nächtliche Repo-Pflege, Doku-Drift oder PR-Vorreview) — nur unter vollständiger Bedingungsliste 23.12, Konnektorenliste leer.
5. **OE-5 — Held-out-Ablage:** Empfehlung bestätigen — separates privates CI-only-Repo für die zwei Autonomie-Projekte (boxscore, new_nfl); Deny-Verzeichnis mit ausgewiesener String-Schwäche für den Rest.
6. **OE-6 — WIP-Limit:** Zahl festlegen (2 oder 3 offene ungeprüfte Agenten-PRs) und Härtegrad (gemessene N-Regel belassen oder Hook-Promotion: Blockade von `gh pr create` ab Limit).
7. **OE-7 — Autonomie- und Fehlerbudget-Startwerte:** Triggerliste (2 Defekt-Escapes ∨ 1 Gate-Umgehung ∨ 1 Trifecta-Verstoß), Degradierung zwei Wochen, Aufstieg ab ≥20 Golden Tasks mit pass^3 ≥ 85 % und stabiler Rework-Quote über vier Wochen — bestätigen oder anpassen.
8. **OE-8 — Kostenrahmen:** Max 5x + Credits-Cap 20–40 USD + API-Spend-Limit 25 USD bestätigen; Termin der Max-20x-Prüfung (frühestens nach zwei Monaten `/usage`-Evidenz).
9. **OE-9 — Profil-Defaultmatrix und LIGHT-Dauerbetrieb:** Archetyp-Zuordnung aus Abschnitt 13 je Projekt bestätigen; welche Projekte dürfen dauerhaft LIGHT laufen (Kandidat: funkatlas-Exploration) und was löst den Wechsel nach STANDARD aus (Vorschlag: erster realer Nutzerbetrieb).
10. **OE-10 — AGENTS.md-Umstellung:** CLAUDE.md jetzt zur dünnen Brücke via `@AGENTS.md` machen (reine Mechanik über elf Projekte, aber Churn) — oder erst mit v5.
11. **OE-11 — A3-Vorabfreigaben:** Welche Repos erhalten die exakte Vorabfreigabe für Push/Draft-PR aus W3-Umgebungen (E2/E3)?

---

## Anhang: Herkunftsvermerk je Hauptbaustein

| Hauptbaustein | Herkunft |
|---|---|
| Trägerformat: Delta-Paket v4.1, 28-Zeilen-Delta-Tabelle mit verifizierten v4.0-Ankern, Nummernstabilität 26.7, 3-Wellen-Einführung mit Erfolgskriterien | Entwurf A (Anker-Verifikation: J1) |
| Anti-Flickenteppich-Regel; P7-Streichregel; Scheduler-Merkregeln; Orthogonalität Profil/Modus; Spike-De-minimis-Schwelle; Zweitmeinung ab R2; MCP-Fundstellenkorrektur; „Nicht übernommen"-Liste | Entwurf A (J1-verteidigt) |
| Acht-Phasen-Schema mit Abbruchverhalten; Ein-Seiten-Gesamtdiagramm als I-Schaubild (28.15) | Entwurf B |
| LIGHT-Default + ≤1-Seite-Budget + Begründungspflicht für STANDARD; Freigaben-Kollaps in LIGHT; Sammel-Reconciliation je Tranche in LIGHT | Entwurf B |
| Vollständiger Artefaktkanon inkl. HANDBACK/STATUS und Distribution-&-Signing-Runbook; Kennzahlen-Baseline; M1-Terminologie-Korrektur; Portfolio Control Plane (25.11); Learn-Stub-Automation | Entwurf B |
| E/N/I-Systematik mit Gate-Probe; Schutzklausel der drei unmechanisierten Urteile; Zustandsmaschine mit Fehlerbudget-Triggern und „Stufe ist das Profil"; OE-2-Auflösung Boxscore/W4; Held-out-Differenzierung; vollständige Routines-Liste + Grün-Status-Warnung; Agentenidentität; `/loop`-Expiry; Spend-Limit-0-Schalter; server-migration-Sofortmaßnahme; ehrliche N-Deklaration schwacher Mechanismen | Entwurf C |
| Right-Sizing der Gate-Probe (halbjährlich, 5–10 tragende Regeln); Registerform als zwei 26.5-Felder; Konstruktion „A Träger, B Right-Sizing-, C Härtungs-Spender"; Vorabentscheid „v4.1 jetzt, v5 später" | Gutachten J1 |
| Konsolidierungsauflagen: S-A1-Streichung, Schein-E-Verbot, Bezeichner-Entkollision, Kanonlücken, Batch-API/Continuous-Cleanup, Rollen-Korrektur, Erstprobe als Einführungs-Exit | Gutachten J2 |
| Rework-Zurechnungsregel; E1–E5-Legende im Normtext; Gate-Proben-Kadenz (halbjährlicher Block + Erstprobe je neuer E-Regel) | Redaktion (Auflagen beider Gutachten) |
