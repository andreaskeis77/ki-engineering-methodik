# Laufzeitklassen K0–K2: Deterministik-first für Produkte

**Stand:** 2026-07-28
**Status:** beschlossen (Eigentümerentscheidung OE-12, Geltung: Laufzeit der Produkte — die Entwicklung bleibt agentengestützt)
**Einordnung:** Verallgemeinerung des OE-2-Musters (LLM raus aus dem Promotionspfad) zum Architekturprinzip; Kostenbezug: Dossier 19

---

## 1. Das Prinzip

> **Deterministisch, wo spezifizierbar. LLM zur Laufzeit nur, wo das Verstehen oder Erzeugen von Sprache und Bildern der Kern der Aufgabe ist — und dann mit Budget, Gate, Fallback und Provenance.**

Zwei Fragen sind strikt zu trennen: *Womit wird entwickelt?* (agentengestützt — unverändert, Agenten schreiben hervorragend rein deterministischen Code) und *Was ruft das Produkt zur Laufzeit auf?* (dieses Dokument). Motive: Kosten, Reproduzierbarkeit, Offline-Fähigkeit, Testbarkeit, Unabhängigkeit von Anbietern und Preisänderungen.

## 2. Die drei Laufzeitklassen

| Klasse | Definition | Anforderungen |
|---|---|---|
| **K0 — Kein Laufzeit-LLM** (Default) | Verhalten vollständig deterministisch: Regeln, Algorithmen, klassisches ML, Parser, SQL | keine besonderen; normale Gates |
| **K1 — LLM optional, austauschbar** | LLM nur als punktueller, planbarer Batch-Schritt (Anreicherung, Extraktion, Klassifikations-Bootstrap) | Mock-Modus; Ergebnis-Cache; Schema-Validierung des Outputs; Betrieb läuft ohne LLM weiter (graceful degradation); Provenance je Ergebnis (Modell, Version, Prompt-Hash, Abrufzeit); Kostenvoranschlag |
| **K2 — LLM-Kernfunktion („Premium")** | Sprach-/Bildverstehen oder -erzeugung ist der Produktkern | bewusste Eigentümerentscheidung je Feature; Kosten-Cap; Modell-Eval mit Ground Truth (Capsule-Muster); Fakten-/Publish-Gates vor Veröffentlichung; definierter degradierter Modus; Provenance |

**Zusatzregeln:** Nie ein LLM im kritischen Pfad ohne deterministisches Gate dahinter (Zero-Trust, Methodik 20.1; OE-2). Klassifikation ist Pflichtfeld der Spezifikation (Vorlage 28.3) und wird im Review geprüft (N-Regel). Ein K2-Feature, dessen LLM-Anteil nach Bootstrap durch Regeln ersetzbar wird, steigt bewusst nach K1/K0 ab — das ist ein Erfolg, kein Rückschritt.

## 3. Entscheidungsregel (in dieser Reihenfolge prüfen)

1. Ist das Verhalten vollständig spezifizierbar (Schema, Regeln, Algorithmus)? → **K0.**
2. Gibt es eine klassische 90-%-Lösung (Parser, Regex, FTS, Heuristik, klassisches ML), deren Rest tolerierbar oder manuell abdeckbar ist? → **K0.**
3. Wird Sprach-/Bildverstehen nur punktuell, planbar und cachebar gebraucht? → **K1.**
4. Ist es der Produktkern und rechtfertigt der Nutzen die laufenden Kosten (Faustformeln Dossier 19)? → **K2.**
5. Im Zweifel: als Experiment nach Kapitel 27 mit Variantenvergleich klassisch vs. LLM entscheiden, nicht aus Bequemlichkeit.

## 4. Aufgabentypen: klassisch zuerst

| Aufgabentyp | Klassischer Weg (Default) | LLM gerechtfertigt, wenn … |
|---|---|---|
| Strukturierte Daten parsen (CSV/JSON/APIs) | immer klassisch | — |
| Berechnung, Statistik, Simulation | klassisch (vgl. boxscore Elo/Monte-Carlo) | — |
| CRUD, Workflows, Dashboards, Benachrichtigungen | klassisch | — |
| Volltextsuche | SQLite FTS5 / PostgreSQL tsvector | echter semantischer Suchbedarf belegt ist (dann zuerst lokale Embeddings prüfen) |
| Entity Resolution, Dubletten | deterministische Regeln, klassische Record-Linkage-Verfahren | nur als Vorschlagsgeber mit Human Review (curio-Muster) |
| OCR gedruckter Dokumente | Tesseract-Klasse | Layout chaotisch/Handschrift → K1-Batch mit Rohdaten-Cache |
| Klassifikation mit stabilem, kleinem Schema | Regeln oder klassisches ML | LLM einmalig als Trainingsdaten-Bootstrap (K1), danach K0 |
| Extraktion aus stabilem HTML | Parser/Selektoren | Layout instabil → K1 mit Schema-Validierung |
| Freitext-Beratung, redaktionelle Texterzeugung, Bildverstehen, semantische Synthese | — | Kernfall für K1/K2 |

## 5. Portfolio-Klassifikation (Stand 2026-07-28)

| Projekt | Laufzeitklasse | Begründung / Konsequenz |
|---|---|---|
| **boxscore** | K0-Kern + K2-Modul | Daten, Elo, Monte-Carlo, SSG: rein deterministisch. Content-Generierung: K2 mit Fakten-Gates und Wochen-Kostencap (beibehalten); Promotion seit OE-2 deterministisch |
| **new_nfl** | **K0** | vollständig deterministische Datenplattform — kein Laufzeit-LLM |
| **capsule** | **K2 (Premium)** | Foto-Analyse und Beratung sind der Produktkern — bestätigt. Modell-Evals und Kostenbeobachtung weiterführen; prüfen, welche Ontologie-Zuordnungen nach Bootstrap in K0-Regeln übergehen |
| **capsule-app** | **K0** | reiner API-Client; alle KI-Funktionen liegen serverseitig in Capsule |
| **curio** | **K1/K2-Grenzfall** | LLM-Proposals sind zentral, aber batchartig mit Mock-Modus, Human Review und Provenance — die **Referenzimplementierung des K1-Musters**; so lassen |
| **joes-journal** | **K0** | redaktionelles Produkt, kein Laufzeit-LLM nötig |
| **tischatlas** | **K0-Kern**, K1-Kandidat | Domänenmodell, Identität, Preise: deterministisch/explizit mehrdeutig. Karten-/Dokumentextraktion als möglicher K1-Batch (Rohdokument-Cache existiert, Schema-Validierung, Review) |
| **fritz_old / wlan / funkatlas** | **K0** | Messung und Diagnose deterministisch; optional später K1-Berichtszusammenfassungen (nice-to-have, kein Bedarf) |
| **server-migration** | **K0** (Laufzeit) | Agenten nur als attended Entwicklungs-/Discovery-Werkzeug |

**Befund:** 8 von 11 Projekten sind zur Laufzeit überwiegend oder vollständig K0 — die Intuition „vieles geht klassisch" ist am eigenen Portfolio belegt. Premium-LLM konzentriert sich bewusst auf capsule (K2), das boxscore-Content-Modul (K2 mit Gates) und curio (K1-Muster).

## 6. Integration in die Methodik v4.1

- Neuer Unterabschnitt **12.5 „Laufzeitklassen K0–K2 (Deterministik-first)"** in `KI_ENGINEERING_METHODIK.md` (Slot frei, kollisionsfrei mit dem laufenden Delta) — wird nach Abschluss des v4.1-Laufs ergänzt.
- `AGENTS.md` § 8 (Architekturvertrag), neue Zeile: „Laufzeit-LLM nur nach K-Klassifikation: K0 ist Default; K1/K2 mit Budget, Gate, Fallback und Provenance (Methodik 12.5)."
- Spec-Vorlage 28.3: Pflichtfeld „Laufzeitklasse".
- Verbindlichkeit: N-Regel (Review-Prüfung), Enforcement über das Spec-Pflichtfeld; Promotion zu härterem Mechanismus bei Verstößen.
