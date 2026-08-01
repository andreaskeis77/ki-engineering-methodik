# HOME-SRV01 — gepflegter Infrastrukturstatus und Methodik-Bezug

**Stand:** 2026-08-01 · **Version:** 1.1 · **Eigentümer:** Andreas
**Zweck:** Einzige gepflegte Wahrheit über den Ist-Zustand des Heimservers *und* über die Frage, was dieser Zustand nach der Methodik erlaubt und was er sperrt.

**Quellen:**

- As-built und Betriebsanleitung: [`input/HOME-SRV01_EINRICHTUNG_UND_BETRIEB_2026-07-30.md`](../../input/HOME-SRV01_EINRICHTUNG_UND_BETRIEB_2026-07-30.md) (Einrichtung 30.07.2026, verifizierte Endzustände, Rollback- und Notfallpfade)
- Hardware-Detailinventur: [`input/HEIMSERVER_HP_ELITEDESK_800_G6.md`](../../input/HEIMSERVER_HP_ELITEDESK_800_G6.md) (Stand 28.07.2026, Kapitel 3–5 weiterhin gültig)
- Normativer Rahmen: `KI_ENGINEERING_METHODIK.md` 22.10 (W-Matrix), 23.12 (Matrizen A/B), 25.5 (Backup-Gate), 25.8–25.11 (Betriebs-Layer), sowie [`ENTSCHEIDUNGSPROTOKOLL_OE.md`](../../recherche/tranche1/ENTSCHEIDUNGSPROTOKOLL_OE.md) OE-1, OE-3, OE-11

> **Pflege-Trigger:** jede Änderung an Konten, Netzwerk, Fernzugriff, Verschlüsselung, Backup oder Ausführungsumgebung des Servers; außerdem im monatlichen Learn-Review (Methodik 9.8). Ohne Pflege fällt dieses Dokument auf Stufe I zurück (Methodik-Prinzip P7: kein Artefakt ohne Eigentümer und Pflege-Trigger).

---

## 1. Ist-Zustand in einem Blick

| Bereich | Zustand (30.07.2026) | Methodik-Relevanz |
|---|---|---|
| Identität | `HOME-SRV01`, Tailscale `home-srv01`, IP `100.116.230.81` | Zielsystem OE-3 |
| Betriebssystem | Windows 11 Pro 24H2, sauber neu installiert, OEM aktiviert | Umgebung **E1 — nativ Windows** |
| Rollentrennung | `srvuser` (Standard + RDP), `srvadmin` (lokaler Admin), `andre` (Notfall), builtin `Administrator` deaktiviert | Grundlage für Least Privilege; **Dienstkonto fehlt noch** |
| Verschlüsselung | C: und D: BitLocker XTS-AES 128; C: TPM + Recovery-Passwort, D: Recovery-Passwort + Auto-Unlock | Recovery-Schlüssel extern verifiziert (2026-07-30), D:-Schlüssel per Entsperrprobe bewiesen |
| Lizenz | Windows dauerhaft aktiviert, nach Neuinstallation bestätigt (2026-07-30) | erledigt |
| Firmware | TPM aktiv (IFX 7.85.4555.0), Secure Boot aktiv, HP BIOS 02.26.00 | **VT-x/VT-d weiterhin unbekannt** — blockiert WSL2-Prüfung |
| Fernzugriff | RDP nur über den Tailscale-Adapter; allgemeine RDP-Firewallregeln deaktiviert; Heimnetzzugriff negativ getestet; keine Router-Portfreigabe | Vorbildlich: Änderung mit Rückfalloption **und** Negativbeweis |
| Schutz | Defender aktiv inkl. Tamper Protection, Firewall in allen Profilen aktiv | Basisschicht steht |
| Verfügbarkeit | Standby/Ruhezustand aus, 24/7; Neustartfestigkeit ohne lokale Anmeldung getestet | Voraussetzung für geplante Läufe erfüllt |
| Netzwerkmedium | weiterhin WLAN | Betriebsbedingung des Ops-Piloten (Referenzmodell §11) **nicht** erfüllt |
| Ausführungsumgebung | **kein WSL2, kein Docker, kein Hyper-V** | **Harte Sperre für W3** (siehe §2) |
| Datensicherung | Infrastruktur und Automatik stehen (Hetzner Storage Box `offsite-backup`, restic-Repository, append-only nachweislich wirksam, nächtlicher Lauf als SYSTEM mit VSS seit 2026-07-31, Dead-Man's-Switch verifiziert). **Offen bleibt die Restore-Probe mit echten Daten** (NT-B4/NT-B5) sowie NT-B3 und NT-B6 (§8) | **Harte Sperre für A5**, bis die Restore-Probe bestanden ist (siehe §2) |
| Daten-Layout | D: `DATA`; angelegt sind `backups\{config,staging,cache}`, `logs\backup`, `deploy\scripts` sowie seit 2026-08-01 `dev\` (Quell-Repos), `data\blitz`, `logs\blitz` | `D:\dev` ist **nicht** Sicherungsquelle (GitHub ist die Off-Site-Kopie der Repos); `D:\data` und `D:\deploy` sind es |
| Entwicklungs-Arbeitsplatz | seit 2026-08-01 aktiv: Git, GitHub CLI, VS Code, Claude Code installiert; Methodik-Repo unter `D:\dev\ki-engineering-methodik`; ExecutionPolicy `RemoteSigned` für `CurrentUser` | attended Arbeit nach W1; **läuft unter `srvadmin` — siehe Risiko 1 in §3** |

## 2. Was dieser Zustand erlaubt — und was er sperrt

Maßgeblich ist die Windows-Autonomie-Matrix (Methodik 22.10). `HOME-SRV01` ist Umgebung **E1 (nativ Windows)**.

| Stufe | Status heute | Begründung |
|---|---|---|
| **W1 — attended, bis A5** | ✅ **zulässig** | Der Mensch ist das Gate. RDP über Tailscale ist ein tragfähiger attended Kanal; Remote Control zählt ebenfalls als attended. Einschränkung: A5 nur im Zwei-Schritt Plan → Freigabe → Ausführung. |
| **W2 — unattended read-only (A0; M0/M1)** | ⛔ **noch nicht zulässig** | Nativ Windows verlangt das vollständige Kompensationspaket K+P+H+E+C. Vorhanden ist nur ein Teil der Kontentrennung. Es fehlen: Dienstkonto `svc-claude` ohne Adminrechte, NTFS-ACLs auf Secret-Pfade, read-only-DB-Rollen, lesende Allowlist im `dontAsk`-Modus, Audit- und Kill-File-Hook, praktisch validierte Egress-Firewall je Dienstkonto, ENV-Scrub. Ohne diese Kompensation ist unattended read-only *nicht* durch „Defender und Firewall sind an" gedeckt. |
| **W3 — unattended schreibend (A1–A3; M2)** | ⛔ **gesperrt** | Verlangt prozessgebundene OS-Isolation. Eine native Windows-Sandbox kommt dauerhaft nicht (Issue #46740, „not planned"). WSL2 ist auf dieser Maschine **nicht installiert**. Damit ist OE-1 (M2 unattended) auf `HOME-SRV01` unwirksam, und OE-11 (A3-Vorabfreigaben) gilt hier ebenfalls nicht — Freigaben sind gerätegebunden (Runbook Abschnitt I). |
| **W4 — A4/A5 unattended** | ⛔ **nie**, in keiner Umgebung | unverändert |

**Zusätzliche harte Sperre — Backup-Gate (Methodik 25.5):** Ohne bestandene Restore-Probe jünger als 30 Tage gibt es **keine A5-Freigabe auf Daten- oder Infrastrukturfähigkeiten**. Es existiert bisher kein Backup und keine Probe. Solange das so bleibt, darf `HOME-SRV01` **kein produktives System-of-Record** für migrierte Projekte werden — unabhängig davon, dass OE-3 ihn als künftiges Produktionsziel benannt hat.

**Konsequenz in einem Satz:** Der Server ist heute eine saubere, gut abgesicherte **attended** Arbeitsumgebung. Für jede Form von unbeaufsichtigtem Agentenbetrieb ist er noch nicht freigegeben, und als Produktionsziel ist er durch das Backup-Gate gesperrt.

## 3. Sicherheitsbewertung aus Methodik-Sicht

**Belastbar umgesetzt:**

- Angriffsfläche minimiert: keine öffentliche Exposition, keine Portfreigabe, RDP an genau einen Adapter gebunden — und der Ausschluss wurde **negativ getestet**, nicht nur behauptet. Das entspricht exakt dem geforderten Beweismuster (Runbook Abschnitt G, Methodik-Prinzip „Beobachtung vor Interpretation").
- Identität und Berechtigung getrennt (`srvuser`/`srvadmin`), Notfallkonto vorhanden, builtin-Administrator deaktiviert.
- Verschlüsselung, TPM und Secure Boot aktiv; die Änderung wurde vor der Firewall-Härtung verifiziert.
- Die Firewall-Umstellung folgte dem Muster „Sicherheitsänderung mit Rückfalloption" (neue Regel anlegen → bestehende Sitzung offen lassen → testen → alte Regel deaktivieren → erneut testen). Das ist ein bestätigtes Learn-Muster und gehört als Runbook-Baustein in den Kanon.

- **Recovery-Material gesichert und geprüft (2026-07-30).** Beide BitLocker-Recovery-Schlüssel liegen außerhalb des Servers und stimmen mit den auf der Maschine hinterlegten Protektoren überein; der `D:`-Schlüssel wurde zusätzlich durch eine echte Entsperrprobe bewiesen. Windows ist nach der Neuinstallation dauerhaft aktiviert.

**Offene Risiken, nach Dringlichkeit:**

1. **Restore-Probe offen.** Kein ECC, kein RAID — die Backup-Disziplin *ist* die Redundanz. Die nächtliche Sicherung läuft seit 2026-07-31, aber der Rückweg ist mit echten Daten nie erprobt (NT-B4/NT-B5, bisher nur eine 36-Byte-Testdatei). Bis zur bestandenen Probe darf nichts Unersetzliches auf dieses Gerät. Damit bleibt dies das größte Einzelrisiko.
2. **Interaktive Arbeit läuft als `srvadmin` (Risikoakzeptanz des Eigentümers, 2026-08-01).** Der Entwicklungsarbeitsplatz — Git, GitHub-Token, VS Code, Claude Code, ExecutionPolicy `RemoteSigned` — ist unter dem lokalen Administratorkonto eingerichtet, nicht unter `srvuser`. Damit entfällt auf dieser Maschine die einzige *wirksame* Isolationsgrenze: Eine native Windows-Sandbox existiert nicht und ist dauerhaft nicht geplant (Issue #46740), und `permissions.deny` ist stringbasiert und über die Shell umgehbar (Methodik 22.10, §6.1 der Autonomie-Matrix). Jeder Tool-Aufruf eines Agenten läuft folglich elevated. Bewusst getragen, weil der Betrieb attended ist (W1, Mensch als Gate), das Gerät physisch in der Wohnung steht und die Alternative Reibung im Alltagsbetrieb erzeugt. **Kompensationen, die dadurch nicht entfallen dürfen:** Deny-Listen im Permission-Profil bleiben als Unfallschutz aktiv; W2/W3 bleiben unverändert gesperrt (Adminkontext ersetzt keine Isolation); und **Dienste sowie Scheduled Tasks künftiger Projekte werden nicht unter `srvadmin` registriert**, sondern unter einem eigenen, minimal berechtigten Konto — das ist bei der ersten BLITZ-Automatisierung fällig und nicht verhandelbar. Rücknahme jederzeit möglich: `icacls` auf `D:\dev`, `D:\data`, `D:\logs` für `srvuser`, danach Identität, ExecutionPolicy und `gh auth login` im `srvuser`-Profil wiederholen.
3. **Tailnet-Reichweite vs. geplante Freigabe an Karen.** Die RDP-Firewallregeln erlauben den gesamten Tailscale-Bereich `100.64.0.0/10`. Erweiterte Tailscale-ACLs sind ausdrücklich noch nicht konfiguriert. Sobald ein weiterer Benutzer ins Tailnet eingeladen wird, ist RDP für dessen Geräte **auf Netzebene erreichbar** — es schützt dann nur noch das Windows-Kennwort. Die im As-built-Dokument formulierte Absicht „kein Zugriff auf RDP für Karen" ist damit erst erfüllt, wenn die ACLs **vor** der Einladung stehen. Das ist eine Reihenfolgebedingung, kein optionaler Feinschliff.
4. **Tailscale-Geräteschlüssel läuft nicht ab** und der Dienst läuft unattended. Für einen 24/7-Server ist das eine bewusste und vertretbare Entscheidung, aber sie verschiebt die Kontrolle vollständig auf die Tailnet-ACLs und den Notausschalter „Tailscale-ACL-Sperre" (Methodik 25.10). Der Schalter existiert bisher nur auf dem Papier.
5. **BitLocker mit TPM-only, ohne PIN, ohne BIOS-Kennwort.** Das schützt zuverlässig gegen den Diebstahl eines *ausgebauten* Datenträgers, nicht gegen einen Angreifer mit physischem Zugriff auf das laufende oder bootende Gerät. Für ein Gerät in der eigenen Wohnung ist das eine vertretbare Risikoakzeptanz — sie sollte als solche dokumentiert und nicht mit „verschlüsselt" gleichgesetzt werden.

## 4. Phase 0 der Migration „VPS → HOME-SRV01" (OE-3), fortgeschrieben

Der Inventar-Backlog aus dem alten Heimserver-Dokument ist per OE-3 die Phase 0 des Migrationsvorhabens. Stand nach dem 30.07.:

| # | Punkt | Status | Anmerkung |
|---|---|---|---|
| 1 | Tailscale-Status dokumentieren | ✅ erledigt | Tailnet, IP, unattended, Key-Expiry dokumentiert; **ACLs weiterhin offen** |
| 2 | Energie-/Autostart-Profil für 24/7 | ✅ überwiegend erledigt | Standby/Ruhezustand aus; automatisches Einschalten nach Stromausfall bewusst offen gelassen |
| 3 | BIOS-Version | ✅ erledigt | HP 02.26.00 vom 04.05.2026 |
| 4 | Rollenverteilung Heimserver ↔ VPS | ✅ entschieden (OE-3) | Umsetzung offen; VPS bleibt bis zum Umzug produktiv |
| 5 | **VT-x/VT-d im BIOS prüfen** | ❌ offen | **Blockiert die WSL2-Einrichtung und damit OE-1/OE-11 auf diesem Gerät** |
| 6 | **SMART-Test beider SSDs** | ❌ offen | „Healthy" ist keine Verschleißprüfung; vor der Migration von Nutzdaten nachholen |
| 7 | **Ethernet statt WLAN** | ❌ offen | Betriebsbedingung des Ops-Piloten laut Referenzmodell §11 |
| 8 | RAM-Bestückung / Dual-Channel | ❌ offen | niedrige Priorität, reine Leistungsfrage |

## 5. Nächste Schritte in belastbarer Reihenfolge

Die Reihenfolge ist nicht beliebig — jeder Schritt hebt genau eine Sperre auf.

> ✅ **Erledigt am 2026-07-30:** Recovery-Schlüssel für `C:` und `D:` extern verifiziert, Windows-Aktivierung bestätigt. Nachweise siehe §7.

1. **Backup einrichten und einen echten Restore-Test fahren** — Ziel entschieden (2026-07-30): **Hetzner Storage Box BX11** (1 TB, 3,20 € netto/Monat), append-only per erzwungenem SSH-Kommando, Sub-Account für den Server, serverseitige Snapshots als zweite Ebene. Ausführbares Verfahren inkl. Negativtests: [`runbooks/RUNBOOK_BACKUP_RESTIC_HETZNER.md`](../runbooks/RUNBOOK_BACKUP_RESTIC_HETZNER.md). Erst nach bestandener Restore-Probe ist das A5-Gate offen und der Server darf produktive Daten tragen. **Das ist der einzige verbleibende Punkt mit Totalverlustpotenzial.**
2. **VT-x/VT-d im HP-BIOS prüfen** und, falls aktivierbar, **WSL2 + Strict-Sandbox nach dem bestehenden Runbook einrichten** — inklusive vollständiger Wiederholung der Negativtests NT-1 bis NT-6 und eines eigenen Tokens `agent-w3-home-srv01`. Erst danach gelten OE-1 und OE-11 auf diesem Gerät. *Reihenfolgehinweis aus dem Runbook: zuerst das Latitude, dann diese Maschine.*
3. **Tailscale-ACLs definieren** — vor jeder weiteren Einladung ins Tailnet. Danach erst Karen einladen und Capsule über Tailscale Serve bereitstellen.
4. **Ops-Pilot Stufe 0 vorbereiten** (Methodik 25.9): Dienstkonto `svc-claude` ohne Adminrechte, NTFS-ACLs, `agent_ro`-DB-Rolle, Kill-File- und Audit-Hook ab Tag 1, Egress-Firewall je Dienstkonto praktisch validieren, Windows Scheduled Task headless mit separatem API-Key und Spend-Limit. Erst dieses Paket macht W2 zulässig.
5. **Ethernet und SMART** nachziehen, bevor Nutzdaten migriert werden.
6. **D:-Verzeichnisstruktur anlegen** und Deployment-, Logging- und Secrets-Standard festlegen — das ist Phase 1 der Migration und Voraussetzung dafür, dass Projekte reproduzierbar umziehen.

## 6. Learn-Kandidaten aus dieser Einrichtung (Methodik 9.8)

Die Einrichtung hat drei Muster empirisch bestätigt, die in die Methodik zurückfließen sollten:

1. **Serielle Durchführung mit Verifikation je Schritt** hat nachweislich sechs konkrete Fehlklassen verhindert (u. a. Löschen der falschen SSD, Aussperren durch Firewalländerung). Kandidat für einen Runbook-Baustein „Ein-Änderung-pro-Schritt bei Infrastrukturarbeit".
2. **Sicherheitsänderung mit Rückfalloption** (neue Regel → Sitzung offen halten → testen → alte Regel deaktivieren → erneut testen) ist das generalisierbare Muster für jede Fernzugriffsänderung. Kandidat für den Notausschalter-/Runbook-Katalog (25.10).
3. **Negativtest als Abnahmekriterium.** Dass RDP über die Heimnetz-IP *scheitert*, wurde aktiv nachgewiesen. Genau dieses Prinzip fordert der WSL2-Runbook mit NT-1 bis NT-6 — hier wurde es unabhängig davon angewandt und hat funktioniert. Bestätigt die Regel „Beweis vor Freigabe".

## 7. Prüfnachweise

Nach Methodik 26.8 gilt: Enforcement, das nie geprobt wird, erodiert wie Prosa. Jede Prüfung trägt deshalb ein Datum und einen Wiederholungstrigger.

| Prüfung | Ergebnis | Datum | Wiederholen bei / spätestens |
|---|---|---|---|
| Recovery-Schlüssel `C:` — Übereinstimmung mit externer Ablage (KeyProtectorId + 48 Ziffern) | ✅ identisch | 2026-07-30 | BIOS-/Firmware-Update, TPM-Änderung, Board-Tausch; sonst halbjährlich |
| Recovery-Schlüssel `D:` — Übereinstimmung **und** echte Entsperrprobe (`Lock`/`Unlock-BitLocker`) | ✅ Entsperrung mit externem Schlüssel erfolgreich | 2026-07-30 | wie oben |
| Externe Ablage vorhanden (Passwortmanager + Offline-Kopie außerhalb des Servers) | ✅ bestätigt | 2026-07-30 | halbjährlich |
| Windows-Aktivierung nach Neuinstallation (`slmgr /xpr`) | ✅ dauerhaft aktiviert | 2026-07-30 | nach Board-Tausch oder Neuinstallation |
| RDP über Heimnetz-IP blockiert (Negativtest) | ✅ `TcpTestSucceeded: False` | 2026-07-30 | nach jeder Firewall-/Netzwerkänderung |
| RDP über Tailscale erreichbar | ✅ `TcpTestSucceeded: True` | 2026-07-30 | nach jeder Firewall-/Netzwerkänderung |
| **NT-B1** append-only greift — `forget` auf vorhandenen Snapshot | ✅ **verweigert mit HTTP 403**, vier Wiederholversuche, `failed to remove one or more snapshots` | 2026-07-30 | nach jeder Änderung an `authorized_keys` oder Sub-Account |
| **NT-B2** kein SFTP mit dem Backup-Schlüssel | ✅ `Connection closed`, ohne Passwort-Rückfall | 2026-07-30 | wie NT-B1 |
| Repository angelegt, Schreib-/Lese-Round-Trip mit Testdatei | ✅ `e59324b6f1`, Snapshot geschrieben und inhaltsgleich zurückgeholt | 2026-07-30 | — |
| Nächtliche Automatik `restic-nightly-storagebox` als SYSTEM, mit VSS | ✅ Lauf erfolgreich: `snapshot 0d85b2b2`, `check` ohne Fehler, `ERGEBNIS: OK` | 2026-07-31 | nach jeder Änderung an Skript, Konto oder Schlüssel |
| **NT-B7** Alarmweg — Dead-Man's-Switch healthchecks.io | ✅ `/fail` ausgelöst, Check wurde rot, **E-Mail nachweislich zugestellt**, danach zurückgesetzt | 2026-07-31 | halbjährlich mit der Gate-Probe (26.8) |
| **NT-B3** kein Zugriff auf fremde Bereiche der Storage Box | ❌ offen | — | vor Produktivsetzung |
| **NT-B4/NT-B5 Restore-Probe mit echten Daten** (Backup-Gate 25.5), NT-B5 vom Latitude aus dem Passwortmanager | ❌ **offen** — bisher nur eine 36-Byte-Testdatei; das ist **kein** gültiger Nachweis | — | **erforderlich vor jeder A5-Freigabe; danach alle 90 Tage, vor A5-Freigaben < 30 Tage** |
| **NT-B6** Hetzner-Snapshot-Ebene | ❌ offen — Snapshot-Plan noch nicht konfiguriert | — | vor Produktivsetzung |
| Offline-Ablage der Backup-Kette (Hetzner-Zugang inkl. 2FA-Codes, Storage-Box-Hauptkennwort, restic-Repository-Passwort) | ❌ noch nicht angelegt | — | bei Einrichtung; danach halbjährlich mit den BitLocker-Schlüsseln zusammen prüfen |
| Negativtests WSL2-Sandbox NT-1..NT-6 | ❌ nicht anwendbar — WSL2 nicht installiert | — | vor Inkraftsetzung von OE-1/OE-11 auf diesem Gerät |
| Notausschalter-Katalog (Kill-File, Egress-Sperre, Tailscale-ACL-Sperre) | ❌ nicht eingerichtet | — | vor dem ersten unbeaufsichtigten Lauf |

> **Recovery-Schlüssel `C:`:** Die Übereinstimmung ist geprüft, ein vollständiger Pre-Boot-Wiederherstellungstest (`manage-bde -forcerecovery C:`) steht noch aus. Der ist nur direkt am Gerät mit Tastatur und Monitor durchführbar, nie über RDP. Angesichts der bestandenen `D:`-Entsperrprobe und der identischen Ablagedisziplin ist das Restrisiko gering — es ist ein Nice-to-have, kein Blocker.

## 8. Wiederaufnahmepunkt — Backup-Einrichtung (Stand 2026-07-30, 22:30)

Verfahren: [`../runbooks/RUNBOOK_BACKUP_RESTIC_HETZNER.md`](../runbooks/RUNBOOK_BACKUP_RESTIC_HETZNER.md) v1.1.

### Konkrete Werte dieser Installation

| Gegenstand | Wert |
|---|---|
| Storage Box | `offsite-backup` · BX11 · 1 TB · Falkenstein (eu-central) · ID #625403 |
| Hauptkonto (nur Latitude, attended, darf löschen) | `u643226` @ `u643226.your-storagebox.de`, Port 23 |
| Sub-Account (HOME-SRV01, append-only) | `u643226-sub1` @ `u643226-sub1.your-storagebox.de`, Verzeichnis `backup-home-srv01` |
| SSH-Schlüssel Latitude | `%USERPROFILE%\.ssh\id_ed25519` — mit Passphrase, in der Hetzner Console als `latitude-admin` |
| SSH-Schlüssel HOME-SRV01 | `D:\backups\config\id_ed25519_storagebox` — **ohne** Passphrase, erzwungenes Kommando in `authorized_keys` des Sub-Accounts |
| restic-Repository | `e59324b6f1`, Version 2, Kompression auto |
| Repository-Passwort | `D:\backups\config\restic-pw.txt` (BOM-frei), zusätzlich Passwortmanager + Offline-Kopie |
| restic-Version | 0.19.1 |
| Aufrufmuster | `$RcloneCmd = "ssh -p23 -i D:/backups/config/id_ed25519_storagebox u643226-sub1@u643226-sub1.your-storagebox.de"` → `restic -o "rclone.program=$RcloneCmd" -r rclone: <befehl>`<br>**Pfad mit Vorwärts-Schrägstrichen** — Backslashes zerlegen den String |

> Kennwörter, Passphrasen und private Schlüssel stehen bewusst **nicht** in diesem Repository. Sie liegen ausschließlich im Passwortmanager und in der Offline-Kopie.

### Abgearbeitet

| Runbook-Abschnitt | Stand |
|---|---|
| B Storage Box bestellen und konfigurieren | ✅ SSH ein, äußere Erreichbarkeit ein, SMB/WebDAV aus |
| C Sub-Account | ✅ Lesen/Schreiben, SSH ein, SMB/WebDAV/FTP aus |
| D Schlüssel und append-only erzwingen | ✅ `authorized_keys` einzeilig, 175 Byte, hochgeladen |
| E Automatische Snapshots | ✅ täglich, 04:00 **UTC** = 06:00 Ortszeit, 10 Slots |
| F restic und Repository | ✅ restic 0.19.1 maschinenweit unter `C:\Program Files\restic\`, Repository `e59324b6f1` |
| G Verzeichnisse, Ausschlussliste, Skript, Automatik, Alarmierung | ✅ **fertig und erfolgreich gelaufen** (`snapshot 0d85b2b2`, `check` fehlerfrei, `ERGEBNIS: OK`) |
| H Negativtests | teilweise: NT-B1 ✅, NT-B2 ✅, NT-B7 ✅ · **NT-B3 bis NT-B6 offen** |
| I Monatliche Pflege vom Latitude | ❌ offen (Hauptkonto-Zugang dort noch nicht eingerichtet) |

### Betriebsstand

- Geplante Aufgabe `restic-nightly-storagebox`, täglich 02:30 Ortszeit, Ausführung als **SYSTEM** mit VSS
- Skript `D:\deploy\scripts\backup-nightly.ps1` — nur `backup` und `check`, **kein** `forget`/`prune`
- Dead-Man's-Switch auf healthchecks.io, Period 1 Tag, Grace 4 Stunden, E-Mail-Zustellung nachgewiesen
- `D:` trägt bisher nur das Skript selbst — der Lauf sichert real noch fast nichts

### Nächster Schritt (genau einer)

**Echte Daten nach `D:` bringen, dann die Restore-Probe fahren.** Ohne repräsentative Daten ist NT-B4/NT-B5 wertlos und das A5-Gate bleibt zu.

Empfohlene Reihenfolge, die den Zirkelschluss auflöst („Migration braucht Backup, Backup-Nachweis braucht Daten"):

1. Capsule-Daten (~3,5 GB) und boxscore (~2,5 GB) als **Replikat** nach `D:\data\...` kopieren. Der VPS bleibt dabei ausdrücklich System-of-Record — es wird nichts umgeschaltet (OE-3: kein Parallelbetrieb ohne benanntes führendes System).
2. Vorher möglichst **LAN-Kabel** statt WLAN legen (offener Punkt 5) — der erste Volllauf ist der Moment mit dem höchsten Abbruchrisiko, und ein abgebrochener Upload blockiert laut Abschnitt A Grenze 2 alle Folgeläufe.
3. Nächtlichen Lauf attended anstoßen und vollständig durchlaufen lassen.
4. **NT-B4** (Restore auf leeres Verzeichnis, fachliche Stichprobe) und **NT-B5** (derselbe Restore vom Latitude, Zugangsdaten aus dem Passwortmanager) durchführen.
5. **NT-B3** und **NT-B6** nachziehen, Ergebnisse in §7 eintragen.
6. Erst danach: A5-Gate offen, System-of-Record je Projekt umschalten.

Parallel möglich, unabhängig davon: Hauptkonto-Zugang auf dem Latitude einrichten (Runbook Abschnitt I) — nötig für `prune` und für die Reparatur bei abgebrochenen Uploads.

### Offene Aufräumpunkte

- Test-Snapshot `77b74b4a` (36 Byte) liegt noch im Repository und ist per append-only nicht entfernbar. Verschwindet beim ersten monatlichen `prune` vom Latitude. Kein Handlungsbedarf.
- Datenbank-Dumps müssen **unkomprimiert** erzeugt werden, sonst dedupliziert restic nicht und das Repository wächst pro Nacht um die volle Dumpgröße. Gehört in Schritt 3 des Skripts.

---

## Changelog

| Datum | Änderung |
|---|---|
| 2026-08-01 | Entwicklungsarbeitsplatz auf dem Server eingerichtet: Methodik-Repo nach `D:\dev\ki-engineering-methodik` geklont, `D:\dev` als Basis für Quell-Repos ergänzt (bewusst **keine** Sicherungsquelle — GitHub ist die Off-Site-Kopie; `backup-nightly.ps1` wurde nicht angefasst), `D:\data\blitz` und `D:\logs\blitz` für das erste Fast-Track-Projekt angelegt. ExecutionPolicy `RemoteSigned` im `CurrentUser`-Scope. **Neue Risikoakzeptanz (§3 Risiko 2): interaktive Arbeit läuft als `srvadmin`** — damit entfällt die einzige wirksame OS-Isolationsgrenze; W2/W3 bleiben unverändert gesperrt, Dienste und Scheduled Tasks künftiger Projekte dürfen nicht unter diesem Konto registriert werden. Drift in §1 und §3 gegenüber dem Changelog vom 31.07. korrigiert (Backup-Automatik läuft; offen ist die Restore-Probe, nicht das Backup als solches). |
| 2026-07-31 | Backup-Automatik fertig: nächtliche Aufgabe als SYSTEM mit VSS, Lauf erfolgreich (`snapshot 0d85b2b2`, `check` fehlerfrei), Hetzner-Snapshot-Plan aktiv, Dead-Man's-Switch auf healthchecks.io eingerichtet und Alarmweg per NT-B7 nachgewiesen. Drei Learn-Einträge ins Runbook (v1.3): Schrägstriche im `rclone.program`-String, restic maschinenweit installieren, ACL des privaten Schlüssels auf Dateiebene. **A5-Gate bleibt geschlossen** — es fehlen echte Daten und die Restore-Probe NT-B4/NT-B5. |
| 2026-07-30 | Backup-Infrastruktur aufgebaut und teilverifiziert: Storage Box, Sub-Account, append-only-Schlüssel, restic-Repository `e59324b6f1`. NT-B1 und NT-B2 bestanden. Wiederaufnahmepunkt als §8 ergänzt. Produktives Backup und Restore-Probe stehen aus — **A5-Gate bleibt geschlossen**. |
| 2026-07-30 | Backup-Ziel entschieden: **Hetzner Storage Box BX11**, append-only per erzwungenem SSH-Kommando; Runbook `RUNBOOK_BACKUP_RESTIC_HETZNER.md` erstellt. Zwischenzeitlich geprüfter Entwurf auf Backblaze B2 verworfen (dort ist append-only nur indirekt über `b2_hide_file` plus Lifecycle-Regel erreichbar, Egress kostenpflichtig, keine serverseitigen Snapshots). **Korrektur zu §8.2 der As-built-Doku:** Google Drive, OneDrive und Proton Drive sind als Ziele verworfen — Proton blockiert rclone aktiv, OneDrive+restic hat dokumentierte Kombinationsprobleme, und keiner der drei kann append-only. |
| 2026-07-30 | Prüfnachweise ergänzt (§7): Recovery-Schlüssel `C:`/`D:` extern verifiziert, `D:` per Entsperrprobe bewiesen, Windows-Aktivierung bestätigt. Backup ist damit das führende Einzelrisiko. |
| 2026-07-30 | Erstfassung nach Neuaufsetzung und Inbetriebnahme von `HOME-SRV01` |
