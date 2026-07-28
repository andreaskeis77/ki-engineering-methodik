# Windows-Autonomie-Matrix: Autoritätsstufe x Ausführungsumgebung x Fähigkeitsklasse

**Stand:** 2026-07-28 | Konsolidierung aus Dossiers 06, 12, 14, 16 (Konfliktlinie 4 aus `00_KRITIK_UND_LUECKEN.md`) plus eigener Primärquellen-Verifikation.
**Status: NORMATIVER VORSCHLAG** für die Methodik (Ergänzung Kapitel 22/23). Die Entscheidung liegt bei Andreas; abweichende Festlegungen sind als bewusste Risikoakzeptanz zu dokumentieren.

## Executive Summary

Der scheinbare Widerspruch der Dossiers — WSL2-Sandbox-Pflicht "ab A3" (06/12) gegen den nativen unattended Ops-Agenten auf dem Windows-Server (16) — löst sich auf, sobald man zwei Achsen trennt: ob ein **menschliches Gate** im Lauf existiert (attended vs. unattended) und ob der Lauf **Schreibwirkung** hat (read vs. write, Workspace vs. System/extern). Die präzisierte Grenze lautet: **Unattended read-only ist nativ auf Windows zulässig**, wenn ein minimal berechtigtes Servicekonto plus NTFS-ACLs, read-only-DB-Rollen, lesende Allowlist im `dontAsk`-Modus, Egress-Firewall und Audit-/Kill-File-Hooks das fehlende OS-Sandboxing als identitätsgebundenes Enforcement ersetzen; **unattended schreibend erfordert OS-Isolation** (WSL2-Sandbox, Container/VM, ephemerer CI-Runner oder Anthropic-Cloud), nativ nur als eng definierte Runbook-Ausnahme; **attended ist nativ bis A5 zulässig**, weil der Mensch das Gate ist. Die Verifikation bestätigt die Grundlage: Die Sandbox läuft ausdrücklich nicht auf nativem Windows, und der Feature-Request dazu wurde im April 2026 als "not planned" geschlossen — die Methodik muss dauerhaft ohne native Windows-Sandbox planen, zumal Deny-Read-Regeln ohne Sandbox per Bash trivial umgehbar sind. Cloud-Routines laufen verifiziert **komplett ohne Permission-Prompts**; ihre Kontrollflächen sind Repo-Auswahl, `claude/`-Branch-Restriktion, Environment-Netz-Allowlist und Konnektoren-Kuratierung — wobei Konnektor-Traffic die Netz-Allowlist umgeht und alle verbundenen Konnektoren **inklusive Schreib-Tools** per Default aktiv sind. Routines sind daher nur unter engen Bedingungen vertretbar (M0/M1-read, kuratierte Konnektoren, keine Secrets im Environment, private Repos, Output nur auf `claude/`-Branches) und für M3, A4+ sowie jede Konfiguration mit gleichzeitig offener Lethal-Trifecta verboten. Terminologisch wird Dossier 16 korrigiert: Read-only mit Credentials ist M1 (nicht M2), unabhängig davon, ob lokal oder remote.

## 1. Auflösung der Konfliktlinie 4

Die Regel "WSL2 ab A3" (Dossiers 06/12) meint autonome **Entwicklungs­sessions mit freier Schreib- und Push-Fähigkeit**: Dort ist die Sandbox die einzige harte Grenze, weil Permission-Rules stringbasiert sind (ein Deny auf `Read(~/.ssh/**)` hindert `Bash(cat ~/.ssh/id_rsa)` nicht [V3]), der Settings-Selbstschutz nur in der Sandbox existiert und Credential-Masking sowie der Egress-Proxy an die Sandbox gebunden sind [V1]. Dossier 16 empfiehlt dagegen einen **unattended read-only** Ops-Agenten: Dort übernimmt das OS-Konto die Enforcement-Rolle — nicht prozessgebunden (Sandbox), sondern identitätsgebunden (Servicekonto `svc-claude` ohne Adminrechte, NTFS-ACLs, `agent_ro`-DB-Rolle, Firewall). Beides ist OS-Level-Isolation, nur anders geschnitten. Kein Widerspruch — aber die Grenze muss normiert werden:

**Grenzregel (Vorschlag):** Maßgeblich ist nicht die A-Stufe allein, sondern das Tripel *(Gate, Schreibwirkung, Umgebung)*:

- **W1 — Attended** (Mensch beantwortet Prompts, auch via Remote Control): jede Umgebung zulässig, nativ Windows eingeschlossen, bis A5 (dort Zwei-Schritt: Plan → Freigabe → Ausführung). Hooks und Deny-Rules bleiben Pflicht-Zweitschicht.
- **W2 — Unattended read-only** (A0; M0/M1): nativ zulässig **nur** mit dem vollständigen Kompensationspaket K+P+H+E+C (Legende unten). Read-only heißt: keine Mutation außer Report-Ablage in ein definiertes, nicht ausführbares Verzeichnis; keine Pushes; keine externen Writes. Restrisiko ist Exfiltration (Lesen + Egress); deshalb sind Egress-Firewall auf Anthropic-API plus benötigte Ziele und NTFS-/`permissions.deny`-Sperren auf Secret-Pfade **konstitutiv**, nicht optional.
- **W3 — Unattended schreibend** (A1–A3; M2): nur mit prozessgebundener Isolation — WSL2-Sandbox im Strict-Profil, Devcontainer/VM, ephemerer GitHub-Runner oder Anthropic-Cloud-Umgebung. Nativ Windows nur als **Runbook-Ausnahme**: genau ein benanntes, idempotentes, reversibles Skript als Skill (`disable-model-invocation: true`, `allowed-tools` exakt auf das Skript, Rate-Limit, Audit, Rollback-Pfad) — keine freie Schreibautonomie.
- **W4 — A4 (Merge/Promotion) und jede A5-Fähigkeit: nie unattended**, in keiner Umgebung. Das bestätigt die bestehende v4.0-Regel und bleibt unverändert.

## 2. Umgebungssteckbriefe

| Umgebung | Isolation | Egress-Kontrolle | Credential-Schutz | Human-Gate möglich | Identität |
|---|---|---|---|---|---|
| **E1 nativ Windows** (Laptop/VPS) | keine Sandbox [V1][V3]; nur Konto/NTFS/DB-Rollen | Windows-Firewall (pro Konto/Prozess), Tailscale-ACLs | kein Masking; nur Scope-Hygiene + `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` | ja (Prompts, Remote Control) | OS-Servicekonto, Bot-PAT |
| **E2 WSL2 + Sandbox** | bubblewrap+socat, OS-enforced [V1] | Proxy-Allowlist, `strictAllowlist`; Domain-Fronting-Restrisiko | `sandbox.credentials` deny/mask, Settings-Selbstschutz | ja | Bot-Account/fine-grained PAT |
| **E3 GitHub-Actions-CI** | ephemere VM, verschwindet nach Job | ungefiltert (Schwäche) → Secrets minimieren | kurzlebiger `GITHUB_TOKEN`, OIDC/WIF, keine statischen Secrets | nur asynchron (workflow_dispatch) | GitHub App/CI-Token |
| **E4 Cloud-Routine** | Anthropic-Cloud, frischer Clone, kein lokaler Zugriff | Environment-Allowlist (Trusted/Custom/Full); **Konnektoren umgehen sie** [V2] | Env-Vars für jeden Environment-Nutzer sichtbar [V2] | **nein — keine Prompts** [V2] | läuft als Andreas' GitHub-/Konnektor-Identität [V2] |
| **E5 Cowork-Cloud** (Cloud Scheduled Tasks) | Anthropic-Cloud, kein lokaler Dateizugriff | dünner dokumentiert als Routines | Konnektor-Kuratierung | nein (unattended) | Andreas' Konnektor-Identität |

## 3. Matrix A — Autoritätsstufen x Umgebung

Legende: **U** = unattended zulässig (mit genanntem Enforcement) | **A** = nur attended | **—** = nicht zulässig / nicht vorgesehen. Enforcement-Kürzel: **S** Sandbox-Strict-Profil (`enabled`, `failIfUnavailable`, `allowUnsandboxedCommands:false`, `denyRead ~/` + `allowRead .`, `strictAllowlist`) · **P** Permission-Rules/`--allowedTools` + `dontAsk` · **H** Hooks (PreToolUse-deny/ask, Audit-Log, Kill-File) · **K** Servicekonto + NTFS + read-only-DB-Rollen · **E** Egress-Restriktion (Firewall/Allowlist/Environment-Netzpolicy) · **C** Credential-Schutz (deny/mask, ENV-Scrub, keine Secrets im Scope) · **I** eigene Agentenidentität (Bot, fine-grained PAT) · **B** Branch-Restriktion (`claude/`, Branch-Protection) · **G** menschliches Gate · **2** Zwei-Schritt-Freigabe · **R** Runbook-Form.

| Stufe | E1 nativ Windows | E2 WSL2+Sandbox | E3 GH-Actions-CI | E4 Cloud-Routine | E5 Cowork-Cloud |
|---|---|---|---|---|---|
| **A0** lesen/analysieren | **U** (K,P,H,E,C)¹ | **U** (S,P,H) | **U** (Turn-/Kostenlimit) | **U** (Bedingungen §5) | **U** (nur M0/M1-Konnektoren) |
| **A1** lokale Mutation | **A**; U nur R² | **U** (S,H) | **U** (ephemer) | **U** (wirkt nur im Clone) | — |
| **A2** Commit lokal | **A** (Selbstpersistenz-Risiko)³ | **U** (S,H,I) | **U** (I) | **U** (im Clone) | — |
| **A3** Push/Draft-PR | **A** | **U**⁴ (S,C,I,B + exakte Vorabfreigabe) | **U**⁴ (I,B, SHA-Pinning) | **U**⁴ (B: `claude/`-Kanal, private Repos) | — |
| **A4** Merge/Promotion | **A** (G,2) | **A** | **A** — nie durch unattended Agenten | **—** | **—** |
| **A5-\*** Deploy/Live/Admin | **A** (G,2, capability-scoped) | **A** | Deploy nur als deterministische Pipeline, Auslösung attended | **—** | **—** |

¹ Ops-Agent-Profil Dossier 16 (Stufe 0). ² Runbook-Ausnahme nach §1.3. ³ Commits können `.claude/`, `.github/`, Hooks verändern → Privilege Escalation im Folgelauf; ohne Sandbox kein Settings-Schutz. ⁴ Bestehende v4.0-Regel: A3 unattended nur bei exakter Vorabfreigabe je Ziel; die Routine-/Workflow-Definition selbst gilt als diese Vorabfreigabe, wenn Ziel-Repo und Branch-Regel benannt sind.

## 4. Matrix B — Fähigkeitsklassen x Umgebung (read vs. write)

| Klasse | E1 nativ | E2 WSL2 | E3 CI | E4 Routine | E5 Cowork |
|---|---|---|---|---|---|
| **M0** lokal read, ohne Creds | **U** (P,H) | **U** (S) | **U** | **U** | **U** |
| **M1** read mit Creds | **U** (K,C,E: zielgebundene read-only-Rollen)⁵ | **U** (S,C) | **U** (OIDC, minimal) | **U nur**, wenn Server/Konnektor **serverseitig** read-only erzwingt⁶ | wie E4 |
| **M2** write Dev/Test | **A**; U nur R | **A**; U nur mit deklarierter Vorabfreigabe je Tool+Ziel (moderater Lockerungsvorschlag)⁷ | **U eng** (PR-/Issue-Automation, I, `--max-turns`) | **verboten** via Konnektor⁶; Git-Kanal siehe A3 | **verboten** |
| **M3** extern/irreversibel | **A** (2) | **A** (2) | nur deterministische Pipeline ohne LLM im Pfad | **verboten** | **verboten** |
| **M4** UI/MCP-Apps | **A** + Designgate | **A** | — | **—** | **A** |

⁵ Terminologie-Korrektur zu Dossier 16: read-only mit Credentials ist **M1** (Methodik 23.4), auch remote (Postgres MCP restricted, DuckDB-MCP read-only, Directus-read-Policy). ⁶ In Routines gilt: jedes Tool eines eingebundenen Konnektors läuft **promptlos, Writes eingeschlossen** [V2]; ein Konnektor, der Read- und Write-Tools mischt, ist in einer Routine automatisch M2+. Es gibt dort kein per-Tool-Gate → nur Konnektoren einbinden, die serverseitig read-only sind (readonly-DSN, eigener read-only-MCP); insbesondere **keinen GitHub-Konnektor** in Routines (trüge Merge-Fähigkeiten = A4). ⁷ Abweichung von der bisherigen strikten Regel "unattended nur M0/M1" — als Option zur Entscheidung vorgelegt; Beibehalt der strikten Regel ist die konservative Alternative.

## 5. Routines gegen Lethal Trifecta und Gate-Modell

Verifiziert [V2]: Routines laufen als volle Cloud-Sessions **ohne Permission-Modus und ohne Freigabe-Prompts**; Reichweite bestimmen Repo-Auswahl + Branch-Setting, Environment (Netzstufen Trusted/Custom/Full, Env-Vars, Setup-Script) und Konnektoren. Default-Zustand ist unsicher konfiguriert: **alle** verbundenen Konnektoren aktiv (inkl. Writes), Env-Vars für jeden Environment-Nutzer sichtbar, Konnektor-Traffic läuft über Anthropic-Server **an der Netz-Allowlist vorbei**. Positiv: Push default nur auf `claude/`-Branches; API-Trigger-Payload kommt als `<routine-fire-payload>` untrusted-gewrappt an; der gespeicherte Prompt gilt seit v2.1.214 als beauftragte Aufgabe, nicht als Konsens für weitergehende Aktionen; grüner Run-Status bedeutet nur "kein Infrastrukturfehler", nicht Task-Erfolg.

**Trifecta-Analyse:** Kante 1 (private Daten) = Repo + Konnektor-Reads + Env-Vars; Kante 2 (untrusted Input) = Fremd-PRs, Webinhalte, Konnektor-Rückgaben (API-Payload ist durch das Wrapping entschärft, bleibt aber Daten-Injektionsfläche); Kante 3 (Exfiltration) = Netz-Egress, **Konnektor-Writes (umgehen die Netzpolicy)**, Git-Push (bei public Repos ist ein `claude/`-Push bereits Veröffentlichung).

**Vertretbar ("sinnvoll unter Bedingungen / pilotgeeignet"), wenn alle Punkte erfüllt:** (1) Fähigkeiten auf M0/M1 begrenzt — Konnektorenliste je Routine aktiv leergeräumt bzw. nur serverseitig read-only-Server; (2) keine Secrets in Environment-Variablen (höchstens ein kurzlebiges, minimal gescoptes Token); (3) Netz Trusted oder Custom-minimal, **nie Full**; (4) nur private Repos, "Allow unrestricted branch pushes" aus, Output ausschließlich `claude/`-Branch/Draft-Kanal (strukturell A3-gedeckelt); (5) GitHub-Trigger nur auf Repos ohne Fremd-Schreibzugriff; (6) Ergebnisprüfung durch Mensch oder CI vor jeder Weiterverwendung; (7) Akzeptanz, dass die Routine unter Andreas' GitHub-/Konnektor-Identität handelt (keine Bot-Trennung möglich) — sonst Routines auf Nicht-Git-Aufgaben begrenzen. **Verboten:** Schreib-Konnektoren oder GitHub-Konnektor eingebunden; Full-Netz bei gleichzeitig untrusted Input; Secrets im Environment zusammen mit untrusted Input und offenem Egress; public-Repo-Ziele; jede M3-Reichweite (Prod-Daten, Deploy, Live-Systeme); jedes A4+. Gate-Modell-Fazit: Eine so beschnittene Routine endet strukturell beim A3-Äquivalent — konform zur v4.0-Regel "unattended endet vor A4"; alles darüber hat in E4/E5 keinen Platz, weil dort kein Gate existiert.

## 6. Verifikationsstand offener Detailfragen

1. **Native Windows-Sandbox:** Doku eindeutig "Native Windows is not supported. On Windows, run Claude Code inside a WSL2 distribution"; aus WSL2-Sandbox sind Windows-Binaries (`powershell.exe`, `/mnt/c/…`) blockiert [V1]. Feature-Request #46740 (11.04.2026) wurde als **"not planned" geschlossen** [V3]; die Websuche ergab keine gegenteilige Ankündigung. Planungsannahme: kommt nicht — PowerShell-native Projekte bleiben dauerhaft auf Kompensation (K,P,H,E,C) bzw. attended angewiesen. Fallback-Verhalten beachten: Ohne `failIfUnavailable:true` läuft Claude Code bei fehlender Sandbox **unsandboxed weiter** [V1].
2. **Routines:** Promptlosigkeit, Kontrollflächen, Konnektor-Default, Netz-Bypass der Konnektoren, Branch-Regel, Payload-Wrapping direkt verifiziert [V2]. Die separate Cloud-Environments-Seite war beim Direktabruf 404; die Kernaussagen (Trusted-Default-Allowlist mit Package-Registries u. ä., Env-Var-Sichtbarkeit, 403 `host_not_allowed`) sind in der Routines-Doku enthalten [V2/S4].
3. **Restrisiken bleiben dokumentiert:** Domain-Fronting am Sandbox-Proxy (auch WSL2), breite Allowlist-Domains als Exfil-Pfad, CI-Egress ungefiltert — keine Umgebung liefert einen dichten Kanalverschluss; die Trifecta-Deklaration je Lauf (Dossier 12) bleibt deshalb Pflichtfeld.

## Konsequenzen für Andreas

1. **Grenzregel aus §1 als Kapitel-22-Ergänzung übernehmen** (Vorschlagstext W1–W4 dort wörtlich verwendbar); Matrix A/B als Anhang zu Kapitel 23. Entscheidungsbedarf: M2-Lockerungsoption (Fußnote 7) annehmen oder strikte M0/M1-Regel behalten.
2. **VPS-Ops-Agent (Dossier 16 Stufe 0) freigeben** — er ist matrixkonform: A0/M0–M1 unattended nativ mit vollem Kompensationspaket; Windows-Firewall-Egress pro Dienstkonto vor Produktivsetzung praktisch validieren (WFP-Regelwerk testen).
3. **Laptop-Entwicklung:** autonome Läufe (A1–A3) nur noch in WSL2 mit Strict-Sandbox-Profil und Credential-Masking; PowerShell-native Projekte attended oder via CI, da die WSL2-Sandbox Windows-Binaries blockiert.
4. **Routines-Pilot** nur nach der Bedingungsliste in §5 (erste Kandidaten: nächtliche Repo-Pflege, Doku-Drift, PR-Vorreview in privaten Repos); vor jedem Anlegen Konnektorenliste leeren. Cowork-Cloud-Tasks vorerst nur für M0/M1-Wissensarbeit; Kontrollflächen dünner dokumentiert — vor Ausweitung prüfen.
5. **A4/A5 bleiben ausnahmslos attended**; Merges und Deploys nie in promptlose Pfade verlagern, Deploy-Ausführung deterministisch (Pipeline), nicht agentisch.

## Quellenverzeichnis

**Eigene Abrufe (dieser Lauf):**
1. [V1] Claude Code Docs — Sandboxing (Plattform-Support, Fallback, credentials, strictAllowlist, Limitierungen): https://code.claude.com/docs/en/sandboxing (abgerufen 2026-07-28)
2. [V2] Claude Code Docs — Routines (promptloser Betrieb, Konnektor-Default, Netzstufen, Branch-Regel, Payload-Wrapping, Identität): https://code.claude.com/docs/en/routines (abgerufen 2026-07-28)
3. [V3] GitHub anthropics/claude-code Issue #46740 — Native sandbox support for Windows: closed as "not planned"; Deny-Rule-Umgehung per Bash dokumentiert: https://github.com/anthropics/claude-code/issues/46740 (abgerufen 2026-07-28)
4. [S4] Claude Code Docs — Cloud Environments: https://code.claude.com/docs/en/cloud-environments (Direktabruf 404 am 2026-07-28; Inhalte über [V2] belegt)

**Interne Grundlagen (Sweep, Stand 2026-07-28):**
5. [intern] Dossier 06 `06_plattform.md` — Sandbox/Hooks/Headless/Remote Control, mobile Positiv-/Negativliste
6. [intern] Dossier 12 `12_sicherheit.md` — Lethal Trifecta, Sandbox-Grenzen, Agentenidentität, CISA/OWASP-Anker
7. [intern] Dossier 14 `14_claude_oekosystem.md` — Scheduler-Ebenen, Routines-Ersterfassung, MCP-Kontrollen
8. [intern] Dossier 16 `16_server_db_administration.md` — Ops-Agent-Betriebsmodelle, Servicekonto, DB-MCPs, Runbook-Skills
9. [intern] Methodik v4.0 Kap. 5.2/23.4 und `input/CLAUDE.md` — Definitionen A0–A5, M0–M4, Unattended-Regeln
