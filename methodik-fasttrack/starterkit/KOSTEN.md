# KOSTEN — Transparenz-Log (append-only, nie Blocker)

> **Regel:** Vor jeder größeren Front (neue Etappe, Fanout, Massenlauf) eine Schätzzeile; nach dem Lauf das Ist nachtragen. Ist-Quelle: Headless-/API-Läufe melden `total_cost_usd` (aus `claude -p --output-format json`) — Pflicht. Im Abo-Betrieb kann die Session das exakte Ist nicht lesen: grobe Eigenschätzung mit Marker `geschätzt` oder `n/a (Abo)` eintragen; exaktes Ist trägt der Eigentümer optional per `/usage` nach.
> Daumenregeln: Chat 1× · Einzelagent ≈4× · Agent-Teams ≈7× · Multi-Agent-Fanout ≈15× Tokenverbrauch · 1 Mio. agentische Tokens ≈ 2,5–4 USD (Sonnet-Klasse) · schwere Fanouts je 5h-Fenster: ~1 auf Pro, 2–3 auf Max 5x.

**Projektschätzung MVP (P0):** `[z. B. „~5–8 Mio. Tokens ≈ 15–30 USD API-Äquivalent bzw. X Abo-Fenster"]`

| Datum | Etappe/Lauf | Muster | Modell | Schätzung | Ist | Notiz |
|---|---|---|---|---|---|---|
| `[YYYY-MM-DD]` | `[was]` | `[solo/fanout×N/teams]` | `[modell]` | `[vorab]` | `[nachher]` | |
