# Pin a version; 5.x shown here
FROM apache/superset:5.0.0

# Add config
COPY --chown=superset superset_config.py /app/superset_config.py
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Simple startup that binds to $PORT (Render sets this)
COPY --chown=superset start.sh /app/start.sh
RUN chmod +x /app/start.sh

USER superset
CMD ["/app/start.sh"]
