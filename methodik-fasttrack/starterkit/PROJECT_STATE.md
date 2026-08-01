# PROJECT_STATE — Snapshot

> **Regel:** Diese Datei wird bei jedem Session-Ende **komplett überschrieben** — nie additiv fortschreiben. Sie ist die einzige Statuswahrheit des Projekts. Jede Aussage trägt ihre Evidenzart: `behauptet` / `getestet` / `real abgenommen`.

```yaml
projekt: "[name]"
stand: "[YYYY-MM-DD HH:MM]"
lifecycle: idea            # idea | concept | active-development | pilot | paused | superseded | archived
phase: P0                  # P0 Kickoff | P1 MVP | P2 Advanced MVP | P3 Beweis-Review | P4 Übergabe
haertungstrigger_gefeuert: false   # true sobald echte Nutzer/echte Daten → P3 erzwingen
autonomie: "stehende Freigabe aktiv"   # oder: "erloschen am [YYYY-MM-DD] wegen [Grund]"
ports: []                  # z. B. [8321]
datenbanken: []            # z. B. ["sqlite: ./data/app.db"]
letzter_commit: ""
naechster_checkpoint: "[MVP-Demo | Beweis-Review | —]"
pausiert_bis: null         # PAUSIEREN = exit_entscheid bleibt null + pausiert_bis gesetzt
exit_entscheid: null       # null | HÄRTEN | NEUBAU | VERWERFEN
```

## Was funktioniert

- `[Feature/Slice]` — `[behauptet | getestet | real abgenommen]`

## Was nicht funktioniert / bekannte Schulden

- `[offene Brüche, bewusste Abkürzungen, Testschulden]`

## Wiederaufnahmeschritt (genau einer)

`[Der eine konkrete nächste Schritt, mit dem die nächste Session sofort produktiv startet.]`

<!-- Beim P3-Entscheid HÄRTEN/NEUBAU/VERWERFEN: Succession Record als SUCCESSION.md im Repo-Root anlegen.
Vorlage (aus METHODIK_FASTTRACK.md Kap. 11.3):

# Succession Record — <projekt>
- Entscheid (Datum): HÄRTEN | NEUBAU | VERWERFEN
- Warum: <2–5 Sätze: was hat die Idee bewiesen/widerlegt>
- Was übernommen wird: <Konzepte, Datenmodelle, Code-Teile, Erkenntnisse>
- Was bewusst verworfen wird und warum:
- Kanonisches Nachfolge-Repo: <Link oder «keins»>
- Gesamtkosten Prototyp: <aus KOSTEN.md>
- Learnings für die Methodik: <max. 3 Stichpunkte>
-->

