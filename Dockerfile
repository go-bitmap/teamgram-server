FROM ubuntu:latest
RUN apt update -y && apt install -y ffmpeg && apt-get clean
WORKDIR /app
COPY ./teamgramd/ /app/
RUN chmod +x /app/docker/entrypoint.sh
ENTRYPOINT /app/docker/entrypoint.sh
