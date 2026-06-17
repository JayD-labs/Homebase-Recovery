#!/bin/bash

set -e

echo "=================================="
echo " Homebase Docker Installer V1"
echo "=================================="
echo ""

DEFAULT_USER=$(logname 2>/dev/null || echo "$USER")
DOCKER_BASE="/home/$DEFAULT_USER/Homebase-Core/docker"

read -p "Portainer installieren? (j/n) [j]: " INSTALL_PORTAINER
INSTALL_PORTAINER=${INSTALL_PORTAINER:-j}

read -p "Watchtower installieren? Auto-Updates für Container (j/n) [n]: " INSTALL_WATCHTOWER
INSTALL_WATCHTOWER=${INSTALL_WATCHTOWER:-n}

read -p "Homebase Docker Netzwerk erstellen? (j/n) [j]: " CREATE_NETWORK
CREATE_NETWORK=${CREATE_NETWORK:-j}

echo ""
echo "Installiere benötigte Pakete..."
sudo apt update
sudo apt install -y curl ca-certificates gnupg lsb-release

echo ""
echo "Docker wird installiert..."
if command -v docker >/dev/null 2>&1; then
    echo "Docker ist bereits installiert."
else
    curl -fsSL https://get.docker.com | sudo sh
fi

echo ""
echo "Benutzer zur Docker-Gruppe hinzufügen..."
sudo usermod -aG docker "$DEFAULT_USER"

echo ""
echo "Docker Dienst aktivieren..."
sudo systemctl enable docker
sudo systemctl start docker

echo ""
echo "Docker Compose prüfen..."
if docker compose version >/dev/null 2>&1; then
    docker compose version
else
    echo "Docker Compose ist nicht verfügbar. Installation über Docker-Paket wird erwartet."
fi

echo ""
echo "Docker Struktur erstellen..."
mkdir -p "$DOCKER_BASE/stacks"
mkdir -p "$DOCKER_BASE/containers"
mkdir -p "$DOCKER_BASE/volumes"
mkdir -p "$DOCKER_BASE/backups"
mkdir -p "$DOCKER_BASE/stacks/portainer"
mkdir -p "$DOCKER_BASE/stacks/watchtower"
mkdir -p "$DOCKER_BASE/stacks/homebase"
mkdir -p "$DOCKER_BASE/stacks/monitoring"
mkdir -p "$DOCKER_BASE/stacks/databases"

if [[ "$CREATE_NETWORK" == "j" ]]; then
    echo ""
    echo "Homebase Docker Netzwerk erstellen..."
    if sudo docker network ls | grep -q "homebase-net"; then
        echo "Docker Netzwerk homebase-net existiert bereits."
    else
        sudo docker network create homebase-net
    fi
fi

if [[ "$INSTALL_PORTAINER" == "j" ]]; then
    echo ""
    echo "Portainer wird eingerichtet..."

    sudo docker volume create portainer_data

    sudo docker rm -f portainer 2>/dev/null || true

    sudo docker run -d \
        --name portainer \
        --restart=always \
        -p 9000:9000 \
        -p 9443:9443 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer-ce:latest

    cat > "$DOCKER_BASE/stacks/portainer/docker-compose.yml" <<EOF
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    ports:
      - "9000:9000"
      - "9443:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
EOF
fi

if [[ "$INSTALL_WATCHTOWER" == "j" ]]; then
    echo ""
    echo "Watchtower wird eingerichtet..."

    sudo docker rm -f watchtower 2>/dev/null || true

    sudo docker run -d \
        --name watchtower \
        --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        containrrr/watchtower \
        --cleanup \
        --schedule "0 0 4 * * *"

    cat > "$DOCKER_BASE/stacks/watchtower/docker-compose.yml" <<EOF
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --cleanup --schedule "0 0 4 * * *"
EOF
fi

echo ""
echo "Docker Test..."
sudo docker run --rm hello-world

IP_ADDR=$(hostname -I | awk '{print $1}')

echo ""
echo "=================================="
echo "Docker V4 erfolgreich installiert ✅"
echo ""
echo "Docker Root:"
echo "$DOCKER_BASE"
echo ""

if [[ "$INSTALL_PORTAINER" == "j" ]]; then
    echo "Portainer:"
    echo "http://$IP_ADDR:9000"
    echo "https://$IP_ADDR:9443"
    echo ""
fi

if [[ "$INSTALL_WATCHTOWER" == "j" ]]; then
    echo "Watchtower:"
    echo "Installiert und läuft täglich um 04:00 Uhr."
    echo ""
fi

echo "Docker Netzwerk:"
if [[ "$CREATE_NETWORK" == "j" ]]; then
    echo "homebase-net"
else
    echo "Nicht erstellt."
fi

echo ""
echo "WICHTIG:"
echo "Damit Docker ohne sudo funktioniert:"
echo "Einmal abmelden/anmelden oder:"
echo "newgrp docker"
echo ""
echo "Test:"
echo "docker ps"
echo "=================================="