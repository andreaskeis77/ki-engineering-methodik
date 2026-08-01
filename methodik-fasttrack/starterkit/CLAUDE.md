# CLAUDE.md — Claude-Code-Brücke (Fast-Track)

**Zweck:** Dünne Brücke gemäß OE-10. Die operative Projektverfassung steht vollständig in `AGENTS.md` und wird nur dort gepflegt (Windows: Import, kein Symlink).

@AGENTS.md

Nur Claude-Code-Spezifisches:

- Dies ist ein **Fast-Track-Projekt**: maximale Autonomie im Projekt-Scope, siehe `AGENTS.md` Abschnitt 3. Nutze Subagenten, parallele Agenten und Workflows großzügig; schreibe Agenten-Artefakte sofort auf Disk (resumefähig).
- Plan Mode nur bei echten Architektur-Weichen; Standardfall ist direktes Bauen in Etappen.
- Headless-/CI-Läufe (optional) nutzen den separaten API-Key mit Workspace-Spend-Limit — ob und wo er liegt, steht im Steckbrief (`AGENTS.md`, Feld „API-Key für Headless/CI"); ohne Eintrag keine Headless-Läufe. Ist-Kosten (`total_cost_usd`) in `KOSTEN.md` melden.
- Ändere nie selbständig `.claude/`, `.github/workflows/`, Hooks oder Permission-Settings (Selbstpersistenz-Sperre, `AGENTS.md` Abschnitt 3/5).
