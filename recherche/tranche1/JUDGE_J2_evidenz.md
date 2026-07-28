# Gutachten J2 — Evidenz, Vollständigkeit, Konsistenz

**Gutachter:** J2 (unabhängig) · **Stand:** 2026-07-28
**Prüfgegenstand:** `ENTWURF_A_evolution.md` (262 Z.), `ENTWURF_B_lifecycle.md` (249 Z.), `ENTWURF_C_enforcement.md` (252 Z.), alle in `/home/claude/recherche/tranche1/`
**Prüfmaßstab:** (1) Abdeckung aller elf Pflichtelemente aus Forschungsauftrag Abschnitt 14 plus Betriebs-/Scheduler-/Kosten-Layer; (2) Verarbeitung aller 12 Arbeitsaufträge der Synthese v2 (Abschnitt 7, einzeln geprüft); (3) Respekt der Konfliktentscheide K1–K4 (MCP-Zielrevision 2025-11-25, kein METR-Punktschätzer, Benchmark-Regel B1–B5, Windows-Matrix W1–W4, Routines-Bedingungsliste); (4) Enforcement-Benennung jeder E-Regel; (5) Widersprüche zur Evidenzlage oder zu v4.0-Invarianten ohne Ausweis. Referenzquellen: `00_SYNTHESE.md` v2, Forschungsauftrag §14, Portfolio-Analyse §15/§17.3/§18, `input/CLAUDE.md` v4.0. Zeilenangaben (Z.) beziehen sich auf die jeweilige Entwurfsdatei.

**Gesamturteil vorab:** Alle drei Entwürfe sind substanzstark, decken die elf Pflichtelemente formal vollständig ab und respektieren die vier Konfliktentscheide im Kern. Die Unterschiede liegen in der Konsistenz beim härtesten Praxisfall (Boxscore-Auto-Merge vs. W4), in der Ehrlichkeit der E-Regel-Deklarationen und in Detail-Vollständigkeit der Arbeitsauftrags-Verarbeitung. **Rangfolge: C vor B vor A.**

---

## 1. Entwurf A — Evolution (Delta auf v4.0)

### Stärken

- **Präziseste Rückführbarkeit in die Bestandsmethodik.** Die Delta-Tabelle §14 (Z. 211–239) listet 27 Bausteine mit v4.0-Kapitelanker, Art (neu/Schärfung) und Enforcement-Spalte — kein anderer Entwurf macht die Adoption so mechanisch prüfbar. Nummernstabilität nach Methodik 26.7 wird durchgehalten (Z. 4, 17).
- **MCP-Korrektur mit Fundstellen-Präzision:** Delta #17 (Z. 229) benennt nicht nur die Zielrevision 2025-11-25, sondern explizit die zu korrigierende Stelle („CLAUDE.md-Steckbrief — dort steht noch 2026-07-28"). Verifiziert: `input/CLAUDE.md` §2 nennt tatsächlich `2026-07-28`. K1-konform.
- **Anti-Flickenteppich-Regel** (Z. 24): je Querschnittsthema genau eine normative Heimat (W-Matrix → 22.10, Kosten → 22.7/21.6, Scheduler → 11.8, E/N/I → 26.8, Betrieb → 25.8–25.10, Archetypen → 4.5), andere Kapitel verweisen nur. Das ist eine strukturelle Antwort auf die Dokumentationsdrift-Schwäche (Portfolio §17.1), die B und C so nicht haben.
- **Orthogonalität Zeremonie-Profil vs. Arbeitsmodus explizit** (Z. 21, 187): „das Profil bestimmt *wie viel* Zeremonie, der Modus *wie gearbeitet* wird; auch ein HIGH-RISK-Projekt erledigt einen Tippfehler im LIGHT-Profil". Sauberste Abgrenzung zum bestehenden Modi-System (v4.0 Kap. 5), die eine v4.0-Kollision (STANDARD als Modus-Default vs. LIGHT als Profil-Default) vermeidet.
- **Scheduler-Merkregeln** (Z. 175): „Was Schreibwirkung braucht, gehört nicht in promptlose Ebenen; was täglich feuert, braucht Kontextdiät; Remote Control ist keine Scheduler-Ebene." Didaktisch die beste Verdichtung von Arbeitsauftrag 4.
- **Evidenztreue der Zahlen:** 23–93 pp Selbstkorrektur-Asymmetrie (Z. 64), 97 %/0 % SpecBench-Extremfall (Z. 125), +8 pp Annahmenregister (Z. 103), Anthropic-Telemetrie ≈70/80 (Z. 52), Duplikation +81 % (Z. 125), Issue #46740 (Z. 70) — alle stimmen mit Synthese/Addenda überein; Dossier-Verweise inline (D01/D02, D03, D07, D16).
- **Konkrete Schwellen, wo die Synthese keine nennt:** Spike-Karten-Pflicht ab Token-Box > 0,1 Mio. Tokens (Z. 131), Fehlerbudget-Startwert 2 Vorfälle/Monat (Z. 76), Rework-Faktor > 2 über drei Tranchen wirkt wie ein Vorfall (Z. 76).

### Schwächen

- **S-A1 (gravierend, Konsistenz): Boxscore-Auto-Merge widerspricht W4 — unausgewiesen.** Z. 37 erklärt „A4/A5 bleiben attended (W4)" und Z. 70 stuft die W-Matrix als E-Stufe ein („nie unattended, in keiner Umgebung"). Gleichzeitig: Z. 205 „Der Boxscore-Auto-Merge-/Auto-Deploy-Pfad bleibt legitim, wird aber an die drei OpenAI-Voraussetzungen … gebunden" und Z. 200 „Auto-Merge-Pfad nur mit Held-out-Suite + Attestation" für Archetyp B. Ein agentischer Auto-Merge (Portfolio §15.2: „Agent merged und deployt bei Grün") ist A4 unattended — von W4 kategorisch ausgeschlossen. A löst das weder auf (deterministische Pipeline ohne LLM? attended One-Tap? Risikoakzeptanz-Ausnahme?) noch weist A den Konflikt aus; E9 (Z. 261) fragt nur nach den drei OpenAI-Eintrittsbedingungen, nicht nach dem W4-Konflikt. B (E2) und C (OE-2) benennen exakt diesen Konflikt als Eigentümerentscheidung. **Das ist der einzige echte Verstoß gegen einen Konfliktentscheid ohne Ausweis im gesamten Prüffeld.**
- **S-A2 (Enforcement-Ehrlichkeit):** „Resume-Pflicht (E)" (Z. 182) und die Prompt/Prozess-Ebene der „Caps auf drei Ebenen (E)" (Z. 181, Stagnationsregel) tragen keinen deterministischen Mechanismus — nach A's eigener Regel P2 (Z. 18: „benennt ihren Enforcement-Mechanismus oder gilt als N") müssten sie N sein. Kein Prüfmechanismus für Enforcement selbst (C hat dafür die Gate-Probe).
- **S-A3 (Vollständigkeitslücken gegen Synthese):** (a) Batch-API −50 % fehlt im Kosten-Layer (Z. 179–183; nur „Batch-SDK-Jobs" als Aufgabentyp Z. 173) — A19/AA5 nennen sie ausdrücklich. (b) Continuous-Cleanup-Lauf (Synthese 4.3.7, AA8) fehlt als Baustein; „Cleanup-Läufe" erscheinen nur als OpenAI-Eintrittsbedingung (Z. 205). (c) Agentenidentität (Bot-Account, fine-grained PATs; AA10, Synthese 4.3.11) nur implizit („PAT-/Key-Rotation", Z. 162); B und C benennen den Bot-Account explizit. (d) Artefaktkanon §6 ohne STATUS/HANDBACK-Zeile und ohne Distribution-&-Signing-Runbook (AA7 fordert beide im Kanon mit Eigentümer/Pflege-Trigger/Drift-Schutz; Signing-Runbook nur als Archetyp-Pflicht Z. 203). (e) Portfolio Control Plane (Portfolio §18.6) fehlt vollständig. (f) Art.-50-Transparenzzeile (Synthese Befund 18) fehlt.
- **S-A4 (Bezeichner-Kollision):** „E1" ist doppelt belegt — Umgebung E1 Server (Z. 173) und Eigentümerentscheidung E1 M2-Lockerung (Z. 253); dieselbe Kollision E/N/I-Stufe „E" vs. Umgebungs-IDs E1–E5 vs. Entscheidungen E1–E10. C vermeidet das mit OE-Präfix.
- **S-A5 (dünnere Stellen):** Informationsflüsse (§7) sind im Kern eine Freigabepunkte-Tabelle; ein explizites Flussmodell (vorwärts Artefakte / rückwärts Evidenz wie B §7) fehlt. Die Routines-Bedingungsliste wird an den Anhang 23.12 delegiert und nur zu drei Punkten wiedergegeben (Z. 172) — zulässig, aber schwächer nachprüfbar als C §5.2.

---

## 2. Entwurf B — Lifecycle-first

### Stärken

- **Vollständigste Behandlung der elf Pflichtelemente.** Jede der acht Phasen (§3.2, Z. 50–64) ist einheitlich mit Eingaben, Artefakten, Rollen, Autonomie/W-Zelle, Gates **und Abbruchverhalten** ausgestattet — die Pflichtelemente „Informationsflüsse", „Entscheidungsprozesse" und „Abbruchmechanismen" sind hier am dichtesten operationalisiert (zusätzlich Abbruch-/Eskalationskatalog mit 8 Mechanismen, Z. 101, und explizite Entscheidungsprozess-Regel, Z. 140). Einziges Gesamtdiagramm (Z. 28–44).
- **Vollständigster Artefaktkanon (AA7):** §6 (Z. 107–122) ist der einzige Kanon, der HANDBACK/STATUS (Z. 120) **und** das Distribution-&-Signing-Runbook (Z. 121) als Kanonzeilen mit Eigentümer/Pflege-Trigger/Drift-Schutz führt; `project-state.yaml` als E mit CI-Konsistenzcheck und README-Generierung (Z. 115) setzt Portfolio §17.1/§18.5 exakt um.
- **Einziger Entwurf mit Portfolio Control Plane** (Z. 127: aggregiertes Read-Model aus project-state.yaml + Run-Manifesten + CI-Status; Welle 3, Z. 234) — deckt Portfolio §18.6, das A und C auslassen.
- **Einziger Entwurf mit der M1-Terminologie-Korrektur** aus K4 („read-only mit Credentials ist M1, nicht M2", §14 Z. 223) — ein kleines, aber echtes Vollständigkeitsplus bei den Konfliktentscheiden.
- **Anti-Overhead-Regel am schärfsten operationalisiert** (Portfolio §17.3): „LIGHT ist der Default für alles Reversible; Artefakt-Budget LIGHT ≤ 1 Seite gesamt; wer STANDARD wählt, begründet es mit Risiko, nicht mit Gewohnheit" (Z. 197); LIGHT-Kurzform für jedes Pflichtartefakt (Prinzip 1, Z. 17). Profiltabelle mit 7 Parametern (Z. 199–207) ist die operationalste Profildefinition.
- **Boxscore/W4-Konflikt ausgewiesen:** E2 (Z. 239) stellt die A4-Politik als explizite Eigentümerentscheidung (W4 durchsetzen vs. dokumentierte Risikoakzeptanz-Ausnahme). Konsistenz gewahrt: G3 „Merge (A4) immer attended" (Z. 135) wird nirgends im Dokument unterlaufen.
- **Kennzahlen-Review vollständig** (AA12): P8 (Z. 64) nennt Rework-Quote, Defekt-Escape, Durchlaufzeit, Duplikations-/Churn-Signale, Eval-Trends, Kosten-Ist — die komplette Baseline-Liste des Arbeitsauftrags 12; B5-Regel als operative Klausel „Öffentliche Benchmark-Scores sind nie Aufstiegsgrund" (Z. 95). Learn-Schritt mit eigenem Enforcement-Ansatz (Scheduled-Task-Stub + Dashboard-Verstoß, Z. 64). Quellenblock am Dokumentende (Z. 249).

### Schwächen

- **S-B1 (Enforcement-Ehrlichkeit):** Die WIP-Regel wird als „(E über Prozess + Dashboard)" deklariert (Z. 58) — „Prozess + Dashboard" ist Messung, kein deterministischer Mechanismus. Das verletzt B's eigenes Prinzip 2 (Z. 18: „E-Regeln haben einen benannten deterministischen Mechanismus"). C behandelt dieselbe Regel ehrlich als gemessene N-Regel mit Promotion-Option zum `gh pr create`-Hook (OE-6).
- **S-B2 (Betriebslücke):** Der D16-Befund „Tailscale SSH fällt als Windows-Ziel aus → Windows-OpenSSH + Tailscale-ACLs" fehlt im Betriebs-Layer §11 (nur „Tailscale-ACL-Sperre" als Notausschalter, Z. 179; kein Fernzugriffspfad für Ops-Stufe 1 benannt). A (Z. 158) und C (Z. 159) haben ihn.
- **S-B3 (Detail-Ungenauigkeit):** Z. 144 zitiert „46,4 % Ablehnungsquote agentischer PRs aus Prozessgründen" — die Synthese (Befund 2, K2) sagt „agentischer **Bug-Fix**-PRs überwiegend aus Prozessgründen". C zitiert korrekt (Z. 124). Kein inhaltlicher Schaden, aber ein Wortlaut-Slip in einem Ankerwert.
- **S-B4 (kleinere Lücken):** (a) Ops-Profilnamen `ops-readonly`/`ops-runbook` (AA9) nicht explizit benannt (substanziell abgedeckt in §4 Z. 77). (b) Routines-Bedingungsliste nur teilweise wiedergegeben („Kontrollflächen … vor Anlage leeren", M0/M1, private Repos, Z. 189); „kein GitHub-Konnektor" nur über den K4-Verweis abgedeckt. (c) Inhalt der „2026-ready"-Designregeln (Handles statt Sessions, keine Roots/Sampling/Logging/DCR) nicht ausgeführt (nur genannt, Z. 22, 223); C führt sie aus (Z. 224). (d) Dieselbe Bezeichner-Kollision wie A: „E4" = Umgebung Cloud (Z. 189) und „E4" = Eigentümerentscheidung Kostenrahmen (Z. 241).
- **S-B5 (Adoptionsaufwand):** Das v4.0-Mapping §14 ist thematisch, nicht anschlussfähig auf Unterabschnitts-Ebene wie A's Delta-Tabelle; als Neuschnitt-Vorlage für v5 deklariert (Z. 3) und insofern legitim, aber die Rückführung einzelner Regeln in die bestehende Kapitelstruktur muss nachgearbeitet werden.

---

## 3. Entwurf C — Enforcement-first

### Stärken

- **Beste Antwort auf die Kernfrage „jede E-Regel mit Mechanismus".** §2 definiert einen abschließenden Mechanismen-Katalog (Z. 15); das **Enforcement-Register** als eigenes Artefakt (E-Regel → Mechanismus → letzte Gate-Probe, Z. 21, 98) und die **quartalsweise Gate-Probe** („ein harmloser, absichtlich regelwidriger Versuch muss nachweislich blockiert werden; Enforcement, das nie geprüft wird, erodiert wie Prosa", Z. 21) schließen die Lücke, die A und B offenlassen: dass E-Deklarationen selbst ungetestet erodieren. Erster Einführungs-Exit ist konsequent „erste Gate-Probe bestanden — eine E-Regel blockiert nachweislich" (Z. 233).
- **Ehrlichste Schwächen-Ausweisung (Evidenzdisziplin):** Held-out-Ablage: „`permissions.deny` … ist stringbasiert und nur in der Sandbox hart; robust ist ein separates privates Repo" (Z. 131, OE-5 mit Empfehlung). WIP-Limit ehrlich als gemessene N-Regel mit Hook-Promotion-Option (Z. 124, OE-6). Selbstprüfung der eigenen Perspektive am Ende (Z. 252: „wo der Mechanismus schwach ist …, ist die Schwäche ausgewiesen statt kaschiert") — und das stimmt mit dem Dokumentinhalt überein.
- **Sauberste Lösung des Boxscore/W4-Konflikts (Portfolio §15.3):** OE-2 (Z. 241) benennt die Kollision wörtlich („kollidiert mit W4") und bietet zwei präzise Optionen mit Empfehlung: Content-Refresh als deterministische CI-Pipeline **ohne LLM im Promotionspfad** (womit W4 gar nicht berührt wird) für Daten, attended Merges für Code. Das ist die einzige Auflösung, die W4 unangetastet lässt und den etablierten Boxscore-Nutzen erhält.
- **Konfliktentscheide am präzisesten übernommen:** W1–W4 wörtlich inkl. M-Klassen-Zuordnung (W2: A0; M0/M1 — W3: A1–A3; M2) und aufgeschlüsseltem Kompensationspaket inkl. ENV-Scrub (Z. 79); vollständigste Routines-Bedingungsliste im Fließtext (M0/M1, Konnektorenliste leer bzw. serverseitig read-only, keine Secrets, Netz nie Full, nur private Repos, Output nur `claude/`-Branches, kein GitHub-Konnektor, Ergebnisprüfung, Identitäts-Akzeptanz — Z. 81); MCP-Delta mit ausgeführten „2026-ready"-Inhalten (Handles statt Sessions, keine Roots/Sampling/Logging/DCR, Z. 224); korrektes Zitat „agentischer Bug-Fix-PRs" (Z. 124); ~27 pp SpecBench-Divergenz pro Verzehnfachung (Z. 131) synthesekonform.
- **A-Stufen als Zustandsmaschine mit Asymmetrie-Prinzip** (Z. 22, 64–75): Abstieg mechanisch (Fehlerbudget-Zähler in `project-state.yaml`, vom Session-Start-Hook ausgewertet — die Stufe *ist* das geladene Settings-Profil, Z. 66), Aufstieg menschlich mit ADR + Evidenzverweis (Z. 73); konkrete Budget-Trigger (2 Defekt-Escapes ∨ 1 Gate-Umgehungsversuch ∨ 1 Trifecta-Verstoß, Z. 75). Das ist die am weitesten durchmechanisierte Fassung von Arbeitsauftrag 3.
- **Gegengewichte gegen Über-Mechanisierung explizit:** Prinzip 5 (Z. 25) nimmt Produkturteil, Designfreigabe und Risikoakzeptanz dauerhaft vom Promotion-Pfad aus — konsistent in §3 (Outcome-Schleife unmechanisiert, Z. 44) und §9 (Produktexperimente enden im menschlichen Urteil, Z. 138) durchgehalten.
- **Betriebs-/Scheduler-Details über Synthese-Minimum hinaus, alle belegbar:** `/loop` 7-Tage-Expiry (Z. 177), „Routines melden grünen Status auch bei inhaltlichem Misserfolg — Ergebnisprüfung bleibt Pflicht" (Z. 182, aus D14), Restore-Probe < 30 Tage als A5-Bedingung (Z. 165), Spend-Limit-auf-0 als Notausschalter (Z. 169), Portfolio-Sofortmaßnahme „server-migration privat" in Welle 1 (Z. 233, aus Portfolio §19.1 — nur C integriert sie).

### Schwächen

- **S-C1 (innere Unschärfe):** Rollentabelle §4 deckelt den Implementer bei „A1–A2 im Worktree" (Z. 55) und den Lead bei A0–A2 (Z. 54), aber §5.1/5.3 sehen A3-Pfade vor (TK1-Deckel A3, Background/Worktree+PR A2–A3, Z. 68, 85) und §3 kennt „Red-first ab A3 Protokollpflicht" (Z. 37). Wer A3 (Push/Draft-PR) ausübt, bleibt rollenseitig unbestimmt — vermutlich der Implementer mit Vorabfreigabe, aber das steht nicht da. Nicht ausgewiesen.
- **S-C2 (Kanonlücken, wie A):** Artefaktkanon §6 ohne STATUS/HANDBACK-Zeile und ohne Distribution-&-Signing-Runbook (AA7); Signing nur als Archetyp-E-Zone (Z. 209). HANDBACK erscheint nur in §5.4 (Safety Park).
- **S-C3 (Portfolio-Lücken):** Portfolio Control Plane (§18.6) fehlt (nur „WIP-Zählung sichtbar", Z. 234/124). Der PR-Evidenzblock (Z. 144) lässt gegenüber der 18.4-Feldliste das Kosten- und das Doku-Update-Feld aus (Kosten stehen im Run-Manifest — vertretbar, aber der Evidence-Bundle-Schnitt der Portfolio-Analyse ist bei B vollständiger).
- **S-C4 (Kennzahlen-Baseline verstreut):** AA12 verlangt eine Baseline je Projekt; C hat Rework (§5.1), Defekt-Escapes (§5.1), Erosions-Signale (§8.2), Kosten (§12.2) — aber keine geschlossene Liste, und „Durchlaufzeit" fehlt. A (Welle 3, Z. 249) und B (P8, Z. 64) führen die vollständige Liste.
- **S-C5 (nicht definierte Kürzel):** §5.3 nutzt „nur E2/E3" als Umgebungs-IDs (Z. 85), ohne die E1–E5-Legende einzuführen (Verweis auf Matrizen A/B im Anhang implizit; betrifft A und B mit „E1/E4" gleichermaßen, C nutzt die Kürzel aber am prominentesten im Normtext).

---

## 4. Einzelprüfungen

### 4.1 Elf Pflichtelemente (Forschungsauftrag §14) + geforderte Layer

| Pflichtelement | A | B | C |
|---|---|---|---|
| Rollen Mensch/Agenten | ✓ §4 | ✓ §4 (Phasenbindung) | ✓ §4 (A-Deckel je Rolle, aber S-C1) |
| Autonomiestufen | ✓ §5 | ✓ §5 | ✓ §5 (Zustandsmaschine) |
| Projektartefakte | ✓ §6 (Lücken S-A3d) | ✓ §6 (vollständigster Kanon) | ✓ §6 (Lücken S-C2; + Enforcement-Register) |
| Informationsflüsse | (✓) §7 knapp | ✓ §7 (Flussprinzip, Control Plane) | ✓ §7 (project-state als Rückgrat) |
| Entscheidungsprozesse | ✓ §7 | ✓ §7 (explizite Regel Z. 140) | ✓ §7 |
| Freigabepunkte | ✓ §7 (Tabelle mit Kanal+Enforcement) | ✓ §7 (G1–G6) | ✓ §7 (abschließende Liste) |
| Parallelisierung | ✓ §8 | ✓ §8 | ✓ §8.1 |
| Verifikation | ✓ §8 | ✓ §8 (Q1–Q4) | ✓ §8.2 |
| Experimentierkreisläufe | ✓ §9 (Token-Box-Schwelle) | ✓ §9 (Übernahme nur via P2) | ✓ §9 (TTL/CI-Mechanismus) |
| Traceability | ✓ §10 | ✓ §10 | ✓ §10 |
| Abbruch/Eskalation | ✓ §5(c) | ✓ §5-Katalog + je Phase §3.2 (am dichtesten) | ✓ §5.4 |
| Betriebs-Layer | ✓ §11 (inkl. OpenSSH-Fix) | ✓ §11 (Tailscale-SSH-Lücke S-B2) | ✓ §11 (inkl. Gate-Probe der Schalter) |
| Scheduler-Layer | ✓ §12 (4 Ebenen + Merkregeln) | ✓ §12 (4 Ebenen + RC-Zeile) | ✓ §12.1 (4 Ebenen + D14-Details) |
| Kosten-Layer | (✓) §12 — Batch-API fehlt | ✓ §12 vollständig | ✓ §12.2 vollständig |

### 4.2 Zwölf Arbeitsaufträge der Synthese v2 (einzeln)

| AA | Inhalt (Kurz) | A | B | C |
|---|---|---|---|---|
| 1 | Lifecycle 8 Phasen + Reconcile + Learn | ✓ §3 (9.7/9.8, Mapping-Tabelle) | ✓✓ §3 (tiefste Ausarbeitung, Diagramm) | ✓ §3 (Gate+Mechanismus je Übergang) |
| 2 | W-Matrix wörtlich, Matrizen A/B Anhang, Routines-Liste, M2-Option als Entscheid | ✓ Z. 70 (E1) | ✓ Z. 97 (E1); Routines-Liste nur teilweise | ✓✓ Z. 79–81 (OE-1; vollständigste Liste, M-Klassen korrekt) |
| 3 | Doppelkonditionierung (Evidenz + Task-Klassen), Rework-Pflichtmetrik, Orchestrierungskopplung | ✓ Z. 72–77 | ✓ Z. 86–99 (Abstieg automatisch) | ✓✓ §5.1/5.3 (Zustandsmaschine, Hook-Auswertung) |
| 4 | Scheduler-Zuordnung 4 Ebenen + Remote Control attended | ✓ Z. 166–175 | ✓ Z. 183–192 | ✓ Z. 175–182 |
| 5 | Kosten-Layer komplett (inkl. Batch-API, Resume, Monatsreview) | (✓) Z. 177–183 — **Batch-API fehlt** | ✓ Z. 193 | ✓ Z. 186–191 |
| 6 | Verifikationsbandbreite: A1–A8, WIP, Slice, Rollenkern, Zweitmeinung | ✓ §8/§4 | ✓ §8/§4 | ✓ §8.1/§4 |
| 7 | Artefaktkanon E/N/I, jedes Artefakt mit Eigentümer/Trigger/Drift-Schutz, inkl. STATUS + Signing-Runbook | (✓) §6 — STATUS+Signing fehlen im Kanon | ✓✓ §6 vollständig | (✓) §6 — STATUS+Signing fehlen im Kanon |
| 8 | Qualitätsschicht: 5-stufige Gate-Hierarchie, Audits inkl. Continuous Cleanup, Testreparatur-Regel, Flaky-Quarantäne | (✓) §8 — **Continuous-Cleanup-Lauf fehlt** | ✓ Z. 146–154 | ✓ Z. 126–134 |
| 9 | Betriebs-Layer inkl. Ops-Stufenplan 0–3, Profile, DB-Normen, Backup-Gate, Notausschalter, mobile Asymmetrie | ✓ §11 | ✓ §11 (Profilnamen fehlen; Tailscale-SSH-Lücke) | ✓ §11 |
| 10 | Technisches Fundament: Sandbox/W3, Plugin, Headless-Kopplung, WIF, Agentenidentität, MCP 2025-11-25 + 2026-ready + Trigger | (✓) — Bot-Account/PATs nur implizit | ✓ (+ M1-Korrektur, einzig) | ✓✓ (2026-ready-Inhalte ausgeführt; Bot-Account+PATs explizit Z. 60) |
| 11 | Evidence Chain dreistufig + gemeinsames Schema | ✓ §10 | ✓ §10 | ✓ §10 |
| 12 | Messdisziplin: Kennzahlen-Baseline (vollständig), Verbote (Gefühl/Benchmarks), Statusquellen-Hierarchie | ✓ (Baseline vollständig, Welle 3) | ✓✓ (P8-Liste vollständig, B5-Klausel Z. 95) | (✓) Baseline verstreut, Durchlaufzeit fehlt |

Bilanz: **B 12/12** (davon 2 mit kleinen Formlücken), **C 12/12** (davon 2 mit Teillücken AA7/AA12), **A 12/12 formal, aber 4 Aufträge mit Substanzlücken** (AA5 Batch, AA7 Kanon, AA8 Cleanup, AA10 Identität).

### 4.3 Konfliktentscheide

| Entscheid | A | B | C |
|---|---|---|---|
| K1 MCP 2025-11-25 + 2026-ready + Umstellungstrigger | ✓ Delta #17 mit CLAUDE.md-Fundstelle | ✓ §14 + M1-Korrektur | ✓✓ §14 mit ausgeführten Designregeln |
| K2 kein METR-Punktschätzer; A1–A8 + Stanford | ✓ (P3, §14 „Nicht übernommen") | ✓ (Prinzip 4, Z. 144) | ✓ (Z. 124; präzisestes Zitat) |
| K3 Benchmark-Regel B1–B5 | ✓ (Delta #13 → 20.7) | ✓ (+ operative B5-Klausel Z. 95) | ✓ (Prinzip 6, Research-Gate) |
| K4a W-Matrix W1–W4 wörtlich | ✓, **aber de facto durch Z. 200/205 unterlaufen (S-A1)** | ✓ konsistent | ✓ konsistent, präziseste Wiedergabe |
| K4b Routines-Bedingungsliste + A3-Deckel | ✓ (teilweise wiedergegeben, Rest → 23.12) | ✓ (teilweise, via K4-Verweis) | ✓✓ (vollständig im Normtext) |

### 4.4 E-Regel-Enforcement (Stichproben)

- Durchgängige Mechanismus-Benennung: A ✓ (Enforcement-Spalte über alle 27 Delta-Zeilen), B ✓ (je E-Regel in Klammern), C ✓✓ (Mechanismen-Katalog + Register + Gate-Probe).
- Als E deklariert ohne deterministischen Mechanismus: A „Resume-Pflicht (E)", A „Prompt-Ebene der Caps (E)" (Z. 181–182); B „WIP-Regel (E über Prozess + Dashboard)" (Z. 58). C: keine gefundene — die zwei schwachen Kandidaten (WIP, Held-out-Deny) sind ausdrücklich als N bzw. als schwacher Mechanismus ausgewiesen (Z. 124, 131).
- Prüfung des Enforcement selbst: nur C (Gate-Probe, Z. 21; Notausschalter „getestet per Gate-Probe", Z. 169; A hat immerhin „jeder Schalter mit dokumentiertem Test-Datum", Z. 162).

---

## 5. Bewertungstabelle (Skala 1–10, streng)

| Kriterium | A | B | C |
|---|---|---|---|
| K1 Abdeckung der elf Pflichtelemente (§14) | 9 | 10 | 9 |
| K2 Betriebs-/Scheduler-/Kosten-Layer vollständig | 8 | 9 | 9 |
| K3 Verarbeitung der 12 Arbeitsaufträge (einzeln) | 8 | 9 | 9 |
| K4 Konfliktentscheide respektiert (K1–K4, B1–B5, Routines) | 9 | 9 | 10 |
| K5 E-Regeln mit belastbarem, ehrlichem Enforcement | 7 | 7 | 10 |
| K6 Evidenztreue (Zahlen, Zitate, Fundstellen) | 9 | 9 | 9 |
| K7 Innere Konsistenz / v4.0-Invarianten ohne unausgewiesene Widersprüche | 6 | 8 | 9 |
| K8 Portfolio-Verankerung (15.3, 17.3, 18.4–18.6, 19.1) | 7 | 9 | 8 |
| K9 Adoptierbarkeit / Delta-Präzision / Einführungspfad | 9 | 8 | 8 |
| **Summe (max. 90)** | **72** | **78** | **81** |

Begründungsschwerpunkte: A verliert bei K7 wegen S-A1 (einziger unausgewiesener Verstoß gegen einen Konfliktentscheid im Feld) und bei K5/K2/K3 wegen der Substanzlücken S-A2/S-A3; A gewinnt K9 klar (27-Zeilen-Delta mit Kapitelankern). B gewinnt K1 und K8 (Phasen-Vollausstattung, Control Plane, 18.4/18.5-Treue), verliert bei K5 wegen S-B1. C gewinnt K4 und K5 deutlich (Gate-Probe, Register, ehrliche Schwächen-Ausweisung, OE-2) und hält K7 trotz S-C1 am höchsten.

---

## 6. Rangfolge

1. **Entwurf C (Enforcement-first) — 81/90.** Beste Erfüllung des Prüfschwerpunkts: einziger Entwurf, der Enforcement nicht nur benennt, sondern prüfbar macht (Register + Gate-Probe), der alle Konfliktentscheide inklusive vollständiger Routines-Liste und 2026-ready-Inhalten präzise transportiert und den härtesten Konsistenzfall (Boxscore vs. W4) mit einer W4-erhaltenden Lösung auflöst. Schwächen (Kanonlücken, fehlende Control Plane, Implementer-A-Deckel) sind reparabel und betreffen keine Konfliktentscheide.
2. **Entwurf B (Lifecycle-first) — 78/90.** Vollständigster Entwurf in der Breite (Pflichtelemente, Artefaktkanon, Kennzahlen, Control Plane, M1-Korrektur) und konsistent gegenüber W4; verliert den Spitzenplatz durch die unehrliche E-Deklaration des WIP-Limits, die Tailscale-SSH-Betriebslücke und geringere Enforcement-Tiefe.
3. **Entwurf A (Evolution) — 72/90.** Wertvollster Migrationsmechanismus (Delta-Tabelle, Nummernstabilität, Anti-Flickenteppich-Regel) und hohe Evidenztreue im Detail — aber der unausgewiesene Widerspruch zwischen „A4/A5 bleiben attended (W4)" (Z. 37, E-Stufe Z. 70) und „Auto-Merge-Pfad bleibt legitim / nur mit Held-out-Suite + Attestation" (Z. 200, 205) ist genau der Fehlertyp, den ein Referenzmodell mit normativer W-Matrix nicht enthalten darf; dazu kommen vier Substanzlücken gegen die Arbeitsaufträge (Batch-API, Continuous Cleanup, Agentenidentität, Kanonzeilen).

---

## 7. Was von wem übernehmen (Bausteine für die konsolidierte Fassung)

| # | Baustein | Quelle | Fundstelle |
|---|---|---|---|
| 1 | Enforcement-Register + quartalsweise Gate-Probe (E-Regel → Mechanismus → letzter Blockade-Nachweis); Einführungs-Exit „erste Gate-Probe bestanden" | **C** | Z. 21, 98, 169, 233 |
| 2 | OE-2-Auflösung Boxscore/W4: Content-Refresh als deterministische CI-Pipeline ohne LLM im Promotionspfad; Code-Merges attended (One-Tap via Remote Control) | **C** | Z. 241 |
| 3 | Vollständige Routines-Bedingungsliste wörtlich im Autonomie-Kapitel (nicht nur Anhangsverweis) + Hinweis „Routines melden grünen Status auch bei Misserfolg" | **C** | Z. 81, 182 |
| 4 | Ehrliche Held-out-Ablage-Entscheidung: separates CI-only-Repo für Autonomie-Projekte, Deny-Verzeichnis (mit ausgewiesener String-Schwäche) für den Rest | **C** | Z. 131, OE-5 Z. 244 |
| 5 | A-Stufen-Zustandsmaschine in `project-state.yaml`, vom Session-Start-Hook als Settings-Profil geladen; Abstieg mechanisch mit konkreten Budget-Triggern, Aufstieg als ADR mit Evidenzverweis | **C** | Z. 66–75 |
| 6 | Acht-Phasen-Pipeline mit einheitlichem Phasen-Schema (Eingaben/Artefakte/Rollen/A-Deckel+W-Zelle/Gates/**Abbruch**) samt Gesamtdiagramm als Lifecycle-Referenzdarstellung | **B** | §3, Z. 28–64 |
| 7 | Artefaktkanon-Tabelle als vollständigste Fassung — inkl. HANDBACK/STATUS-Zeile und Distribution-&-Signing-Runbook mit Eigentümer/Pflege-Trigger/Drift-Schutz | **B** | §6, Z. 107–122 |
| 8 | Anti-Overhead-Operationalisierung: LIGHT-Default für alles Reversible, Artefakt-Budget LIGHT ≤ 1 Seite, Begründungspflicht für STANDARD („Risiko, nicht Gewohnheit") | **B** | Z. 17, 197 |
| 9 | Portfolio Control Plane als Read-Model aus project-state.yaml + Run-Manifesten + CI-Status (deckt Portfolio §18.6, macht das WIP-Limit portfolioweit sichtbar) | **B** | Z. 127, 234 |
| 10 | M1-Terminologie-Korrektur („read-only mit Credentials ist M1, nicht M2") in die MCP-/Steckbrief-Korrektur aufnehmen | **B** | Z. 223 |
| 11 | 27-Zeilen-Delta-Tabelle mit v4.0-Kapitelankern und Nummernstabilität 26.7 als Einführungsvehikel (v4.1-Paket bzw. Rückführungsplan für den v5-Schnitt) — inkl. der präzisen CLAUDE.md-Steckbrief-Korrekturstelle | **A** | §14 Z. 211–239, Z. 229 |
| 12 | Anti-Flickenteppich-Regel (je Querschnittsthema genau eine normative Heimat) + Scheduler-Merkregeln + explizite Orthogonalität Zeremonie-Profil/Arbeitsmodus | **A** | Z. 24, 175, 21/187 |

**Auflagen für die Konsolidierung (unabhängig von der Quelle):** (a) S-A1 darf in keiner Fassung überleben — die Archetyp-B-Zeile „Auto-Merge-Pfad nur mit Held-out-Suite + Attestation" ist durch die OE-2-Mechanik zu ersetzen. (b) WIP-Limit einheitlich als gemessene N-Regel mit benannter Hook-Promotion führen (C Z. 124), nicht als Schein-E (B Z. 58). (c) Resume-Pflicht und Stagnationsregel als N führen oder einen echten Mechanismus benennen (gegen A Z. 181–182). (d) Bezeichner entkollidieren: Eigentümerentscheidungen als OE-*, Umgebungen E1–E5 mit Legende im Normtext. (e) Kanonlücken schließen: STATUS/HANDBACK und Signing-Runbook in jeden Kanon (B als Vorlage); Batch-API −50 % und Continuous-Cleanup-Lauf in jede Kosten-/Qualitätsfassung. (f) C's Implementer-A-Deckel (A1–A2) mit dem A3-Pfad (Vorabfreigabe je Ziel) explizit verdrahten.
