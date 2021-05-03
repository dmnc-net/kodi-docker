#!/bin/sh
xhost +local:docker > /dev/null
mkdir -p $HOME/.kodi/temp $HOME/.kodi/userdata
touch $HOME/.kodi/temp/kodi.log

TAG=$1
IMAGE="kodi:$TAG"
NAME="Kodi-$TAG"
KODI_DATA="kodi-data"
CT="--rm"
NETWORK="--network host"
TZ=$(timedatectl|grep zone|awk '{print $3}')
X11="-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY"
PULSE="-v /run/user/$UID/pulse:/run/user/$UID/pulse -e PULSE_SERVER=unix:/run/user/$UID/pulse/native"
DEV="--device /dev/dri --device /dev/snd"
DBUS="-v /run/dbus:/run/dbus -v /var/lib/dbus/machine-id:/var/lib/dbus/machine-id"
V_HOMEFOLDER="-v $HOME:/home/kodi"
V_KODI="-v $KODI_DATA:/home/kodi/.kodi"
V_USERDATA="-v $HOME/.kodi/userdata:/home/kodi/.kodi/userdata"
V_KODILOG="-v $HOME/.kodi/temp/kodi.log:/home/kodi/.kodi/temp/kodi.log"
docker volume inspect $KODI_DATA >/dev/null 2>&1 || docker volume create $KODI_DATA
docker run -ti $CT $NETWORK --name $NAME -e TZ=$TZ $DEV $PULSE $DBUS $X11 $V_HOMEFOLDER $V_KODI $V_USERDATA $V_KODILOG $IMAGE
