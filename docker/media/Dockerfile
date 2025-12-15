FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/media /app/bin/media
RUN chmod +x /app/bin/media
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/media
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
