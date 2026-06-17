# Homebase Recovery

**Version:** 1.0.0
**Status:** Stable Release
**Release-Datum:** 17.06.2026

Homebase Recovery ist das Wiederherstellungs- und Installationssystem für Homebase-Core.

Ziel ist es, einen Raspberry Pi nach einer Neuinstallation, einem SD-Karten-Ausfall oder einem Hardwarewechsel innerhalb weniger Minuten wieder betriebsbereit zu machen.

---

# Features

* Automatisierte Installation aller Homebase-Komponenten
* Homebase-Core Projektstruktur
* Docker Installation
* Samba Netzwerkfreigaben
* Backup-System mit systemd-Timer
* WLAN KeepAlive & Auto-Reconnect
* Recovery- und Wiederherstellungsfunktionen

---

# Enthaltene Skripte

## INSTALL_ALL.sh

Zentraler Installer für Homebase Recovery.

Installiert alle verfügbaren Komponenten oder ermöglicht eine benutzerdefinierte Auswahl.

### Ausführung

```bash
cd ~/Homebase-Recovery

sudo apt install dos2unix -y
dos2unix *.sh

chmod +x *.sh

./INSTALL_ALL.sh
```

---

## INSTALL_STRUCTURE.sh

Erstellt die vollständige Homebase-Core Verzeichnisstruktur.

### Ausführung

```bash
chmod +x INSTALL_STRUCTURE.sh

./INSTALL_STRUCTURE.sh
```

---

## INSTALL_KEEPALIVE.sh

Installiert das Homebase KeepAlive System.

### Funktionen

* WLAN KeepAlive
* WLAN Auto-Reconnect
* WLAN Powersave deaktivieren
* Nutzung des systemd Hardware-Watchdogs
* Automatische Netzwerkwiederherstellung

### Ausführung

```bash
chmod +x INSTALL_KEEPALIVE.sh

sudo ./INSTALL_KEEPALIVE.sh
```

---

## INSTALL_DOCKER.sh

Installiert Docker und die Homebase Docker Umgebung.

### Funktionen

* Docker Installation
* Docker Compose Unterstützung
* Docker Netzwerk
* Optionale Portainer Installation
* Optionale Watchtower Installation
* Homebase Docker Struktur

### Ausführung

```bash
chmod +x INSTALL_DOCKER.sh

sudo ./INSTALL_DOCKER.sh
```

---

## INSTALL_SAMBA.sh

Installiert und konfiguriert Samba Netzwerkfreigaben.

### Funktionen

* Benutzererkennung
* Passwortvergabe
* Frei definierbare Freigaben
* Konfigurierbare Zugriffsrechte

### Ausführung

```bash
chmod +x INSTALL_SAMBA.sh

sudo ./INSTALL_SAMBA.sh
```

---

## INSTALL_BACKUP.sh

Installiert das Homebase Backup System.

### Funktionen

* Daily Backups
* Weekly Backups
* Monthly Backups
* Manual Backups
* Emergency Backups
* Systemd Timer
* Konfigurierbare Backup-Ziele

### Ausführung

```bash
chmod +x INSTALL_BACKUP.sh

sudo ./INSTALL_BACKUP.sh
```

---

# Empfohlene Installation

Für einen neuen Raspberry Pi:

```bash
cd ~/Homebase-Recovery

sudo apt install dos2unix -y
dos2unix *.sh

chmod +x *.sh

./INSTALL_ALL.sh
```

Nach erfolgreicher Installation:

```bash
sudo reboot
```

---

# Projektstruktur

```text
Homebase-Recovery
│
├── README.md
├── .gitignore
│
├── INSTALL_ALL.sh
├── INSTALL_STRUCTURE.sh
├── INSTALL_KEEPALIVE.sh
├── INSTALL_DOCKER.sh
├── INSTALL_SAMBA.sh
└── INSTALL_BACKUP.sh
```

---

# Ziel

Homebase Recovery bildet die technische Grundlage für Homebase-Core.

Das System soll die Bereitstellung, Wartung und Wiederherstellung von Raspberry-Pi-basierten Homebase-Systemen vereinfachen und automatisieren.

---

# Lizenz

Derzeit private Entwicklung im Rahmen des Homebase-Projekts.
