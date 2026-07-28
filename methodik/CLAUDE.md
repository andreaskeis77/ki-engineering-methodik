# CLAUDE.md — Claude-Code-Brücke zur Projektverfassung

**Zweck:** Dünne Brücke gemäß OE-10 (Methodik-Version 4.1, Stand 2026-07-28). Die operative Projektverfassung steht vollständig in `AGENTS.md` und wird nur dort gepflegt; Einbindung unter Windows als Import, kein Symlink.

@AGENTS.md

Nur Claude-Code-Spezifisches:

- Enforcement laut Methodik Kapitel 26: Permission-Rules/Settings, Sandbox-Profil (unbeaufsichtigte Schreibläufe nur mit `failIfUnavailable: true`) und Hooks (Audit, Kill-File, PreToolUse-Gates) müssen eingerichtet sein — Verfassungstext ersetzt sie nicht.
- Hooks, Skills, Agents und Settings kommen versioniert aus dem privaten Methodik-Plugin (Methodik 26.9); lokale Abweichungen nur per ADR.
- `/loop`-Session-Crons verfallen nach 7 Tagen (Expiry); Wiederkehrendes rechtzeitig der zuständigen Scheduler-Ebene zuordnen (`AGENTS.md` Abschnitt 7 bzw. Methodik 11.8).
