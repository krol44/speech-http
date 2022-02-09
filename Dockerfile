FROM golang:1.17-buster as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o speech-http .

FROM debian:buster-slim

RUN apt-get -y update && apt-get -y install build-essential pkg-config wget scons libspeechd-dev speech-dispatcher python-lxml git lame \
	&& cd /root && git clone --recursive https://github.com/RHVoice/RHVoice.git && cd RHVoice \
    && echo "quality=max" >> config/RHVoice.conf \
	&& scons -j8 --config=force && scons install && ldconfig \
	&& apt-get purge -y build-essential pkg-config wget scons python-lxml libspeechd-dev speech-dispatcher git \
	&& apt-get autoremove -y && apt-get clean all \
	&& rm -r /root/*

COPY ./speech.sh .

COPY --from=builder /app/speech-http .
EXPOSE 8048

CMD ["./speech-http"]