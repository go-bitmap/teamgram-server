FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/session /app/bin/session
RUN chmod +x /app/bin/session
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/session
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
