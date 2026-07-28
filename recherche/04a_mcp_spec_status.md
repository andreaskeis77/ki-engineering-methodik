# MCP-Spezifikationsstatus: Klärung der Konfliktlinie 1 (Dossier 04 vs. 13)

**Stand:** 2026-07-28 (alle [V]-Abrufe am heutigen Tag; Prüfzeitpunkt beachten — heute ist zugleich der angekündigte Release-Tag)
**Zweck:** Verbindlicher Statusentscheid zur MCP-Revision 2026-07-28; Prüfung, welche Aussagen aus `04_mcp.md` bestätigt bzw. zu relativieren sind; Festlegung der MCP-Zielrevision für den CLAUDE.md-Steckbrief.

---

## Executive Summary

Der Konflikt ist zugunsten von Dossier 13 entschieden: **Die Revision 2026-07-28 ist zum Prüfzeitpunkt nicht veröffentlicht; Current ist weiterhin 2025-11-25.** Das belegen drei unabhängige, heute direkt abgerufene Primärstellen: Die Versioning-Seite der Spezifikation nennt wörtlich „The current protocol version is 2025-11-25"; das GitHub-Spec-Repo führt 2025-11-25 als „Latest"-Release und „MCP 2026-07-28 RC" nur als Pre-release; der Blog enthält keinen Final-Release-Post, und `modelcontextprotocol.io/specification/2026-07-28` liefert 404. Die 2026er-Inhalte existieren real — als seit 21.05.2026 eingefrorener Release Candidate, dessen Text auf der Website unter `/specification/draft/` geführt wird und dessen Finalisierung der RC-Blogpost wörtlich für heute ankündigt („The final specification will be published on July 28, 2026"). Dossier 04 hat diese Ankündigung als vollzogenen Release behandelt — die *inhaltlichen* Beschreibungen (Stateless Core, Extensions, Deprecations) sind korrekt und am Draft/RC verifizierbar, aber alle Formulierungen, die 2026-07-28 als geltende Revision voraussetzen, sind auf „RC, Finalisierung angekündigt" herabzustufen. Neufund bei der Prüfung: Die Deprecated-Registry listet neben Roots, Sampling und Logging auch **Dynamic Client Registration** als „Deprecated in 2026-07-28" (Migration: Client ID Metadata Documents) — das fehlt in Dossier 04. Für Andreas gilt: Zielrevision im CLAUDE.md-Steckbrief bleibt **2025-11-25**, eigene Server werden aber „2026-ready" entworfen (kein Session-Header-Reliance, explizite Handles, keine Roots/Sampling/MCP-Logging/DCR in Neubauten); umgestellt wird erst, wenn die Versioning-Seite 2026-07-28 als Current führt und stabile (Nicht-Beta-)SDKs vorliegen.

## 1. Statusentscheid mit Belegkette

**Entscheid: 2025-11-25 ist Current. 2026-07-28 ist Release Candidate (Website-Status „Draft"), nicht released — Finalisierung für heute angekündigt, zum Prüfzeitpunkt nicht vollzogen.**

Belegkette (alle Abrufe 2026-07-28):

1. **Versioning-Seite** [V1]: „The **current** protocol version is **2025-11-25**." Die Seite definiert zugleich die Statusbegriffe (Draft = „in-progress, not yet ready for consumption"; Current; Final) — es gibt in dieser Systematik keinen eigenen Website-Status „Release Candidate"; der RC lebt formal als Draft.
2. **GitHub-Releases des Spec-Repos** [V2]: Jüngstes stabiles Release **2025-11-25** (markiert „Latest"); **„MCP 2026-07-28 RC"** existiert als **Pre-release** (Tag vom 29.05.2026). Kein Final-Tag für 2026-07-28.
3. **Blog-Index** [V3]: Die jüngsten einschlägigen Posts sind der RC-Post (21.05.2026) und „Beta SDKs for the 2026-07-28 MCP Spec Release Candidate" (29.06.2026). **Kein Post vom oder um den 28.07.2026 zu einem finalen Release** (Prüfzeitpunkt).
4. **RC-Blogpost** [V4]: wörtlich „The release candidate is locked as of May 21, 2026. The final specification will be published on **July 28, 2026**. The ten-week window is for SDK maintainers and client implementers to validate the changes." Das Datum in Dossier 04 stammt also aus einer **Ankündigung**, nicht aus einem Vollzug.
5. **URL-Probe** [V5]: `modelcontextprotocol.io/specification/2026-07-28` → **404**. Die 2026er-Inhalte sind nur unter `/specification/draft/` erreichbar, dort explizit als Draft markiert [V6].
6. **Sekundärecho** [S1–S3]: Akamai, WorkOS, SecurityWeek u. a. schreiben durchgängig prospektiv („ships July 28", „what security teams must prepare for") — sie referieren die Ankündigung und belegen keinen Vollzug.

**Wichtige Einschränkung:** Heute *ist* der angekündigte Release-Tag. Ein Vollzug im Tagesverlauf (US-Zeitzonen) ist möglich und sogar wahrscheinlich; der Entscheid gilt „Stand Prüfzeitpunkt". Handlungsleitend ist deshalb nicht das Datum, sondern der **Umstellungstrigger** (Abschnitt 4): Erst wenn die Versioning-Seite [V1] 2026-07-28 als Current führt und das Repo einen Nicht-Pre-release-Tag trägt, gilt die Revision als erschienen. Blogposts und Presse sind dafür keine hinreichende Quelle — genau diese Verwechslung war der Fehler in Dossier 04.

## 2. Was am RC-Inhalt heute direkt verifizierbar ist

Der Draft-Changelog auf der Website [V6] ist schlanker als der RC-Blogpost und listet: Entfernung der Protokoll-Sessions (`Mcp-Session-Id` entfällt; Cross-Call-State über explizite, server-generierte Handles als normale Tool-Argumente; SEP-2567), `extensions`-Feld in Client-/ServerCapabilities, dokumentierte OpenTelemetry-Konventionen für `_meta` (`traceparent`/`tracestate`/`baggage`), deterministische Tool-Sortierung für Caching, Standard-Header-Pflicht auf Streamable-HTTP-POST inkl. `x-mcp-header` (SEP-2243). Das bestätigt den Kern der 04er-Beschreibung (Stateless Core, Extensions, OTel-Tracing).

Die **Deprecated-Registry** [V7] (unter `/specification/draft/deprecated`, normativ über die per-Feature-Notices) präzisiert die Deprecations:

| Feature | Deprecated in | Frühestes Removal | Migrationspfad |
|---|---|---|---|
| Roots | 2026-07-28 | erste Revision ≥ 2027-07-28 | Tool-Parameter, Resource-URIs, Serverkonfiguration |
| Sampling | 2026-07-28 | erste Revision ≥ 2027-07-28 | direkte LLM-Provider-APIs |
| Logging | 2026-07-28 | erste Revision ≥ 2027-07-28 | stderr (stdio) bzw. OpenTelemetry |
| **Dynamic Client Registration** | **2026-07-28** | erste Revision ≥ 2027-07-28 | **Client ID Metadata Documents** |
| HTTP+SSE-Transport | 2025-03-26 | 3 Monate nach SEP-2596 Final | Streamable HTTP |

Zwei Befunde daraus: (a) Die 12-Monats-Uhr ist an die Revision 2026-07-28 gebunden („Deprecated in 2026-07-28", frühestes Removal ab 2027-07-28) — sie läuft formal erst mit deren tatsächlichem Erscheinen; die Handlungsempfehlung („nichts Neues darauf bauen") gilt trotzdem sofort, denn die Registry sagt ausdrücklich „new implementations SHOULD NOT adopt". (b) Die **DCR-Deprecation ist ein in Dossier 04 fehlender Punkt** mit praktischer Relevanz für jeden eigenen OAuth-geschützten Remote-Server.

**Nicht einzeln nachverifiziert** (weiter nur über den RC-Blogpost [V4] belegt, Status „RC-Inhalt"): Tasks-Rückführung in eine Extension, `InputRequiredResult`, die sechs OAuth-Angleichungen, Konformitätssuite/SDK-Tiers. MCP Apps (Extension, seit 26.01.2026) und Enterprise-Managed Authorization (stable seit 18.06.2026) sind **Extensions mit eigener Versionierung** und in ihrer Gültigkeit vom Core-Release unabhängig — die 04er-Aussagen dazu bleiben unberührt.

## 3. Dossier-04-Empfehlungen: bestätigt vs. zu relativieren

**Uneingeschränkt bestätigt** (vom Spec-Status unabhängig):
- CLI-first, MCP-second; Playwright MCP; eigener schmaler Remote-Server als Multi-Client-Fassade (Empf. 1–3).
- M0–M4-Ergänzungen (Herkunftsvertrauen, Lese/Schreib-Split, Output-Budget) und Sicherheitsleitplanken inkl. NSA-CSI und Lethal-Trifecta-Prüfung (Empf. 4–5).
- Hook-basiertes Aufruf-Logging und W3C Trace Context in `_meta` (Empf. 6) — Letzteres ist bereits im Draft-Changelog dokumentiert [V6] und abwärtskompatibel nutzbar.
- Kontextkosten-Empfehlungen (Tool Search, Instructions < 2 KB) (Empf. 7); „Nicht investieren"-Liste (Empf. 9).
- Spec-Hygiene „nichts Neues auf Roots/Sampling/MCP-Logging" (Empf. 8, Kern) — durch die Registry sogar formal untermauert [V7]; **zu ergänzen um: kein Dynamic Client Registration in neuen eigenen OAuth-Flows**.

**Zu relativieren:**
- „Die finale Spezifikation erscheint heute" (Abschn. 2) → **falsch als Tatsachenbehauptung**; korrekt: RC seit 21.05. eingefroren, Finalisierung für heute *angekündigt*, zum Prüfzeitpunkt nicht vollzogen [V1–V5].
- „Stateless Core senkt Betriebskosten von Remote-Servern" als Ist-Nutzen → Design-Aussage des RC; praktisch nutzbar erst mit released Spec und stabilen SDKs (Beta seit 29.06. [V3]). Bis dahin: Server gegen 2025-11-25 bauen, aber ohne serverseitigen Session-State (Handles statt Sessions) — das ist heute schon spec-konform und macht die spätere Migration trivial.
- Deprecation-*Fristen*: 12-Monats-Fenster startet erst mit Release der 2026er-Revision; die in 04 implizierte laufende Frist ist zu früh datiert. Verhaltensempfehlung unverändert.
- Bewertungszeile „Eigener Remote-MCP-Server … Stateless Core senkt Betriebsaufwand": Begründung auf „RC-Design, kurz vor Release" umstellen; Bewertung selbst („sinnvoll unter Bedingungen") bleibt.

## 4. Security Best Practices: korrekte URL

Dossier 04 zitierte `…/specification/2025-06-18/basic/security_best_practices`. Diese Alt-URL existiert weiterhin (Revisions-Archiv) [V9], **maßgeblich ist aber die Fassung der Current-Revision**: `https://modelcontextprotocol.io/specification/2025-11-25/basic/security_best_practices` [V8]. Inhaltlich deckt die aktuelle Fassung alles in 04 Referenzierte ab (Confused Deputy, Token-Passthrough-Verbot, SSRF über OAuth-Discovery, Session Hijacking — „Sessions dürfen nie Authentifizierung ersetzen", Local-Server-Compromise inkl. Consent mit vollständigem Kommando und Sandboxing, OAuth-URL-Validierung/XSS/RCE, stdio-Proxy-Eskalation, Scope-Minimierung). Die Seite verlinkt intern auf `/specification/latest/…` — für den Steckbrief empfiehlt sich die revisionsgebundene 2025-11-25-URL (stabil zitierbar) plus Vermerk, dass `latest` stets auf Current zeigt.

## 5. Methodische Lehre für das Forschungsprogramm

Der 04/13-Konflikt ist ein Lehrbuchfall **„Ankündigung ≠ Vollzug"**: Ein präzises, glaubwürdiges Release-Datum aus einem offiziellen Blogpost wurde am Stichtag als Fakt übernommen, während die normative Statusquelle (Versioning-Seite, Release-Tags) das Gegenteil zeigte. Sekundärquellen verstärken solche Fehler, weil sie Ankündigungen prospektiv abschreiben [S1–S3]. Regel ab jetzt: **Spezifikations- und Versionsstatus ausschließlich an der normativen Statusseite bzw. am Release-Artefakt festmachen (Statusseite > Release-Tag > Changelog > Blog > Presse)**; angekündigte Termine als „geplant für" führen, nie als vollzogen — auch und gerade am Stichtag selbst.

## Konsequenzen für Andreas

1. **CLAUDE.md-Steckbrief: MCP-Zielrevision = 2025-11-25 (Current)** — normative Referenz für eigene Server und Konfigurationsentscheidungen; Security-Best-Practices-Link auf die 2025-11-25-URL umstellen.
2. **Design-Vorgabe „2026-ready" ergänzen:** kein Reliance auf `Mcp-Session-Id`; Anwendungszustand über explizite Handles; keine Roots/Sampling/MCP-Logging in Neubauten (stderr/OTel stattdessen); in eigenen OAuth-Flows kein Dynamic Client Registration mehr neu einführen, Client ID Metadata Documents als Migrationspfad beobachten; W3C Trace Context in `_meta` schon jetzt mitführen.
3. **Umstellungstrigger definieren statt Datum:** Steckbrief erst auf 2026-07-28 heben, wenn (a) die Versioning-Seite sie als Current führt, (b) das Spec-Repo ein Final-Tag (kein Pre-release) trägt und (c) die genutzten SDKs (Python/TypeScript) stabile Releases dafür haben; danach zusätzlich abwarten, bis Claude Code die Revision ausrollt. Prüfrhythmus: kurzer Check in den nächsten Tagen (Release ist unmittelbar bevorstehend), sonst wöchentlich.
4. **Dossier 04 bleibt als Sachstandsdossier nutzbar** — mit diesem Addendum als Korrekturblatt: Abschnitt 2 dort ist als „RC-Inhalt, Release angekündigt" zu lesen; die Handlungsempfehlungen 1–9 gelten fort (Empf. 8 um die DCR-Deprecation erweitert).
5. **Für die Synthese v2 (K6):** Konfliktlinie 1 ist aufgelöst — Dossier 13 hatte den korrekten Stand; die 04er-Inhalte sind sachlich richtig, nur der Reifegrad war überzeichnet. Keine der Architekturentscheidungen (CLI-first, schmale eigene Fassade, Sicherheitsleitplanken) hängt am Release-Termin.

## Quellenverzeichnis

Alle [V]-Abrufe am 2026-07-28.

1. [V1] MCP Spezifikation: Versioning („current protocol version is 2025-11-25"; Statusdefinitionen Draft/Current/Final) — https://modelcontextprotocol.io/specification/versioning
2. [V2] GitHub: modelcontextprotocol/modelcontextprotocol — Releases (2025-11-25 „Latest"; „MCP 2026-07-28 RC" als Pre-release vom 29.05.2026) — https://github.com/modelcontextprotocol/modelcontextprotocol/releases
3. [V3] MCP Blog Index (jüngste Spec-Posts: RC 21.05.2026, Beta-SDKs 29.06.2026; kein Final-Release-Post) — https://blog.modelcontextprotocol.io/
4. [V4] MCP Blog: The 2026-07-28 Specification Release Candidate („locked as of May 21, 2026 … will be published on July 28, 2026"; Stateless Core, Extensions, MCP Apps, Tasks, Deprecations) — https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
5. [V5] Negativbefund: https://modelcontextprotocol.io/specification/2026-07-28 → HTTP 404
6. [V6] MCP Spezifikation: Draft-Changelog (Session-Entfernung SEP-2567, Extensions-Capabilities, OTel-`_meta`, deterministische Sortierung, Header SEP-2243; Seite als Draft markiert) — https://modelcontextprotocol.io/specification/draft/changelog
7. [V7] MCP Spezifikation: Deprecated Features Registry (Roots/Sampling/Logging/DCR „Deprecated in 2026-07-28", frühestes Removal ≥ 2027-07-28; SEP-2577, SEP-2596, PR #2858) — https://modelcontextprotocol.io/specification/draft/deprecated
8. [V8] MCP Spezifikation 2025-11-25: Security Best Practices (aktuelle kanonische Fassung) — https://modelcontextprotocol.io/specification/2025-11-25/basic/security_best_practices
9. [V9] MCP Spezifikation 2025-06-18: Security Best Practices (Alt-Revision, weiterhin erreichbar — von Dossier 04 zitierte URL) — https://modelcontextprotocol.io/specification/2025-06-18/basic/security_best_practices
10. [V10] MCP Spezifikation 2025-11-25: Landingpage (Schema-Referenz schema/2025-11-25/schema.ts) — https://modelcontextprotocol.io/specification/2025-11-25
11. [S1] Akamai: The New MCP Specification — What Security Teams Must Prepare For (prospektiv) — https://www.akamai.com/blog/security-research/new-mcp-specification-security-teams-must-prepare
12. [S2] WorkOS: The biggest MCP spec update ships July 28 (prospektiv) — https://workos.com/blog/mcp-2026-spec-agent-authentication
13. [S3] SecurityWeek: New Enterprise-Ready MCP Specification Brings New Security Challenges (prospektiv) — https://www.securityweek.com/new-enterprise-ready-mcp-specification-brings-new-security-challenges/
