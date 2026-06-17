#!/bin/bash

set -e

echo "=================================="
echo " Homebase Backup Installer V1"
echo "=================================="
echo ""

echo "Installiere benötigte Pakete..."
sudo apt update
sudo apt install -y rsync tar

DEFAULT_USER=$(logname 2>/dev/null || echo "$USER")
DEFAULT_HOMEBASE="/home/$DEFAULT_USER/Homebase-Core"
DEFAULT_RECOVERY="/home/$DEFAULT_USER/Recovery"
DEFAULT_BACKUP="/backups"

read -p "Homebase-Core sichern? (j/n) [j]: " BACKUP_HOMEBASE
BACKUP_HOMEBASE=${BACKUP_HOMEBASE:-j}

read -p "Recovery-Ordner sichern? (j/n) [j]: " BACKUP_RECOVERY
BACKUP_RECOVERY=${BACKUP_RECOVERY:-j}

read -p "Docker Volumes sichern? (j/n) [n]: " BACKUP_DOCKER
BACKUP_DOCKER=${BACKUP_DOCKER:-n}

read -p "System-Konfigurationen sichern? (j/n) [j]: " BACKUP_CONFIGS
BACKUP_CONFIGS=${BACKUP_CONFIGS:-j}

echo ""
echo "Backup-Ziel wählen:"
echo "[1] Lokal auf dem Pi: /backups"
echo "[2] Eigener Pfad, z.B. externe SSD"
echo ""

read -p "Auswahl [1]: " BACKUP_TARGET_CHOICE
BACKUP_TARGET_CHOICE=${BACKUP_TARGET_CHOICE:-1}

if [[ "$BACKUP_TARGET_CHOICE" == "2" ]]; then
    read -p "Backup-Pfad eingeben: " BACKUP_PATH
else
    BACKUP_PATH="$DEFAULT_BACKUP"
fi

read -p "Wie viele tägliche Backups behalten? [7]: " RETENTION_DAYS
RETENTION_DAYS=${RETENTION_DAYS:-7}

read -p "Tägliche Backup-Uhrzeit? [03:00]: " BACKUP_TIME
BACKUP_TIME=${BACKUP_TIME:-03:00}

echo ""
echo "Backupstruktur wird erstellt..."
echo ""

sudo mkdir -p "$BACKUP_PATH/daily"
sudo mkdir -p "$BACKUP_PATH/weekly"
sudo mkdir -p "$BACKUP_PATH/monthly"
sudo mkdir -p "$BACKUP_PATH/manual"
sudo mkdir -p "$BACKUP_PATH/emergency"
sudo mkdir -p "$BACKUP_PATH/logs"
sudo mkdir -p "$BACKUP_PATH/restore"

sudo chown -R "$DEFAULT_USER:$DEFAULT_USER" "$BACKUP_PATH"

echo ""
echo "Backup Script wird erstellt..."
echo ""

BACKUP_SCRIPT="$BACKUP_PATH/backup_homebase.sh"

cat > "$BACKUP_SCRIPT" <<EOF
#!/bin/bash

set -e

DATE=\$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_ROOT="$BACKUP_PATH"
LOG_FILE="\$BACKUP_ROOT/logs/backup_\$DATE.log"

echo "==================================" >> "\$LOG_FILE"
echo "Homebase Backup gestartet: \$(date)" >> "\$LOG_FILE"
echo "==================================" >> "\$LOG_FILE"

mkdir -p "\$BACKUP_ROOT/daily"

TEMP_DIR="/tmp/homebase_backup_\$DATE"
mkdir -p "\$TEMP_DIR"

EOF

if [[ "$BACKUP_HOMEBASE" == "j" ]]; then
cat >> "$BACKUP_SCRIPT" <<EOF
if [ -d "$DEFAULT_HOMEBASE" ]; then
    echo "Sichere Homebase-Core..." >> "\$LOG_FILE"
    mkdir -p "\$TEMP_DIR/Homebase-Core"
    rsync -a --delete "$DEFAULT_HOMEBASE/" "\$TEMP_DIR/Homebase-Core/" >> "\$LOG_FILE" 2>&1
fi

EOF
fi

if [[ "$BACKUP_RECOVERY" == "j" ]]; then
cat >> "$BACKUP_SCRIPT" <<EOF
if [ -d "$DEFAULT_RECOVERY" ]; then
    echo "Sichere Recovery..." >> "\$LOG_FILE"
    mkdir -p "\$TEMP_DIR/Recovery"
    rsync -a --delete "$DEFAULT_RECOVERY/" "\$TEMP_DIR/Recovery/" >> "\$LOG_FILE" 2>&1
fi

EOF
fi

if [[ "$BACKUP_DOCKER" == "j" ]]; then
cat >> "$BACKUP_SCRIPT" <<EOF
if command -v docker >/dev/null 2>&1; then
    echo "Sichere Docker Volumes..." >> "\$LOG_FILE"
    mkdir -p "\$TEMP_DIR/docker-volumes"
    docker volume ls -q > "\$TEMP_DIR/docker-volumes/volume-list.txt"
fi

EOF
fi

if [[ "$BACKUP_CONFIGS" == "j" ]]; then
cat >> "$BACKUP_SCRIPT" <<EOF
echo "Sichere System-Konfigurationen..." >> "\$LOG_FILE"
mkdir -p "\$TEMP_DIR/system-configs"

[ -f /etc/samba/smb.conf ] && sudo cp /etc/samba/smb.conf "\$TEMP_DIR/system-configs/smb.conf"
[ -f /etc/fstab ] && sudo cp /etc/fstab "\$TEMP_DIR/system-configs/fstab"
[ -d /etc/systemd/system ] && sudo cp -r /etc/systemd/system "\$TEMP_DIR/system-configs/systemd"

EOF
fi

cat >> "$BACKUP_SCRIPT" <<EOF
ARCHIVE="\$BACKUP_ROOT/daily/homebase_backup_\$DATE.tar.gz"

echo "Erstelle Archiv..." >> "\$LOG_FILE"
tar -czf "\$ARCHIVE" -C "\$TEMP_DIR" . >> "\$LOG_FILE" 2>&1

echo "Räume temporäre Daten auf..." >> "\$LOG_FILE"
rm -rf "\$TEMP_DIR"

echo "Lösche alte Daily Backups älter als $RETENTION_DAYS Tage..." >> "\$LOG_FILE"
find "\$BACKUP_ROOT/daily" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "Backup fertig: \$ARCHIVE" >> "\$LOG_FILE"
echo "Fertig: \$(date)" >> "\$LOG_FILE"
EOF

chmod +x "$BACKUP_SCRIPT"

echo ""
echo "Systemd Timer wird erstellt..."
echo ""

HOUR=$(echo "$BACKUP_TIME" | cut -d':' -f1)
MINUTE=$(echo "$BACKUP_TIME" | cut -d':' -f2)

sudo tee /etc/systemd/system/homebase-backup.service > /dev/null <<EOF
[Unit]
Description=Homebase Backup Service

[Service]
Type=oneshot
ExecStart=$BACKUP_SCRIPT
EOF

sudo tee /etc/systemd/system/homebase-backup.timer > /dev/null <<EOF
[Unit]
Description=Run Homebase Backup Daily

[Timer]
OnCalendar=*-*-* $HOUR:$MINUTE:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable homebase-backup.timer
sudo systemctl restart homebase-backup.timer

echo ""
echo "=================================="
echo "Backup V1 erfolgreich eingerichtet ✅"
echo ""
echo "Backup-Pfad:"
echo "$BACKUP_PATH"
echo ""
echo "Backup-Script:"
echo "$BACKUP_SCRIPT"
echo ""
echo "Timer:"
echo "homebase-backup.timer"
echo ""
echo "Manuelles Backup:"
echo "$BACKUP_SCRIPT"
echo ""
echo "Timer prüfen:"
echo "systemctl status homebase-backup.timer --no-pager"
echo "=================================="