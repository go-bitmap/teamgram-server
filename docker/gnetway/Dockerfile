FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/gnetway /app/bin/gnetway
COPY ./teamgramd/bin/server_pkcs1.key /app/bin/server_pkcs1.key
RUN chmod +x /app/bin/gnetway
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/gnetway
WORKDIR /app/bin
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
