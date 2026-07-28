# Forschungsplan — KI-native Software- und Systems-Engineering-Methodik

**Stand:** 2026-07-28 (Abend) — **Lauf 1, Ergänzungslauf, Konsolidierung und Tranche 1 abgeschlossen**
**Basis:** Forschungsauftrag (Zielbild-Dokument), Methodik v4.0, Analyse/Refactoring v4, Recherche-Kompendium, GitHub-Portfolio-Analyse, Heimserver-Inventar
**Abgestimmt mit Andreas am:** 2026-07-28 (Scope: Sweep + Tranche-1-Tiefe · Ablage: Claude-Projekt + Downloads · Format: Dossiers + Synthese)

---

## 1. Ergebnisstand (alle Läufe abgeschlossen)

| Lauf | Agenten | Ergebnis |
|---|---|---|
| Recherche-Sweep (Felder 7.1–7.15) | 14 | Dossiers 01–13 (~340 Quellen) |
| Ergänzungslauf Anbieter-Ökosysteme (Wunsch Andreas 28.07.) | 3 | Dossiers 14–16 (Claude, OpenAI & Co., Server-/DB-Administration) |
| Vollständigkeitskritik | (im Sweep) | `00_KRITIK_UND_LUECKEN.md` — 4 Konfliktlinien, Abdeckungslücken, Prio-Plan |
| Konsolidierungslauf (Prio 1–8 der Kritik) | 6 | Addenda `04a`, `17`–`20` + **Gesamtsynthese v2** (`00_SYNTHESE.md`, Konflikte entschieden) |
| **Tranche 1: Operating Model** (Auftrag § 14) | 6 | 3 konkurrierende Entwürfe + 2 Gutachten + **`tranche1/OPERATING_MODEL_REFERENZMODELL.md` (v1.0-Entwurf)** |
| Eigentümerentscheidungen (interaktiv, 28.07.) | — | **OE-1 bis OE-12 beschlossen** (`tranche1/ENTSCHEIDUNGSPROTOKOLL_OE.md`); inkl. OE-12 Deterministik-first K0–K2 (`21_runtime_llm_klassifikation.md`) |
| v4.1-Einarbeitung (2 Editoren + unabh. Review + Korrektur) | 4 | **`methodik/`: KI_ENGINEERING_METHODIK.md v4.1, AGENTS.md-Vorlage, CLAUDE.md-Brücke** (1 wichtiger + 5 geringe Review-Befunde, alle behoben) |

Gesamtvolumen: ~35 Agenten-Läufe, ~430 geprüfte Quellen, ~4,8 Mio. verarbeitete Tokens, ein abgefangener Session-Limit-Abbruch (sauber per Resume fortgesetzt — Kostenmodell-Fallstudie in Dossier 19).

## 2. Ablagestruktur im Claude-Projekt

```
input/       — 7 Ausgangsdokumente (6 von Andreas + Heimserver-Inventar HP EliteDesk 800 G6)
recherche/   — 00_FORSCHUNGSPLAN, 00_SYNTHESE (v2), 00_KRITIK_UND_LUECKEN,
               Dossiers 01–16, Addenda 04a + 17–20
recherche/tranche1/ — 3 Entwürfe, 2 Gutachten, OPERATING_MODEL_REFERENZMODELL (v1.0-Entwurf)
```

Lokal zusätzlich: `00_SYNTHESE_v1_basis13.md` (archivierte Erstsynthese, Provenance).

## 3. Konventionen (gelten für alle Folgeläufe)

Quellenstatus [V]/[S] mit Abrufdatum; Bewertungsskala nach Auftrag § 8; Benchmark-Zitierregel B1–B5 (Addendum 17); Statusquellen-Hierarchie „Ankündigung ≠ Vollzug" (Addendum 04a); keine Entscheidungen auf gefühlter Produktivität; Resume-fähige Workflows mit Artefakt je Agent.

## 4. Nächste Schritte

**Entschieden (28.07., interaktive Session):** OE-1 bis OE-12 — mit zwei bewussten Abweichungen von den Empfehlungen (OE-1: M2 unattended in WSL2-Sandbox sofort erlaubt, mit blockierenden Voraussetzungen; OE-3: EliteDesk wird neues Produktionsziel). **Erledigt:** v4.1-Delta eingearbeitet (`methodik/`), OE-12 integriert (Methodik 12.5, SPEC-Pflichtfeld, AGENTS.md § 8).

**Folgearbeiten (offen):**

1. Physische Umsetzung beim Eigentümer: WSL2+Sandbox einrichten und negativ testen (Voraussetzung OE-1/OE-11); Kostenschalter setzen (OE-8); Bestandsrepos auf AGENTS.md-Brücke umstellen (OE-10, agentengestützter Lauf möglich)
2. Ops-Pilot Stufe 0 auf dem EliteDesk (read-only Ops-Agent gemäß Dossier 16, Methodik 25.9) und Migrationsvorhaben VPS → Heimserver aufsetzen (OE-3, Phase 0 = Inventar-Backlog)
3. Offene Beschaffungen aus der Kritik: gated Primärdokumente (DORA-Vollreport, CISA, OWASP-PDF, EN-301-549-Zeitplan), Merge-Konflikt-Empirie
4. Beobachtungsliste: MCP-Release-Vollzug (täglich → wöchentlich), METR-Fixed-Task-Studien H2/2026, Stack-Overflow-Survey 2026, Veracode-Folgeupdate
5. Tranchen 2–6 des Forschungsauftrags (Toolchain-Referenzarchitektur, Quality Engineering, Daten/Ontologien, Experience, Gesamtmethodik) — Tranche 2 ist durch Dossiers 06/14/15/16/19/20 bereits stark vorbereitet
6. Optional: GitHub-Repo (Konnektor oder ZIP-Export der kompletten Struktur)
