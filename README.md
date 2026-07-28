# KI-native Software- und Systems-Engineering-Methodik — Forschungsrepository

**Eigentümer:** Andreas (Chefarchitekt, Product Owner, Freigabeinstanz)
**Stand:** 2026-07-28
**Status:** Recherche-Sweep, Konsolidierung und Tranche 1 abgeschlossen — Entscheidungsvorlage liegt beim Eigentümer

> ⚠️ **Dieses Repository muss privat bleiben.** Es enthält Infrastrukturdetails (Heimserver-Inventar, Gerätenamen, Netzwerkinformationen) und interne Betriebsüberlegungen. Vgl. die Lehre aus der Portfolio-Analyse (Kapitel 14: temporär öffentliche Repos als Reconnaissance-Risiko).

---

## Worum es geht

Dieses Repository sammelt die Forschung zum Aufbau einer professionellen, KI-nativen Software- und Systems-Engineering-Methodik für private, anspruchsvolle Softwareprojekte: Ein menschlicher Chefarchitekt steuert Ziele, Anforderungen, Architektur und Freigaben; KI-Agenten analysieren, planen, implementieren, testen, dokumentieren und verbessern innerhalb klarer Leitplanken. Grundlage ist der Forschungsauftrag in `input/KI_native_Software_Engineering_Zielbild_und_Forschungsauftrag.md`.

## Struktur

```
input/                  Ausgangskorpus (7 Dokumente)
  ├─ Forschungsauftrag, Methodik v4.0, CLAUDE.md-Vorlage,
  ├─ Analyse/Refactoring v4, Recherche-Kompendium,
  ├─ GitHub-Portfolio-Analyse (11 Projekte, 5 Archetypen)
  └─ Heimserver-Inventar (HP EliteDesk 800 G6)

recherche/              Ergebnisse des Forschungsprogramms vom 28.07.2026
  ├─ 00_FORSCHUNGSPLAN.md          Ablauf, Läufe, Konventionen, nächste Schritte
  ├─ 00_SYNTHESE.md                Gesamtsynthese v2 (alle 16 Dossiers, Konflikte entschieden)
  ├─ 00_KRITIK_UND_LUECKEN.md      Vollständigkeitskritik (4 Konfliktlinien, Lücken, Prio-Plan)
  ├─ 00_SYNTHESE_v1_basis13.md     archivierte Erstsynthese (Provenance)
  ├─ 01–13                         Sweep-Dossiers zu den Forschungsfeldern 7.1–7.15
  ├─ 14–16                         Anbieter-Ökosysteme (Claude, OpenAI & Co., Server-/DB-Administration)
  ├─ 04a, 17–20                    Konsolidierungs-Addenda (MCP-Status, Empirie-Anker,
  │                                fehlende Organisationen, Kostenmodell, Windows-Autonomie-Matrix)
  └─ tranche1/                     Tranche-1-Ergebnis (Operating Model)
       ├─ ENTWURF_A_evolution.md       konkurrierender Entwurf: Delta auf v4.0
       ├─ ENTWURF_B_lifecycle.md       konkurrierender Entwurf: Lifecycle-Neuschnitt
       ├─ ENTWURF_C_enforcement.md     konkurrierender Entwurf: Enforcement-first
       ├─ JUDGE_J1_praxis.md           Gutachten Praxis/Right-Sizing
       ├─ JUDGE_J2_evidenz.md          Gutachten Evidenz/Vollständigkeit
       └─ OPERATING_MODEL_REFERENZMODELL.md   ★ finales Referenzmodell (v1.0-Entwurf)
```

## Einstiegspunkte

1. **`recherche/tranche1/OPERATING_MODEL_REFERENZMODELL.md`** — das Hauptergebnis: Operating Model und Lifecycle-Referenzmodell als v4.1-Delta-Paket, mit elf offenen Eigentümerentscheidungen **OE-1 bis OE-11**.
2. **`recherche/00_SYNTHESE.md`** — der Gesamtüberblick über alle Befunde inkl. der entschiedenen Konfliktlinien (MCP-Spec-Status, METR-Anker, Benchmark-Regel B1–B5, Windows-Autonomie-Grenze).
3. **`recherche/00_FORSCHUNGSPLAN.md`** — was gelaufen ist und was als Nächstes ansteht.

## Konventionen

Dokumentation deutsch, Commits englisch (gemäß `input/CLAUDE.md`). Quellenstatus **[V]** = Primärquelle selbst abgerufen und geprüft (mit Abrufdatum), **[S]** = über Suchergebnisse belegt. Bewertungsskala je Methode/Technologie: jetzt empfohlen · sinnvoll unter Bedingungen · pilotgeeignet · beobachten · überdimensioniert · nicht belastbar · überwiegend Marketing.

## Provenance

Erstellt am 2026-07-28 in einer Claude-Cowork-Session durch parallele Recherche-Agenten (5 Läufe, ~35 Agenten, ~430 geprüfte Quellen), orchestriert als resumefähige Workflows mit unabhängiger Vollständigkeitskritik und konkurrierenden Entwurfs-/Gutachter-Agenten. Die Wissensbasis liegt zusätzlich im Claude-Projekt „KI Methodik und Engineering Approach".
