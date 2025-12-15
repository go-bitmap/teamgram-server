FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/msg /app/bin/msg
RUN chmod +x /app/bin/msg
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/msg
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
