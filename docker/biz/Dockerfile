FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/biz /app/bin/biz
RUN chmod +x /app/bin/biz
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/biz
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
