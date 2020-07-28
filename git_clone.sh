#!/bin/bash

VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if [ "$VENDOR" = "GenuineIntel" ]

then
read -p "Add yourself to SUDO sudo usermod -aG sudo '$(whoami)'" < /dev/tty
fi

PTH=`eval echo ~$USER`
HST=`hostname`
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
cat $PTH/.ssh/id_$HST.pub

read -p "Add pub to github https://github.com/settings/keys for SSH git clone" < /dev/tty

eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST
git clone git@github.com:roklseky/dockerfile.git
mv dockerfile/`hostname` $PTH/docker
rm -rf dockerfile


sh $PTH/docker/ini_install.sh