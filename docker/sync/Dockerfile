FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/sync /app/bin/sync
RUN chmod +x /app/bin/sync
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/sync
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
