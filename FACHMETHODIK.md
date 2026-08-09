# FACHMETHODIK — Fachmethodiken als dritte Achse

**Version:** 1.0 · **Stand:** 2026-08-09 · **Eigentümer:** Andreas (Product Owner, Freigabeinstanz)
**Gilt neben:** Standard v4.1 (`methodik/`) und Fast-Track v1.0 (`methodik-fasttrack/`)

> **Kernsatz:** Eine **Projektmethodik** beantwortet, *wie viel Prozess* ein Projekt braucht — man wählt genau eine. Eine **Fachmethodik** beantwortet, *wie mit einem Gegenstand gearbeitet wird* — sie gilt zusätzlich, neben der gewählten Projektmethodik, und ein Projekt wendet null bis mehrere davon an.

> **Zum Wort „dritte Achse":** gemeint ist die dritte Methodik neben Standard v4.1 und Fast-Track v1.0 — **keine dritte Wahlmöglichkeit**. Man wählt nicht zwischen Standard, Fast-Track und Quellenarbeit; man wählt eine Projektmethodik und wendet die passenden Fachmethodiken zusätzlich an.

---

## 1. Zwei Fragen, die nicht dieselbe sind

Das Repo führt zwei Projektmethodiken: Standard v4.1 (`methodik/`) und Fast-Track v1.0 (`methodik-fasttrack/`). Beide beantworten dieselbe Frage — *wie viel Prozess braucht dieses Projekt?* — und schließen einander aus. Die Eignungsweiche in `methodik-fasttrack/METHODIK_FASTTRACK.md` Kapitel 2 ist genau das: eine Weiche.

Daneben steht eine zweite Frage, die von beiden unbeantwortet bleibt: *wie arbeitet man mit einem Gegenstand?* Für Quellen heißt das Kataloge, Normdaten, Werk gegen Ausgabe, Zitierfähigkeit, Verifikationsschuld, Beschaffungsrecht — nichts davon steht in einer der beiden Projektmethodiken.

Diese zweite Frage ist **keine dritte Weichenstellung.** Ein Projekt kann Fast-Track sein und Quellenarbeit brauchen; ein anderes kann Standard v4.1 sein und dieselbe Quellenarbeit brauchen. Eine Regel, die man *zusätzlich* anwendet, gehört nicht in eine Auswahl, aus der man eine nimmt.

| | **Projektmethodik** | **Fachmethodik** |
|---|---|---|
| Beantwortet | wie viel Prozess | wie arbeitet man mit einem Gegenstand |
| Anzahl je Projekt | genau eine | null bis mehrere |
| Verhältnis | schließen einander aus | gelten zusätzlich, nebeneinander |
| Heute | Standard v4.1, Fast-Track v1.0 | Quellenarbeit (`fachmethodik/quellenarbeit/`) |
| Bei Konflikt | — | Projektmethodik hat Vorrang, Abweichung wird deklariert |

## 2. Verhältnis zur Projektmethodik

Eine Fachmethodik **ergänzt, sie ersetzt nichts.** Sie hebt keine Regel der gewählten Projektmethodik auf, keine harte Grenze und keinen Gate-Schritt. Sie setzt keine Projektmethodik voraus und schreibt keine vor: dasselbe Kapitel gilt unter Standard v4.1 wie unter Fast-Track.

Wo eine Fachmethodik einer Regel der gewählten Projektmethodik widerspricht, gilt **die Projektmethodik** — und die Abweichung wird **im Projekt deklariert**, nicht in der Fachmethodik und nie stillschweigend. Der Ort der Deklaration ist der, an dem das Projekt seine Entscheidungen ohnehin führt: eine Zeile in `DECISIONS.md` unter Fast-Track (`METHODIK_FASTTRACK.md` Kap. 8) oder ein ADR unter Standard v4.1 (Methodik 26.4).

Der Referenzfall liegt vor: `bismarck` führt sein Datenmodell mit deutschen Feldnamen und weicht damit von Methodik 1.4 ab („Code, Identifier, Branches und Commit-Nachrichten auf Englisch"). Die Abweichung steht als Zeile in `DECISIONS.md` des Projekts, mit Begründung und verworfener Alternative — nicht als Ausnahme in der Methodik. Genau so sieht der Normalfall aus: Die Regel bleibt, was sie ist; das Projekt trägt seine Abweichung sichtbar.

Die Wahrheitshierarchie der Methodik 3.1 bleibt unberührt. Recht, Plattformregeln und technisch erzwungene Sicherheitsgrenzen stehen über jeder Fachmethodik. Eine Fachmethodik rangiert dort, wo die projektübergreifenden Defaults rangieren (Stufe 5), nicht darüber.

## 3. Was eine Fachmethodik nicht ist

**Kein Fachwissen, keine Anleitung zum Gegenstand.** Sie regelt das *Arbeiten*, nicht die Sache. „Wie prüfe ich eine bibliographische Angabe" gehört hinein, „wer war Bismarck" nicht.

Die Abgrenzung läuft über eine Faustregel:

> Eine Regel gehört in die Fachmethodik, wenn ein **zweites Projekt mit anderem Gegenstand** sie unverändert übernehmen könnte.

Daraus folgen drei Ausschlüsse:

- **Keine Projektbelegung.** `id-vergabe` gilt für jede Literaturdatenbank, `port_betrieb: 3314` gilt für `bismarck`. Ports, Pfade, Kontonamen und Ressourcen bleiben im Projekt.
- **Keine Entscheidung über ein konkretes Datenmodell.** Welche Felder ein Projekt führt und in welcher Sprache, ist eine Projektentscheidung und steht in `DECISIONS.md` oder im ADR — auch dann, wenn sie gut begründet ist.
- **Keine Portfolio- oder Werkzeugbefunde.** Beobachtungen über das Haus — gelebte Konventionen, Werkzeugketten, Prozesse — gehören nach `methodik/` oder `methodik-fasttrack/`, nicht in eine Fachmethodik. Die Fachmethodik ist kein Sammelbecken für alles, was sonst keinen Platz hat.

## 4. Wie eine neue Fachmethodik entsteht

**Aus einem Projekt heraus, nie auf Vorrat.** Wer eine Fachmethodik ohne Projekt anlegt, beschreibt eine Arbeit, die niemand gemacht hat.

**Bedingung für die Anlage:** mindestens **zwei Kapitel im Reifegrad `erprobt`** aus einem realen Projekt (Reifegrade siehe Abschnitt 5). Vorher ist der richtige Ort das Projekt selbst — dort entstehen die Regeln am Material, dort ändern sie sich, und dort gehören sie hin, solange sie sich noch ändern.

Anlage, wenn die Bedingung erfüllt ist:

1. Ordner `fachmethodik/<name>/` mit einem `README.md`: Kapitelgerüst als Tabelle (Kapitel, Reifegrad, Herkunft, Fälle, Stand, nächster fälliger Schritt), Beschreibung je Kapitel, Erbschaftsabschnitt nach Abschnitt 6 dieser Datei.
2. Eintrag in den Bestand (Abschnitt 7 dieser Datei).
3. Eigentümerfreigabe — die Anlage einer Fachmethodik ist keine Agentenentscheidung.

**Keine leere Kapiteldatei.** Ein Kapitel existiert als Zeile in der Tabelle, bis es Inhalt hat. Ein leeres `verifikationsregeln.md` sieht in sechs Wochen aus, als gäbe es Verifikationsregeln.

**Gründungsfall Quellenarbeit (deklarierte Ausnahme).** `fachmethodik/quellenarbeit/` ist zusammen mit dieser Achse angelegt worden und erfüllt die Zwei-Kapitel-Bedingung heute **nicht** — sie führt zwei Kapitel im Reifegrad `Entwurf` und fünf `geplant`. Die Ausnahme ist eine Eigentümerentscheidung für die Gründung und gilt für keine weitere Fachmethodik. Sie trägt dieselbe Frist wie ein einzelnes Kapitel (Abschnitt 5): Erreicht Quellenarbeit nicht binnen zweier Aufträge des Projekts `bismarck` zwei Kapitel im Reifegrad `erprobt`, wird der Ordner nicht stillschweigend weitergeführt, sondern zurückgebaut — oder die Bedingung wird begründet geändert.

## 5. Reifegrade — der Mechanismus, ohne den das Gerüst nur guter Wille ist

Jedes Kapitel einer Fachmethodik trägt einen Reifegrad. Er wird im README der jeweiligen Fachmethodik je Kapitel geführt.

| Stufe | Bedeutung | Bedingung für den Aufstieg |
|---|---|---|
| **geplant** | benannt, nicht geschrieben | — |
| **Entwurf** | im Projekt geschrieben, noch nicht oder nur an einer Stichprobe angewandt | vollständige Anwendung auf die Grundgesamtheit |
| **erprobt** | auf die **volle Grundgesamtheit** angewandt, mit genannter **Fall- und Fehlerzahl** und Datum | mindestens einmal unter Korrekturdruck geändert und danach stabil geblieben |
| **bewährt** | in zwei Projekten oder über zwei Aufträge hinweg stabil | — |

Drei Regeln dazu — sie sind der Punkt der Übung:

**Nur `bewährt` wird kopiert.** Kapitel im Reifegrad `Entwurf` oder `erprobt` stehen in der Fachmethodik **als Verweis auf das Projektdokument**, nicht als Kopie. Solange eine Regel sich noch ändert, darf sie nur an einer Stelle stehen. Der Verweis lautet auf **Repo, Pfad und Commit**, nicht nur auf den Dateinamen — ein Dateiname belegt nichts, wenn die Datei sich seit dem Verweis dreimal geändert hat.

**Der Aufstieg von `Entwurf` zu `erprobt` verlangt nicht nur eine Fallzahl, sondern die vollständige Anwendung auf die Grundgesamtheit, die das Kapitel zu regeln beansprucht — mit genannter Fehlerzahl.** Eine Regel, die auf eine Stichprobe angewandt wurde, ist **geprüft**, nicht **erprobt**. Stichprobe und Grundgesamtheit sind zwei verschiedene Evidenzstufen. „Hat sich bewährt" ist keine Evidenz; „auf 280 Titel angewandt, 61 Fälle auf der Nacharbeitsliste, 4 Regeländerungen" ist eine. Ohne Zahl kein Aufstieg — ohne Grundgesamtheit auch nicht. Das ist derselbe Unterschied wie zwischen `behauptet` und `getestet` in den Statusdateien (`METHODIK_FASTTRACK.md` Kap. 3 Nr. 5).

*Warum die Grundgesamtheit und nicht die Stichprobe:* Eine Stichprobe trifft die häufigen Fälle und verfehlt die seltenen — 25 von rund 340 Zeilen erreichen eine Formklasse mit vier bis sechs Vorkommen rechnerisch nicht, und genau dort bricht eine Regel. Der Befund, aus dem diese Klausel stammt, steht im Projekt: Die Mehrzahl der Regelbrüche an `id-vergabe` v0.1 kam **nach** der Stichprobe, aus Klasseninventar und vollständiger Durchsicht (`bismarck` · `doku/methodik/id-vergabe.md` Abschnitt 8 · Commit `9461933`).

**Ein Kapitel, das zwei Aufträge lang `Entwurf` bleibt, wird entweder erprobt oder gestrichen.** Anti-Drift nach demselben Muster wie der Promotion-Pfad für N-Regeln in Methodik 26.8: Eine Regel ohne Mechanismus darf nicht wie eine Regel aussehen. Ein Kapitel ohne Anwendung auch nicht.

Zusätzlich führt das README je Kapitel den **nächsten fälligen Schritt**. Ein Reifegrad ohne benannten nächsten Schritt ist ein Zustand, den niemand verlässt.

## 6. Was nicht in einer Fachmethodik steht

Eine Fachmethodik ist immer nur die **fachliche Hälfte**. Die allgemeine Hälfte steht in der Langmethodik und wird nicht verdoppelt: Verifikationsdisziplin und Publish-Gate (Kapitel 20), eine Wahrheit je Datensorte, Datenzonen, Adapter und Ingest (13.1–13.3), Dokumentenkanon und Doku-Anti-Drift (3.2, 3.3).

Das ist nicht Sparsamkeit, sondern der Grund, aus dem OE-10 `CLAUDE.md` zur Brücke gemacht hat (Methodik 26.9): Zwei Fassungen derselben Regel driften, und man merkt es an der Stelle, an der man sich auf sie verlässt. Jedes Fachmethodik-README trägt deshalb einen Abschnitt, der ausdrücklich benennt, was dort **nicht** steht, weil es schon in der Langmethodik steht — mit Verweis, nicht mit Kopie.

## 7. Der Rückweg — was passiert, wenn eine Regel aufgestiegen ist

Ab dem Reifegrad **`bewährt`** ist die Fachmethodik die **kanonische Fassung**, und das Projektdokument wird zum Verweis auf sie. Nicht umgekehrt, und **nie beides zugleich**.

| Reifegrad | Kanonische Fassung | Die andere Seite |
|---|---|---|
| `geplant`, `Entwurf`, `erprobt` | Projektdokument | Fachmethodik verweist darauf (Repo, Pfad, Commit) |
| `bewährt` | Fachmethodik | Projektdokument wird zum Verweis; abweichende Projektregeln werden zu deklarierten Abweichungen nach Abschnitt 2 |

Der Übergang ist ein Arbeitsschritt, kein Nebeneffekt: Beim Aufstieg auf `bewährt` wandert der Text in die Fachmethodik, und das Projektdokument wird im selben Arbeitsblock auf einen Verweis zurückgeschnitten (Doku-Anti-Drift, Methodik 3.3).

Wer das nicht festlegt, hat nach dem zweiten Projekt zwei Fassungen von `id-vergabe.md`, die sich in einem Detail unterscheiden, und keine Möglichkeit zu entscheiden, welche gilt. Es ist dieselbe Bewegung wie bei `AGENTS.md`: eine Wahrheit, alles andere Brücke.

## 8. Bestand

| Fachmethodik | Ordner | Entstanden aus | Kapitel | Stand |
|---|---|---|---|---|
| Quellenarbeit | [`fachmethodik/quellenarbeit/`](fachmethodik/quellenarbeit/README.md) | `bismarck` | 7 (2 Entwurf, 5 geplant) | 2026-08-09 |

Neue Zeilen entstehen nur nach Abschnitt 4. Eine Fachmethodik, deren Kapitel sämtlich `geplant` sind, gehört nicht in diese Tabelle, sondern in das Projekt, das sie braucht.

## 9. Verbindlichkeit und Pflege

**Verbindlichkeit (Methodik 26.8):** Alle Regeln dieser Datei sind **N** — normativ, nicht erzwungen. Es gibt heute keinen Mechanismus, der prüft, ob ein Kapitel seinen Reifegrad, seine Fallzahl oder seinen nächsten fälligen Schritt trägt; Verstöße fallen im Learn-Review auf (Methodik 9.8), nicht im Gate. Was keinen Mechanismus hat, darf nicht E heißen.

**Promotion-Kandidat:** Ein Check, der jede Kapitelzeile eines Fachmethodik-README auf vollständige Felder (Reifegrad, Herkunft, Fälle, Stand, nächster Schritt) und jeden Verweis auf `Entwurf`/`erprobt`-Kapitel auf die Form *Repo + Pfad + Commit* prüft. Er wird gebaut, wenn die Regel zweimal nachweislich verletzt wurde — nicht vorher (Methodik 26.8, Promotion-Pfad).

**Pflege:** Abschnittsnummern dieser Datei sind Referenzanker wie die Kapitelnummern der Langmethodik (Methodik 26.7): Neues wird als Unterabschnitt ergänzt, bestehende Abschnitte werden nicht verschoben. Änderungen an Abschnitt 2 (Vorrang), Abschnitt 4 (Anlagebedingung), Abschnitt 5 (Reifegrade) und Abschnitt 7 (Rückweg) sind Eigentümerentscheidungen.
