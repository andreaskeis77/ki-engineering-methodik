# Entscheidungsprotokoll — Eigentümerentscheidungen OE-1 bis OE-11

**Datum:** 2026-07-28
**Entscheider:** Andreas (Eigentümer, Chefarchitekt)
**Grundlage:** `OPERATING_MODEL_REFERENZMODELL.md` v1.0-Entwurf, Abschnitt 16; interaktive Entscheidungssession
**Status:** beschlossen — Grundlage für das v4.1-Delta in `KI_ENGINEERING_METHODIK.md` und die Projektverfassungs-Vorlagen

---

## Übersicht

| OE | Thema | Entscheidung | Zur Empfehlung |
|---|---|---|---|
| 1 | M2-Lockerung | **M2 in WSL2 sofort zulassen** | ⚠ ambitionierter |
| 2 | Boxscore-Promotion | CI-Pipeline ohne LLM, Attestation Pflicht | ✓ bestätigt |
| 3 | Serverrollen | **Heimserver wird neues Produktionsziel** | ⚠ weitreichender |
| 4 | Routines-Pilot | Ja: Doku-Drift-Wächter | ✓ bestätigt |
| 5 | Held-out-Ablage | Zweistufig (CI-only-Repo + Deny-Verzeichnis) | ✓ bestätigt |
| 6 | WIP-Limit | 2 offene ungeprüfte Agenten-PRs, N-Regel mit Promotion-Pfad | ✓ bestätigt |
| 7 | Autonomie-Startwerte | Trigger 2/1/1, Degradierung 2 Wochen, Aufstieg ≥20 Tasks · pass³ ≥ 85 % · 4 Wochen | ✓ bestätigt |
| 8 | Kostenrahmen | Max 5x + Credits-Cap 20–40 USD + API-Key mit 25-USD-Limit | ✓ bestätigt |
| 9 | Zeremonie-Profile | Defaults bestätigt; funkatlas dauerhaft LIGHT; Trigger: erster realer Nutzerbetrieb | ✓ bestätigt |
| 10 | AGENTS.md | **Jetzt umstellen** (CLAUDE.md wird dünne Brücke via `@AGENTS.md`) | ✓ bestätigt |
| 11 | A3-Vorabfreigaben | boxscore, new_nfl, tischatlas | ✓ bestätigt |
| 12 | Runtime-LLM-Prinzip | Deterministik-first: Laufzeitklassen K0/K1/K2, K0 als Default | ✚ neu (28.07., nicht aus Referenzmodell) |

## Entscheidungen im Einzelnen

**OE-1 — M2-Lockerung: M2 in WSL2 sofort zulassen.** Unbeaufsichtigte Schreiboperationen (M2) sind erlaubt, wenn der Lauf in der WSL2-Sandbox (Strict-Profil) stattfindet UND jedes Tool+Ziel vorab deklariert und freigegeben ist. Natives Windows bleibt unattended read-only (M0/M1 mit Kompensationspaket). *Abweichung von der konservativen Empfehlung — bewusste Eigentümerentscheidung zugunsten von Automatisierung.* **Voraussetzungen (blockierend):** WSL2 + Sandbox-Profil auf Latitude und EliteDesk eingerichtet und per Negativtest geprüft; Fehlerbudget aus OE-7 gilt uneingeschränkt auch für M2-Läufe (Degradierung entzieht die M2-Erlaubnis zuerst). Review nach einem Quartal mit Eval-Evidenz.

**OE-2 — Boxscore-Promotion: bestätigt.** Content-Refresh läuft als deterministische, einmalig freigegebene CI-Pipeline ohne LLM im Promotionspfad; Artifact-Attestation ist Pflicht; W4 (A4/A5 nie unattended durch Agenten) bleibt unangetastet. Code-Merges immer attended, mobil via Remote Control.

**OE-3 — Serverrollen: Heimserver (HP EliteDesk 800 G6) wird neues Produktionsziel.** Mittelfristig ziehen die Projekte vom Windows-VPS auf den EliteDesk um; das `server-migration`-Vorhaben wird damit als „VPS → Heimserver"-Migration fortgesetzt (statt VPS → Linux). Der Ops-Agent-Pilot Stufe 0 (read-only) startet auf dem EliteDesk und wächst mit dem Aufbau mit. *Weitreichender als die Empfehlung.* **Konsequenzen:** eigenes Migrationsvorhaben mit Phasenplan nötig (Inventar-Backlog aus dem Heimserver-Dokument wird Phase 0: SMART, BIOS/VT-x, LAN-Kabel, Tailscale, Energieprofil); VPS bleibt bis zum vollzogenen Umzug unverändert produktiv; kein Parallelbetrieb ohne klare System-of-Record-Regel je Projekt.

**OE-4 — Routines-Pilot: ja, Doku-Drift-Wächter.** Nächtliche read-only Cloud-Routine prüft Doku-/Statuskonsistenz gegen Code-Realität und legt Draft-Reports auf `claude/`-Branches ab. Strikt unter der 7-Punkte-Bedingungsliste (M0/M1, Konnektorenliste leer, keine Secrets im Environment, kein Full-Netz, nur private Repos, Output nur `claude/`-Kanal, Ergebnisprüfung durch Andreas). Adressiert die portfolioweite Schwäche Nr. 1 (Dokumentationsdrift).

**OE-5 — Held-out-Ablage: zweistufig bestätigt.** Separates privates CI-only-Repo mit Abnahmetests für boxscore und new_nfl; Deny-Verzeichnis (mit dokumentierter String-Schwäche) für alle übrigen Projekte.

**OE-6 — WIP-Limit: 2, als N-Regel.** Maximal 2 offene ungeprüfte Agenten-PRs; zunächst gemessene Regel (Kennzahl im Run-Manifest/Portfolio-Status), Promotion zum Hook (`gh pr create`-Blockade) bei wiederholten Verstößen gemäß E/N/I-Promotion-Pfad.

**OE-7 — Autonomie- und Fehlerbudget-Startwerte: bestätigt.** Degradierung bei 2 Defekt-Escapes ∨ 1 Gate-Umgehung ∨ 1 Trifecta-Verstoß, Dauer 2 Wochen; Aufstieg ab ≥20 Golden Tasks mit pass³ ≥ 85 % und stabiler Rework-Quote über 4 Wochen. Als Startwerte markiert; Kalibrierung nach dem ersten Quartal.

**OE-8 — Kostenrahmen: bestätigt.** Max 5x als Fundament; Usage Credits mit 20–40 USD Monats-Cap als Überlauf; separater Console-API-Key mit 25-USD-Workspace-Spend-Limit für CI und unbeaufsichtigte SDK-Läufe. Max-20x-Prüfung frühestens nach zwei Monaten `/usage`-Evidenz. Kosten-Soll/Ist als Run-Manifest-Pflichtfelder.

**OE-9 — Zeremonie-Profile: bestätigt.** Archetyp-Defaultmatrix aus Abschnitt 13 gilt; LIGHT ist beweislastfreier Default für Reversibles (≤1 Seite Artefaktbudget, Begründungspflicht für STANDARD); funkatlas-Exploration dauerhaft LIGHT; Wechsel nach STANDARD beim ersten realen Nutzerbetrieb.

**OE-10 — AGENTS.md-Umstellung: jetzt.** Die Projektverfassung wandert inhaltlich in `AGENTS.md` (offener Standard); `CLAUDE.md` wird dünne Brücke via `@AGENTS.md`-Import (Windows: Import, kein Symlink). Umstellung der Bestandsrepos agentengestützt als eigener mechanischer Lauf; Vorlagen ab sofort in dieser Form. Macht Codex/Gemini als Zweitagenten für Quervalidierung nutzbar.

**OE-11 — A3-Vorabfreigaben: boxscore, new_nfl, tischatlas.** Diese drei Repos erhalten die exakte Vorabfreigabe für Push + Draft-PR aus W3-Umgebungen (WSL2-Sandbox/CI). Merge (A4) bleibt ausnahmslos attended. Alle übrigen Repos: unattended endet bei A2 (lokaler Commit).

**OE-12 — Runtime-LLM-Prinzip (neu, 28.07.): Deterministik-first für Produkte.** Geltung nur Laufzeit; die Entwicklung bleibt agentengestützt. Drei Laufzeitklassen: K0 (kein LLM, Default), K1 (LLM optional als austauschbarer Batch-Schritt mit Mock-Modus, Cache, Schema-Validierung, Fallback, Provenance), K2 (LLM-Kernfunktion „Premium" — bewusste Entscheidung je Feature mit Kosten-Cap, Modell-Eval, Fakten-Gates, degradiertem Modus). Nie LLM im kritischen Pfad ohne deterministisches Gate. Klassifikation ist Spec-Pflichtfeld (N-Regel). Portfolio-Klassifikation und Entscheidungsregel: `recherche/21_runtime_llm_klassifikation.md` — Befund: 8 von 11 Projekten überwiegend K0; Premium-LLM konzentriert auf capsule (K2), boxscore-Content (K2 mit Gates), curio (K1-Referenzmuster).

## Unmittelbare Folgearbeiten aus den Entscheidungen

1. **v4.1-Delta einarbeiten** in `KI_ENGINEERING_METHODIK.md` (Delta-Tabelle + diese Entscheidungen als verbindliche Werte) und Vorlagen-Umbau `AGENTS.md` + `CLAUDE.md`-Brücke (OE-10) — beauftragt.
2. WSL2 + Sandbox-Profil einrichten und negativ testen (Voraussetzung OE-1), danach A3-Freigaben konfigurieren (OE-11).
3. Migrationsvorhaben „VPS → EliteDesk" als eigenes Projekt aufsetzen (OE-3), Phase 0 = Inventar-Backlog.
4. Routines-Pilot Doku-Drift-Wächter konfigurieren (OE-4) — nach 2.
5. Held-out-Repo für boxscore/new_nfl anlegen (OE-5); Kostenrahmen technisch umsetzen (OE-8: Credits-Cap, API-Key mit Spend-Limit).
6. OE-12 in v4.1 integrieren: neuer Unterabschnitt 12.5 (Laufzeitklassen K0–K2), AGENTS.md-§8-Zeile, Spec-Pflichtfeld „Laufzeitklasse" — nach Abschluss des laufenden v4.1-Laufs, um Edit-Konflikte zu vermeiden.
