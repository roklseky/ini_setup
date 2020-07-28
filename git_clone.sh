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
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
chown -R $USR:$USR $PTH/.ssh
cat $PTH/.ssh/id_$HST.pub

echo "Add pub to github https://github.com/settings/keys for SSH git clone. Press [ENTER] when done"
read continue

echo HostName github.com > $PTH/.ssh/config
echo HostName 10.0.0.222 >> $PTH/.ssh/config
echo IdentityFile $PTH/.ssh/id_$HST >> $PTH/.ssh/config
git clone git@github.com:roklseky/dockerfile.git
mv dockerfile/`hostname` $PTH/docker
rm -rf dockerfile

sh $PTH/docker/ini_install.sh
