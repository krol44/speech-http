FROM golang:1.17-buster as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o speech-http .

FROM debian:buster-slim

RUN apt-get -y update && apt-get -y install build-essential pkg-config wget scons libao4 libao-dev python-lxml lame \
	&& cd /root && wget -nv --show-progress --progress=bar:force:noscroll https://github.com/Olga-Yakovleva/RHVoice/archive/1.2.2.tar.gz \
	&& tar xzvf 1.2.2.tar.gz && cd RHVoice-1.2.2 \
	&& scons -j8 --config=force && scons install && ldconfig \
	&& apt-get purge -y build-essential pkg-config wget scons python-lxml \
	&& apt-get autoremove -y && apt-get clean all \
	&& rm -r /root/*

COPY ./speech.sh .

COPY --from=builder /app/speech-http .
EXPOSE 8048

CMD ["./speech-http"]