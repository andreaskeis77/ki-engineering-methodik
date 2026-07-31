# Runbook: Offsite-Backup mit restic auf Hetzner Storage Box (append-only)

**Version:** 1.3 · **Stand:** 2026-07-31 · **Status:** in Erstinstallation erprobt (Ziel: Hetzner Storage Box BX11, 1 TB, append-only per erzwungenem SSH-Kommando)
**Changelog:** 1.3 (2026-07-31) — ACL-Behandlung des privaten Schlüssels korrigiert: muss auf die **Datei** wirken (`/reset /T`), Besitzer auf Administratoren, SIDs statt lokalisierter Namen. Ohne das verwirft OpenSSH den Schlüssel beim Lauf als SYSTEM. · 1.2 (2026-07-31) — Ausführungskonto der geplanten Aufgabe von `svc-backup` auf `SYSTEM` geändert (VSS erfordert Administratorrechte, siehe Abschnitt A); `known_hosts` für das SYSTEM-Profil vorbereiten ergänzt; `RESTIC_CACHE_DIR` gesetzt; Verzeichnisstruktur als eigener Schritt; Ausschlussliste bereinigt (Sicherungsquellen dürfen nicht ausgeschlossen werden). · 1.1 (2026-07-30) — Learn-Einträge aus der Erstinstallation auf `HOME-SRV01`: Pfade im `rclone.program`-String müssen Vorwärts-Schrägstriche verwenden (Backslashes werden als Escape gewertet); Fehlerbilder zu `init` ergänzt; Hinweis zur BOM-freien Passwortdatei. · 1.0 (2026-07-30) — Erstfassung. Ersetzt den verworfenen Entwurf auf Backblaze B2 (Begründung: Hetzner erfüllt append-only nativ, Traffic unbegrenzt, Snapshots als zweite Schicht, DSGVO-Raum).

**Zweck:** Schließt den blockierenden Punkt 1 aus [`../infrastruktur/HOME-SRV01_STATUS.md`](../infrastruktur/HOME-SRV01_STATUS.md) §5 und öffnet damit das **A5-Gate aus Methodik 25.5** („ohne aktuelle Restore-Probe < 30 Tage keine A5-Freigabe auf Daten-/Infrastrukturfähigkeiten"). Ohne bestandene Negativtests (Abschnitt H) bleibt das Gate geschlossen.
**Ausführung:** attended. Abschnitte B–E vom **Latitude**, F–H auf **HOME-SRV01** als `srvadmin`. Dauer ~1,5–2 h inklusive erstem Lauf und Restore-Probe.

> **Umsetzungsstand auf `HOME-SRV01`:** Abschnitte B–F sind am 2026-07-30 abgearbeitet, E ist zu verifizieren, **ab G geht es weiter**. Konkrete Werte dieser Installation, bestandene Tests und der genaue Wiederaufnahmepunkt stehen in [`../infrastruktur/HOME-SRV01_STATUS.md`](../infrastruktur/HOME-SRV01_STATUS.md) §8. Dieses Runbook bleibt generisch und gilt unverändert auch für weitere Geräte.

> **Schritt 0 — Doku-Abgleich (Pflicht, Statusquellen-Regel 20.7):** Vor Beginn die aktuellen Angaben zu Storage-Box-Sub-Accounts, SSH-Port und restricted shell gegen docs.hetzner.com prüfen, ebenso die restic-Optionen `rclone.program` gegen restic.readthedocs.io. Dieses Runbook nennt den Stand vom 2026-07-30; weicht die Doku ab, gilt die Doku und dieses Runbook wird per Learn-Schritt (9.8) aktualisiert.

---

## A. Entwurfsentscheidungen (warum es so gebaut wird)

| Entscheidung | Begründung |
|---|---|
| **Erzwungenes SSH-Kommando mit `--append-only`** | `restrict,command="rclone serve restic --stdio --append-only ./restic"` in `authorized_keys`. Der Server kann neue Dateien schreiben, aber **keine bestehende ändern oder löschen** — unabhängig davon, was auf HOME-SRV01 passiert. Das ist echtes Enforcement, nicht Konfigurationsdisziplin. |
| **Sub-Account für HOME-SRV01, Hauptkonto nur attended** | Der Sub-Account hat ein eigenes Home und eigene `authorized_keys`. Der Server sieht ausschließlich sein eigenes Verzeichnis. Das Hauptkonto bleibt auf dem Latitude und ist das einzige, das `prune` ausführen kann. |
| **Repository in einem Unterordner (`./restic`), nicht im Home-Wurzelverzeichnis** | Damit liegt `.ssh/authorized_keys` des Sub-Accounts **außerhalb** des servierten Baums. Ohne diese Trennung wäre ein Überschreiben der eigenen Schlüsseldatei denkbar — der klassische Ausbruch aus append-only. Zweite Schicht: `--append-only` verbietet Überschreiben ohnehin. |
| **Automatische Snapshots der Storage Box** | Bis zu 10 Slots bei BX11, serverseitig erzeugt. Der Sub-Account kann sie **nicht** löschen. Zweite, von restic unabhängige Wiederherstellungsebene. |
| **`prune` nur attended vom Latitude** | Anders als bei objektbasierten Zielen kann der append-only-Schlüssel `forget`/`prune` gar nicht ausführen — die Operation wird serverseitig verweigert. Speicherfreigabe ist damit ein bewusster menschlicher Schritt, terminlich gekoppelt an das monatliche Learn-Review (9.8). |
| **Geplante Aufgabe läuft als `SYSTEM`, nicht als eigenes Dienstkonto** | Ursprünglich war ein Konto `svc-backup` ohne Adminrechte vorgesehen. Das ist nicht durchführbar: Ein Backup muss **alle** Quelldateien lesen, auch von Diensten gesperrte, und dafür braucht es Volumenschattenkopien (`--use-fs-snapshot`) — die setzen Administratorrechte voraus. Ein „Dienstkonto ohne Adminrechte", dem man dann Adminrechte gibt, ist Etikettenschwindel. `SYSTEM` ist die ehrlichere Wahl: kein zu verwahrendes oder zu rotierendes Kennwort, keine interaktive Anmeldung, keine Fernanmeldung. Der Schutz gegen die eigentliche Bedrohung — Zerstörung der Sicherung — kommt ohnehin nicht aus dem Konto, sondern aus append-only (NT-B1). **Davon unberührt:** Der spätere Ops-Agent `svc-claude` bekommt den Storage-Box-Schlüssel nie; die ACL auf `D:\backups\config` schließt ihn aus. |
| **DB-Dumps unkomprimiert** | Komprimierte Dumps deduplizieren nicht — jede Nacht landet ein voller Dump im Repo. Plain-SQL dedupliziert nahezu vollständig; die Kompression übernimmt restic selbst. |

**Ehrliche Grenze 1 — Vertraulichkeit:** Append-only schützt gegen **Löschung und Verschlüsselung** durch einen kompromittierten Server. Es schützt **nicht gegen Mitlesen** — wer HOME-SRV01 übernimmt, findet dort das restic-Passwort und kann die Backup-Inhalte entschlüsseln. Das ist bauartbedingt (der Server muss schreiben können) und als Restrisiko akzeptiert; Vertraulichkeit gegen Serverkompromittierung ist kein Ziel dieses Runbooks.

**Ehrliche Grenze 2 — abgebrochene Uploads ([rclone #8958](https://github.com/rclone/rclone/issues/8958), offen):** `rclone serve restic --append-only` verweigert **jedes** Überschreiben bestehender Dateien. Der offizielle restic-rest-server erlaubt dagegen ein Überschreiben, wenn die Prüfsumme zum Dateinamen passt. Praktische Folge: Bricht ein Upload mitten in einer Pack-Datei ab, scheitert der Wiederholungsversuch von restic — und **alle Folgeläufe scheitern**, bis die Teildatei entfernt ist. Das ist kein Datenverlust, aber ein stiller Stillstand, wenn niemand hinschaut.

*Gegenmaßnahmen:* (1) Der erste Volllauf läuft **attended** über eine stabile Verbindung — bevorzugt über LAN-Kabel, nicht WLAN. (2) Der nächtliche Lauf **muss** bei Fehlschlag benachrichtigen; ein stilles Scheitern ist der schlimmste Ausgang (Methodik: „grüner Run-Status belegt keinen Task-Erfolg"). (3) Reparatur siehe Abschnitt I.

**Positiv geprüft:** Lock-Dateien sind von der Löschsperre ausgenommen. Der normale Betrieb hinterlässt also keine hängenden Locks, und `restic backup` läuft ohne Sonderbehandlung.

## B. Storage Box bestellen (Latitude)

1. Hetzner-Konto anlegen bzw. anmelden, **Zwei-Faktor-Authentifizierung sofort aktivieren.** Das Konto ist ab jetzt Teil der Recovery-Kette.
2. Storage Box **BX11** bestellen (1 TB, 3,20 € netto/Monat, keine Einrichtungsgebühr, monatlich kündbar).
   - Standort: **Deutschland** oder Finnland — für den privaten Einsatz ist Deutschland die naheliegende Wahl.
3. In der Hetzner Console für die Storage Box aktivieren:
   - **SSH-Support: ein** (ohne das geht nichts von hier)
   - Externe Erreichbarkeit: ein
   - Samba/CIFS, WebDAV, FTP: **aus** — jeder nicht gebrauchte Dienst ist Angriffsfläche
4. Benutzername (`uXXXXX`) und Hauptpasswort notieren → Passwortmanager.

Verbindungstest:

```powershell
ssh -p23 uXXXXX@uXXXXX.your-storagebox.de
```

Erwartet: eine eingeschränkte Shell ohne vollen Befehlsumfang. Das ist korrekt — Hetzner erlaubt bewusst keine interaktive Vollshell.

## C. Sub-Account für HOME-SRV01 anlegen

Hetzner Console → Storage Box → **Sub-Accounts** → *Sub-Account erstellen*:

| Feld | Wert |
|---|---|
| Verzeichnis | `backup-home-srv01` |
| Kommentar | `HOME-SRV01 restic append-only` |
| Zugriff | Lesen **und** Schreiben |
| SSH | **aktiviert** |
| External reachability | aktiviert |
| Samba/WebDAV/FTP | **deaktiviert** |

Ergebnis: Benutzername `uXXXXX-subN` und Hostname `uXXXXX-subN.your-storagebox.de`. Passwort setzen und in den Passwortmanager legen — es wird nur einmal für die Ersteinrichtung gebraucht.

> Das Home des Sub-Accounts ist aus Sicht des Hauptkontos der Ordner `./backup-home-srv01`. Diese Pfadabbildung wird in Abschnitt I gebraucht.

## D. Schlüssel erzeugen und append-only erzwingen

**Auf HOME-SRV01** (als `srvadmin`), Schlüssel ohne Passphrase, weil der Lauf unbeaufsichtigt startet:

```powershell
New-Item -ItemType Directory -Force -Path "D:\backups\config" | Out-Null

ssh-keygen -t ed25519 `
    -f "D:\backups\config\id_ed25519_storagebox" `
    -C "home-srv01-restic-append" `
    -N '""'

Get-Content "D:\backups\config\id_ed25519_storagebox.pub"
```

Den öffentlichen Schlüssel kopieren. Daraus lokal eine Datei `authorized_keys` bauen — **eine einzige Zeile**, kein Zeilenumbruch in der Mitte:

```text
restrict,command="rclone serve restic --stdio --append-only ./restic" ssh-ed25519 AAAA...restlicher-key... home-srv01-restic-append
```

Hochladen — einmalig mit dem Sub-Account-Passwort:

```powershell
sftp -P 23 uXXXXX-subN@uXXXXX-subN.your-storagebox.de
```

```text
mkdir .ssh
mkdir restic
put D:/backups/config/authorized_keys .ssh/authorized_keys
quit
```

> **Reihenfolge beachten:** Der Ordner `restic` muss existieren, bevor der erzwungene Befehl greift — danach ist der Sub-Account auf genau diesen Ordner beschränkt und kann `.ssh` nicht mehr erreichen. Genau das ist beabsichtigt.

ACL auf den privaten Schlüssel und die Konfiguration setzen — **erst nachdem der Schlüssel erzeugt wurde**, und zwingend auch auf die Dateien, nicht nur auf das Verzeichnis:

```powershell
$Cfg = "D:\backups\config"
icacls $Cfg /inheritance:r /grant:r "*S-1-5-18:(OI)(CI)(F)" "*S-1-5-32-544:(OI)(CI)(F)"
icacls "$Cfg\*" /reset /T
icacls $Cfg /setowner "*S-1-5-32-544" /T
icacls "$Cfg\id_ed25519_storagebox"
```

Erwartet: **genau zwei** Einträge — SYSTEM und Administratoren, beide `(I)(F)`.

> ⚠ **Häufigster Fehler beim ersten Lauf als SYSTEM.** Setzt man die ACL nur auf das *Verzeichnis*, behält die bereits erzeugte Schlüsseldatei ihre Einträge aus der Entstehungszeit. OpenSSH prüft die Datei selbst, verwirft den Schlüssel mit `UNPROTECTED PRIVATE KEY FILE! ... This private key will be ignored` und fällt auf Passwort-Authentifizierung zurück — die als SYSTEM niemand beantwortet, also läuft der Lauf in einen Timeout. Von Hand als `srvadmin` funktioniert derselbe Aufruf, weil dieses Konto Besitzer ist. Deshalb `/reset /T` auf die Dateien und Besitzer auf die Gruppe Administratoren setzen. SIDs statt Namen verwenden, sonst scheitert es auf deutschsprachigem Windows an `Administrators` vs. `Administratoren`. *(Learn-Eintrag aus der Erstinstallation 2026-07-31.)*

## E. Automatische Snapshots aktivieren (zweite Schicht)

Hetzner Console → Storage Box → **Snapshots** → *Snapshot-Plan*:

- täglich, Ausführung etwa **04:00** — also nach dem nächtlichen Backup aus Abschnitt G
- BX11 hält bis zu 10 Slots

Diese Snapshots erzeugt Hetzner serverseitig. Weder HOME-SRV01 noch der Sub-Account können sie löschen. Sie sind die Rückfallebene, falls das restic-Repository selbst beschädigt wird.

## F. Dienstkonto, restic und Repository

Auf HOME-SRV01, administrative PowerShell:

```powershell
$Password = Read-Host "Kennwort für svc-backup" -AsSecureString
New-LocalUser -Name "svc-backup" -Password $Password `
    -FullName "Backup Service" -Description "Dienstkonto für restic-Offsite-Backup"
Set-LocalUser -Name "svc-backup" -PasswordNeverExpires $true
# KEINE Mitgliedschaft in Administratoren, KEINE Remotedesktop-Rechte

New-Item -ItemType Directory -Force -Path "D:\backups\staging","D:\logs\backup","D:\deploy\scripts"

winget install restic.restic
restic version                     # erwartet: 0.18.x oder neuer

# PFLICHT: restic maschinenweit verfuegbar machen.
# winget installiert nur ins Profil des aufrufenden Benutzers; die geplante Aufgabe
# laeuft als SYSTEM und findet es dort nicht ("restic wurde nicht als Name ... erkannt").
$Item = Get-Item (Get-Command restic).Source
if ($Item.LinkType) { $Real = $Item.Target[0] } else { $Real = $Item.FullName }
New-Item -ItemType Directory -Force -Path "C:\Program Files\restic" | Out-Null
Copy-Item $Real "C:\Program Files\restic\restic.exe" -Force
& "C:\Program Files\restic\restic.exe" version
```

Repository-Passwort erzeugen und **sofort** sichern:

```powershell
$RepoPw = -join ((33..126) | Get-Random -Count 32 | ForEach-Object {[char]$_})
$RepoPw | Set-Content -Path "D:\backups\config\restic-pw.txt" -Encoding utf8 -NoNewline
$RepoPw     # anzeigen, in Passwortmanager UND Offline-Kopie übertragen, Fenster danach schließen
```

> ⚠ **Ohne dieses Passwort ist das Backup wertlos** — dieselbe Regel wie bei den BitLocker-Recovery-Schlüsseln. Passwortmanager **und** Offline-Kopie, beides außerhalb des Servers. Der Eintrag gehört in dieselbe Prüfliste (§7 des Statusdokuments).

Repository initialisieren — der erzwungene Befehl liefert Pfad und Modus, deshalb bleibt `-r rclone:` ohne Pfadangabe:

```powershell
$env:RESTIC_PASSWORD_FILE = "D:\backups\config\restic-pw.txt"

$RcloneCmd = "ssh -p23 -i D:/backups/config/id_ed25519_storagebox uXXXXX-subN@uXXXXX-subN.your-storagebox.de"

restic -o "rclone.program=$RcloneCmd" -r rclone: init
```

Erwartet: `created restic repository <id> at rclone:`.

> ⚠ **Pfade im `rclone.program`-String immer mit Vorwärts-Schrägstrichen.** restic zerlegt diesen String nach Shell-Regeln und wertet Backslashes als Escape-Zeichen. Mit `D:\backups\config\...` zerfällt der Pfad und ssh meldet `Could not resolve hostname backups`. `D:/backups/config/...` funktioniert unter Windows einwandfrei. *(Learn-Eintrag aus der Erstinstallation 2026-07-30.)*

Zwei weitere Fehlerbilder:

- **Passwortabfrage `enter password for new repository`** → `RESTIC_PASSWORD_FILE` zeigt ins Leere. Abbrechen (nicht raten!), Datei prüfen, erneut versuchen.
- **Timeout nach etwa einer Minute** → bekanntes Zusammenspiel von restic, rclone und erzwungenen SSH-Kommandos ([restic #5139](https://github.com/restic/restic/issues/5139)). Prüfe, ob die `authorized_keys` wirklich **eine** Zeile ist und ob der Ordner `restic` existiert.

## G. Sicherungsumfang, Skript und Zeitplan

Ausschlussdatei `D:\backups\config\excludes.txt` gemäß §8.3 der As-built-Doku:

```text
.venv
venv
node_modules
__pycache__
*.pyc
dist
build
.next
target
.cache
.pytest_cache
.mypy_cache
*.tmp
Thumbs.db
```

> Die Sicherungsquellen selbst (`D:\apps`, `D:\data`, `D:\deploy`, `D:\backups\staging`) dürfen **nicht** in der Ausschlussliste stehen. Die Datei muss **BOM-frei** geschrieben werden, sonst wird das erste Muster nicht erkannt.

**Dead-Man's-Switch anlegen** (Methodik 25.8, Observability-Minimum): Auf `healthchecks.io` einen kostenlosen Check erstellen — Period `1 day`, Grace `4 hours` — und die Ping-URL notieren. Der Wert dieses Weges liegt darin, dass er auch dann Alarm schlägt, wenn der Server komplett ausfällt und deshalb niemand mehr etwas ins Log schreibt. Ohne ihn ist die Einschränkung aus Abschnitt A (Grenze 2) ein stiller Stillstand.

Sicherungsskript `D:\deploy\scripts\backup-nightly.ps1`:

```powershell
$Restic = "C:\Program Files\restic\restic.exe"
$Ping   = "https://hc-ping.com/<eigene-uuid>"
$Stamp  = Get-Date -Format "yyyy-MM-dd_HHmmss"
$LogDir = "D:\logs\backup"
Start-Transcript -Path "$LogDir\backup_$Stamp.log" | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$env:RESTIC_PASSWORD_FILE = "D:\backups\config\restic-pw.txt"
$env:RESTIC_CACHE_DIR     = "D:\backups\cache"
$RcloneCmd = "C:/Windows/System32/OpenSSH/ssh.exe -p23 -i D:/backups/config/id_ed25519_storagebox uXXXXX-subN@uXXXXX-subN.your-storagebox.de"

function Send-Ping($Suffix) {
    try { Invoke-RestMethod -Uri "$Ping$Suffix" -TimeoutSec 20 | Out-Null }
    catch { Write-Output "WARNUNG: Ping '$Suffix' fehlgeschlagen: $_" }
}

$BackupExit = 99
$CheckExit  = 99
Send-Ping "/start"

try {
    # 1) Datenbanken UNKOMPRIMIERT dumpen — sonst dedupliziert restic nicht.
    # & pg_dump -U backup -d capsule -f "D:\backups\staging\capsule.sql"

    # 2) Sicherung mit VSS, damit offene Dateien konsistent erfasst werden
    & $Restic -o "rclone.program=$RcloneCmd" -r rclone: backup `
        "D:\apps" "D:\data" "D:\deploy" "D:\backups\staging" `
        --use-fs-snapshot `
        --exclude-file="D:\backups\config\excludes.txt" `
        --tag nightly --host HOME-SRV01
    $BackupExit = $LASTEXITCODE

    # 3) Konsistenzprüfung mit Stichprobe
    & $Restic -o "rclone.program=$RcloneCmd" -r rclone: check --read-data-subset=5%
    $CheckExit = $LASTEXITCODE

    # 4) Staging aufräumen, Logs älter als 30 Tage entfernen
    Remove-Item "D:\backups\staging\*" -Recurse -Force -ErrorAction SilentlyContinue
    Get-ChildItem $LogDir -Filter "backup_*.log" |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } |
        Remove-Item -Force -ErrorAction SilentlyContinue
}
catch { Write-Output "ABBRUCH: $_" }

if ($BackupExit -eq 0 -and $CheckExit -eq 0) {
    "OK $(Get-Date -Format s)" | Set-Content "D:\backups\config\last-success.txt" -Encoding ascii
    Write-Output "ERGEBNIS: OK"; Send-Ping ""; Stop-Transcript | Out-Null; exit 0
}
else {
    Write-Output "ERGEBNIS: FEHLER (backup=$BackupExit check=$CheckExit)"
    Send-Ping "/fail"; Stop-Transcript | Out-Null; exit 1
}
```

> **Kein `forget` und kein `prune` in diesem Skript.** Der append-only-Schlüssel darf beides nicht, und das ist der Punkt der Übung. Die Retention läuft attended nach Abschnitt I.
>
> **`restic` und `ssh` immer mit vollem Pfad aufrufen.** Die Aufgabe läuft als SYSTEM mit anderem Suchpfad; ein blankes `restic` scheitert mit „wurde nicht als Name eines Cmdlet … erkannt".

Geplante Aufgabe (Ausführung als `SYSTEM`, Begründung in Abschnitt A):

```powershell
$Action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument '-NoProfile -ExecutionPolicy Bypass -File "D:\deploy\scripts\backup-nightly.ps1"'
$Trigger   = New-ScheduledTaskTrigger -Daily -At 02:30
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$Settings  = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 6)
Register-ScheduledTask -TaskName "restic-nightly-storagebox" `
    -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
```

**Hostschlüssel für SYSTEM hinterlegen** — sonst fragt `ssh` beim ersten Lauf nach der Bestätigung des Fingerabdrucks, und weil als SYSTEM niemand antwortet, hängt die Aufgabe unbegrenzt:

```powershell
$SysSsh = "C:\Windows\System32\config\systemprofile\.ssh"
New-Item -ItemType Directory -Force -Path $SysSsh | Out-Null
Copy-Item "$env:USERPROFILE\.ssh\known_hosts" "$SysSsh\known_hosts" -Force
```

## H. Negativtests (Pflicht — Beweis vor Freigabe)

Ergebnisse mit Datum in `D:\backups\config\negativtests.md` protokollieren **und** in §7 des Statusdokuments eintragen.

| # | Test | Vorgehen | Erwartet |
|---|---|---|---|
| **NT-B1** | append-only greift | Auf HOME-SRV01 einen **vorhandenen** Snapshot löschen lassen: `restic -o rclone.program="$Rclone" -r rclone: forget <snapshot-id>` | **verweigert** — der Server lehnt die Löschung ab.<br>⚠ **Nicht mit `prune` auf einem frischen Repository testen.** Gibt es nichts zu löschen, meldet `prune` `to delete: 0 blobs` und `done`, ohne je einen Löschversuch zu unternehmen — das sieht wie ein Fehlschlag des Tests aus, ist aber gar kein Test. Der Löschversuch muss echt sein. *(Learn-Eintrag aus der Erstinstallation 2026-07-30.)* |
| **NT-B2** | Ausbruch aus dem Repo-Ordner | Auf HOME-SRV01: `sftp -P 23 -i <key> uXXXXX-subN@...` sowie Versuch, `.ssh/authorized_keys` zu lesen oder zu ersetzen | **verweigert** — der erzwungene Befehl lässt nur `rclone serve restic` zu, kein SFTP |
| **NT-B3** | Kein Zugriff auf fremde Bereiche | Mit dem Sub-Account-Schlüssel auf das Hauptkonto-Verzeichnis zugreifen | **verweigert** |
| **NT-B4** | **Restore funktioniert fachlich** | `restic ... restore latest --target D:\restore-test` auf ein *leeres* Verzeichnis; Stichprobe: eine Capsule-Uploaddatei öffnen, einen DB-Dump auf Kopf und Zeilenzahl prüfen | Dateien vorhanden, lesbar, inhaltlich plausibel |
| **NT-B5** | Restore **ohne** den Server | Denselben Restore vom **Latitude** ziehen, mit Repository-Passwort und Zugangsdaten **aus dem Passwortmanager** | erfolgreich |
| **NT-B6** | Snapshot-Ebene trägt | In der Hetzner Console einen Snapshot auswählen und eine einzelne Datei daraus wiederherstellen | erfolgreich; Sub-Account kann Snapshots nicht löschen |
| **NT-B7** | **Alarmweg funktioniert** | `Invoke-RestMethod -Uri "<ping-url>/fail"`, danach mit `<ping-url>` zurücksetzen | Check wird rot, **E-Mail kommt tatsächlich an** (auch Spam-Ordner prüfen). Ein Benachrichtigungsweg, der nie ausgelöst hat, ist eine Behauptung, kein Mechanismus (26.8). |

**Abnahme:** Alle sechs bestanden und protokolliert → die Restore-Probe ist gültig, das A5-Gate aus 25.5 ist offen. Ein einziger fehlgeschlagener Test = keine Freigabe, Ursache klären (kein „Retry bis grün").

**NT-B5 ist der eigentlich wichtige Test.** Er prüft nicht restic, sondern eure Ablagedisziplin — dieselbe Logik wie bei der BitLocker-Entsperrprobe. Ein Backup, das nur der Server wiederherstellen kann, ist keins.

## I. Monatliche Pflege (attended, im Learn-Review)

Vom **Latitude**, mit dem Hauptkonto. Hier wird der Pfad des Sub-Account-Verzeichnisses gebraucht:

```powershell
$Main = "ssh -p23 uXXXXX@uXXXXX.your-storagebox.de rclone serve restic --stdio ./backup-home-srv01/restic"
$env:RESTIC_PASSWORD_FILE = "<lokale Kopie oder Eingabe aus dem Passwortmanager>"

restic -o rclone.program="$Main" -r rclone: snapshots      # Kette lückenlos?
restic -o rclone.program="$Main" -r rclone: forget `
    --keep-daily 14 --keep-weekly 8 --keep-monthly 12 --tag nightly --prune
restic -o rclone.program="$Main" -r rclone: check --read-data-subset=10%
```

Retention 14/8/12 gemäß §8.5 der As-built-Doku.

Zusätzlich monatlich: belegten Speicher in der Hetzner Console ablesen und gegen die Erwartung halten. **Ein plötzlicher Sprung ist ein Alarmsignal** — typischerweise ein komprimierter Dump, der die Deduplikation aushebelt.

Alle 90 Tage: NT-B4 und NT-B5 wiederholen, Datum in §7 des Statusdokuments nachziehen. Vor jeder A5-Freigabe muss die Probe jünger als 30 Tage sein (25.5).

### Störungsfall: Backup scheitert mit „file already exists"

Ursache ist ein abgebrochener Upload nach Grenze 2 in Abschnitt A: Eine Pack-Datei liegt unvollständig im Repository, und der append-only-Zugang darf sie nicht überschreiben. Reparatur **vom Latitude** mit dem Hauptkonto:

1. Fehlermeldung im Log lesen — sie nennt den Dateinamen, meist unter `data/<xx>/<hash>`.
2. Prüfen und entfernen:
   ```powershell
   $Main = "ssh -p23 u643226@u643226.your-storagebox.de rclone serve restic --stdio ./backup-home-srv01/restic"
   restic -o "rclone.program=$Main" -r rclone: check
   ```
   `check` benennt beschädigte oder unerwartete Pack-Dateien. Diese per SFTP mit dem **Hauptkonto** aus `./backup-home-srv01/restic/data/...` löschen.
3. `restic check` erneut, dann den nächtlichen Lauf manuell anstoßen.

Tritt das wiederholt auf, ist die Ursache fast immer die Verbindung — dann LAN-Kabel legen (offener Punkt 5 im Statusdokument), nicht das Backup umbauen.

## J. Wiederherstellung im Ernstfall

Vollständiger Verlust von HOME-SRV01, Wiederherstellung von einer beliebigen Maschine:

```powershell
$Main = "ssh -p23 uXXXXX@uXXXXX.your-storagebox.de rclone serve restic --stdio ./backup-home-srv01/restic"
$env:RESTIC_PASSWORD = "<Repository-Passwort aus dem Passwortmanager>"

restic -o rclone.program="$Main" -r rclone: snapshots
restic -o rclone.program="$Main" -r rclone: restore <snapshot-id> --target E:\wiederherstellung
```

Ist das Repository beschädigt: Hetzner Console → Snapshots → passenden Zeitpunkt wählen und zurückrollen, danach erneut `restic check`.

**Was du dafür zwingend brauchst — alles außerhalb des Servers:**

1. Hetzner-Konto-Zugang inklusive 2FA-Wiederherstellungscodes
2. Hauptkonto-Passwort der Storage Box
3. restic-Repository-Passwort

Fehlt eines davon, ist das Backup verloren. Diese drei Punkte gehören in dieselbe Offline-Ablage wie die BitLocker-Recovery-Schlüssel.

---

**Rollback:** Storage Box ist monatlich kündbar und folgenlos löschbar. Auf HOME-SRV01 entfernen `Unregister-ScheduledTask -TaskName "restic-nightly-storagebox"`, das Skript und `D:\backups\config` alle Spuren. **Pflege:** Runbook-Änderungen nur versioniert mit Changelog-Zeile; Erkenntnisse aus dem Aufbau als Learn-Einträge (9.8).
