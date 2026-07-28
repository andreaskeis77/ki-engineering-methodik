# Vollständigkeitskritik des Recherche-Sweeps — Konflikte, Lücken, Folgeplan

**Stand:** 2026-07-28 (nach Abschluss aller 16 Dossiers)
**Erstellt von:** unabhängigem Kritik-Agenten (Input: Kernbefunde der Sweep-Dossiers, Stichproben aus den Volltexten), redaktionell konsolidiert
**Zweck:** Qualitätssicherung der Recherche selbst — was widerspricht sich, was fehlt, was muss vor der Tranche-1-Vertiefung geklärt werden

---

## 1. Die vier Konfliktlinien (vor Weiterverarbeitung aufzulösen)

1. **MCP-Spezifikationsstatus (kritisch).** Dossier 04 behandelt die Revision 2026-07-28 als final erschienen und leitet Handlungsempfehlungen daraus ab; Dossier 13 hat `modelcontextprotocol.io/specification` am selben Tag direkt geprüft und fand **2025-11-25 als „Current"**, die 2026er-Revision nur als Draft (Beleg für „final" ist nur der Release-Candidate-Blogpost vom 21.05.2026). Bis zur Klärung gelten die 04er-Empfehlungen (Stateless-Core, Deprecation-Reaktionen) als **vorläufig**.
2. **METR −19 %.** Dossiers 03 und 07 stützen normative Schlüsse (WIP-Limit, Metrikdisziplin) auf die 19-%-Verlangsamung, die Dossier 08 als methodisch überholt ausweist (Studien-Redesign, aktueller Effekt „um null mit großer Unsicherheit"). Die Argumente sind auf robustere Anker umzustellen (AIDev-Ablehnungsraten, DORA-Differenzierung nach Task-Klassen, Anthropic-Praxisdaten) — die Schlussfolgerungen selbst bleiben plausibel, brauchen aber sauberere Evidenz.
3. **Benchmark-Skepsis inkonsistent angewendet.** Dossier 01 zitiert SWE-bench Verified 78,4 % als Fortschrittsbeleg, Dossier 03 nutzt SWE-bench Lite, während Dossier 13 die SWE-Bench-Illusion (Memorisierung: 76 % vs. 53 % Pfad-Identifikation) an der Primärquelle bestätigt. Nötig: eine einheitliche Zitierregel für Benchmarks.
4. **Windows-Autonomie-Grenze.** Dossiers 06/12 erklären die WSL2-Sandbox für autonome Läufe (ab A3) faktisch zur Pflicht; Dossier 16 empfiehlt den unattended Ops-Agenten nativ auf dem Windows-Server. Die plausible Grenzziehung (read-only M0–M2 nativ zulässig, schreibend nur sandboxed) ist nirgends konsolidiert. Zusätzlich ungeprüft: Cloud-Routines laufen laut Dossier 14 **komplett ohne Permission-Prompts** — eine Lethal-Trifecta-Bewertung dieses Pfads fehlt.

## 2. Abdeckungslücken gegenüber dem Forschungsauftrag (§ 6.2)

- **NVIDIA:** null Treffer im Korpus; damit fehlt auch lokale GPU-Inferenz (Ollama u. ä.) als Datenschutz-/Kosten-/Offline-Option.
- **NIST, ISO/IEC, IEEE:** AI RMF + GenAI-Profil, SSDF SP 800-218A, ISO/IEC 42001 und 5338 kommen nicht vor; Standardisierung bisher nur W3C, IETF, OWASP, MITRE, ETSI, Linux Foundation.
- **AWS / DeepMind / Microsoft Research / Meta:** nur punktuell (Kiro, je eine Studie); Amazon Q Developer, Bedrock AgentCore, AutoGen/Agent Framework, AlphaEvolve/CodeMender, Meta-Engineering-Praxis fehlen.
- **MIT / Stanford:** nicht systematisch ausgewertet; akademische Basis arXiv-lastig.
- **OSS-Community-Praxis:** KI-Beitrags-Policies (Linux-Kernel, curl, Debian/Fedora) und Maintainer-Empirie zur AI-PR-Flut fehlen völlig — dabei wäre das Zusatzevidenz für die Verifikationsbandbreiten-These.
- **Teilfrage Kosten (§ 8):** kein konsolidiertes Betriebskostenmodell (Plan-Limits vs. API, Tokenfaktoren je Orchestrierungsmuster, Routines/CI-Kontingente) — Voraussetzung für alle empfohlenen Piloten.
- **Teilfrage Konfliktlösung zwischen Agenten:** nur als Konfliktvermeidung beantwortet; Verfahren für den tatsächlichen Konfliktfall fehlt.
- **Quellenstatus-Divergenzen:** mehrere zentrale Dokumente bleiben unverifiziert (DORA-Vollreport inkl. Klärung der sieben Kapazitäten, CISA-Agentic-Guidance, OWASP-ASI-PDF, NSA-CSI-PDF, DTCG-Spec-Volltext, BFSG-Gesetzestext).

## 3. Prozessbefund (bereits behoben)

Die ursprüngliche Gesamtsynthese wurde nur aus den Dossiers 01–13 gebaut (ohne die Ökosystem-Dossiers 14–16) und ist daher als `00_SYNTHESE_v1_basis13.md` archiviert; eine **Synthese v2 über alle 16 Dossiers inkl. expliziter Auflösung der vier Konfliktlinien** wird im Konsolidierungslauf neu erstellt. Der Ablagebeschluss (alle Dossiers ins Claude-Projekt) ist inzwischen umgesetzt.

## 4. Konsolidierungslauf (gestartet 2026-07-28)

| Agent | Auftrag | Zieldatei |
|---|---|---|
| K1 | MCP-Spec-Status klären (Prio 1) | `04a_mcp_spec_status.md` |
| K2 | Empirie-Anker korrigieren: METR-Umstützung, Benchmark-Zitierregel, DORA-Kapazitäten (Prio 3/5 teilw.) | `17_empirie_anker_korrekturen.md` |
| K3 | Fehlende Organisationen und Gremien inkl. OSS-Policies (Prio 4/6) | `18_fehlende_organisationen.md` |
| K4 | Betriebskostenmodell der Methodik (Prio 7) | `19_kostenmodell.md` |
| K5 | Windows-Autonomie-Matrix inkl. Routines-Bewertung (Prio 8) | `20_windows_autonomie_matrix.md` |
| K6 | Gesamtsynthese v2 über alle 16 Dossiers + Addenda, Konfliktlinien entschieden (Prio 2) | `00_SYNTHESE.md` |

**Danach (Prio 9):** Tranche-1-Vertiefung „Operating Model & Lifecycle-Referenzmodell" — bewusst erst nach Auflösung der Konflikte, damit keine instabilen Zahlen ins Referenzmodell einfließen.

## 5. Bewusst offen gelassen (für spätere Läufe)

Beschaffung weiterer gated Primärdokumente (EN-301-549-Zeitplan, EAS-Kontingente, ETH-AGENTbench-Primärpaper, GraphRAG-Bench-Volltext); METR-Fixed-Task-Folgestudien H2 2026 auf der Beobachtungsliste; quantitative Empirie zu Merge-Konflikt-Raten paralleler Agenten.
