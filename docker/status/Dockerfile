FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/status /app/bin/status
RUN chmod +x /app/bin/status
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/status
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
