FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/idgen /app/bin/idgen
RUN chmod +x /app/bin/idgen
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/idgen
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
