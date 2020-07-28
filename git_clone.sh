#!/bin/bash

VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if [ "$VENDOR" = "GenuineIntel" ] 
then
PTH=`eval echo ~$USER`
USR=$( echo ${PTH##/*/} )
sudo usermod -aG sudo $USR
fi

PTH=`eval echo ~$USER`
HST=`hostname`
mkdir $PTH/.ssh
USR=$( echo ${PTH##/*/} )
chown $USR:$USR $PTH/.ssh
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
cat $PTH/.ssh/id_$HST.pub

echo "Add pub to github https://github.com/settings/keys for SSH git clone. Press [ENTER] when done"
read continue

eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST
git clone git@github.com:roklseky/dockerfile.git
mv dockerfile/`hostname` $PTH/docker
rm -rf dockerfile

sh $PTH/docker/ini_install.sh
