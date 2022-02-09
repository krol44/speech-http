#!/bin/bash
TMP=$(mktemp /tmp/speech.XXXXXXXXX)
echo "$2" | RHVoice-test --volume 100 -p $1 -o $TMP > /dev/null 2>&1
lame -b 64 --cbr -m j -h --quiet $TMP $TMP.mp3
cat $TMP.mp3 | base64 -w 0
rm $TMP*