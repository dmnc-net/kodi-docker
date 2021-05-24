# kodi-docker
> Kodi running in docker container thru the existing X11 session.

#### Why?
Because after some Arch Linux updates (i.e. Python v3.9, ICU i18n v69) I finally realized that rolling-update distros are not good for Kodi. 

#### Usage - building from [github](https://github.com/dmnc-net/kodi-docker)
```Shell
./build.sh ubuntu
```
```Shell
./run.sh ubuntu
```
#### Usage - running from [dockerhub](https://hub.docker.com/r/dmnc/kodi)
Create kodi-docker.sh (or /usr/bin/kodi)
```Shell
#!/bin/sh
xhost +local:docker > /dev/null
mkdir -p $HOME/.kodi/temp $HOME/.kodi/userdata
touch $HOME/.kodi/temp/kodi.log
if [ "$1" == "" ]; then TAG="ubuntu"; else TAG="$1"; fi
IMAGE="dmnc/kodi:$TAG"
NAME="Kodi-$TAG-dockerhub"
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
```

#### Underlaying distros
 - Ubuntu - officialy supported by Kodi team
 - Alpine Linux - experimental, little bit lighter, but doesn't support Widevine
