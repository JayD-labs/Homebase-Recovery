#!/bin/bash

set -e

echo "=================================="
echo " Homebase Structure Installer V1"
echo "=================================="
echo ""

DEFAULT_USER=$(logname 2>/dev/null || echo "$USER")
DEFAULT_BASE="/home/$DEFAULT_USER/Homebase-Core"

read -p "Installationspfad [$DEFAULT_BASE]: " BASE
BASE=${BASE:-$DEFAULT_BASE}

echo ""
echo "Homebase-Core wird erstellt unter:"
echo "$BASE"
echo ""

mkdir -p "$BASE"

mkdir -p "$BASE/backend/routes"
mkdir -p "$BASE/backend/database/migrations"
mkdir -p "$BASE/backend/services"
mkdir -p "$BASE/backend/api/internal"
mkdir -p "$BASE/backend/api/external"

mkdir -p "$BASE/frontend/css"
mkdir -p "$BASE/frontend/js"
mkdir -p "$BASE/frontend/assets/images"
mkdir -p "$BASE/frontend/assets/icons"
mkdir -p "$BASE/frontend/assets/logos"

mkdir -p "$BASE/modules/Homebase-AIWorker/sources/youtube"
mkdir -p "$BASE/modules/Homebase-AIWorker/sources/reddit"
mkdir -p "$BASE/modules/Homebase-AIWorker/sources/tiktok"
mkdir -p "$BASE/modules/Homebase-AIWorker/processing"
mkdir -p "$BASE/modules/Homebase-AIWorker/output/videos"
mkdir -p "$BASE/modules/Homebase-AIWorker/output/thumbnails"
mkdir -p "$BASE/modules/Homebase-AIWorker/output/metadata"
mkdir -p "$BASE/modules/Homebase-AIWorker/uploads/youtube"
mkdir -p "$BASE/modules/Homebase-AIWorker/uploads/shorts"

mkdir -p "$BASE/modules/Homebase-Backup/backups"
mkdir -p "$BASE/modules/Homebase-Backup/restore"
mkdir -p "$BASE/modules/Homebase-Backup/schedules"

mkdir -p "$BASE/modules/Homebase-Files/uploads"
mkdir -p "$BASE/modules/Homebase-Files/downloads"
mkdir -p "$BASE/modules/Homebase-Files/shares"

mkdir -p "$BASE/modules/Homebase-SmartHome/devices"
mkdir -p "$BASE/modules/Homebase-SmartHome/automations"
mkdir -p "$BASE/modules/Homebase-SmartHome/dashboards"

mkdir -p "$BASE/modules/Homebase-Games/installed"
mkdir -p "$BASE/modules/Homebase-Games/saves"
mkdir -p "$BASE/modules/Homebase-Games/configs"

mkdir -p "$BASE/modules/Homebase-Monitoring"
mkdir -p "$BASE/modules/Homebase-Notifications"

mkdir -p "$BASE/data/users"
mkdir -p "$BASE/data/logs"
mkdir -p "$BASE/data/settings"
mkdir -p "$BASE/data/cache"
mkdir -p "$BASE/data/sessions"
mkdir -p "$BASE/data/uploads"

mkdir -p "$BASE/backups/daily"
mkdir -p "$BASE/backups/weekly"
mkdir -p "$BASE/backups/monthly"
mkdir -p "$BASE/backups/manual"
mkdir -p "$BASE/backups/emergency"

mkdir -p "$BASE/docs/setup"
mkdir -p "$BASE/docs/roadmap"
mkdir -p "$BASE/docs/development"
mkdir -p "$BASE/docs/architecture"
mkdir -p "$BASE/docs/recovery"

mkdir -p "$BASE/scripts/install"
mkdir -p "$BASE/scripts/backup"
mkdir -p "$BASE/scripts/recovery"
mkdir -p "$BASE/scripts/maintenance"
mkdir -p "$BASE/scripts/updates"

mkdir -p "$BASE/services/docker"
mkdir -p "$BASE/services/systemd"
mkdir -p "$BASE/services/nginx"

mkdir -p "$BASE/config/system"
mkdir -p "$BASE/config/modules"
mkdir -p "$BASE/config/backups"

mkdir -p "$BASE/storage/media"
mkdir -p "$BASE/storage/documents"
mkdir -p "$BASE/storage/exports"
mkdir -p "$BASE/storage/temp"

mkdir -p "$BASE/recovery/configs"
mkdir -p "$BASE/recovery/installers"
mkdir -p "$BASE/recovery/backups"
mkdir -p "$BASE/recovery/documentation"

touch "$BASE/README.md"
touch "$BASE/CHANGELOG.md"
touch "$BASE/.env"
touch "$BASE/requirements.txt"
touch "$BASE/config.py"

touch "$BASE/backend/app.py"
touch "$BASE/backend/routes/dashboard.py"
touch "$BASE/backend/routes/auth.py"
touch "$BASE/backend/routes/settings.py"
touch "$BASE/backend/routes/files.py"
touch "$BASE/backend/routes/aiworker.py"

touch "$BASE/backend/database/database.db"
touch "$BASE/backend/database/models.py"

touch "$BASE/backend/services/backup_service.py"
touch "$BASE/backend/services/notification_service.py"
touch "$BASE/backend/services/file_service.py"
touch "$BASE/backend/services/user_service.py"

touch "$BASE/frontend/index.html"
touch "$BASE/frontend/css/style.css"
touch "$BASE/frontend/css/dashboard.css"
touch "$BASE/frontend/css/settings.css"
touch "$BASE/frontend/js/app.js"
touch "$BASE/frontend/js/dashboard.js"
touch "$BASE/frontend/js/settings.js"

touch "$BASE/modules/Homebase-AIWorker/README.md"
touch "$BASE/modules/Homebase-AIWorker/config.py"
touch "$BASE/modules/Homebase-AIWorker/processing/video_editor.py"
touch "$BASE/modules/Homebase-AIWorker/processing/title_generator.py"
touch "$BASE/modules/Homebase-AIWorker/processing/description_generator.py"
touch "$BASE/modules/Homebase-AIWorker/processing/metadata_generator.py"

chown -R "$DEFAULT_USER:$DEFAULT_USER" "$BASE" 2>/dev/null || true

echo ""
echo "=================================="
echo "Homebase-Core Struktur erstellt ✅"
echo ""
echo "Pfad:"
echo "$BASE"
echo "=================================="