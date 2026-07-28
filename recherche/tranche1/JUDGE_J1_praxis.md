# Gutachten J1 — Fokus: Praxis, Right-Sizing, Adoptierbarkeit

**Gutachter:** J1 (unabhängig) · **Datum:** 2026-07-28
**Gegenstand:** ENTWURF_A_evolution.md, ENTWURF_B_lifecycle.md, ENTWURF_C_enforcement.md (alle vollständig gelesen)
**Prüfmaßstab:** Kann Andreas das Modell in 2 Wochen nebenher einführen? Überlebt es die 5 realen Archetypen (bes. LIGHT — Portfolio §17.3 warnt vor Governance-Overhead)? Ist die Solo-Review-Bandbreite respektiert? Sind die Regeln im Alltag befolgbar oder Papiertiger? Wie hoch sind Einführungs- und Pflegekosten? Würde ein Pragmatiker es lieben oder belächeln?
**Zusätzlich herangezogen:** 00_SYNTHESE.md (v2, Arbeitsauftrag 1–12, K1–K4), Forschungsauftrag Abschnitt 14, Portfolio-Analyse §15/§17.3/§18, Methodik v4.0 (Kapitelstruktur verifiziert), CLAUDE.md v4.0.

---

## 0. Vorbemerkung des Gutachters: Die Substanz ist zu ~90 % identisch — bewertet wird das Trägerformat

Alle drei Entwürfe setzen denselben Synthese-Arbeitsauftrag (00_SYNTHESE §7, Punkte 1–12) um: 8-Phasen-Lifecycle + Reconcile + Learn, W1–W4-Matrix wörtlich aus A20, E/N/I-Taxonomie, Doppelkonditionierung der A-Stufen, WIP-Limit 2–3 PRs, Slice als Einheit, LIGHT/STANDARD/HIGH-RISK, Ops-Stufenplan 0–3, Scheduler-Vierteilung, Kosten-Layer (Max 5x + Credits + API-Key 25 USD), Held-out-Suite, Plugin-Verteilung, Spec-Reconciliation, Learn-Schritt. Sogar die offenen Eigentümerentscheidungen überlappen weitgehend (M2-Lockerung, Routines-Pilot, Kostenrahmen, Serverrollen, Boxscore).

Die Rangfrage unter meinem Fokus ist deshalb keine Substanzfrage, sondern: **Welche Verpackung ist am billigsten einzuführen, am billigsten zu pflegen, und welche zwingt das Right-Sizing am wirksamsten in den Alltag?** Dort unterscheiden sich die drei erheblich.

**Eigene Verifikationsleistung dieses Gutachtens:** Ich habe Entwurf A's Anker-Behauptung gegen die reale Kapitelstruktur der Methodik v4.0 geprüft (KI_ENGINEERING_METHODIK.md, 30 Kapitel, alle Unterabschnitte gegrept). Ergebnis in Abschnitt 1.

---

## 1. Entwurf A — Evolution (Delta auf v4.0)

### Stärken

**A-S1 — Die Adoptierbarkeits-Behauptung ist verifiziert, nicht nur behauptet.** A verspricht „keine einzige Kapitelnummer verschieben" (§1) und liefert in §14 eine 27-zeilige Delta-Tabelle mit exakten Ankern. Prüfung gegen die reale v4.0-Struktur: **Alle ~15 neuen Unterabschnittsnummern sind exakt die nächsten freien Slots** — 4.5 (Kap. 4 endet bei 4.4 „Minimalprofil"), 5.6 (nach 5.5), 8.6 (nach 8.5), 9.7/9.8 (nach 9.6), 10.9 (nach 10.8), 11.8 (nach 11.7), 18.11 (nach 18.10), 20.7 (nach 20.6), 22.10 (nach 22.9), 23.12 (nach 23.11), 25.8–25.10 (nach 25.7), 26.8/26.9 (nach 26.7), 27.7 (nach 27.6), 28.11–28.14 (nach 28.10). Auch die In-place-Referenzen stimmen: „verdiente Autonomie aus 5.5" steht wörtlich in v4.0 5.5; 15.5 ist tatsächlich der „Menschliche Geschmackscheckpoint"; 21.6 ist „Run-Manifeste"; 25.7 „Betrieb" ist real der dünnste Teil; 28.7 ist HANDBACK; der monierte MCP-Steckbrief-Fehler (CLAUDE.md nennt 2026-07-28 statt 2025-11-25) ist im Input real vorhanden. **Die Migration ist mechanisch: Abschnitte einfügen, nichts umbauen.** Kein anderer Entwurf kann adoptiert werden, ohne die Methodik neu zu schreiben.

**A-S2 — Welle 1 ist echt 2-Wochen-groß und besteht aus Konfiguration, nicht aus Dokumentenschreiben.** §15: „W-Matrix in Kraft setzen, MCP-Steckbrief korrigieren, Kostenrahmen einrichten (Credits-Cap, API-Key mit Spend-Limit), Run-Manifest-Schema, Notausschalter einrichten und testen, WIP-Limit und Stagnationsregel scharf" — mit prüfbarem Erfolgskriterium („ein Testlauf produziert ein schema-valides Manifest"). Das ist die einzige der drei Einführungssequenzen, die in zwei Wochen nebenher wirklich einen normativ gültigen Zustand erreicht (bei B liefert Welle 0 nur „Plugin v0.1 in zwei Projekten", bei C „eine E-Regel blockiert nachweislich").

**A-S3 — Eingebaute Pflegekosten-Kontrollen.** Die Anti-Flickenteppich-Regel (§2, Schluss: „je Querschnittsthema eine Heimat — W-Matrix → 22.10, Kosten → 22.7/21.6, Scheduler → 11.8 … Andere Kapitel verweisen nur") adressiert genau den Hauptfehlermodus eines Delta-Ansatzes. P7 („Kein Artefakt ohne Eigentümer und Pflege-Trigger. Was niemand pflegt, wird gestrichen oder auf I gestuft", §2) ist die einzige explizite Anti-Zombie-Regel der drei Entwürfe.

**A-S4 — Right-Sizing mit der schärfsten Einzelregel zur Task-Ebene.** §13: „Das Profil folgt primär der Task-Klasse und Risikoklasse, nicht allein dem Projekt — **auch ein HIGH-RISK-Projekt erledigt einen Tippfehler im LIGHT-Profil**." Plus Orthogonalität Profil/Modus explizit. Die LIGHT-Zeile ist wirklich leicht: „Spec-Block im Item, Worklog | Statik + targeted Tests, Ein-Kommando-Verify | Checkbox im PR" (§13); Reconcile in LIGHT: „Checkbox genügt" (§3, Neu 9.7).

**A-S5 — Bandbreitenschonendste Review-Ökonomie.** WIP-Limit 2–3 PRs mit Drossel-Regel (§8.1: „bei Stau wird Generierung gedrosselt, nie Prüftiefe"); Zweitmeinungs-Gate **erst ab Risikoklasse R2** (§8.3) — billiger als B (Reviewer-Agent bei jedem STANDARD-PR) und deutlich billiger als C (frischer Reviewer „für jeden Agenten-PR", C §8.2). Monatliches Kosten-Review explizit auf „5 Minuten" gedeckelt und mit dem Learn-Review zusammengelegt (§12).

**A-S6 — Einzige De-minimis-Schwelle für Experimente.** §9: „Spike-Karten-Pflicht ab Token-Box > 0,1 Mio. Tokens" — kleine Experimente bleiben papierfrei. B und C verlangen die Spike-Karte für jedes Experiment (B §9 „Jede Spike-Karte…", C §9 „Jeder Spike beginnt mit…"). Für ein Privatportfolio mit viel Exploration (funkatlas, curio) ist das der Unterschied zwischen befolgbar und ignoriert.

**A-S7 — Bewusste Nicht-Übernahmen als eigene Liste.** §14 Schluss: „Nicht übernommen (bewusst, synthese-konform): Microservices/Kafka/Vault/Triple-Stores/IDPs, SaaS-Evals, Agenten-Flotten, …" — Right-Sizing durch Ausschluss, dokumentiert statt stillschweigend.

### Schwächen

**A-W1 — „2 Wochen" gilt nur für Welle 1; das Gesamtpaket ist ein Quartalsprogramm.** Der eigene Executive Summary beziffert „rund 20 neue Unterabschnitte und rund 15 In-place-Schärfungen" (§1) — 35 Redaktionseingriffe. Welle 2 (Monat 1) und Welle 3 (Quartal) enthalten die eigentliche Evidenz-Maschinerie (Golden Tasks, pass^k, Held-out). Ehrlich gestaffelt, aber die Schlagzeile „sofort adoptierbar" gilt nur für die Regelschicht.

**A-W2 — Höchste Entscheidungslast: 10 offene Eigentümerentscheidungen (§16, E1–E10) gegenüber 8 (B) und 9 (C).** E10 ist besonders problematisch: A lässt offen, ob das Paket als v4.1 in Kraft tritt oder „als Bauplan in einen v5-Neuschnitt eingeht" — eine Meta-Unentschiedenheit, die die eigene Kernstärke (sofortige Inkraftsetzung) relativiert und Adoption verschleppen kann.

**A-W3 — Kein Gesamtbild, keine Lehrbarkeit.** Das Modell existiert nur als Ankerliste über ein 3000-Zeilen-Dokument. Es gibt kein Diagramm, keine Ein-Seiten-Sicht („Wo bin ich gerade im Prozess?"). B beweist mit §3.1, dass das auf einer halben Seite geht. Wer A adoptiert, hat ein korrektes Nachschlagewerk und kein Bild im Kopf — im Alltag ein realer Befolgbarkeitsnachteil.

**A-W4 — Einzelabschnitte sind referenztauglich, aber alltagsunlesbar dicht.** Neu 22.10 (§5a) presst die komplette W-Matrix inklusive Kompensationspaket K+P+H+E+C in einen Fließtextblock; die Scheduler-Tabelle (§12) trägt vier Ebenen × fünf Spalten mit Kürzeln (E1, E4, W2, K+P+H+E+C, dontAsk), wobei **E1–E5 nirgends im Entwurf definiert werden** (aus A20 geerbt; Leser des Entwurfs allein kann die Regel nicht anwenden — Schwäche teilen alle drei, siehe C-W6).

**A-W5 — LIGHT hat keine Default-Regel.** A sagt, das Profil folgt der Task-Klasse (§13), aber nirgends steht, was im Zweifel gilt. B kehrt die Beweislast um („wer STANDARD wählt, begründet es mit Risiko, nicht mit Gewohnheit", B §13); A überlässt die Profilwahl je Item dem Ermessen — genau dort entsteht in der Praxis Zeremonie-Kriechen Richtung STANDARD.

**A-W6 — Rework-Faktor als „Pflichtmetrik im Run-Manifest" (§5b) ohne Messmechanismus.** Wie ein Folge-Fix einem früheren Lauf zugerechnet wird, sagt niemand; „Rework-Faktor > 2 über drei Tranchen wirkt wie ein Vorfall" ist ohne Zurechnungsregel nicht auswertbar. (Geteilte Schwäche: B §5a und C §14 fordern dieselbe Metrik gleich mechanismuslos — aber A erhebt sie zusätzlich zum Fehlerbudget-Auslöser und hängt damit am meisten daran.)

---

## 2. Entwurf B — Lifecycle-first

### Stärken

**B-S1 — Bestes mentales Modell, einziges Gesamtbild.** §3.1 liefert das einzige Diagramm der drei Entwürfe: eine Pipeline P1–P8, menschliche Gates G1–G6 klar getrennt von Maschinen-Gates Q1–Q4, Makro-/Mikro-Skala benannt. §2: „Das Modell muss in ein Diagramm passen … und in einer Stunde lehrbar sein." Für die Alltagsfrage „an welcher Station stehe ich, wer entscheidet hier?" ist das jedem Ankerverzeichnis überlegen.

**B-S2 — Schärfstes Right-Sizing aller drei Entwürfe; die direkteste Antwort auf Portfolio §17.3.** §13: „**LIGHT ist der ausdrückliche Default für alles Reversible; Artefakt-Budget LIGHT ≤ 1 Seite gesamt; wer STANDARD wählt, begründet es mit Risiko, nicht mit Gewohnheit.**" Dazu: G1+G2 kollabieren in LIGHT zu einer Issue-Freigabe (§3.2 P3), Spec-Reconciliation in LIGHT als „Sammelabgleich je Tranche" statt je Merge (§13-Tabelle), Run-Manifest in LIGHT als „Kurzform (auto aus Headless-JSON)". Das ist Governance, die sich selbst kleinhält — exakt was §17.3 („kleine Änderungen unverhältnismäßig teuer") verlangt.

**B-S3 — Solo-Bandbreite ist Architekturprinzip, nicht Fußnote.** §2 Prinzip 3: „genau eine Entscheidungsfront je Projekt; Parallelität nur unterhalb der letzten Freigabe" — erhebt Andreas' real etabliertes Muster (Verweis Portfolio §8.2) zur Regel. §4: „Seine Review-Bandbreite ist die knappste Ressource des Systems." Zweitmodell nur bei HIGH-RISK (§3.2 P5) — Mittelweg zwischen A (ab R2) und C (jeder PR).

**B-S4 — Learn-Schritt mit Takt und Selbst-Enforcement.** §3.2 P8: „Scheduled Task erzeugt den Review-Stub; ein Merge-Kalendermonat ohne Learn-Protokoll ist ein Verstoß im Dashboard." A und C deklarieren Learn als Monatsritual, nur B automatisiert die Erinnerung — im Solo-Betrieb der Unterschied zwischen stattfinden und versanden. Ebenso praktisch: „Ablehnung erzeugt einen Learn-Eintrag (Grund als Datum), nicht nur einen neuen Versuch" (§3.2 P5).

**B-S5 — Konkreteste Pilotierung.** §15 benennt Pilotprojekte (tischatlas, boxscore) und harte Exit-Kriterien („fünf Merges vollständig durch die Pipeline; Kennzahlen-Baseline erhoben"). Wellen-Exits sind messbar formuliert.

### Schwächen

**B-W1 — Der Einführungspfad ist kein 2-Wochen-Pfad, sondern ein 3-Monats-Programm mit Dokumenten-Neuschnitt am Ende.** Kopfzeile: „Eigenständiger Entwurf als Entscheidungsgrundlage für Methodik v5. Dieses Dokument schreibt v4.0 nicht um" — d. h. bis „Methodik v5 wird aus diesem Referenzmodell geschnitten" (§15, Welle 3, „Monat 3+") laufen **zwei normative Dokumente parallel**: die geltende v4.0 (auf die alle CLAUDE.md-Verfassungen mit Kapitelnummern verweisen, z. B. „Methodik 10.8", „Methodik 21.6") und B's §-/P-/G-/Q-Welt. Wie diese Doppelphase gehandhabt wird, regelt B nirgends. Die Delta-Tabelle §14 mappt 30 Kapitel auf 9 Zeilen — als Umbauanleitung zu grob.

**B-W2 — Stillschweigender Konflikt mit der geltenden Nummernstabilitätsregel.** v4.0 26.7 und CLAUDE.md Kap. 14 („Kapitelnummern der Langmethodik sind stabil: Neues wird als Unterabschnitt ergänzt") sind geltendes Recht des Systems; B's Neuschnitt setzt sie außer Kraft, ohne das je zu erwähnen oder als Eigentümerentscheidung auszuweisen. B §14 räumt selbst ein: „Das Modell ist ein Neuschnitt der **Darstellung**, nicht der Substanz" — der Pragmatiker fragt: Warum dann die Darstellungskosten von drei Monaten zahlen?

**B-W3 — Vokabellast.** B addiert drei neue Buchstabensysteme (P1–P8, G1–G6, Q1–Q4) zu den fünf bestehenden (A0–A5, M0–M4, W1–W4, E1–E5, R-Klassen) plus T1–T4-Task-Klassen und der Doppelbedeutung von „STANDARD" (Modus und Profil). Lehrbar in einer Stunde — ja; aber jede Session, jedes Artefakt und jede Vorlage muss künftig zwei Nomenklaturen (v4.0-Kapitel und B-Codes) übersetzen, solange die Doppelphase läuft.

**B-W4 — Ein „E"-Etikett hängt an unbebauter Infrastruktur.** Das WIP-Limit deklariert B als „(E über Prozess + Dashboard)" (§3.2 P5), das Dashboard ist aber die „Portfolio Control Plane (privates Dashboard; **Pilot**)" (§7) und kommt erst in Welle 3 (§15). Ein E-Status, dessen Mechanismus ein noch nicht existierendes Dashboard ist, ist nach B's eigener Definition („Verbindlich ist nur Erzwungenes", §2 P2) ein Papier-E. C behandelt denselben Punkt ehrlicher (gemessene N-Regel, Hook-Promotion als OE-6).

**B-W5 — Kleiner Spec-Widerspruch bei LIGHT.** §3.2 P4 verlangt „je Slice Test-first mit beobachtetem Rot (Red-Beweis im Run-Manifest)" unqualifiziert; die §13-Tabelle sieht für LIGHT nur ein Auto-Kurzmanifest aus Headless-JSON vor. Ob der Red-Beweis in LIGHT gilt und wie er in die Kurzform kommt, bleibt offen.

---

## 3. Entwurf C — Enforcement-first

### Stärken

**C-S1 — Die beste Einzelidee aller drei Entwürfe: die Gate-Probe.** §2 Prinzip 1: Das Enforcement-Register wird „quartalsweise per Gate-Probe getestet: Ein harmloser, absichtlich regelwidriger Versuch muss nachweislich blockiert werden. **Enforcement, das nie geprüft wird, erodiert wie Prosa.**" Das ist die einzige Stelle in allen drei Entwürfen, die die Papiertiger-Frage auf die Mechanismen selbst anwendet — Hooks und CI-Checks verrotten in der Praxis genauso wie Prosa. Exit-Kriterium Welle 1 konsequent: „erste Gate-Probe bestanden — eine E-Regel blockiert nachweislich" (§15.1).

**C-S2 — Vorbildliche Ehrlichkeit über schwache Mechanismen.** §8.2 zur Held-out-Ablage: „Mechanismus ehrlich benannt: `permissions.deny` … ist stringbasiert und nur in der Sandbox hart; robust ist ein separates privates Repo" — mit differenzierter Empfehlung OE-5 (separates Repo nur für die zwei Autonomie-Projekte, Deny-Verzeichnis für den Rest). §8.1 startet das WIP-Limit als „gemessene N-Regel" mit Hook-Promotion als expliziter Option (OE-6). Die Selbstprüfungs-Fußnote deklariert die Verzerrung der eigenen Perspektive. Das ist die intellektuelle Redlichkeit, die ein Pragmatiker honoriert.

**C-S3 — Schutz vor der eigenen Logik.** §2 Prinzip 5: drei Urteile werden „bewusst **nie** mechanisiert" (Produkturteil, Designfreigabe, Risikoakzeptanz) und bleiben „dauerhaft N — ohne Promotion-Pfad". Verhindert, dass der Promotion-Automatismus die Outcome-Schleife frisst.

**C-S4 — Konkreteste Operationalisierung der Autonomie-Mechanik.** §5.1: „die Stufe *ist* das Profil, kein Satz" — der Zustand (Projekt × Task-Klasse) liegt in project-state.yaml und wird vom Session-Start-Hook als Permission-/Sandbox-Profil geladen; Degradierung passiert dadurch wirklich, ohne menschliche Buchführung. Die Fehlerbudget-Triggerliste ist die entscheidbarste der drei: „2 Defekt-Escapes … **oder** 1 Gate-Umgehungsversuch (`--no-verify`, Testabschwächung) **oder** 1 Sicherheits-/Trifecta-Verstoß" → automatisch eine Stufe runter für zwei Wochen (§5.1).

**C-S5 — Konkreteste Eigentümervorlagen.** OE-2 löst die reale Boxscore-W4-Kollision (Portfolio §15.3) mit einer echten Empfehlung: „(b) für reine Datenaktualisierung [deterministische CI-Pipeline ohne LLM im Promotionspfad], (a) für Code [attended via Remote Control]" (§16). OE-9 stellt als einziger die Frage, welche Projekte **dauerhaft** in LIGHT bleiben dürfen (Kandidat funkatlas) und was den Wechsel auslöst — die praktisch wichtigste Right-Sizing-Entscheidung fürs reale Portfolio.

### Schwächen

**C-W1 — Höchste stehende Pflegekosten, nirgends budgetiert.** Der Apparat umfasst dauerhaft: Enforcement-Register pflegen, Gate-Proben quartalsweise (§2 P1), Pruning-Zyklus quartalsweise (§6, AGENTS.md-Zeile), CI-Konsistenzchecks auf project-state.yaml als E über 11 Repos (§6), SPEC-Schema-Lint (§3), commit-msg-Hook (§10), Branch Protection überall (§15.2), ADR je Stufenentscheidung (§5.1). Jeder Mechanismus ist auch ein Wartungsgegenstand, der kaputtgehen kann. C beziffert an keiner Stelle, was der Apparat pro Woche kostet — für ein Solo-Feierabend-Portfolio die erste Frage. Die Gate-Probe prüft Wirksamkeit, nicht Kosten.

**C-W2 — Zweitmeinungs-Gate für jeden Agenten-PR verletzt die eigene Engpass-Analyse.** §8.2: „unabhängiger Reviewer mit frischem Kontext **für jeden Agenten-PR**" — steht in Spannung zur LIGHT-Zeile §13 („Reviews gebündelt") und verdoppelt (Kostentabelle der Synthese: „Writer/Reviewer-Split ≈2× Einzellauf") die Kosten auch trivialer PRs. A (ab R2) und B (Reviewer-Agent nur STANDARD, Zweitmodell nur HIGH-RISK) sind hier bandbreiten- und kostenehrlicher.

**C-W3 — Konkrete Inkonsistenz im Rollenmodell: Niemand in der Rollentabelle darf A3.** §4 begrenzt den Implementer auf „A1–A2 im Worktree" und den Lead auf „A0–A2 im Auftrag"; §5.1 deckelt TK1/TK2 aber bei A3, und §5.3 koppelt „Background/Worktree+PR" an A2–A3. Wenn die Rollenprofile als Tool-Allowlists erzwungen werden (C's eigener Anspruch, §4: „Rollenprofile sind Plugin-Bestandteil"), kann der Branch-Push mit Draft-PR (A3) von keiner definierten Rolle ausgeführt werden. A („A1–A3 je Freigabe") und B („Push nur mit A3") sind konsistent.

**C-W4 — Governance-Selbstzweck-Risiko trifft das Register selbst.** Portfolio §17.3 warnt wörtlich davor, „methodische Dokumente zum Selbstzweck" zu machen. Das Enforcement-Register ist eine neue methodische Dokumentklasse mit eigenem Quartalsritual — für 11 Privatprojekte mit einem Betreiber genau die Sorte Apparat, die §17.3 meint, sofern sie nicht radikal klein gehalten wird (im Entwurf: unbegrenzt, jede E-Regel).

**C-W5 — Gleiches Einführungsproblem wie B.** Kopfzeile: „Entwurf als Entscheidungsgrundlage für Methodik v5 (schreibt v4.0 nicht um)" — auch C braucht den v5-Neuschnitt und regelt die Doppelphase mit den bestehenden Kapitelverweisen nicht; die Delta-Tabelle §14 ist mit 13 Zeilen ebenfalls zu grob als Umbauanleitung.

**C-W6 — Normative Regeln auf undefinierten Kürzeln.** §5.3: „Background/Worktree+PR (A2–A3, **nur E2/E3**)" — E1–E5 werden im gesamten Entwurf nie definiert (nur als „Matrizen A/B im Anhang" referenziert, §5.2). Ein Anwender von C allein kann die Regel nicht ausführen. (A und B erben dasselbe Kürzelproblem in Scheduler-Tabelle bzw. Manifest-Feld, aber C hängt als einziger eine Verbotsregel daran.)

---

## 4. Bewertungstabelle

Skala 1–10. Kriterien aus dem Prüfmaßstab; Gesamt = ungewichtetes Mittel.

| Kriterium | A (Evolution) | B (Lifecycle) | C (Enforcement) | Begründungskern |
|---|---|---|---|---|
| K1 — Einführbarkeit in 2 Wochen nebenher | **9** | 5 | 5 | A: verifizierte freie Anker, Welle 1 = Konfiguration mit Erfolgskriterium (A §15); B/C: v5-Neuschnitt, Doppelphase ungeregelt (B/C Kopfzeile, B-W1, C-W5) |
| K2 — Archetyp-/LIGHT-Tauglichkeit (Portfolio §17.3) | 7 | **9** | 6 | B: LIGHT-Default + ≤1-Seite-Budget + Begründungspflicht für STANDARD (B §13); A: Tippfehler-Regel, aber kein Default (A-W5); C: LIGHT ok, aber Apparat drumherum (C-W1/W4) |
| K3 — Respekt der Solo-Review-Bandbreite | 8 | **9** | 6 | B: „eine Entscheidungsfront je Projekt" als Prinzip (B §2 P3); A: Zweitmeinung ab R2, 5-Minuten-Review; C: Reviewer je PR + Quartalsrituale zehren am selben Engpass (C-W2) |
| K4 — Alltags-Befolgbarkeit (Papiertiger-Test) | 7 | 8 | **8** | C: höchster Mechanisierungsgrad + Gate-Probe, aber Rolleninkonsistenz (C-W3); B: klarstes Stationsmodell, aber Papier-E beim WIP (B-W4); A: alles verankert, aber kein Gesamtbild, dichte Blöcke (A-W3/W4) |
| K5 — Einführungs- und Pflegekosten | **7** | 6 | 4 | A: Anti-Flickenteppich + P7-Streichregel, aber 35 Eingriffe + E10-Schwebe; B: Neuschnitt + Control Plane + Vokabelmigration; C: höchste stehende Kosten, unbudgetiert (C-W1) |
| K6 — Pragmatiker-Test (lieben oder belächeln) | **8** | 7 | 6 | A: „Delta statt Neubau, Churn ohne Evidenz" überzeugt; 10 offene Entscheidungen nerven. B: liebt Pipeline + LIGHT-Default, belächelt Neuschnitt „der Darstellung, nicht der Substanz" (B §14). C: liebt Gate-Probe und Ehrlichkeit, belächelt ein „Enforcement-Register" mit Quartalsritual fürs Hobby-Portfolio |
| **Gesamt** | **7,7** | **7,3** | **5,8** | |

---

## 5. Rangfolge

**1. Entwurf A — Evolution.** Gewinnt unter dem Praxis-Fokus, weil er als einziger den Zustand „Modell ist in Kraft" in zwei Wochen erreicht — und weil seine zentrale Behauptung (mechanisches Delta ohne Umnummerierung) der einzigen harten Verifikation dieses Gutachtens standhält (alle Anker real und frei, alle Querverweise korrekt). Schwächen (kein Gesamtbild, kein LIGHT-Default, E10-Schwebe) sind durch Übernahmen aus B und C billig heilbar; die Schwächen von B und C (Doppeldokumenten-Phase, Pflegeapparat) sind es nicht.

**2. Entwurf B — Lifecycle-first.** Das beste *Denkmodell* und das beste Right-Sizing — als Zieldarstellung für einen späteren v5 klar wertvoll. Als Einführungspfad jetzt aber der teurere Weg: drei Monate bis zur normativen Gültigkeit, ungeregelte Koexistenz mit den bestehenden Kapitelverweisen, stiller Bruch der geltenden Nummernstabilitätsregel. B verliert nicht an Substanz, sondern an Sequenzierung.

**3. Entwurf C — Enforcement-first.** Enthält die beste Einzelidee (Gate-Probe) und die ehrlichste Mechanismus-Diskussion, ist aber als Gesamtmodell für einen Solo-Betreiber überinstrumentiert: höchste stehende Pflegekosten ohne Selbstbudget, Reviewer-Pflicht je PR gegen den eigenen Engpass-Befund, dazu die einzige harte interne Inkonsistenz der drei Entwürfe (Rollentabelle vs. A3). C ist der beste Steinbruch und das schwächste Fundament.

---

## 6. Was-von-wem-übernehmen (konkrete Bausteine mit Quelle)

Empfohlene Konstruktion: **A als Träger (v4.1-Delta), B als Right-Sizing- und Didaktik-Spender, C als Härtungs-Spender.**

| # | Baustein | Quelle | Wohin in A | Fundstelle |
|---|---|---|---|---|
| 1 | Trägerformat: Delta-Paket auf verifizierte v4.0-Anker + 3-Wellen-Einführung mit Erfolgskriterien; E10 vorab zugunsten „v4.1 jetzt, v5 später aus Betriebserfahrung" entscheiden | **A** | Basis | A §14, §15 |
| 2 | LIGHT-Default-Regel: „LIGHT ist Default für alles Reversible; Artefakt-Budget ≤ 1 Seite; wer STANDARD wählt, begründet mit Risiko, nicht mit Gewohnheit" | **B** | Neu 4.5 | B §13 |
| 3 | G1=G2-Kollaps in LIGHT (eine Issue-Freigabe genügt) + Sammel-Reconciliation je Tranche statt je Merge in LIGHT | **B** | 4.5 / Neu 9.7 | B §3.2 P3, §13-Tabelle |
| 4 | Ein-Seiten-Gesamtdiagramm (Phasen, menschliche Gates, Maschinen-Gates) als **informatives** Schaubild (I-Stufe) vorn in der Methodik — Lehrbild ohne Umnummerierung | **B** | Kapitel 1 oder 28 (Vorlage) | B §3.1 |
| 5 | Learn-Stub-Automation: Scheduled Task erzeugt den Monats-Review-Stub; ein Merge-Monat ohne Learn-Protokoll wird sichtbar | **B** | Neu 9.8 | B §3.2 P8 |
| 6 | Gate-Probe — right-sized: halbjährliche Stichprobe auf den 5–10 tragenden E-Regeln (Kill-File, Sandbox-failIfUnavailable, Branch Protection, Held-out, Spend-Limit), nicht Quartalsritual über alles | **C** | Neu 26.8 | C §2 Prinzip 1 |
| 7 | Enforcement-Register nicht als eigenes Dokument, sondern als zwei Felder im bestehenden Regel-Lebenszyklus 26.5 (`mechanismus`, `letzte_probe`) | **C** (Form: A) | 26.5/26.8 | C §6; A §6 (`enforcement`-Feld) |
| 8 | Schutzklausel: drei dauerhaft unmechanisierte Urteile ohne Promotion-Pfad (Produkturteil, Designfreigabe, Risikoakzeptanz) | **C** | Neu 26.8 | C §2 Prinzip 5 |
| 9 | Fehlerbudget-Triggerliste (2 Defekt-Escapes / 1 Gate-Umgehung / 1 Trifecta-Verstoß; 2 Wochen Degradierung) + „Stufe ist das Profil": Session-Start-Hook lädt das degradierte Profil aus project-state.yaml | **C** | Neu 5.6 / 25.8; beantwortet E8 | C §5.1 |
| 10 | Boxscore-Entscheidungsvorlage: Content-Refresh als deterministische CI-Pipeline ohne LLM im Promotionspfad (vorab einmalig freigegeben); Code-Merges attended via Remote Control | **C** | Entscheidungsvorlage zu A's E9 | C §16 OE-2 |
| 11 | Differenzierte Held-out-Ablage: separates privates Repo nur für die zwei Autonomie-Projekte (boxscore, new_nfl), Deny-Verzeichnis für den Rest | **C** | Neu 18.11 | C §8.2, OE-5 |
| 12 | Gegen B/C verteidigen (A behalten): Zweitmeinungs-Gate erst ab R2 statt je PR; Spike-Karten-Pflicht erst ab 0,1-Mio-Token-Box; Anti-Flickenteppich-Regel; P7-Streichregel | **A** | 10.8, 8.6, §2 | A §8.3, §9, §2 |

**Zusätzlich zu fixieren (Fehlerliste, unabhängig von der Quelle):** (a) E1–E5-Umgebungskürzel im übernommenen Text einmal definieren (Lücke in allen drei, am kritischsten C §5.3); (b) Rework-Zurechnungsregel definieren oder die Metrik ehrlich auf „manuell im Monatsreview geschätzt" herabstufen (alle drei fordern die Pflichtmetrik ohne Mechanismus); (c) C's Rollentabellen-Deckel auf „Implementer A1–A3 je Freigabe" korrigieren, falls Bausteine aus C §4 übernommen werden; (d) B's WIP-„E"-Etikett bis zur Existenz eines Zählmechanismus als N führen (C's OE-6-Lösung).

---

## 7. Schlussbemerkung des Gutachters

Der Pragmatiker-Test in einem Satz: **A würde Andreas nächste Woche benutzen, B würde er gern gelesen haben, C würde er plündern.** Die Substanz ist dreifach identisch belegt; entscheidend ist, dass die Regelschicht in zwei Wochen in Kraft ist (nur A), dass LIGHT der beweislastfreie Normalfall wird (nur B sagt das), und dass die wenigen wirklich tragenden E-Regeln nachweislich feuern (nur C prüft das). Die Kombination aus Zeile 1–12 der Übernahmeliste liefert alle drei Eigenschaften zum Preis von einem.
