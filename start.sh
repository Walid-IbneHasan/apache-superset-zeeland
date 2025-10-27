#!/usr/bin/env bash
set -e

# Use the Python that Superset runs with (the venv one)
PY="${PYTHON:-python}"

# 1) Ensure pip exists in the venv
$PY -m ensurepip --upgrade || true
$PY -m pip install --no-cache-dir --upgrade pip wheel || true

# 2) Ensure the Postgres driver is present
if ! $PY - <<'PYCODE'
import importlib.util, sys
sys.exit(0 if importlib.util.find_spec("psycopg2") else 1)
PYCODE
then
  $PY -m pip install --no-cache-dir "psycopg2-binary>=2.9"
fi

# 3) First-run init (idempotent)
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

# 4) Start web server bound to Render's $PORT
exec gunicorn -w 2 -k gevent --timeout 120 \
  --bind 0.0.0.0:${PORT:-8088} "superset.app:create_app()"
