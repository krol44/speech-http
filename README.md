# speech-http - RHVoice 1.6.0 with http api

docker run -d --restart=always -p 8048:8048 --log-opt max-size=50m --name=speech-http krol44/speech-http

**curl -v http://127.0.0.1:8048/slt/test**
```
slt - voice
test - text for speech
output - base64
```

https://hub.docker.com/r/krol44/speech-http
