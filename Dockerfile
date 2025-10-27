FROM apache/superset:5.0.0

# --- put psycopg2 where Python will find it without touching the venv ---
USER root
RUN mkdir -p /app/pythonpath && chown -R superset:superset /app/pythonpath
# Install the driver into /app/pythonpath (a plain directory on sys.path)
RUN pip install --no-cache-dir --target=/app/pythonpath "psycopg2-binary>=2.9"
# Make sure Python searches /app/pythonpath
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"

# --- your config and startup ---
COPY --chown=superset superset_config.py /app/superset_config.py
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

COPY --chown=superset start.sh /app/start.sh
RUN chmod +x /app/start.sh

USER superset
CMD ["/app/start.sh"]
