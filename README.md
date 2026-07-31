# KI-native Software- und Systems-Engineering-Methodik — Forschungsrepository

**Eigentümer:** Andreas (Chefarchitekt, Product Owner, Freigabeinstanz)
**Stand:** 2026-07-30
**Status:** Recherche, Konsolidierung, Tranche 1 und die Eigentümerentscheidungen OE-1 bis OE-12 sind abgeschlossen; die Methodik liegt als v4.1 in `methodik/` vor. **Offen ist die physische Inkraftsetzung** — die Regeln sind geschrieben, die erzwingenden Mechanismen noch nicht eingerichtet (Stand siehe `methodik/infrastruktur/HOME-SRV01_STATUS.md`).

> ⚠️ **Dieses Repository muss privat bleiben.** Es enthält Infrastrukturdetails (Heimserver-Inventar, Gerätenamen, Konten- und Rollenmodell, Tailscale- und Heimnetzadressen, Firewall-Konfiguration) und interne Betriebsüberlegungen. Vgl. die Lehre aus der Portfolio-Analyse (Kapitel 14: temporär öffentliche Repos als Reconnaissance-Risiko).
>
> Kennwörter, Tokens und BitLocker-Recovery-Schlüssel gehören **nicht** in dieses Repository — auch nicht in ein privates. Sie liegen ausschließlich im Passwortmanager plus Offline-Kopie.

---

## Worum es geht

Dieses Repository sammelt die Forschung zum Aufbau einer professionellen, KI-nativen Software- und Systems-Engineering-Methodik für private, anspruchsvolle Softwareprojekte: Ein menschlicher Chefarchitekt steuert Ziele, Anforderungen, Architektur und Freigaben; KI-Agenten analysieren, planen, implementieren, testen, dokumentieren und verbessern innerhalb klarer Leitplanken. Grundlage ist der Forschungsauftrag in `input/KI_native_Software_Engineering_Zielbild_und_Forschungsauftrag.md`.

## Struktur

```
methodik/               ★ die geltende Methodik (v4.1) — hier steht, was gilt
  ├─ KI_ENGINEERING_METHODIK.md    Langfassung v4.1 (Begründungen, Verfahren, Vorlagen)
  ├─ AGENTS.md                     operative Projektverfassung (Vorlage, agentenneutral)
  ├─ CLAUDE.md                     dünne Brücke via @AGENTS.md (OE-10)
  ├─ runbooks/                     ausführbare Verfahren
  │    ├─ RUNBOOK_WSL2_SANDBOX_SETUP.md   schaltet OE-1/OE-11 physisch scharf (NT-1..NT-6)
  │    └─ RUNBOOK_BACKUP_RESTIC_HETZNER.md Offsite-Backup append-only, öffnet das A5-Gate (NT-B1..NT-B6)
  └─ infrastruktur/
       └─ HOME-SRV01_STATUS.md     ★ gepflegter Serverstatus + was er erlaubt/sperrt

input/                  Ausgangskorpus (8 Dokumente)
  ├─ Forschungsauftrag, Methodik v4.0, CLAUDE.md-Vorlage,
  ├─ Analyse/Refactoring v4, Recherche-Kompendium,
  ├─ GitHub-Portfolio-Analyse (11 Projekte, 5 Archetypen),
  ├─ Heimserver-Inventar (HP EliteDesk 800 G6, 28.07. — Hardwareteil gültig)
  └─ HOME-SRV01 As-built und Betrieb (30.07., maßgeblich für Software/Konfiguration)

recherche/              Ergebnisse des Forschungsprogramms vom 28.07.2026
  ├─ 00_FORSCHUNGSPLAN.md          Ablauf, Läufe, Konventionen, nächste Schritte
  ├─ 00_SYNTHESE.md                Gesamtsynthese v2 (alle 16 Dossiers, Konflikte entschieden)
  ├─ 00_KRITIK_UND_LUECKEN.md      Vollständigkeitskritik (4 Konfliktlinien, Lücken, Prio-Plan)
  ├─ 00_SYNTHESE_v1_basis13.md     archivierte Erstsynthese (Provenance)
  ├─ 01–13                         Sweep-Dossiers zu den Forschungsfeldern 7.1–7.15
  ├─ 14–16                         Anbieter-Ökosysteme (Claude, OpenAI & Co., Server-/DB-Administration)
  ├─ 04a, 17–21                    Konsolidierungs-Addenda (MCP-Status, Empirie-Anker,
  │                                fehlende Organisationen, Kostenmodell, Windows-Autonomie-Matrix,
  │                                Runtime-LLM-Klassifikation K0–K2)
  └─ tranche1/                     Tranche-1-Ergebnis (Operating Model)
       ├─ ENTWURF_A_evolution.md       konkurrierender Entwurf: Delta auf v4.0
       ├─ ENTWURF_B_lifecycle.md       konkurrierender Entwurf: Lifecycle-Neuschnitt
       ├─ ENTWURF_C_enforcement.md     konkurrierender Entwurf: Enforcement-first
       ├─ JUDGE_J1_praxis.md           Gutachten Praxis/Right-Sizing
       ├─ JUDGE_J2_evidenz.md          Gutachten Evidenz/Vollständigkeit
       ├─ OPERATING_MODEL_REFERENZMODELL.md   finales Referenzmodell (v1.0-Entwurf)
       └─ ENTSCHEIDUNGSPROTOKOLL_OE.md ★ die getroffenen Entscheidungen OE-1 bis OE-12
```

## Einstiegspunkte

1. **`methodik/AGENTS.md`** — was in jedem Projekt gilt: Modi, Autoritätsstufen A0–A5, Sicherheitskern, W-Matrix. Der kürzeste Weg zum verbindlichen Teil.
2. **`methodik/infrastruktur/HOME-SRV01_STATUS.md`** — wo die Umsetzung real steht: Serverzustand und welche Autonomiestufe er heute erlaubt bzw. sperrt.
3. **`recherche/tranche1/ENTSCHEIDUNGSPROTOKOLL_OE.md`** — die zwölf getroffenen Eigentümerentscheidungen **OE-1 bis OE-12** mit Begründung; das zugehörige Referenzmodell steht in `OPERATING_MODEL_REFERENZMODELL.md`.
4. **`recherche/00_SYNTHESE.md`** — der Gesamtüberblick über alle Befunde inkl. der entschiedenen Konfliktlinien (MCP-Spec-Status, METR-Anker, Benchmark-Regel B1–B5, Windows-Autonomie-Grenze).
5. **`recherche/00_FORSCHUNGSPLAN.md`** — was gelaufen ist und was als Nächstes ansteht.

## Konventionen

Dokumentation deutsch, Commits englisch (gemäß `input/CLAUDE.md`). Quellenstatus **[V]** = Primärquelle selbst abgerufen und geprüft (mit Abrufdatum), **[S]** = über Suchergebnisse belegt. Bewertungsskala je Methode/Technologie: jetzt empfohlen · sinnvoll unter Bedingungen · pilotgeeignet · beobachten · überdimensioniert · nicht belastbar · überwiegend Marketing.

## Provenance

Erstellt am 2026-07-28 in einer Claude-Cowork-Session durch parallele Recherche-Agenten (5 Läufe, ~35 Agenten, ~430 geprüfte Quellen), orchestriert als resumefähige Workflows mit unabhängiger Vollständigkeitskritik und konkurrierenden Entwurfs-/Gutachter-Agenten. Die Wissensbasis liegt zusätzlich im Claude-Projekt „KI Methodik und Engineering Approach".
