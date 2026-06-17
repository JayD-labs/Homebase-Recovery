#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Bitte starten mit: sudo ./INSTALL_KEEPALIVE.sh"
  exit 1
fi

echo "=== Pi KeepAlive Installer V1 ==="

echo "[1/4] Alte watchdog.service deaktivieren, weil systemd bereits /dev/watchdog0 nutzt..."
systemctl stop watchdog 2>/dev/null || true
systemctl disable watchdog 2>/dev/null || true

echo "[2/4] WLAN Powersave deaktivieren..."
mkdir -p /etc/NetworkManager/conf.d

cat > /etc/NetworkManager/conf.d/wifi-powersave-off.conf <<'WIFI'
[connection]
wifi.powersave = 2
WIFI

systemctl restart NetworkManager 2>/dev/null || true

echo "[3/4] WLAN Auto-Reconnect Script erstellen..."
cat > /usr/local/bin/wifi-watchdog.sh <<'WIFIDOG'
#!/bin/bash

PING_TARGET="192.168.178.1"
WLAN_IFACE="wlan0"

if ! ping -c 2 -W 3 "$PING_TARGET" > /dev/null; then
  logger "Homebase WiFi-Watchdog: Verbindung hängt, reconnect wird versucht"

  ip link set "$WLAN_IFACE" down 2>/dev/null || true
  sleep 5
  ip link set "$WLAN_IFACE" up 2>/dev/null || true
  sleep 10

  systemctl restart NetworkManager 2>/dev/null || true
  systemctl restart dhcpcd 2>/dev/null || true
fi
WIFIDOG

chmod +x /usr/local/bin/wifi-watchdog.sh

echo "[4/4] systemd Timer erstellen..."
cat > /etc/systemd/system/wifi-watchdog.service <<'SERVICE'
[Unit]
Description=Homebase WiFi Watchdog Reconnect

[Service]
Type=oneshot
ExecStart=/usr/local/bin/wifi-watchdog.sh
SERVICE

cat > /etc/systemd/system/wifi-watchdog.timer <<'TIMER'
[Unit]
Description=Run Homebase WiFi Watchdog every 2 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=2min
Unit=wifi-watchdog.service

[Install]
WantedBy=timers.target
TIMER

systemctl daemon-reload
systemctl enable wifi-watchdog.timer
systemctl restart wifi-watchdog.timer

echo
echo "===================================="
echo "FERTIG ✅"
echo "KeepAlive V1 installiert:"
echo "- systemd Hardware-Watchdog bleibt aktiv"
echo "- extra watchdog.service deaktiviert"
echo "- WLAN Powersave deaktiviert"
echo "- WLAN Auto-Reconnect alle 2 Minuten"
echo
echo "Prüfen mit:"
echo "systemctl status wifi-watchdog.timer --no-pager"
echo "sudo lsof /dev/watchdog*"
echo "===================================="