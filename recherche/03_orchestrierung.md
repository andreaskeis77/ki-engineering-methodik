# Dossier 03 — Agentenrollen, Multi-Agent-Orchestrierung und Parallelisierung

**Stand: 2026-07-28.** Quellenstatus-Konvention: **[V]** = Primärquelle am 2026-07-28 selbst abgerufen und inhaltlich geprüft; **[S]** = nur über Suchergebnisse belegt. Nummern (Q1…) verweisen auf das Quellenverzeichnis.

---

## Executive Summary

Die Debatte "Einzelagent vs. Multi-Agent" hat sich 2025–2026 empirisch geklärt: Beide Lager haben Recht — für unterschiedliche Aufgabentypen. Anthropics Orchestrator-Worker-System schlägt einen Einzelagenten bei breit parallelisierbaren Rechercheaufgaben um 90,2 %, verbraucht aber ~15× so viele Tokens wie ein Chat (Q1). Cognition zeigt umgekehrt, dass eng gekoppelte Schreibarbeit an gemeinsamem Code in einem single-threaded Agenten mit vollem Kontext zuverlässiger ist, weil parallele Agenten implizit widersprüchliche Entscheidungen treffen (Q9). Die Berkeley-MAST-Studie liefert die Taxonomie dazu: 14 Fehlermodi in drei Klassen (Spezifikation, Inter-Agent-Misalignment, Verifikation), und Multi-Agent-Gewinne auf Benchmarks sind oft minimal — Orchestrierung ist ein Designproblem, kein Selbstzweck (Q10). Rollensimulationen ganzer Softwarefirmen (MetaGPT/ChatDev) gelten heute als Forschungsartefakt; produktiv durchgesetzt haben sich wenige, entlang von Kontext- und Berechtigungsgrenzen geschnittene Rollen: Planner/Lead, Implementer, Explorer und vor allem der unabhängige Reviewer mit frischem Kontext. Dessen Wert ist inzwischen hart belegt: LLMs korrigieren byte-identische Fehler 23–93 Prozentpunkte häufiger, wenn sie als fremd statt als eigen präsentiert werden (Q12). Kompetitive Lösungsagenten (Best-of-N) skalieren nachweislich — SWE-bench-Coverage steigt log-linear mit der Zahl der Versuche (15,9 % → 56 % bei 250 Samples) — aber nur, wo ein harter automatischer Verifier existiert; ohne ihn plateauiert die Auswahl (Q13, Q21). Produktseitig deckt Claude Code inzwischen alle Orchestrierungsmuster ab: Subagents (Kontextisolation), Agent Teams (experimentell, Shared-Task-Liste, Messaging), Agent View/Background-Sessions, Dynamic Workflows (Skript als Orchestrator, bis 16 parallel, Cap 1.000 Agenten) und Worktree-Isolation als Integrationsfundament (Q2–Q8). Die Konkurrenz konvergiert auf dasselbe Muster: asynchrone Task-Agenten mit dem Pull Request als Integrationsvertrag und Separation of Duties (Codex, Copilot Coding Agent, Jules, Devin, Cursor) (Q15–Q18, Q20). Der Engpass verschiebt sich damit messbar von der Codeerzeugung zur menschlichen Review- und Integrationskapazität — was Andreas' Konzept der Verifikationsbandbreite als WIP-Limit direkt bestätigt; die METR-RCT (erfahrene Entwickler mit KI 19 % langsamer, gefühlt 20 % schneller) mahnt zusätzlich, Parallelität nie nach gefühltem Tempo zu bewerten (Q14, Q23).

---

## 1. Einzelagent vs. spezialisierte Rollen: Was Forschung und Praxis tragen

Die frühen Rollen-Frameworks MetaGPT und ChatDev (simulierte Firma mit Product Manager, Architect, Engineer, QA und SOPs als Koordinationsprotokoll) begründeten das Paradigma, gelten aber für Produktivcode als überholt: Ihre Gewinne stammen primär aus erzwungenen Zwischenartefakten (Spezifikationen, strukturierte Übergaben), nicht aus der Personensimulation (Q19). Die MAST-Analyse von 1.600+ annotierten Traces über 7 Frameworks zeigt, dass genau diese Systeme systematisch an Spezifikationsbrüchen, Inter-Agent-Misalignment und fehlender Abschlussverifikation scheitern und ihre Benchmark-Gewinne "oft minimal" sind (Q10).

Die belastbare Synthese aus Anthropic (Q1) und Cognition (Q9) lautet:

- **Parallelisiere Lesen, serialisiere/partitioniere Schreiben.** Multi-Agent gewinnt bei breadth-first-Aufgaben mit unabhängigen Teilfragen (Recherche, Codebase-Audit, Review aus mehreren Blickwinkeln). Bei eng gekoppelter Schreibarbeit erzeugen parallele Agenten konfligierende implizite Entscheidungen ("actions carry implicit decisions") — dort ist ein linearer Agent mit vollem Kontext überlegen.
- **Rollen sind Kontext- und Berechtigungsgrenzen, keine Jobtitel.** Der praktische Nutzen einer "Rolle" liegt in: eigenem Kontextfenster (Isolation von Suchmüll), eingeschränkten Tools (Reviewer read-only), eigenem Modell (Kostensteuerung) und fokussiertem Systemprompt. Genau so sind Claude-Code-Subagents definiert (Q2).
- **Requirements und Architektur bleiben beim Menschen verankert.** Kein untersuchtes Produkt delegiert Anforderungsentscheidungen autonom; das Interview-/Spec-Muster (Agent interviewt den Owner, schreibt SPEC.md, frische Session implementiert) ist die dokumentierte Best Practice (Q8).

Hierarchische Systeme sind in der validierten Praxis **genau zweistufig**: ein Orchestrator/Lead plus Worker (Anthropic Q1; MultiDevin: ein Manager-Devin steuert bis zu 10 Worker für Backlogs und Migrationen, Q20). Claude Code hält Hierarchien bewusst flach: Teams können nicht verschachtelt werden, der Lead ist nicht übertragbar, Teammates können keine eigenen Teams gründen (Q3). Tiefere Hierarchien sind derzeit nicht belastbar.

## 2. Orchestrierungsmuster im Produktstand: Claude Code als Referenz

Claude Code bietet 2026 vier klar getrennte Parallelisierungsmechanismen plus zwei Querschnittsdienste (Q5):

| Mechanismus | Koordination | Kommunikation | Status |
|---|---|---|---|
| **Subagents** (Q2) | Hauptagent delegiert, erhält Zusammenfassung | nur Rückgabe an Aufrufer | stabil, Standard |
| **Agent View / Background-Sessions** (Q5) | Mensch dispatcht unabhängige Sessions (`claude agents`), jede automatisch im eigenen Worktree | nur an den Menschen | Research Preview |
| **Agent Teams** (Q3) | Lead-Session + Teammates, geteilte Task-Liste mit Dependencies und File-Locking beim Claiming, Mailbox-Messaging | Teammates untereinander direkt | experimentell, opt-in (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) |
| **Dynamic Workflows** (Q6) | JavaScript-Skript hält den Plan; Runtime führt aus | Skript-Variablen statt Kontext | neu (v2.1.154+), alle Bezahlpläne |

Wesentliche Detailbefunde:

- **Subagents** sind Markdown-Dateien mit YAML-Frontmatter (`tools`, `model`, `permissionMode`, `maxTurns`, `isolation: worktree`, `background`). Eingebaute Typen: Explore und Plan (read-only, Write/Edit verweigert) — d. h. Anthropic selbst kodifiziert die Rollen "Rechercheur" und "Planer" als tool-beschränkte Agenten (Q2).
- **Agent Teams** liefern die Bausteine für Planner-Worker-Reviewer-Modelle: Plan-Approval-Pflicht (Teammate bleibt im read-only Plan Mode, bis der Lead den Plan freigibt bzw. mit Begründung ablehnt), Qualitäts-Gates über Hooks (`TeammateIdle`, `TaskCreated`, `TaskCompleted` — Exit-Code 2 verhindert Idle/Abschluss und sendet Feedback), sowie explizite Team-Size-Heuristik: 3–5 Teammates, 5–6 Tasks pro Teammate, "drei fokussierte schlagen fünf verzettelte" (Q3). Wichtig: Teammates werden **nicht** automatisch worktree-isoliert — Dateikonflikte werden durch Arbeitsaufteilung vermieden, nicht durch Merge-Magie.
- **Dynamic Workflows** verschieben die Orchestrierung vom Modellkontext in ein lesbares, wiederholbares Skript: bis 16 gleichzeitige Agenten, hartes Limit 1.000 Agenten pro Lauf, Warnung ab 25 Agenten bzw. 1,5 Mio. projizierten Tokens, resumierbar mit gecachten Teilergebnissen. Das gebündelte `/deep-research` demonstriert das Zielmuster: Fan-out, Cross-Checking, Voting pro Claim, ungeprüfte Claims werden als solche ausgewiesen (Q6). Für Andreas' Reproduzierbarkeits- und Audit-Anspruch ist das die interessanteste Neuerung: Orchestrierung als versionierbares Artefakt.
- **Hooks** machen Gates deterministisch: `PreToolUse` (blockieren), `PostToolUse`/`PostToolBatch` (validieren), `Stop`/`SubagentStop` (Beenden verhindern, solange Qualitätskriterien nicht erfüllt sind) — durchgängig mit Exit-Code-2-Semantik (Q7).

## 3. Wettbewerber: Konvergenz auf den PR als Integrationsvertrag

- **OpenAI Codex** (Q15): Cloud-Agent, jede Aufgabe in isolierter Sandbox mit vorgeladenem Repo; Evidenz über zitierte Terminal-Logs und Testausgaben; AGENTS.md als Steuerdatei; explizite Empfehlung, mehrere gut geschnittene Aufgaben parallel zu delegieren. 2026 als Desktop-App mit Multi-Agent-Ansicht ausgebaut (Q22 [S]).
- **GitHub Copilot Coding Agent** (Q16): Zuweisung per Issue, ephemere GitHub-Actions-Umgebung, Arbeit ausschließlich auf selbst erstellten Branches, Draft-PR mit Session-Logs, Branch Protections bleiben aktiv — und als bemerkenswerteste Governance-Regel: **der Beauftragende darf den PR nicht selbst approven** (Separation of Duties). Parallelbetrieb über mehrere zugewiesene Issues; die Copilot-App orchestriert 2026 mehrere Agenten parallel (Q22 [S]).
- **Google Jules** (Q17): asynchroner Agent auf Cloud-VM, Plan-Approval vor Ausführung, Diff + PR als Ergebnis; Staffelung nach Concurrency (3/15/60 gleichzeitige Tasks je Stufe) — Parallelität ist hier explizit das Preismodell.
- **Devin/Cognition** (Q9, Q20): interessanteste Doppelposition. Produktseitig MultiDevin (Manager + bis 10 Worker) für Backlogs, Migrationen, isolierte wiederholbare Tasks; architektonisch zugleich das prominenteste Plädoyer gegen feingranulare Multi-Agent-Kollaboration. Die Auflösung: Parallelität über **unabhängige Aufgaben** ja, geteilte Schreibarbeit mit Kontextfragmentierung nein.
- **Cursor 2.0/3** (Q18, Q22 [S]): Multi-Agent-Interface als Kernprodukt; parallele Agenten via Git-Worktrees oder Remote-Maschinen; dokumentierter Befund, dass **dasselbe Prompt an mehrere Modelle** mit Auswahl des besten Ergebnisses die Qualität bei schweren Aufgaben spürbar hebt (produktisiertes Best-of-N); nativer Browser-Tool-Loop für Selbstverifikation.

Gemeinsamer Nenner aller Anbieter: ephemere, isolierte Ausführungsumgebung → Branch → Draft-PR → menschliche oder unabhängige Review → kontrollierter Merge. Der Pull Request ist der stabile Integrations- und Auditpunkt, nicht direkte Merges durch Agenten.

## 4. Parallele Entwicklung über Git: Worktrees und kontrollierte Integration

Git-Worktrees sind 2026 der De-facto-Standard für parallele Agentenarbeit am selben Repo (Q4, Q18):

- Claude Code: `claude --worktree <name>` erzeugt Checkout unter `.claude/worktrees/` auf eigenem Branch; `worktree.baseRef` steuert Basis (`fresh` = Default-Branch, `head` = aktueller Stand); `.worktreeinclude` kopiert gitignorierte Dateien (.env etc.); Subagents per `isolation: worktree` dauerhaft isolierbar; periodischer Sweep räumt nur Worktrees ohne ungesicherte Arbeit ab; `--worktree "#1234"` checkt direkt einen PR aus (Q4).
- Das `/batch`-Skill zeigt das Zielmuster für Massenänderungen: eine große Änderung wird auf 5–30 worktree-isolierte Subagents verteilt, **jeder öffnet einen eigenen PR** (Q5).
- Windows-Spezifika sind adressiert (NTFS-Junctions/Symlinks beim Entfernen), aber Split-Pane-Teams via tmux funktionieren nicht in Windows Terminal — der In-Process-Modus ist dort der richtige Weg (Q3, Q4).

**Konfliktlösung ist primär Konfliktvermeidung:** Alle untersuchten Systeme setzen auf disjunkte Dateimengen bzw. Ownership pro Agent (Agent Teams: "Break the work so each teammate owns a different set of files", Q3), kleine Task-Zuschnitte und schnelle Integration statt auf automatisches Mergen konkurrierender Edits. Wo Agenten sich widersprechen, entscheidet der Lead (Plan-Rejection mit Feedback) oder ein Debattenformat: Der dokumentierte "Competing Hypotheses"-Use-Case lässt 5 Teammates gegenseitig ihre Theorien widerlegen, weil sequentielle Untersuchung nachweislich am Anker-Effekt leidet (Q3). Auf Claim-Ebene nutzt `/deep-research` Voting mit Herausfiltern nicht bestätigter Aussagen (Q6).

## 5. Kompetitive Agenten und unabhängige Verifikation

Drei Forschungsstränge tragen die Empfehlung, Erzeugung und Prüfung zu trennen:

1. **Repeated Sampling skaliert — mit Verifier.** Coverage wächst log-linear über vier Größenordnungen an Versuchen; SWE-bench Lite: 15,9 % (1 Versuch) → 56 % (250 Versuche, DeepSeek-Coder-V2). Aber: Majority Voting und Reward-Modelle plateauieren ohne automatische Verifikation — der Engpass ist die Auswahl, nicht die Erzeugung (Q13). CodeMonkeys (Stanford) erreichte mit kombiniertem seriellem+parallelem Scaling und Voting-then-Testing 57,4 % auf SWE-bench Verified (Q21 [S]). Für die Praxis: Best-of-N lohnt genau dann, wenn Tests/Builds als harter Schiedsrichter existieren — das koppelt Parallelität direkt an Test-first-Disziplin.
2. **Selbstkorrektur ist eine Illusion, Fremdkorrektur funktioniert.** Byte-identische fehlerhafte Claims werden 23–93 Prozentpunkte häufiger korrigiert, wenn sie als Nutzernachricht/Tool-Output statt als eigener `<thought>` erscheinen (10 von 13 Zellen p<0,001). Der unabhängige Review-Agent mit frischem Kontext ist damit keine Prozessfolklore, sondern nutzt eine messbare Asymmetrie (Q12). Anthropic operationalisiert das: Reviewer-Subagent sieht **nur Diff und Kriterien**, nicht die Entstehungsgeschichte ("so it evaluates the result on its own terms") — mit der wichtigen Warnung, dass ein auf Lückensuche geprompteter Reviewer immer Lücken meldet und Over-Engineering provoziert; Findings daher auf Korrektheit/Anforderungen beschränken (Q8).
3. **Test-Time-Scaling für Agenten wirkt selektiv.** Parallel Sampling, sequentielle Revision, Verifier und diversifizierte Rollouts verbessern Agentenleistung; listenweise Verifikation (Kandidaten gemeinsam vergleichen) schlägt paarweise/punktweise Bewertung; der Zeitpunkt der Reflexion ist entscheidend (Q11).

Das produktreife Muster ist der **Writer/Reviewer-Split**: eine Session implementiert, eine zweite mit frischem Kontext reviewt gegen Plan/Kriterien; Varianten sind Test-Writer vs. Implementer sowie das gebündelte `/code-review`-Skill (Q8).

## 6. Autonome Schleifen und Abbruchkriterien

Der Werkzeugkasten zur Schleifenbegrenzung ist 2026 produktreif und mehrschichtig (Q6–Q8):

- **Ziel-Gates:** `/goal` prüft nach jedem Turn per separatem Evaluator, ob die Bedingung hält; Stop-Hooks blockieren das Beenden bis zum Bestehen eines Checks — mit eingebauter Notbremse: nach **8 aufeinanderfolgenden Blocks** überstimmt Claude Code den Hook und beendet den Turn (Anti-Endlosschleife) (Q7, Q8).
- **Harte Limits:** `maxTurns` pro Subagent; Workflow-Caps (16 parallel, 1.000 Agenten/Lauf, Warnschwellen 25 Agenten / 1,5 Mio. Tokens); Task-Completion-Gates via Hook (Q2, Q6, Q7).
- **Fortschrittsbasierte Abbruchkriterien** sind als Prompt-Muster kodifiziert: "fixe, bis der Check besteht **oder zwei Runden in Folge keinen Fortschritt bringen**" bzw. "suche, bis zwei Runden nichts Neues finden" (Q6). Das ist das wichtigste übertragbare Kriterium: Abbruch bei Stagnation, nicht nur bei Budget.
- **Community-Praxis:** Der "Ralph-Wiggum-Loop" (Agent in Endlosschleife gegen einen Plan/PROMPT.md, bekannt durch G. Huntley) ist 2026 viral, funktioniert aber nur mit exakt diesen Zutaten — deterministische Checks, Budget-/Iterationslimits, frischer Kontext pro Iteration; ohne Gates ist er Token-Verbrennung (Q24 [S]).
- **Anthropic-Grundregel:** Agenten stoppen, wenn Arbeit "fertig aussieht" — ohne ausführbaren Check ist der Mensch die Verifikationsschleife. Jede unbeaufsichtigte Schleife braucht daher einen maschinenlesbaren Pass/Fail-Anker (Tests, Build, Screenshot-Diff) plus Evidenzpflicht statt Erfolgsbehauptung (Q8).

## 7. Grenzen und Ökonomie: Wann lohnt Fan-out?

Die Zahlen setzen den Rahmen: Agenten ≈ 4× Chat-Tokens, Multi-Agent ≈ 15×; Token-Einsatz erklärt 80 % der Leistungsvarianz; Modell-Upgrade schlägt Token-Verdopplung; Parallelisierung senkte Recherchezeit um bis zu 90 % (Q1). Teams-Kosten skalieren linear mit Teammates; Koordinationsoverhead wächst überproportional; "diminishing returns" jenseits von 3–5 Workern (Q3). Die METR-RCT zeigt zusätzlich, dass erfahrene Entwickler in vertrauten Codebases mit KI **19 % langsamer** waren, sich aber 20 % schneller fühlten — Wahrnehmung ist als Steuerungsgröße unbrauchbar; Review-/Verifikationsaufwand frisst Generierungsgewinne, wenn Qualitätsstandards hoch sind (Q14). Branchenweit gilt Code-Review inzwischen als der neue Engpass paralleler Agentenflotten (Q23 [S]).

**Entscheidungsheuristik Fan-out (kondensiert aus Q1, Q3, Q6, Q8, Q9, Q13):** Parallelisieren, wenn (a) Teilaufgaben unabhängig und read-heavy sind (Recherche, Audit, Review-Perspektiven, Hypothesentest), (b) schreibende Teilaufgaben disjunkte Dateimengen haben, (c) ein automatischer Verifier die Ergebnisse bewertet, und (d) der Aufgabenwert 10–15× Tokenkosten trägt. Nicht parallelisieren bei eng gekoppelten Änderungen, gemeinsamen Dateien, sequentiellen Abhängigkeiten, kleinen Routineaufgaben — und nie über die eigene Review-Kapazität hinaus.

---

## Konsequenzen für Andreas' Methodik und Projekte

1. **Verifikationsbandbreite als WIP-Limit ist der bestätigte Kernregler.** Alle Evidenzlinien (15×-Tokenökonomie Q1, Review-Bottleneck Q23, METR Q14) zeigen: Der Engpass ist Prüfkapazität, nicht Erzeugung. Empfehlung: WIP-Limit explizit als "max. N offene, ungeprüfte Agenten-PRs" definieren (Start: 2–3), nicht als Zahl laufender Agenten.
2. **Rollenkatalog verschlanken statt ausbauen.** Statt neun Personas ein Kernset mit hartem Berechtigungsschnitt: Mensch als Chefarchitekt/PO (Requirements, Architekturentscheide, Merge-Freigabe); Hauptsession als Planner/Lead; Implementer (schreibend, worktree-isoliert); unabhängiger Reviewer und Security-Reviewer (read-only Tools, sieht nur Diff + Kriterien + Spec); Explore/Research (read-only). Test gehört in den Implementer-Loop (hermetische Gates) plus separaten Review der Testqualität — nicht als eigene Dauerrolle. Rollen als versionierte `.claude/agents/*.md` mit `tools`-Allowlist umsetzen (Q2); die Warnung vor Reviewer-Over-Engineering (Q8) in die Reviewer-Prompts übernehmen ("nur Korrektheits-/Anforderungslücken, keine Stilpräferenzen").
3. **Zweitmeinung als Pflicht-Gate verankern, empirisch begründet.** Die Selbstkorrektur-Asymmetrie (Q12) und das Copilot-Modell "Requestor darf nicht approven" (Q16) liefern die Begründung für eine Methodikregel: Kein Agenten-Diff gilt als fertig ohne Review durch eine Instanz mit frischem Kontext; ab Autoritätsstufe A4 zusätzlich menschliche Stichprobe am PR.
4. **Orchestrierungsstufen an Autoritätsstufen koppeln.** Vorschlag: A0–A2 Einzelsession; A3 + Subagents (Explore/Review); A4 + Background-Sessions/Agent View mit Worktree+PR-Pflicht; A5 + Dynamic Workflows bzw. (nach Stabilisierung) Agent Teams, ausschließlich mit hermetischen Test-Gates und Stop-Hook-Kriterien. Agent Teams heute nur als Pilot für read-lastige Fälle (Parallel-Review, Bug-Hypothesen bei der NFL-Plattform oder der Sensorik-Fehlersuche) — experimentell, keine Worktree-Isolation, kein Session-Resume (Q3).
5. **Dynamic Workflows pilotieren — sie passen exakt zum Run-Manifest-Gedanken.** Ein gespeicherter Workflow ist reproduzierbare, versionierbare, auditierbare Orchestrierung (Skript + Phasen + Agentenzahl + Tokenverbrauch sichtbar). Kandidaten: Repo-weite Audits (OWASP-Anker), Migrationsläufe in der Infra-Transformation, Quellen-Cross-Checks der Wissensplattformen. Größenrichtlinie `small/medium` setzen, Kosten zuerst an einer Teilmenge messen (Q6).
6. **Worktree-Disziplin als Default für alles Schreibende.** `isolation: worktree` für schreibende Subagents, `.worktreeinclude` für .env, `worktree.baseRef` bewusst wählen, `/batch`-Muster (ein PR pro Teilaufgabe) für Massenänderungen. Windows: In-Process-Teams statt tmux; Worktree-Handling ist seit v2.1.205+ Windows-sicher (Junctions) (Q3, Q4).
7. **Abbruchkriterien ins Run-Manifest kodifizieren.** Pro autonomem Lauf: maschinenlesbares Erfolgskriterium (Test/Build), `maxTurns`/Rundenlimit, Stagnationsregel ("zwei Runden ohne Fortschritt → Stopp + Eskalation"), Token-/Zeitbudget, Evidenzpflicht (Logs, Testoutput) statt Erfolgsbehauptung. Stop-Hook + `/goal` für unbeaufsichtigte Läufe; die 8-Block-Override-Grenze als gegebene Obergrenze einplanen (Q7, Q8).
8. **Best-of-N gezielt, nicht flächig.** Kompetitive Lösungsagenten nur für schwere, testbare Probleme (kniffliger Bug, Algorithmus, Architektur-Spike als Plan-Wettbewerb mit anschließender Lead-Auswahl) — der Verifier muss vor dem Fan-out existieren (Q13, Q18). Für Routinearbeit ist ein Agent mit gutem Kontext billiger und besser (Q9).

---

## Bewertungstabelle

| Methode / Technologie | Einordnung für Andreas' Kontext | Begründung (Quellen) |
|---|---|---|
| Subagents für Recherche/Review (Kontextisolation, Tool-Restriktion) | **jetzt empfohlen** | stabil, kostenarm, löst Kontextverschmutzung (Q2, Q8) |
| Writer/Reviewer-Split mit frischem Kontext; `/code-review` | **jetzt empfohlen** | empirisch fundiert durch Korrektur-Asymmetrie (Q8, Q12) |
| Git-Worktree-Isolation + PR als Integrationsvertrag | **jetzt empfohlen** | Industriestandard aller Anbieter (Q4, Q15–Q18) |
| Stop-Hooks, `/goal`, `maxTurns`, Stagnationsregeln | **jetzt empfohlen** | deterministische Schleifenbegrenzung, produktreif (Q6–Q8) |
| Dynamic Workflows (Skript-Orchestrierung, `/deep-research`-Muster) | **pilotgeeignet** | neu, aber offiziell, resumierbar, auditierbar; Kosten erst messen (Q6) |
| Agent Teams / Swarm (Shared Tasks, Messaging, Plan-Approval) | **pilotgeeignet bis beobachten** | experimentell, kein Resume, keine Worktree-Isolation; nur read-lastige Piloten (Q3) |
| Kompetitive Lösungsagenten / Best-of-N | **sinnvoll unter Bedingungen** | nur mit hartem Verifier; sonst Auswahl-Plateau (Q13, Q18, Q21) |
| Background-Agenten mit Issue→PR-Loop (Codex/Copilot/Jules-Muster) | **sinnvoll unter Bedingungen** | für gut spezifizierte, isolierte Tasks; Review-Kapazität limitiert (Q15–Q17) |
| Autonome Dauerschleifen (Ralph-Loop) ohne Gates | **derzeit nicht belastbar** | nur mit Checks+Limits sinnvoll; sonst Tokenverbrennung (Q8, Q24) |
| Firmen-Simulation mit vielen Personas (MetaGPT/ChatDev-Stil) | **überdimensioniert / Forschungsartefakt** | Gewinne minimal, Fehlermodi dominieren (Q10, Q19) |
| MultiDevin-artige Agenten-Flotten, Enterprise-Fleet-Management | **überdimensioniert für Privatkontext** | Backlog-Größe rechtfertigt Kosten nicht (Q14, Q20) |
| "Multi-Agent = automatisch besser"-Erzählungen | **überwiegend Marketing** | MAST + Cognition + Tokenökonomie widersprechen (Q1, Q9, Q10) |

---

## Quellenverzeichnis

| Nr. | Quelle | Status |
|---|---|---|
| Q1 | Anthropic Engineering: *How we built our multi-agent research system* — anthropic.com/engineering/multi-agent-research-system | [V] 2026-07-28 |
| Q2 | Claude Code Docs: *Create custom subagents* — code.claude.com/docs/en/sub-agents | [V] 2026-07-28 |
| Q3 | Claude Code Docs: *Orchestrate teams of Claude Code sessions (Agent teams)* — code.claude.com/docs/en/agent-teams | [V] 2026-07-28 |
| Q4 | Claude Code Docs: *Run parallel sessions with worktrees* — code.claude.com/docs/en/worktrees | [V] 2026-07-28 |
| Q5 | Claude Code Docs: *Run agents in parallel* (Vergleich Subagents/Agent View/Teams/Workflows, `/batch`) — code.claude.com/docs/en/agents | [V] 2026-07-28 |
| Q6 | Claude Code Docs: *Orchestrate subagents at scale with dynamic workflows* — code.claude.com/docs/en/workflows | [V] 2026-07-28 |
| Q7 | Claude Code Docs: *Hooks reference* (Stop/SubagentStop/TeammateIdle/TaskCompleted, Exit-Code 2) — code.claude.com/docs/en/hooks | [V] 2026-07-28 |
| Q8 | Claude Code Docs: *Best practices* (Verifikation, Writer/Reviewer, Fan-out, adversarialer Review, 8-Block-Override) — code.claude.com/docs/en/best-practices | [V] 2026-07-28 |
| Q9 | Cognition: *Don't Build Multi-Agents* — cognition.ai/blog/dont-build-multi-agents | [V] 2026-07-28 |
| Q10 | Cemri, Pan et al.: *Why Do Multi-Agent LLM Systems Fail?* (MAST) — arxiv.org/abs/2503.13657 | [V] 2026-07-28 |
| Q11 | *Scaling Test-time Compute for LLM Agents* — arxiv.org/abs/2506.12928 | [V] 2026-07-28 |
| Q12 | *The Self-Correction Illusion: LLMs Correct Others but Not Themselves* — arxiv.org/abs/2606.05976 | [V] 2026-07-28 |
| Q13 | Brown et al.: *Large Language Monkeys: Scaling Inference Compute with Repeated Sampling* — arxiv.org/abs/2407.21787 | [V] 2026-07-28 |
| Q14 | METR: *Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity* (RCT) — metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/ | [V] 2026-07-28 |
| Q15 | OpenAI: *Introducing Codex* — openai.com/index/introducing-codex/ | [V] 2026-07-28 |
| Q16 | GitHub Blog: *GitHub Copilot: Meet the new coding agent* — github.blog | [V] 2026-07-28 |
| Q17 | Google: *Jules* (Produktseite, Tiers/Concurrency) — jules.google | [V] 2026-07-28 |
| Q18 | Cursor: *Introducing Cursor 2.0 and Composer* — cursor.com/blog/2-0 | [V] 2026-07-28 |
| Q19 | Hong et al.: *MetaGPT: Meta Programming for a Multi-Agent Collaborative Framework* (ICLR 2024) — arxiv.org/abs/2308.00352; ChatDev analog | [S] |
| Q20 | Cognition: *September '24 Product Update* / MultiDevin (Manager + bis 10 Worker) — cognition.com/blog/sept-24-product-update; x.com/cognition | [S] |
| Q21 | Ehrlich et al.: *CodeMonkeys: Scaling Test-Time Compute for Software Engineering* — scalingintelligence.stanford.edu/pubs/codemonkeys.pdf | [S] |
| Q22 | Produktstand-Sekundärquellen 2026: Codex-App Multi-Agent (intuitionlabs.ai); Copilot-App GA mit Parallel-Agents (webdeveloper.com); Cursor 3 Worktrees (datacamp.com/blog/cursor-3) | [S] |
| Q23 | Review-Bottleneck-Diskussion 2026: blog.codacy.com (*AI Is Breaking Code Review*); dev.to/code-board (*The Review Bottleneck*); codex.danielvaughan.com (*The Human Review Bottleneck*) | [S] |
| Q24 | Ralph-Wiggum-Loop (Autonome Schleifen, Community-Praxis): ralph-wiggum.ai; paddo.dev/blog/ralph-wiggum-autonomous-loops; leanware.co | [S] |
