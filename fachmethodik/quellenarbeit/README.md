# Fachmethodik Quellenarbeit

**Version:** 0.1 (Gerüst) · **Stand:** 2026-08-09 · **Entstanden aus:** `bismarck`
**Achse und Regeln:** [`../../FACHMETHODIK.md`](../../FACHMETHODIK.md)

Wie arbeitet man mit Quellen: Kataloge und Normdaten, Werk gegen Ausgabe, Zitierfähigkeit, Verifikationsschuld, Beschaffungsrecht. Die Fachmethodik gilt **zusätzlich** zur gewählten Projektmethodik — Standard v4.1 oder Fast-Track v1.0 —, sie ersetzt keine von beiden. Bei Konflikt gilt die Projektmethodik, und die Abweichung wird im Projekt deklariert (`FACHMETHODIK.md` Abschnitt 2).

**In dieser Datei steht heute das Kapitelgerüst, kein Kapitel.** Die Kapitel werden in `bismarck` am realen Material geschrieben und wandern nach der Reifegradregel (`FACHMETHODIK.md` Abschnitt 5) hierher — kapitelweise, und erst ab `bewährt` als Text statt als Verweis. Es liegt bewusst **keine leere Kapiteldatei** im Ordner: Ein leeres `verifikationsregeln.md` sähe in sechs Wochen aus, als gäbe es Verifikationsregeln.

---

## 1. Kapitelgerüst

Die Spalte **Fälle** ist die wichtigste: an wie vielen realen Einzelfällen die Regel angewandt worden ist. Eine Regel mit „—" ist eine Behauptung, eine Regel mit „280" ein Befund — derselbe Unterschied wie zwischen `behauptet` und `getestet` in den Statusdateien.

| Kapitel | Reifegrad | Herkunft | Fälle | Stand | Nächster fälliger Schritt |
|---|---|---|---|---|---|
| `id-vergabe` | Entwurf | bismarck | 25 | 2026-08-09 | Aufstieg zu *erprobt* nach dem Massenlauf in Auftrag 02, Fallzahl aus der Bilanz |
| `erfassungsregeln` | Entwurf | bismarck | 25 | 2026-08-09 | Aufstieg zu *erprobt* nach dem Massenlauf in Auftrag 02, Fallzahl aus der Bilanz |
| `verifikationsregeln` | geplant | bismarck, Auftrag 04 | — | — | Entwurf im Projekt schreiben, wenn der erste Abgleich gegen einen Katalog läuft |
| `quellenkritik` | geplant | bismarck | — | — | Entwurf im Projekt schreiben, sobald der erste Datensatz einer Quellenedition entsteht |
| `belegregeln` | geplant | bismarck, Auftrag 03 | — | — | Entwurf im Projekt schreiben, wenn die erste Kernaussage belegt wird |
| `datenstrategie` | geplant | bismarck, Auftrag 02 | — | — | Entwurf im Projekt schreiben; Pflichtartefakt für Datenprojekte nach Methodik 3.2 |
| `beschaffungsregeln` | geplant | bismarck, Auftrag 05 | — | — | Entwurf im Projekt schreiben, bevor der erste Harvester Inhalte lädt |

**Verweise auf die Kapitel im Reifegrad `Entwurf`** (Repo, Pfad, Commit — nicht nur Dateiname; `FACHMETHODIK.md` Abschnitt 5):

| Kapitel | Verweis |
|---|---|
| `id-vergabe` | `bismarck` · `doku/methodik/id-vergabe.md` · Commit `9461933` (2026-08-09, Entwurf v0.2) |
| `erfassungsregeln` | `bismarck` · `doku/methodik/erfassungsregeln.md` · Commit `9461933` (2026-08-09, Entwurf v0.2) |

Solange ein Kapitel `Entwurf` oder `erprobt` ist, ist das Projektdokument die kanonische Fassung. Ab `bewährt` dreht sich das um (`FACHMETHODIK.md` Abschnitt 7) — nie beides zugleich.

## 2. Was die sieben Kapitel regeln sollen

Die Beschreibungen stammen aus dem Methodik-Abgleich (`bismarck` · `doku/methodik-abgleich.md` Abschnitt 4 · Commit `9461933`); die projektspezifischen Prüffälle stehen dort und bleiben dort. Hier steht nur, was ein zweites Projekt mit anderem Gegenstand unverändert übernehmen könnte.

**`id-vergabe`** — Bildungsregel für Datensatz-IDs und alles, was daran hängt: fehlendes Jahr, mehrere Verfasser, Körperschaften statt Personen, Kollisionen, mehrere Ausgaben desselben Werks, Umlaute und Transliteration. Das Kapitel steht zuerst, weil die ID das Einzige ist, was sich später nicht mehr billig ändern lässt — sie ist Dateiname, Verweisziel und Registeranker zugleich.

**`erfassungsregeln`** — Was in welches Feld gehört. Namensform, die Unterscheidung von Werk, Ausgabe und Bearbeitung, der Umgang mit nicht tragenden Datierungen und mit Angaben, die in der Vorlage mehrdeutig sind (etwa Verlagsort gegen Erscheinungsort). Die Regel über allen: Was nicht belegt ist, bleibt leer.

**`verifikationsregeln`** — Die Quellenhierarchie für bibliographische Angaben, fachlich analog zur Statusquellen-Hierarchie in Methodik 20.7: normativer Katalog beziehungsweise Normdatenbank vor Verlagsangabe vor Aggregator vor Sekundärerwähnung. Wann wird ein Datensatz von `roh` zu `geprüft`? Was gilt als Treffer — Titel- und Jahrestoleranz, unscharfer Abgleich? Und was bei Widerspruch geschieht: nach Methodik 13.1 ein Finding, kein stilles Überschreiben.

**`quellenkritik`** — Wann ein quellenkritischer Eintrag Pflicht ist (Quelleneditionen, tendenziöse Sammlungen, amtliche Aktenpublikationen) und was mindestens darin stehen muss: Entstehungszusammenhang, Auswahlprinzip, bekannte Tendenz, Forschungsstand zur Edition.

**`belegregeln`** — Was ein Beleg ist und was eine Kernaussage. Zitatlänge und Urheberrecht, Format der Fundstelle, Paraphrase gegen Zitat, das Verhältnis von These zu Zitat. Ohne diese Ebene stehen am Ende verifizierte Titel, und keine Frage ist einen Schritt weiter.

**`datenstrategie`** — Das Pflichtartefakt für Daten- und KI-Projekte nach Methodik 3.2: Quellen, IDs, Provenance, Retention, Rechte. Zieht `id-vergabe` und die Rechtefragen zusammen und ist damit das Kapitel, das die anderen bindet.

**`beschaffungsregeln`** — Was heruntergeladen, gespeichert und wie lange gehalten werden darf: robots.txt, Nutzungsbedingungen, Lizenzen und Fernleihe. Die fachliche Umsetzung der harten Grenze aus `METHODIK_FASTTRACK.md` Kap. 9 Nr. 9 („Zugriffssperren werden nicht umgangen; Lizenzfragen parken das betroffene Paket").

## 3. Was diese Fachmethodik von der Langmethodik erbt

> Die Fachmethodik Quellenarbeit ist die fachliche Hälfte. Die allgemeine Hälfte steht in Kapitel 13 und 20 der Langmethodik und wird nicht verdoppelt.

Folgendes steht **nicht** hier, weil es schon dort steht — Verweis, keine Kopie:

| Langmethodik | Was dort geregelt ist | Warum es hier fehlt |
|---|---|---|
| Kapitel 20 — KI-, Quellen- und Datenverifikation | Zero-Trust für KI-Output (20.1), Grounding (20.2), Dokument-/OCR-/Extraktionspipeline in zehn Schritten (20.3), resilienter API-Client (20.5), Publish-Gate (20.6), Statusquellen-Hierarchie „Ankündigung ≠ Vollzug" (20.7) | Das ist die allgemeine Verifikationsdisziplin. Die Fachmethodik setzt sie voraus und ergänzt nur, was am Gegenstand *Quelle* hinzukommt |
| 13.1 — Eine Wahrheit je Datensorte | kanonische Quelle, erlaubte abgeleitete Quellen, Provenance, Konfliktregel, Qualitätscheck; „Konflikte über Toleranz sind Findings, keine Einladung zum stillen Überschreiben" | `verifikationsregeln` benennt die fachliche Hierarchie, nicht das Prinzip |
| 13.2 — Datenzonen | raw → staging/normalized → curated → serving, jede Transformation reproduzierbar und auf Provenance zurückführbar | gilt für jedes Datenprojekt, nicht nur für Quellen |
| 13.3 — Adapter und Ingest | `fetch → snapshot/provenance → validate → parse → normalize → reconcile → publish`, Input-/Output-Contract, Fixtures, Schema-Drift, „keine stillen Datenverluste" | `beschaffungsregeln` regelt, *was* geladen werden darf, nicht *wie* ein Adapter gebaut wird |

Die Aufarbeitung dieser Deckungen steht im Methodik-Abgleich (`bismarck` · `doku/methodik-abgleich.md` Abschnitt 3.2 · Commit `9461933`).

Der Grund für die Trennung ist nicht Sparsamkeit: Zwei Fassungen derselben Regel driften, und man merkt es an der Stelle, an der man sich auf sie verlässt — dieselbe Überlegung, aus der OE-10 `CLAUDE.md` zur Brücke gemacht hat (Methodik 26.9).

## 4. Offene Punkte

| # | Punkt | Gehört wohin |
|---|---|---|
| Q1 | **Reifegrad `id-vergabe` und `erfassungsregeln`.** Beide sind nach dem Wortlaut der Reifegradregel bereits `erprobt`: an 25 geschichteten Einträgen angewandt, mit Datum, unter Korrekturdruck geändert. Beide Projektdokumente führen sich selbst weiter als `Entwurf` und behalten sich den Massenlauf vor. Diese Tabelle folgt der Selbstauskunft des Projekts. **Der Aufstieg ist eine offene Eigentümerentscheidung**, fällig mit der Bilanz aus Auftrag 02 | hier, beim nächsten Stand der Tabelle |
| Q2 | **Commit-Betreff deutsch.** `README.md` und `input/CLAUDE.md` schreiben Commit-Nachrichten englisch vor (Methodik 1.4). Zwei Projekte des Portfolios leben es anders: englischer Conventional-Commits-Typ, deutscher Betreff, ASCII-transliteriert. Zwei Projekte gegen eine Zeile Schrift ist ein Befund, keine Nachlässigkeit | **nicht hierher** — Portfolio-Befund für `methodik/KI_ENGINEERING_METHODIK.md` Abschnitt 1.4. In diesem Auftrag bewusst nicht angefasst |

## 5. Pflege

Jede Änderung an einem Kapitel im Projekt aktualisiert die Zeile in Abschnitt 1: Reifegrad, Fallzahl, Stand, nächster fälliger Schritt und — bei `Entwurf` und `erprobt` — den Commit im Verweis. Ein Kapitel, das zwei Aufträge lang `Entwurf` bleibt, wird erprobt oder gestrichen (`FACHMETHODIK.md` Abschnitt 5).
