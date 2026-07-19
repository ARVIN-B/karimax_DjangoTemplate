#!/bin/sh
set -e

echo "Waiting for Redis at ${CELERY_BROKER_URL:-redis://redis:6379/0}..."
python - <<'PY'
import os, time, sys
from urllib.parse import urlparse

url = os.environ.get("CELERY_BROKER_URL", "redis://redis:6379/0")
parsed = urlparse(url)
host = parsed.hostname or "redis"
port = parsed.port or 6379

try:
    import redis
except ImportError:
    sys.exit(0)

for attempt in range(30):
    try:
        client = redis.Redis(host=host, port=port, socket_connect_timeout=2)
        if client.ping():
            print("Redis is ready.")
            break
    except Exception as exc:
        print(f"Redis not ready ({attempt + 1}/30): {exc}")
        time.sleep(1)
else:
    print("WARNING: Redis did not become ready in time; continuing anyway.")
PY

if [ "${RUN_MIGRATIONS:-1}" = "1" ] && [ "$1" != "celery" ]; then
  echo "Running migrations..."
  python manage.py migrate --noinput || true
fi

exec "$@"
