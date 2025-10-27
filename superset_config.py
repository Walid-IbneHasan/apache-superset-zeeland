import os

# Required in prod
SECRET_KEY = os.environ.get("SUPERSET_SECRET_KEY", "change-me")

# Superset metadata DB (not your analytics DBs)
SQLALCHEMY_DATABASE_URI = os.environ.get("DATABASE_URL", "sqlite:////app/superset_home/superset.db")

# Optional: Redis for cache/sessions
REDIS_URL = os.environ.get("REDIS_URL")
if REDIS_URL:
    CACHE_CONFIG = {
        "CACHE_TYPE": "RedisCache",
        "CACHE_DEFAULT_TIMEOUT": 300,
        "CACHE_KEY_PREFIX": "superset_",
        "CACHE_REDIS_URL": REDIS_URL,
    }
    DATA_CACHE_CONFIG = CACHE_CONFIG

# Let anonymous users view published dashboards
PUBLIC_ROLE_LIKE = "Gamma"

# CSRF/session basics
WTF_CSRF_ENABLED = True
