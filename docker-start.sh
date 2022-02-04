#!/bin/bash
docker build . -t speech-http-c
docker rm -f speech-http
docker run -d --restart=always -p 127.0.0.1:8048:8048 --log-opt max-size=50m --name=speech-http speech-http-c

docker image prune -f