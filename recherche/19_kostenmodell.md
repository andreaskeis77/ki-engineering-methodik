# Betriebskostenmodell der KI-nativen Methodik: Abo vs. API, Tokenfaktoren, Budgets

**Stand:** 2026-07-28. **Auftrag:** Kosten-Querschnittsdossier (K4, Prio 7 aus `00_KRITIK_UND_LUECKEN.md`) als Entscheidungsgrundlage für die empfohlenen Piloten. **Quellenstatus:** [V] = selbst abgerufen und geprüft am 2026-07-28; [V-Dxx] = am 2026-07-28 vom jeweiligen Dossier-Agenten an der Primärquelle verifiziert; [intern] = Messpunkt aus diesem Forschungsprogramm; [S] = nur über Suche belegt.

## Executive Summary

Die Kostenfrage der Methodik hat eine überraschend klare Antwort: In Dollar gemessen ist agentische Arbeit billig, in Abo-Fenstern gemessen ist sie knapp. Der komplette 14-Agenten-Recherche-Sweep dieses Programms (~1,6 Mio. Tokens inkl. abgebrochenem Erstlauf) hätte zu API-Listenpreisen der Sonnet-Klasse grob 4–10 USD gekostet — derselbe Lauf hat aber auf einem nicht erweiterten Abo bei parallelem Betrieb zweier Workflows real ein Session-Limit gerissen. Die knappe Ressource im Abo ist also das 5-Stunden-/Wochenfenster, nicht Geld; die knappe Ressource auf der API ist umgekehrt nur Geld, dafür mit exakter Abrechnung (`total_cost_usd`). Die verifizierten Tokenfaktoren (Chat 1×, Einzelagent ≈ 4×, Multi-Agent-Research ≈ 15×, Agent Teams ≈ 7× einer Session) erlauben Budgetplanung vor dem Lauf; Anthropics Enterprise-Durchschnitt von ~13 USD pro Entwickler-Aktivtag (150–250 USD/Monat) zeigt, dass ein Max-5x-Abo für tägliche intensive Nutzung deutlich unter API-Selbstkosten liegt. Empfehlung für Andreas: Max 5x als Arbeitsfundament, Usage Credits mit Monats-Cap als Überlaufventil statt sofortigem 20x-Upgrade, und ein separater Console-API-Key für CI und unbeaufsichtigte SDK-Automatisierung. Kostenkontrolle wird Methodikbaustein: Token-/Turn-Budget und Abbruchkriterien im Run-Manifest, Kostenfelder aus dem Headless-JSON, ein Workflow-Lauf pro Fenster als Faustregel.

---

## 1. Preisgerüst: Abo-Stufen vs. API (verifiziert)

**Abos** ([claude.com/pricing](https://claude.com/pricing) [V]): Pro 20 USD/Monat (17 bei Jahreszahlung), Max 5x 100 USD, Max 20x 200 USD; alle inkl. Claude Code. **Limits** (offizieller Support-Artikel [V]): Nutzung rollierend je 5-Stunden-Fenster plus Wochenlimit, geteilt über claude.ai, Cowork und Claude Code. Dokumentierte Größenordnungen: Pro ≈ 10–40 Claude-Code-Prompts je 5h-Fenster und ≈ 40–80 Sonnet-Wochenstunden; Max 5x ≈ 50–200 Prompts und ≈ 140–280 h Sonnet + 15–35 h Opus; Max 20x ≈ 200–800 Prompts und ≈ 240–480 h Sonnet + 24–40 h Opus. Wichtig: Anthropic publiziert **keine Token-Quoten** je Fenster, nur Prompt-/Stunden-Bandbreiten (die Artikel referenzieren noch die Sonnet-4/Opus-4-Generation — die Zahlen hinken den Modellen nach); Fensterplanung muss daher empirisch über `/usage` erfolgen. **Überlauf:** „Usage Credits" lassen sich pro Konto aktivieren und werden **zu Standard-API-Preisen** abgerechnet, mit Monats-Spendlimit, Auto-Reload und 2.000 USD Tagesdeckel [V]. Nebenwirkung: Beim Ziehen aus Credits sinkt die Prompt-Cache-Lebensdauer von 1 h (Abo) auf 5 min — Pausen in langen Sessions werden dann teurer [V].

**API-Listenpreise** ([platform.claude.com](https://platform.claude.com/docs/en/about-claude/pricing) [V], je Mio. Tokens Input/Output): Opus 5 (wie alle Opus seit 4.5) 5/25 USD; **Sonnet 5 bis 31.08.2026 promotional 2/10 USD, ab 01.09.2026 3/15 USD**; Sonnet 4.6 3/15; Haiku 4.5 1/5. Prompt Caching: Write 1,25× (5 min) bzw. 2× (1 h), **Cache-Read 0,1× des Input-Preises** — in agentischen Sessions liegt der Großteil der Input-Tokens als Cache-Read an, was die effektiven Kosten massiv senkt. Batch-API: −50 % auf alles (nur für eigene SDK-/Skript-Workloads relevant, nicht für Claude Code interaktiv).

**Referenzgröße für „was kostet ein Entwickler":** Anthropic dokumentiert über Enterprise-Deployments ~13 USD pro Entwickler-Aktivtag, 150–250 USD/Monat, 90 % der Nutzer unter 30 USD/Tag ([code.claude.com/docs/en/costs](https://code.claude.com/docs/en/costs) [V]). Daraus folgt der Break-even: **Wer Claude Code an mehr als ~2 Aktivtagen/Monat intensiv nutzt, fährt mit Pro billiger als mit API; ab ~8 Aktivtagen schlägt Max 5x die API; Max 20x lohnt erst bei nachgewiesener wiederholter Fenster-Erschöpfung.** Umgekehrt: Für seltene, stoßweise Batch-Läufe ist der API-Key wirtschaftlich gleichwertig und operativ überlegen (keine Fensterkollision, exakte Kosten).

## 2. Tokenfaktoren je Orchestrierungsmuster

Verifizierte Multiplikatoren ([Anthropic Engineering](https://www.anthropic.com/engineering/multi-agent-research-system) [V]; [V-D03]):

- **Chat = 1×; Einzelagent ≈ 4× Chat; Multi-Agent-Research ≈ 15× Chat.** Token-Einsatz erklärt in Anthropics BrowseComp-Auswertung 80 % der Leistungsvarianz — mehr Tokens kaufen bei Recherche real bessere Ergebnisse, aber: **Modell-Upgrade schlägt Token-Verdopplung** (erst Modellwahl optimieren, dann Fanout skalieren). Multi-Agent lohnt nur, wenn der Aufgabenwert die ~15× trägt und die Teilaufgaben parallelisierbar/read-heavy sind.
- **Agent Teams ≈ 7× einer Standard-Session** (offizielle Doku [V]) — jeder Teammate hält ein eigenes Kontextfenster und verbraucht weiter, bis er beendet wird. Experimentell, nur Pilot.
- **Workflows** (Dynamic Workflows/Skript-Orchestrierung): Kosten ≈ Zahl der Subagenten × Einzelagentenkosten, mit eingebauten Leitplanken — 16 parallel, 1.000 Agenten/Lauf, **Warnschwellen 25 Agenten bzw. 1,5 Mio. Tokens** [V-D03]. Der Tokenzähler des Workflows ist das natürliche Budget-Instrument.
- **MCP-Kontextkosten sind strukturell entschärft:** Tool Search ist Default (nur Namen + Server-Instructions im Startkontext, Definitionen laden bei Bedarf), MCP-Outputs sind auf 25k Tokens gedeckelt [V-D14]. Rest-Regel aus der offiziellen Kostenseite [V]: CLI-Tools (`gh`, `aws`) bleiben tokengünstiger als MCP-Server; ungenutzte Server deaktivieren; CLAUDE.md unter ~200 Zeilen, Spezialwissen in on-demand-Skills.
- **Versteckte Verbraucher** [V]: Extended Thinking (als Output abgerechnet, per `/effort` senkbar), lange Sessions (voller Kontext je Nachricht; `/clear` zwischen Aufgaben), Cache-Misses nach Pausen, zeitgesteuerte Tasks (senden je Feuerung den vollen Kontext), Hintergrundfunktionen (<0,04 USD/Session, vernachlässigbar).

## 3. Fallstudie: dieses Forschungsprogramm

Messpunkte [intern], Tokenzähler der Workflow-Läufe (ohne Differenzierung Cache-Read/Write, daher Kostenangaben als Bandbreite zu Listenpreisen):

| Lauf | Tokens | je Agent | API-Kosten (Sonnet-Klasse, Blend 80/20 In/Out, mit/ohne Cache-Effekt) |
|---|---|---|---|
| Sweep, 14 Recherche-Agenten | ~1,0 Mio. | ~70k | ~2–4 USD |
| Abgebrochener Erstlauf | ~0,6 Mio. | — | ~1,5–2,5 USD (versenkt) |
| Ökosystemlauf, 3 Agenten | ~0,38 Mio. | ~125k | ~1–2 USD |
| **Programm gesamt (inkl. Konsolidierung, geschätzt)** | **~2,5–3 Mio.** | — | **~8–15 USD; Opus-Klasse wäre ~2,5× teurer** |

Drei Lehren: (1) **Ein kompletter Recherche-Sweep kostet zu API-Preisen einen einstelligen Dollarbetrag** — weniger als ein Monat Pro; die 15×-Multiplikator-Warnung relativiert sich bei Recherche-Workloads, weil der Aufgabenwert (Entscheidungsgrundlage für Monate) die Tokenkosten trivial übersteigt. (2) **Der Abbruchverlust des Erstlaufs (~0,6 Mio. Tokens ≈ 37 % des Sweep-Volumens) ist der eigentliche Kostentreiber** — nicht der Preis pro Token, sondern Läufe ohne Checkpoint/Resume. Workflows mit Resume-Fähigkeit und Zwischenablage je Agent (Dossier einzeln auf Disk) begrenzen den Wiederholungsverlust auf den letzten Agenten. (3) **Der reale Engpass war das Abo-Fenster:** Zwei parallele Workflows auf einem nicht erweiterten Abo rissen das Session-Limit — zu Listenpreisen wäre derselbe Moment für unter 10 USD durchgelaufen. Faustregel daraus: **maximal ein schwerer Workflow je 5h-Fenster auf Pro; zwei bis drei auf Max 5x; oder Batch-Läufe gleich auf den API-Key legen.**

## 4. CI, Routines, Scheduled Tasks

**GitHub Actions** ([docs.github.com](https://docs.github.com/en/billing/concepts/product-billing/github-actions) [V]): Free 2.000 min/Monat + 500 MB Artefakt-Storage (private Repos), Pro 3.000 min + 1 GB; **public Repos und self-hosted Runner kostenlos**. Minutenpreise: Linux 0,006, Windows 0,010 (1,7×), macOS 0,062 USD (~10×). Rechnung: Ein 10-minütiger Linux-CI-Lauf kostet 0,06 USD — **bei Agenten-CI dominiert immer der Token-, nie der Runner-Preis.** Ein `@claude`-Issue-zu-PR-Lauf via claude-code-action (API-Key als Secret [V-D06]) liegt je nach Turns typischerweise bei 0,25–3 USD; die Kostenbremse ist `--max-turns` plus Concurrency-Limit, nicht das Minutenkontingent. Self-hosted Runner auf dem Windows-VPS sparen nichts Relevantes und kaufen eine RCE-Oberfläche ein (Dossier 06) — nur für die Windows-spezifischen Pfade erwägen, Standard-CI auf `ubuntu-latest`.

**Zeitgesteuerte Läufe** [V-D14]: Cloud-Routines (Research Preview, Pro/Max+, min. stündlich) laufen auf Anthropic-Infrastruktur und ziehen aus demselben Plan-Kontingent — **ohne Permission-Prompts und ohne eigenes Preisschild**; Desktop Scheduled Tasks und `/loop` laufen lokal (min. 1 min) und senden je Feuerung den vollen Kontext [V]. Kostenregel: Wiederkehrende Tasks brauchen eine Kontextdiät (kleiner Prompt, keine fetten CLAUDE.md/MCP-Kataloge) und Haiku/Sonnet statt Opus, sonst frisst ein stündlicher Task still das Wochenfenster. Serverseitige Code Execution ist mit 1.550 Gratis-Stunden/Monat, danach 0,05 USD/h, praktisch kostenlos [V-D14].

## 5. Kostenkontrolle als Methodikbaustein

1. **Budget je Lauf ins Run-Manifest** (erweitert Dossier-03-Konsequenz 7): Sollwerte *vor* dem Lauf (Modellklasse, `maxTurns` je Subagent, Token-Budget mit Workflow-Warnschwelle, Zeitbudget), Istwerte *nach* dem Lauf (`total_cost_usd` und Tokenzahlen aus `claude -p --output-format json` [V-D14]; im Abo-Betrieb ersatzweise Fensteranteil laut `/usage`, dessen Dollarangabe lokal aus Listenpreisen berechnet ist [V]).
2. **Caps auf drei Ebenen:** hart im Werkzeug (`--max-turns`, Workflow-Größe `small/medium`, `MAX_THINKING_TOKENS`/`/effort`), finanziell am Konto (Workspace-Spend-Limits im Console; Monats-Cap der Usage Credits), prozedural im Prompt (Stagnationsregel „zwei Runden ohne Fortschritt → Stopp", Abbruch bei Budgetstand X mit Zwischenergebnis-Pflicht).
3. **Abbruch darf nicht Totalverlust heißen:** Jeder Mehragentenlauf schreibt Teilergebnisse sofort auf Disk (ein Artefakt je Agent), Workflows resumierbar wählen — die 0,6 Mio. versenkten Tokens des Erstlaufs sind das Gegenbeispiel.
4. **Monatliches Kosten-Review** (5 Minuten): `/usage`-Wochenansicht (attribuiert nach Skills/Subagents/MCP-Servern und flaggt Long-Context/Cache-Miss ab 10 % Anteil [V]), Console-Usage-Page für API-Anteile, Actions-Minutenverbrauch. Erst bei wiederholter Wochenfenster-Erschöpfung Stufe wechseln.

## 6. Faustformeln und Entscheidungstabelle

**Faustformeln:** (F1) 1 Mio. agentische Tokens ≈ 2,5–4 USD Sonnet-Klasse, ≈ 7–10 USD Opus-Klasse (Listenpreise, cacheabhängig). (F2) Recherche-Subagent ≈ 70–130k Tokens ≈ 0,25–0,70 USD je Dossier. (F3) Chat 1× → Agent 4× → Teams ~7× → Multi-Agent-Fanout ~15×. (F4) Fanout nur, wenn Aufgabenwert ≥ 10–15× Tokenkosten und ein Verifier existiert. (F5) Modell-Upgrade vor Token-Verdopplung. (F6) CI: Tokens dominieren Runner-Minuten um Faktor ~10–100. (F7) Abo-Planung in Fenstern, nicht Dollars: ein schwerer Workflow je 5h-Fenster (Pro), zwei bis drei (Max 5x).

| Aufgabentyp | Muster | Tokens/Lauf | API-Kosten (Sonnet-Kl.) | Pfad-Empfehlung |
|---|---|---|---|---|
| Kleine Fixes, Fragen, Routine | Einzelsession (Haiku/Sonnet) | <0,1 Mio. | <0,50 USD | Abo |
| Standard-Feature attended | Agent + Explore/Review-Subagents | 0,1–0,5 Mio. | 0,5–3 USD | Abo |
| Repo-Audit, Recherche-Sweep | Workflow, 5–15 Subagents | 0,5–1,5 Mio. | 3–10 USD | Abo seriell; bei Parallelbedarf oder Fensterknappheit API-Key |
| Schwerer Bug, Architektur-Spike | Best-of-N (2–3) + Verifier, Opus-Klasse | 0,3–1 Mio. | 3–10 USD | Abo |
| Issue→PR im CI | claude-code-action, `--max-turns` | 0,05–0,3 Mio. | 0,25–3 USD | API-Key (Secret) |
| Wiederkehrende Checks | Routine (Cloud) / Desktop Task, Kontextdiät | klein, aber Dauerlast | im Abo-Fenster | Abo; Frequenz/Kontext streng begrenzen |
| Parallel-Review-Experimente | Agent Teams (~7×) | hoch | — | nur Pilot, Sonnet, klein |

---

## Konsequenzen für Andreas

1. **Abo-Leiter statt Entweder-oder: Max 5x als Fundament.** Der beobachtete Session-Limit-Abbruch zeigt, dass ein nicht erweitertes Abo für parallele Workflows nicht reicht; die dokumentierten Max-5x-Bandbreiten (50–200 Prompts/5h, 140–280 Sonnet-Wochenstunden) decken den Methodik-Alltag inkl. eines Workflows pro Fenster. **Usage Credits mit kleinem Monats-Cap (20–40 USD) aktivieren** — das ist der offizielle Überlauf zu API-Preisen und billiger als ein vorschnelles 20x-Upgrade. Upgrade auf Max 20x erst nach zwei Monaten mit wiederholter Wochenfenster-Erschöpfung laut `/usage`.
2. **Zweigleisig fahren: Console-API-Key für alles Unbeaufsichtigte.** CI (claude-code-action), Agent-SDK-Automatisierung auf dem VPS und reproduzierbare Experimente (E-Serie aus Dossier 08) auf den API-Key mit Workspace-Spend-Limit (Start: 25 USD/Monat) — exakte Kosten je Lauf, keine Kollision mit dem interaktiven Fenster. Batch-API (−50 %) für Massen-Nichtinteraktives im SDK; Sonnet-5-Promo-Preis endet 31.08.2026, danach +50 % einplanen.
3. **Kostenfelder ab sofort ins Run-Manifest** (Soll: Modell, maxTurns, Token-/Zeitbudget; Ist: total_cost_usd bzw. Fensteranteil, Tokens je Modell, Abbruchgrund) plus Resume-fähige Workflows mit Artefakt-je-Agent — der 0,6-Mio.-Token-Verlust des Erstlaufs war ein Prozess-, kein Preisproblem.
4. **Recherche-Fanout guten Gewissens weiter nutzen:** 15× klingt teuer, ist aber bei Sweeps dieses Zuschnitts einstellige Dollar; die Verifikationsbandbreite (Dossier 03/17), nicht das Tokenbudget, bleibt der limitierende Faktor. Opus-Klasse gezielt für Synthese/Architektur, Sonnet für Breitenrecherche, Haiku für mechanische Subtasks.
5. **Zeitpläne fenster-bewusst bauen:** Routines/Scheduled Tasks ziehen still aus dem Plan-Kontingent und feuern mit vollem Kontext — Kontextdiät, moderate Frequenz, und schwere wiederkehrende Läufe eher als API-getriggerte SDK-Jobs auf dem VPS.
6. **CI-Kostenmodell entwarnt:** GitHub-Free/Pro-Minuten reichen für alle 11 Projekte, solange Tests auf Linux laufen; Kostensteuerung gehört an `--max-turns` und Concurrency, nicht an die Minuten.

## Quellenverzeichnis

1. [V] claude.com/pricing — Abo-Stufen Pro/Max/Team/Enterprise (abgerufen 2026-07-28)
2. [V] support.claude.com/en/articles/11145838 — „Using Claude Code with your Pro or Max plan": 5h-Fenster, Wochenlimits, Prompt-/Stunden-Bandbreiten je Stufe (abgerufen 2026-07-28; referenziert noch Sonnet-4/Opus-4-Generation)
3. [V] support.claude.com/en/articles/12429409 — Usage Credits: Abrechnung zu Standard-API-Preisen, Monats-Cap, Auto-Reload, 2.000-USD-Tagesdeckel (abgerufen 2026-07-28)
4. [V] platform.claude.com/docs/en/about-claude/pricing — API-Preise Opus 5, Sonnet 5 (Promo bis 31.08.2026), Haiku 4.5; Caching-Multiplikatoren; Batch −50 % (abgerufen 2026-07-28)
5. [V] code.claude.com/docs/en/costs — 13 USD/Entwickler-Aktivtag, 150–250 USD/Monat, 90 % < 30 USD/Tag; Agent Teams ~7×; Cache-Lebensdauer 1 h Abo vs. 5 min Credits/API; `/usage`-Attribution; Background < 0,04 USD/Session (abgerufen 2026-07-28)
6. [V] anthropic.com/engineering/multi-agent-research-system — Agenten ≈ 4× Chat, Multi-Agent ≈ 15×; Tokens erklären 80 % Varianz; Ökonomie-Kriterien (abgerufen 2026-07-28)
7. [V] docs.github.com/en/billing/concepts/product-billing/github-actions — Kontingente Free/Pro, Minutenpreise Linux/Windows/macOS, self-hosted/public kostenlos (abgerufen 2026-07-28)
8. [V-D14] code.claude.com/docs/en/scheduled-tasks + /routines — drei Ebenen der Zeitsteuerung; Routines Pro/Max+, min. stündlich, promptfrei
9. [V-D14] code.claude.com/docs/en/headless — `claude -p`, `--bare`, `total_cost_usd` im JSON-Output
10. [V-D14] platform.claude.com Code-Execution-Tool — 1.550 Gratis-Stunden/Monat, dann 0,05 USD/h
11. [V-D03] Claude-Code-Workflows-Doku — Caps 16 parallel/1.000 Agenten, Warnschwellen 25 Agenten/1,5 Mio. Tokens
12. [V-D06] code.claude.com/docs/en/github-actions — claude-code-action@v1, API-Key als Secret, `claude_args`/`--max-turns`
13. [intern] Messpunkte dieses Forschungsprogramms (Workflow-Tokenzähler, 2026-07-28): Sweep 14 Agenten ~1,0 Mio.; abgebrochener Erstlauf ~0,6 Mio.; Ökosystemlauf 3 Agenten ~0,38 Mio.; ein Session-Limit-Abbruch bei zwei parallelen Workflows auf nicht erweitertem Abo
14. [S] Sekundärübersichten zu Claude-Limits 2026 (morphllm.com, ccforeveryone.com u. a.) — nur als Konsistenz-Gegencheck, nicht zitierfähig gegenüber 2/3
