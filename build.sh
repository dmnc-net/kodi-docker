#!/bin/sh
KODI_DATA="kodi-data"
if [ "$1" == "" ]; then echo "* usage: $0 tag";false;exit;fi
docker build --rm --build-arg UID=$UID -f Dockerfile.$1 -t kodi:$1 .
if [ "$2" == "purge" ]; then docker volume rm $KODI_DATA;fi
