FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/bff /app/bin/bff
RUN chmod +x /app/bin/bff
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/bff
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
