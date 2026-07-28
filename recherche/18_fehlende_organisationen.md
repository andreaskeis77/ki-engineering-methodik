# Fehlende Organisationen, Gremien und OSS-Community-Praxis — Lückenschluss zum Sweep

**Stand:** 2026-07-28 (Konsolidierungslauf K3; schließt die Abdeckungslücken aus 00_KRITIK_UND_LUECKEN.md §2 zu NIST/ISO, AWS, NVIDIA/lokaler Inferenz, Microsoft Research, DeepMind, Meta, MIT/Stanford und OSS-Beitrags-Policies)

## Executive Summary

Die im Sweep fehlenden Organisationen liefern drei Sorten Ertrag: wenig (formale Standards), Muster (Big-Tech-Forschung) und harte Empirie (OSS-Community). NIST SSDF 800-218A und ISO/IEC 42001/5338 sind geprüft und für den Privatkontext überdimensioniert — nutzbar bleibt nur ihr Vokabular als Checklisten-Steinbruch. Bei AWS ist der wichtigste Befund die Einstellung von Amazon Q Developer zugunsten von Kiro (EOL-Ankündigung 30.04.2026): ein Lehrstück über Produktbindungsrisiko, während AgentCore als Enterprise-Agenten-Hosting für Andreas irrelevant ist. Lokale GPU-Inferenz (Ollama/llama.cpp) ist 2026 für den Coding-Kernworkflow weiterhin nicht konkurrenzfähig — auf Consumer-Hardware lauffähige Modelle liegen grob 30 Benchmark-Punkte hinter Cloud-Frontier, und Andreas besitzt die nötige GPU nicht; das Datenschutz-/Offline-Argument trägt nur für Nischenaufgaben. DeepMinds AlphaEvolve (GA Juli 2026) und Metas ACH liefern das wertvollste konzeptionelle Muster: evaluator- bzw. mutationsgetriebene Verifikationsschleifen — genau die Richtung der eigenen Review-Gate-These. Die Stanford-100k-Entwickler-Studie liefert den bislang besten Empirie-Anker für aufgabenklassenabhängige Autonomie (Greenfield-einfach +30–35 % bis Brownfield-komplex ≈0/negativ, Rework-Faktor 2,6). Die OSS-Policies (Kernel: Assisted-by-Pflicht; curl: Bug-Bounty-Ende wegen AI-Slop; Gentoo/NetBSD: Ban; Fedora: Disclosure; Debian: laufende GR) bestätigen unabhängig die Verifikationsbandbreiten-These und liefern direkt übernehmbare Verhaltensregeln für eigene Beiträge.

---

## 1. NIST: AI RMF, GenAI-Profil, SSDF 800-218/218A

**Befund.** Das AI Risk Management Framework 1.0 (2023) plus GenAI-Profil NIST-AI-600-1 (Juli 2024) adressiert Organisationen, die KI-Systeme *anbieten oder betreiben*: 12 GenAI-Risikokategorien, Govern/Map/Measure/Manage-Zyklus [S]. SP 800-218 (SSDF v1.1) ist der generische Secure-Development-Katalog; das Addendum **SP 800-218A** (final Juli 2024, [V] csrc.nist.gov, Abruf 2026-07-28) ist ein „SSDF Community Profile" für **Produzenten von GenAI-/Foundation-Modellen und Integratoren solcher Modelle** — nicht für die Frage „wie sichere ich KI-*generierten* Code ab". Diese Frage bleibt beim generischen SSDF bzw. bei den im Sweep bereits erfassten Quellen (OWASP, CISA). Ein Agentic-Profil zum AI RMF existiert bisher nur als Community-Entwurf der Cloud Security Alliance [S].

**Bewertung:** geprüft und für den Privatkontext **überdimensioniert**. Kein Dokument beantwortet Andreas' Kernfragen besser als die schon erfassten OWASP/CISA-Quellen. Verwertbar: die PW/PS/PO-Praktik-IDs des SSDF als neutrale Referenz, falls die Methodik v5 Kontrollen extern verankern will.

## 2. ISO/IEC 42001 und 5338

**Befund.** ISO/IEC 42001:2023 ist ein zertifizierbarer Managementsystem-Standard (AIMS) nach dem 27001-Muster — Leitungsbewusstsein, Rollen, Audits; AWS und Microsoft sind zertifiziert [S]. ISO/IEC 5338:2023 definiert AI-Lifecycle-Prozesse als Erweiterung von ISO 15288/12207 [S]; Volltext kostenpflichtig.

**Bewertung:** 42001 für einen Einzelentwickler **überdimensioniert** (Managementsystem + externe Zertifizierung; Kostenrahmen fünfstellig) — relevant nur als Signal, was Enterprise-Kunden künftig von Lieferanten verlangen. 5338 ebenfalls überdimensioniert, aber als **Begriffsgerüst** (Lifecycle-Stufen, Rollen) über Sekundärliteratur zitierfähig, falls das Tranche-1-Referenzmodell externe Anker braucht. Keine Beschaffung nötig.

## 3. AWS: Q Developer (EOL), Kiro, AgentCore, GenAI Lens

- **Amazon Q Developer wird eingestellt**: Ankündigung 30.04.2026; ab 15.05.2026 keine Neuanmeldungen, 29.05.2026 Modellwechsel nur noch in Kiro, 30.04.2027 End-of-Support für IDE-Plugins und Abos; Nachfolger ist **Kiro** (spec-driven, im Sweep bereits als Konzept erfasst); Q bleibt nur in AWS-Konsole/Docs [V aws.amazon.com/blogs/devops, Abruf 2026-07-28].
- **Bedrock AgentCore**: GA seit Okt 2025 [S]; 2026 u. a. AgentCore **Payments** (Preview; autonome Agenten-Zahlungen via Stripe/Coinbase mit Spending-Limits) und AgentCore Optimization (Preview) [V usage.ai-Monatsreport, Abruf 2026-07-28; Sekundärquelle].
- **Well-Architected Generative AI Lens**: eingeführt April 2025, Nov 2025 um weitere AI/ML-Lenses ergänzt [S]; frei zugängliche Review-Fragenkataloge.

**Bewertung:** AgentCore für Andreas **überdimensioniert** (Enterprise-Agenten-Hosting, AWS-Lock-in; Payments-Preview zusätzlich ein Lethal-Trifecta-Verstärker, den die Methodik ausdrücklich nicht will). Die GenAI Lens ist als kostenlose Architektur-Checkliste **sinnvoll unter Bedingungen** (Steinbruch, nicht Framework). Der Q-Developer-EOL ist der eigentliche Lerngegenstand: selbst ein Hyperscaler gibt seinem Coding-Produkt nur eine 12-Monats-Runway — Werkzeugbindung gehört in der Methodik als reversibles Commitment behandelt (Anti-Lock-in-Linie aus Dossier 15 bestätigt).

## 4. NVIDIA und lokale GPU-Inferenz

**NeMo/NIM.** NeMo ist das Framework für Training/Customization, NIM sind containerisierte Inferenz-Microservices (OpenAI-kompatible API), auch auf RTX-Workstations lauffähig; produktive Nutzung läuft über NVIDIA-AI-Enterprise-Lizenzierung [S]. Für Andreas ohne NVIDIA-Server: **überdimensioniert** — die pragmatische lokale Schiene ist Ollama/llama.cpp, nicht NIM.

**Qualitätsstand lokaler Coding-Modelle 2026** (Benchmark-Zitierregel aus Dossier 17: Werte nur als Größenordnung, Harness beachten):

- Auf Consumer-VRAM lauffähig: **Devstral Small 24B** ≈46,8 % SWE-bench Verified (14 GB Download Q4; ≈16 GB VRAM), **Qwen3-Coder 30B-MoE** (≈19 GB, 256k Kontext, kein publizierter Verified-Wert), **gpt-oss 20B** (läuft ab 16 GB RAM) [V morphllm.com-Vergleich, Abruf 2026-07-28].
- Cloud-Frontier (Claude-Klasse) liegt bei ≈78–80 % Verified (Dossier 01/17) — die **Lücke beträgt gut 30 Punkte** für alles, was auf einer einzelnen Consumer-GPU läuft. Aider-Polyglot zeigt dasselbe Bild (lokal lauffähige ≈40 % vs. ≈74 % bei 400-GB-Klasse-Modellen) [V ebd.].
- Cloud-nahe offene Modelle (Kimi K2.6 1T-MoE, DeepSeek V3.x, große GLM/Qwen) erfordern Server-Hardware jenseits 400 GB — nicht „lokal" im Sinne von Andreas' Geräten. Schwächen lokaler Modelle laut Praxisvergleichen: Debugging-Genauigkeit ~15–20 % unter Cloud, veralteter Framework-Wissensstand, Multi-File-Reasoning [V promptquorum.com, Abruf 2026-07-28; Einzelwerte dort teils unklar geharnesst → nur qualitativ übernehmen].
- Realistische Hardware: 8B-Klasse ab ~5–6 GB VRAM (Autocomplete-Niveau), 24B ab ~16 GB, 30B-MoE ~20–24 GB (RTX 4090/5090); 70B+/große MoE erst mit 128-GB-Unified-Geräten (Strix-Halo-Klasse, DGX Spark) — alles Neuanschaffung, Andreas' Laptop und der GPU-lose Windows-VPS scheiden aus.

**Bewertung:** lokale Coding-Agenten als Primärpfad **derzeit nicht belastbar**; Datenschutz-/Kosten-/Offline-Argument trägt erst bei (a) sensiblen Daten, die den Rechner nicht verlassen dürfen, (b) hochvolumigen Batch-Nebenaufgaben (Embeddings, Klassifikation, Commit-Messages), (c) Offline-Szenarien. Für (a)–(c) wäre ein 24B-Setup via Ollama **pilotgeeignet, unter Bedingung einer GPU-Anschaffung** — bei Andreas' Volumen sind Claude-Plan-Kosten (Dossier 19) der GPU-Amortisation klar überlegen. Einstufung: **beobachten** (Halbjahresrhythmus; Kriterium: lauffähiges Modell ≤32 GB VRAM mit >60 % Verified in unabhängigem Harness).

## 5. Microsoft Research: Agent Framework und Magentic

**Befund.** Das **Microsoft Agent Framework** (1.0, produktionsreif seit ca. April 2026; .NET + Python, Go in Preview) ist der ausdrückliche Nachfolger von AutoGen (Agent-Abstraktionen) und Semantic Kernel (Enterprise-Features); neu sind graphbasierte, typisierte Workflows mit Checkpointing und Human-in-the-Loop, ein vorkonfigurierter „Harness"-Agent (Planning, Todo-Tracking, Context Compaction, Tool-Approval), MCP-Tool-Support, A2A-Integration und Provider-Anbindung u. a. an Anthropic und Ollama [V learn.microsoft.com/agent-framework, Abruf 2026-07-28]. Das MSR-Multi-Agent-System Magentic-One lebt darin als Magentic-Orchestrierungsmuster weiter [S]. GitHub-nahe Forschung (GitHub Next: Copilot Workspace, SpecLang) bleibt Ideenquelle für Spec-first-Arbeit [S].

**Bewertung:** konzeptionell die validierende Nachricht, dass Microsofts konsolidierter Stack dieselben Bausteine kanonisiert, die Andreas' Methodik schon führt (Harness, Checkpoints, Approval-Gates, MCP). Als Werkzeug **sinnvoll unter Bedingungen** — nur falls programmatische Multi-Agent-Workflows außerhalb des Claude Agent SDK nötig werden; sonst **beobachten**, kein Wechselgrund.

## 6. Google DeepMind: AlphaEvolve und CodeMender

- **AlphaEvolve** ist seit 09.07.2026 **GA** auf der Gemini-Enterprise-Plattform: evolutionäre Code-Optimierung als Service — Seed-Programm mit markierten Abschnitten, client-seitiges deterministisches Evaluator-Skript, Mutations-/Scoring-Schleife; Referenzfälle u. a. Infineon, Klarna, JetBrains (+15–20 % Performance); es existiert sogar ein AlphaEvolve-Skill für Claude Code/Antigravity [V cloud.google.com Blog, Abruf 2026-07-28].
- **CodeMender** (Sicherheits-Patch-Agent; 72 Upstream-Patches in OSS-Projekte laut Forschungsstand Okt 2025 [S deepmind.google]) ist seit 21.07.2026 als Preview über Gemini Enterprise erhältlich; das stärkste Modell bleibt Regierungen/Partnern vorbehalten [V shashi.co, Abruf 2026-07-28; Sekundärblog, Detailzahlen mit Vorsicht].

**Bewertung:** Beides erreicht Entwicklerpraxis — aber als Enterprise-Plattformprodukte: für Andreas direkt **überdimensioniert**. Der Transfer ist das Muster: *Optimierung nur gegen einen automatischen, deterministischen Evaluator* (AlphaEvolve) und *Patch-Agent plus separater Kritiker-Agent vor Upstream* (CodeMender) — beides stützt die Review-Gate-Architektur und ist mit Claude-Code-Bordmitteln (Tests als Evaluator, Kritiker-Subagent) nachbaubar. AlphaEvolve-Skill: **pilotgeeignet** nur bei echtem Optimierungsproblem mit sauberer Scoring-Funktion.

## 7. Meta: ACH und Llama-Ökosystem

**ACH (Automated Compliance Hardening).** Metas produktives LLM-System für **mutationsgesteuerte Testgenerierung**: Es erzeugt gezielt Fault-Kandidaten (simulierte Bugs, z. B. Privacy-relevante) und lässt dann Tests generieren, die genau diese Mutanten töten — Hardening statt bloßer Coverage; produktiv u. a. auf Messenger/WhatsApp-Codebasen, publiziert im FSE-2025-Paper und Engineering-Blogs (Feb/Sep 2025) [S engineering.fb.com; dl.acm.org]. **Bewertung: das übernehmenswerteste Einzelmuster dieses Dossiers** — „Agent erzeugt Bug, zweiter Agent muss ihn per Test fangen" ist ein direkt umsetzbares Qualitäts-Gate für Andreas' kritische Module (pilotgeeignet).

**Llama-Ökosystem.** Für Coding 2026 marginalisiert: Llama 4 blieb hinter Erwartungen, Behemoth wurde nicht breit geliefert; die offene Coding-Spitze liegt bei Qwen/DeepSeek/Kimi/GLM [S]. Für Andreas ohne Relevanz.

## 8. MIT und Stanford: wichtigste Primärarbeiten

- **Stanford Software Engineering Productivity Lab (Denisov-Blanch et al.), 100.000+ Entwickler** (Commit-basierte Messung, von Senior-Panels kalibrierte Modelle): Median-Teamgewinn ≈10 %; **Greenfield/niedrige Komplexität +30–35 %, Greenfield/hoch +10–15 %, Brownfield/niedrig +15–20 %, Brownfield/hoch +5–10 % bis negativ**; Fallstudie: +14 % PRs, aber 2,6-faches Rework und −9 % Codequalität → effektiver Output nahe null [V proxify.io-Aufbereitung, Abruf 2026-07-28; Primärquelle Stanford-Vortragsreihe [S]]. **Das ist der gesuchte robuste Ersatz-Anker für die METR-Lücke (Dossier 17): Autonomiegrad nach Task-Klasse, nicht pauschal.**
- **MIT CSAIL (Solar-Lezama-Gruppe): EnCompass** — Framework, das Suche über Agenten-Ausführungspfade (Beam/MCTS via annotierte Branchpoints) von der Agentenlogik trennt; 15–40 % Genauigkeitsgewinn über fünf Repos [V news.mit.edu, Abruf 2026-07-28]. Forschungsrichtung „Inference-Time-Search für Agenten": **beobachten**.

## 9. OSS-Community-Praxis: Policies und AI-PR-Last

| Projekt | Regelung (Stand 07/2026) | Quelle |
|---|---|---|
| **Linux-Kernel** | Offizielle Doku „AI Coding Assistants": Kennzeichnung `Assisted-by: AGENT:MODEL [TOOLS]`; **Agenten dürfen kein Signed-off-by setzen** — DCO kann nur ein Mensch zertifizieren; Einreicher haftet voll und muss allen generierten Code selbst geprüft haben | [V docs.kernel.org, Abruf 2026-07-28] |
| **curl** | Bug-Bounty via HackerOne **beendet zum 31.01.2026** wegen AI-Slop-Flut; Ziel laut Stenberg: „remove the incentive … to submit crap"; Security-Reports nur noch direkt via GitHub | [V bleepingcomputer.com, Abruf 2026-07-28] |
| **Fedora** | Council-Policy (Okt 2025): KI-Beiträge **erlaubt mit Offenlegung**; Verantwortung bleibt beim Menschen | [S theregister.com; communityblog.fedoraproject.org] |
| **Debian** | **General Resolution seit 24.07.2026 im Verfahren**, vier Optionen von Totalverbot bis Disclosure-Pflicht (`Generated-By:`-Trailer); offen | [V opensourceforu.com, Abruf 2026-07-28] |
| **Gentoo / NetBSD / QEMU** | Gentoo-Council-**Ban** seit April 2024; NetBSD-Verbot Mai 2024; QEMU restriktiv; GNOME-Extensions bannen „AI slop" | [S theregister.com; wiki.gentoo.org] |

**Empirie-Lesart:** Die Maintainer-Reaktionen sind ein Feldexperiment zur Verifikationsbandbreite — wo Einreichung billig und Prüfung teuer wird, kollabieren offene Kanäle (curl) oder es entstehen Kennzeichnungs- und Haftungsregeln (Kernel, Fedora). Das ist unabhängige Bestätigung der Kernthese aus Dossier 03/07 und des A-Stufen-Prinzips „Autonomie nur bis zur Grenze der eigenen Prüf­kapazität".

---

## Konsequenzen für Andreas

1. **Standards abhaken:** NIST 800-218A, ISO 42001/5338 nicht weiterverfolgen; höchstens SSDF-Praktik-IDs als optionale Referenzspalte in der Methodik v5. Kein Beschaffungs- oder Zertifizierungsaufwand.
2. **Empirie-Anker tauschen:** Die Stanford-Matrix (Greenfield/Brownfield × Komplexität, Rework 2,6×) als primären Beleg für aufgabenklassenabhängige Autonomiestufen in Synthese v2 übernehmen (ergänzt Dossier 17); Konsequenz: A3+ nur für Greenfield/niedrig-mittel, Brownfield-komplex bleibt A1–A2 mit engem Diff-Review, Rework als Pflichtmetrik neben PR-Durchsatz.
3. **Zwei Muster pilotieren:** (a) ACH-Stil-Mutationstest-Gate für kritische Module (Kritiker-Agent injiziert Bugs, Testsuite bzw. Test-Agent muss sie fangen — messbares Review-Gate); (b) Evaluator-getriebene Optimierungsschleife nach AlphaEvolve-Muster nur dort, wo eine deterministische Scoring-Funktion existiert.
4. **Lokale Inferenz vertagen:** keine GPU-Anschaffung; Wiedervorlage H1 2027 mit klarem Kriterium (≤32 GB VRAM, >60 % SWE-bench Verified unabhängig gemessen). Bis dahin bleiben Datenschutz-Nischen (lokale Embeddings/Klassifikation über Ollama auf CPU/iGPU) die einzige sinnvolle lokale Schiene.
5. **OSS-Beitragsregeln in die Methodik aufnehmen** (neuer Baustein „Upstream-Etikette"): vor jedem Beitrag Policy des Zielprojekts prüfen; Kennzeichnung nach Projektkonvention (`Assisted-by:`/`Generated-By:`); nur einreichen, was selbst verstanden, gebaut und getestet wurde; niemals ungeprüfte agentische Security-Reports; kleine, einzeln prüfbare PRs; bei Ban-Projekten (Gentoo u. a.) keine KI-Beiträge.
6. **Produktbindung als reversibles Commitment führen:** Der Q-Developer-EOL (12-Monats-Runway) bestätigt die Anti-Lock-in-Linie — Methodik-Artefakte (AGENTS.md/CLAUDE.md, MCP-Server, Skills) portabel halten, Anbieterprodukte nur über dünne Adapter.

## Quellenverzeichnis

**[V] direkt abgerufen (2026-07-28):**
1. NIST SP 800-218A Final — csrc.nist.gov/pubs/sp/800/218/a/final
2. AWS DevOps Blog: „Amazon Q Developer end-of-support announcement" — aws.amazon.com/blogs/devops/…
3. usage.ai: AWS-Monatsupdate Mai 2026 (Q-EOL-Termine, Kiro, AgentCore Payments) — Sekundärquelle
4. morphllm.com: „Best Ollama Models" (VRAM/SWE-bench-Vergleich, Juni 2026)
5. promptquorum.com: „Best Local Coding LLMs 2026" — Sekundärquelle, Benchmarks teils unklar
6. Microsoft Learn: Agent Framework Overview — learn.microsoft.com/agent-framework
7. Google Cloud Blog: „AlphaEvolve is available for everyone" (GA 09.07.2026)
8. shashi.co: CodeMender-Preview-Status Juli 2026 — Sekundärblog, begrenztes Vertrauen
9. MIT News: „Helping AI agents search…" (EnCompass, Solar-Lezama)
10. proxify.io: Aufbereitung der Stanford-100k-Studie (Denisov-Blanch)
11. docs.kernel.org/process/coding-assistants.html (Assisted-by, DCO)
12. BleepingComputer: „curl ending bug bounty program…" (31.01.2026)
13. opensourceforu.com: „Debian Eyes Project-Wide Rules For LLM Contributions" (GR 24.07.2026)

**[S] nur über Suche belegt:** NIST AI RMF 1.0 + NIST-AI-600-1 (nist.gov); CSA Agentic-AI-RMF-Profil (labs.cloudsecurityalliance.org); ISO/IEC 42001:2023 und 5338:2023 (iso.org; AWS/Microsoft-Compliance-Seiten); Bedrock AgentCore GA (aws.amazon.com, Okt 2025); Well-Architected GenAI Lens (docs.aws.amazon.com; Lens-Erweiterung Nov 2025); NVIDIA NIM/NeMo inkl. RTX-NIM (developer.nvidia.com); Magentic-One/Magentic-Orchestrierung (Microsoft); GitHub Next (SpecLang, Copilot Workspace); DeepMind-Blogs zu AlphaEvolve/CodeMender (deepmind.google); Meta ACH (engineering.fb.com Feb+Sep 2025; FSE-2025-Paper dl.acm.org); Stanford-Primärvorträge (softwareengineeringproductivity.stanford.edu); Fedora-Council-Policy (theregister.com, communityblog.fedoraproject.org); Gentoo-/NetBSD-Bans (theregister.com 04/2024+05/2024, wiki.gentoo.org); Llama-4-/Open-Weights-Landschaft H1 2026 (digitalapplied.com u. a.).
