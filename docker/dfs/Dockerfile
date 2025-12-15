FROM alpine:latest
RUN apk add --no-cache ffmpeg
WORKDIR /app
COPY ./teamgramd/bin/dfs /app/bin/dfs
RUN chmod +x /app/bin/dfs
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/dfs
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
