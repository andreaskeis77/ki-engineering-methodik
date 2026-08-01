# Fast-Track-Methodik — Prototypen mit maximaler Geschwindigkeit

**Version 1.0 · Stand 2026-08-01 · Basis: Standard-Methodik v4.1 (`../methodik/`)**

Die zweite Methodik des Hauses: für unbewiesene Ideen, die schnell zu einem sehr guten MVP werden sollen — mit maximaler Autonomie für Claude Code, parallelen Agenten und bewusst höherem Risiko. Beweist sich die Idee, folgt **Härtung** nach Standard-Methodik oder ein **Neubau**, für den der Prototyp als lebende Spezifikation dient. Deshalb: Kosten transparent, Code „chatty", Status ehrlich.

| | Standard-Methodik v4.1 | Fast-Track v1.0 |
|---|---|---|
| Für | bewiesene Produkte, echte Nutzer/Daten | unbewiesene Ideen, nur Eigentümer, synthetische Daten |
| Tempo-Modell | Kontrolle, Gates, Nachweise | max. Autonomie, ein Fast-Gate, zwei Pflicht-Checkpoints + Demos |
| Git | Feature-Branches, PR, Review | trunk-based direkt auf `main` (attended) |
| Doku | voller Kanon | Verfassung + 4 Statusdateien + README |
| Ende | Betrieb | HÄRTEN / NEUBAU / VERWERFEN (Succession Record) |

## Dateien

```
METHODIK_FASTTRACK.md    die Methodik (12 Kapitel, ~1/10 der Standard-Länge)
starterkit/              wird 1:1 in jedes neue Projekt kopiert
  ├─ AGENTS.md           Projektverfassung: Charter, stehende Freigabe, Fast-Gate, harte Grenzen
  ├─ CLAUDE.md           dünne Brücke via @AGENTS.md (OE-10)
  ├─ .claude/settings.json  Permission-Profil = mechanische Form der stehenden Freigabe
  ├─ .gitignore          Secrets bleiben aus Git (.env, Keys, secrets/)
  ├─ PROJECT_STATE.md    Status-Snapshot (wird überschrieben, nie additiv)
  ├─ JOURNAL.md          Baugeschichte (append-only)
  ├─ DECISIONS.md        Einzeiler-Entscheidungen (append-only)
  ├─ KOSTEN.md           Kosten-Transparenz (append-only, nie Blocker)
  └─ README.md           Projekt-README-Gerüst
bootstrap-fasttrack.ps1  neues Projekt in <1 Minute aufsetzen
```

## Neues Projekt starten — drei Wege

**Weg 1 — Skript (empfohlen):**

```powershell
c:\ki-engineering-methodik\methodik-fasttrack\bootstrap-fasttrack.ps1 -Name mein-projekt -BasePath C:\dev -GitHub
```

Legt Ordner + Git-Repo (main) + privates GitHub-Repo an, kopiert das Starterkit (inkl. `.claude/settings.json` und `.gitignore`), setzt Name/Datum ein. `-BasePath` muss außerhalb bestehender Git-Repos liegen (das Skript prüft das). Danach: VS Code öffnen, Claude Code starten, P0-Kickoff (siehe unten).

**Weg 2 — von Hand:** Ordner anlegen, `starterkit/*` **inklusive `.claude/` und `.gitignore`** hineinkopieren, Platzhalter `[Projektname]` / `"[name]"` / `[Datum]` ersetzen, `git init -b main`, privates GitHub-Repo, fertig.

**Weg 3 — Claude Code macht alles:** In einer Claude-Code-Session sagen:

> Setze ein neues Fast-Track-Projekt namens `<name>` unter `<pfad>` auf. Nutze `c:\ki-engineering-methodik\methodik-fasttrack\bootstrap-fasttrack.ps1` (oder kopiere das Starterkit von dort). Führe danach den P0-Kickoff mit mir durch.

## P0-Kickoff (der einzige Pflicht-Setup-Schritt, ≤ 30 Minuten)

Claude Code füllt im Dialog den Steckbrief in `AGENTS.md` (Produktziel, erster Vertical Slice, Non-Scope, Datenquellen, Exit-Kriterium …), trägt die MVP-Kostenschätzung in `KOSTEN.md` ein; der Eigentümer bestätigt das Permission-Profil (`.claude/settings.json`) und richtet den Secret-Scan ein (z. B. `gitleaks`, einmalig). Danach baut Claude autonom los. Startprompt:

> Lies AGENTS.md. Führe den P0-Kickoff mit mir durch: Stelle mir die Fragen für den Steckbrief, fülle ihn aus, trage die Kostenschätzung in KOSTEN.md ein und schlage den ersten Vertical Slice vor. Danach baue los.

## Wann Fast-Track — und wann nicht

Fast-Track **nur** wenn: Idee unbewiesen · keine echten Nutzer/PII · kein Produktionspfad · Verlust verschmerzbar. Sobald Auth für echte Nutzer, echte Daten, Zahlungen, Store oder produktive Infrastruktur ins Spiel kommen: Standard-Methodik (Details: `METHODIK_FASTTRACK.md` Kap. 2). Der erste reale Nutzer ist der Härtungstrigger.

## Was auch hier niemals verhandelbar ist

Secrets · echte PII · Repo-Privatheit · Server-Isolation (eigener Ordner, eigene DB, eigene Ports, keine Adminrechte) · Merge/Deploy nie unbeaufsichtigt · Notausschalter · ehrliche Evidenz (`behauptet`/`getestet`/`real abgenommen`). Vollständig: `METHODIK_FASTTRACK.md` Kap. 9.
