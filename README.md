# Homebase Recovery

**Version:** 1.0.0
**Status:** Stable Release
**Release Date:** 2026-06-17

Homebase Recovery is the installation and recovery framework for Homebase Core.

Its purpose is to restore a Raspberry Pi system after a fresh installation, SD card failure, hardware replacement, or system corruption within just a few minutes.

---

# Features

* Automated installation of all Homebase components
* Homebase Core project structure creation
* Docker installation and setup
* Samba network shares
* Automated backup system with systemd timers
* Wi-Fi KeepAlive & Auto-Reconnect
* Recovery and restoration utilities

---

# Included Scripts

## INSTALL_ALL.sh

Main installer for Homebase Recovery.

Installs all available components or allows custom selection.

### Usage

```bash
cd ~/Homebase-Recovery

sudo apt install dos2unix -y
dos2unix *.sh

chmod +x *.sh

./INSTALL_ALL.sh
```

---

## INSTALL_STRUCTURE.sh

Creates the complete Homebase Core directory structure.

### Usage

```bash
chmod +x INSTALL_STRUCTURE.sh

./INSTALL_STRUCTURE.sh
```

---

## INSTALL_KEEPALIVE.sh

Installs the Homebase KeepAlive system.

### Features

* Wi-Fi KeepAlive
* Automatic Wi-Fi reconnect
* Disables Wi-Fi power saving
* Uses the systemd hardware watchdog
* Automatic network recovery

### Usage

```bash
chmod +x INSTALL_KEEPALIVE.sh

sudo ./INSTALL_KEEPALIVE.sh
```

---

## INSTALL_DOCKER.sh

Installs Docker and the Homebase Docker environment.

### Features

* Docker installation
* Docker Compose support
* Dedicated Docker network
* Optional Portainer installation
* Optional Watchtower installation
* Homebase Docker directory structure

### Usage

```bash
chmod +x INSTALL_DOCKER.sh

sudo ./INSTALL_DOCKER.sh
```

---

## INSTALL_SAMBA.sh

Installs and configures Samba network shares.

### Features

* User detection
* Password configuration
* Customizable shared folders
* Configurable access permissions

### Usage

```bash
chmod +x INSTALL_SAMBA.sh

sudo ./INSTALL_SAMBA.sh
```

---

## INSTALL_BACKUP.sh

Installs the Homebase Backup System.

### Features

* Daily backups
* Weekly backups
* Monthly backups
* Manual backups
* Emergency backups
* Systemd timer integration
* Configurable backup destinations

### Usage

```bash
chmod +x INSTALL_BACKUP.sh

sudo ./INSTALL_BACKUP.sh
```

---

# Recommended Installation

For a fresh Raspberry Pi setup:

```bash
cd ~/Homebase-Recovery

sudo apt install dos2unix -y
dos2unix *.sh

chmod +x *.sh

./INSTALL_ALL.sh
```

After installation:

```bash
sudo reboot
```

---

# Project Structure

```text
Homebase-Recovery
│
├── Changelog.md
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

# Mission

Homebase Recovery serves as the foundation of the Homebase ecosystem.

The goal is to simplify deployment, maintenance, backup, and recovery of Raspberry Pi-based Homebase systems through automation and standardized tooling.

---

# Roadmap

Planned future additions:

* Automated Homebase Core deployment
* One-click restore from backup
* Remote recovery capabilities
* Docker container templates
* Homebase Web Dashboard integration
* Hardware monitoring and health checks

---

# License

Currently under private development as part of the Homebase Core project.

License details will be added once the project becomes publicly available.
