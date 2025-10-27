#!/usr/bin/env bash
set -e

mkdir -p /app/superset_home
if [ ! -f /app/superset_home/.initialized ]; then
  superset db upgrade
  superset fab create-admin \
    --username "${ADMIN_USERNAME:-admin}" \
    --firstname "${ADMIN_FIRSTNAME:-Superset}" \
    --lastname "${ADMIN_LASTNAME:-Admin}" \
    --email "${ADMIN_EMAIL:-admin@example.com}" \
    --password "${ADMIN_PASSWORD:-adminpass}" || true
  superset init
  touch /app/superset_home/.initialized
fi

# Use gthread instead of gevent (no external deps required)
exec gunicorn \
  --worker-class gthread \
  --threads 4 \
  --timeout 120 \
  --bind 0.0.0.0:${PORT:-8088} \
  "superset.app:create_app()"
