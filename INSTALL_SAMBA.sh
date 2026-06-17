#!/bin/bash

set -e

echo "=================================="
echo "   Homebase Samba Installer V1"
echo "=================================="
echo ""

DEFAULT_USER=$(logname 2>/dev/null || echo "$USER")
DEFAULT_SHARE_NAME="share"
DEFAULT_SHARE_PATH="/home/$DEFAULT_USER/share"

read -p "Samba Benutzername [$DEFAULT_USER]: " SMBUSER
SMBUSER=${SMBUSER:-$DEFAULT_USER}

read -p "Freigabename [$DEFAULT_SHARE_NAME]: " SHARE_NAME
SHARE_NAME=${SHARE_NAME:-$DEFAULT_SHARE_NAME}

read -p "Freigabe-Pfad [$DEFAULT_SHARE_PATH]: " SHARE_PATH
SHARE_PATH=${SHARE_PATH:-$DEFAULT_SHARE_PATH}

read -p "Gastzugriff erlauben? (j/n) [n]: " GUEST_ACCESS
GUEST_ACCESS=${GUEST_ACCESS:-n}

read -p "Schreibzugriff erlauben? (j/n) [j]: " WRITE_ACCESS
WRITE_ACCESS=${WRITE_ACCESS:-j}

echo ""
echo "Installiere Samba..."
sudo apt update
sudo apt install samba -y

echo ""
echo "Erstelle Freigabeordner..."
sudo mkdir -p "$SHARE_PATH"
sudo chown -R "$SMBUSER:$SMBUSER" "$SHARE_PATH"
sudo chmod -R 775 "$SHARE_PATH"

echo ""
echo "Samba Benutzer wird eingerichtet..."
echo "Bitte jetzt das Samba-Passwort setzen:"
sudo smbpasswd -a "$SMBUSER"

echo ""
echo "Samba-Konfiguration wird gesichert..."
sudo cp /etc/samba/smb.conf "/etc/samba/smb.conf.backup.$(date +%Y%m%d-%H%M%S)"

echo ""
echo "Alte Homebase-Freigabe entfernen, falls vorhanden..."
sudo sed -i "/^\[$SHARE_NAME\]/,/^$/d" /etc/samba/smb.conf

echo ""
echo "Neue Samba-Freigabe wird eingetragen..."

if [[ "$GUEST_ACCESS" == "j" ]]; then
    GUEST_OK="yes"
    VALID_USERS=""
else
    GUEST_OK="no"
    VALID_USERS="valid users = $SMBUSER"
fi

if [[ "$WRITE_ACCESS" == "j" ]]; then
    READ_ONLY="no"
    WRITABLE="yes"
else
    READ_ONLY="yes"
    WRITABLE="no"
fi

sudo tee -a /etc/samba/smb.conf > /dev/null <<SAMBA

[$SHARE_NAME]
path = $SHARE_PATH
browseable = yes
read only = $READ_ONLY
writable = $WRITABLE
guest ok = $GUEST_OK
$VALID_USERS
create mask = 0775
directory mask = 0775

SAMBA

echo ""
echo "Samba-Konfiguration prüfen..."
sudo testparm -s

echo ""
echo "Samba wird neu gestartet..."
sudo systemctl restart smbd
sudo systemctl enable smbd

IP_ADDR=$(hostname -I | awk '{print $1}')

echo ""
echo "=================================="
echo "Samba erfolgreich eingerichtet ✅"
echo ""
echo "Windows Explorer:"
echo "\\\\$IP_ADDR\\$SHARE_NAME"
echo ""
echo "Benutzer:"
echo "$SMBUSER"
echo ""
echo "Freigabe-Pfad:"
echo "$SHARE_PATH"
echo "=================================="