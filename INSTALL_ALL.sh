#!/bin/bash

set -e

echo "=================================="
echo " Homebase Recovery Installer V1"
echo "=================================="
echo ""

echo "Was möchtest du installieren?"
echo ""
echo "[1] Alles"
echo "[2] Nur Struktur"
echo "[3] Nur KeepAlive"
echo "[4] Nur Samba"
echo "[5] Nur Docker"
echo "[6] Nur Backup"
echo "[7] Benutzerdefiniert"
echo ""

read -p "Auswahl [1]: " CHOICE
CHOICE=${CHOICE:-1}

run_script() {
    SCRIPT="$1"
    MODE="$2"

    if [ ! -f "$SCRIPT" ]; then
        echo "FEHLT: $SCRIPT"
        return
    fi

    chmod +x "$SCRIPT"

    echo ""
    echo "Starte: $SCRIPT"
    echo ""

    if [[ "$MODE" == "sudo" ]]; then
        sudo "./$SCRIPT"
    else
        "./$SCRIPT"
    fi
}

install_structure() {
    run_script "INSTALL_STRUCTURE.sh" "normal"
}

install_keepalive() {
    run_script "INSTALL_KEEPALIVE.sh" "sudo"
}

install_samba() {
    run_script "INSTALL_SAMBA.sh" "sudo"
}

install_docker() {
    run_script "INSTALL_DOCKER.sh" "sudo"
}

install_backup() {
    run_script "INSTALL_BACKUP.sh" "sudo"
}

case "$CHOICE" in
    1)
        install_structure
        install_keepalive
        install_docker
        install_samba
        install_backup
        ;;
    2)
        install_structure
        ;;
    3)
        install_keepalive
        ;;
    4)
        install_samba
        ;;
    5)
        install_docker
        ;;
    6)
        install_backup
        ;;
    7)
        read -p "Struktur installieren? (j/n) [j]: " A
        A=${A:-j}
        [[ "$A" == "j" ]] && install_structure

        read -p "KeepAlive installieren? (j/n) [j]: " A
        A=${A:-j}
        [[ "$A" == "j" ]] && install_keepalive

        read -p "Docker installieren? (j/n) [j]: " A
        A=${A:-j}
        [[ "$A" == "j" ]] && install_docker

        read -p "Samba installieren? (j/n) [j]: " A
        A=${A:-j}
        [[ "$A" == "j" ]] && install_samba

        read -p "Backup installieren? (j/n) [j]: " A
        A=${A:-j}
        [[ "$A" == "j" ]] && install_backup
        ;;
    *)
        echo "Ungültige Auswahl."
        exit 1
        ;;
esac

echo ""
echo "=================================="
echo "Homebase Recovery abgeschlossen ✅"
echo "=================================="
echo ""
echo "Empfohlen:"
echo "sudo reboot"
echo ""