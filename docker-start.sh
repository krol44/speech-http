#!/bin/bash
# --platform linux/amd64
docker build . -t speech-http-image
docker rm -f speech-http
docker run -d --restart=always -p 8048:8048 --log-opt max-size=50m --name=speech-http speech-http-image

docker image prune -f