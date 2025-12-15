FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/authsession /app/bin/authsession
RUN chmod +x /app/bin/authsession
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/authsession
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
