# Infrastruktur: Windows-Heimserver und Steuergeräte

**Stand:** 2026-07-28
**Quelle:** Bestandsaufnahme durch Andreas (Hardware-Inventarisierung), redaktionell strukturiert
**Zweck:** Referenzdokument für den Forschungsauftrag — dieser Server ist das Zielsystem für den geplanten agentengestützten Betrieb (Server-Steuerung, DB-Administration, Automatisierung; vgl. Dossier 16 und Windows-Autonomie-Matrix)

---

## 1. Kurzprofil

> **HP EliteDesk 800 G6 Desktop Mini** — Intel Core i5-10500T (6C/12T, 35 W TDP), 32 GB DDR4-2666, Intel UHD 630, 2 × 512-GB-NVMe-SSD, Windows 11 Pro 24H2. Computername `DESKTOP-1TH69EV`. Kompakter Business-Mini-PC als stromsparender privater Heimserver — keine klassische Serverhardware (kein ECC, keine Redundanz, kein RAID, kein iLO).

## 2. Steuer- und Arbeitsgeräte

| Gerät | Rolle |
|---|---|
| **Dell Latitude 7400** (Laptop, älter) | primäres Arbeitsgerät für Administration und Entwicklung gegen den Server |
| **Google Pixel 8** | mobile Steuerung und Freigaben unterwegs (passt zu den Remote-Control-/Mobile-Freigabe-Befunden aus Dossier 14) |

## 3. Hardware im Detail

### Prozessor — Intel Core i5-10500T (Comet Lake, 10. Gen)

| Merkmal | Wert |
|---|---|
| Kerne / Threads | 6 / 12 (Hyper-Threading) |
| Takt | 2,30 GHz Basis, bis 3,80 GHz Turbo |
| Cache / TDP | 12 MB / 35 W |
| Virtualisierung | Intel VT-x und VT-d (BIOS-Aktivierung noch zu prüfen) |
| Weitere Merkmale | AES-NI, Intel Quick Sync (UHD 630) |

Gut geeignet für: RDP-Arbeitsplatz, mehrere Hintergrunddienste, Webanwendungen und Datenbanken, Docker/WSL2, kleinere VMs, Datei-/Backupdienste, Medienverarbeitung. **Nicht** ausgelegt für: viele parallele VMs oder große lokale KI-Modelle.

### Arbeitsspeicher

32 GB DDR4-2666 (31,8 GB nutzbar), **kein ECC** (vom Prozessor nicht unterstützt). RAM-Bestückung (2×16 vs. 1×32, Dual-Channel-Status) noch nicht ermittelt.

### Grafik

Intel UHD Graphics 630 (integriert, 128 MB dediziert + dynamischer Shared Memory). Keine dedizierte GPU. Quick Sync für Video-Transcodierung verfügbar. **Konsequenz für KI:** lokale LLM-Inferenz nur CPU-basiert und damit auf kleine Modelle beschränkt — Einordnung siehe Recherche-Addendum „Fehlende Organisationen" (NVIDIA/lokale Inferenz).

### Massenspeicher

| | SSD 1 (System) | SSD 2 (Daten) |
|---|---|---|
| Datenträger | 0 | 1 |
| Modell | SK hynix PC711 HFS512GDE9X073N | UMIS RPETJ512MGE2QDQ |
| Kapazität | 512 GB (477 GB nutzbar) | 512 GB (477 GB nutzbar) |
| Stil / Zustand | GPT / Healthy | GPT / Healthy |
| Laufwerk | C: — ~73 GB belegt, ~404 GB frei | D: — praktisch leer (~477 GB frei) |
| Partitionen | Reserviert 0,12 GB · EFI 0,10 GB · C: 476,72 GB | MS-reserviert 0,02 GB · D: 476,92 GB |

Gesamt: ~954 GB nutzbar, ~881 GB frei. **D: ist als dediziertes Laufwerk für Serverdaten, Datenbanken und lokale Backups vorgesehen.** Hinweis: „Healthy" ist keine Verschleißprüfung — vollständiger SMART-Check steht aus.

### Netzwerk

WLAN verbunden (Netz `ULVT18`), Bluetooth aktiv. Ethernet-Anschluss und genaue Adapter **noch nicht inventarisiert**. **Empfehlung für Dauerbetrieb: kabelgebundenes LAN statt WLAN** (Stabilität, Latenz, Erreichbarkeit nach Neustart).

### Betriebssystem und Firmware-Kontext

| Merkmal | Wert |
|---|---|
| OS | Windows 11 Pro, 24H2, Build 26100.8894 |
| Installiert | 17.08.2025, dauerhaft aktiviert (OEM-DM, Key im UEFI + extern gesichert) |
| Startmodus | UEFI/GPT |
| Hauptkonto | `PC` (lokaler Administrator, Kennwort gesetzt und getestet) |

Aktuell angeschlossen: USB-Stick 8 GB (E:, exFAT) — kein Teil der Serverkapazität.

## 4. Bewertung als Heimserver

**Stärken:** sparsamer 6-Kern-Prozessor für 24/7-Betrieb, komfortable 32 GB RAM, zwei getrennte SSDs (System/Daten), Windows 11 Pro mit RDP, Virtualisierungsunterstützung (WSL2-fähig), kompakt und leise.

**Einschränkungen gegenüber echter Serverhardware:** kein ECC-RAM, kein redundantes Netzteil, kein RAID, keine Hot-Swap-Laufwerke, kein Out-of-Band-Management (iLO o. ä.), SSD-Zustand nur oberflächlich geprüft.

## 5. Relevanz für Methodik und Forschungsauftrag

1. **Zielsystem des Server-Ops-Piloten (Dossier 16):** read-only Ops-Agent (Health, Logs, DB-Inspektion) als risikoarmer Einstieg; Schreiboperationen nur attended gemäß der in Arbeit befindlichen Windows-Autonomie-Matrix (Addendum 20).
2. **WSL2 ist machbar:** 6C/12T, 32 GB RAM und VT-x reichen komfortabel für WSL2 + Claude-Code-Sandbox — die im Sweep identifizierte Voraussetzung für höhere Autonomiestufen (A3+) auf Windows. BIOS-Prüfung der Virtualisierungsoptionen als erster Schritt.
3. **Kein ECC + kein RAID ⇒ Backup-Disziplin ist die Redundanz:** bestätigt die Methodik-Linie (Backup/Restore-Proben als Gate für autonomen Betrieb); D: als lokales Backup-Ziel plus externes Backup einplanen.
4. **Lokale LLM-Inferenz:** ohne dedizierte GPU nur kleine Modelle über CPU sinnvoll — Cloud-Modelle bleiben der Arbeitspfad, lokale Inferenz höchstens für Nebenaufgaben (Einordnung folgt in Addendum 18).
5. **Mobile Steuerung:** Pixel 8 + Claude Remote Control / GitHub Mobile deckt das Freigabe-unterwegs-Modell ab (Freigeben/Reviewen/Stoppen ja, destruktive Aktionen nie — Asymmetrie-Prinzip aus der Synthese).

## 6. Offene Punkte (Inventar-Backlog)

- Vollständiger SMART-Test beider SSDs (Verschleiß, Betriebsstunden, Temperatur)
- Ethernet-Adapter inventarisieren und Server auf LAN-Kabel umstellen
- BIOS-Version, Virtualisierungsoptionen (VT-x/VT-d aktiv?), RAM-Bestückung, Netzteilgröße
- Tailscale-Status auf diesem Gerät dokumentieren (Tailnet-Name, ACLs, SSH aktiviert?)
- Energie-/Autostart-Profil für 24/7-Betrieb (Verhalten nach Stromausfall, Wake-Konfiguration)
- **Rollenverteilung klären (Eigentümerentscheidung):** Aufgabenteilung zwischen diesem Heimserver und dem bestehenden Windows-VPS aus dem Projektportfolio (was läuft wo; Verhältnis zum `server-migration`-Vorhaben)
