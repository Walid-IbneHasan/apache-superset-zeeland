FROM apache/superset:5.0.0

# install the Postgres driver INTO Superset's virtualenv
USER root
RUN /app/.venv/bin/pip install --no-cache-dir "psycopg2-binary>=2.9"

# config + startup
COPY --chown=superset superset_config.py /app/superset_config.py
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

COPY --chown=superset start.sh /app/start.sh
RUN chmod +x /app/start.sh

USER superset
CMD ["/app/start.sh"]
