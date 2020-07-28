#!/bin/bash

PTH=`eval echo ~$USER`
HST=`hostname`
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
cat $PTH/.ssh/id_$HST.pub

read -p "Add pub to github https://github.com/settings/keys for SSH git clone"

eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST
git clone git@github.com:roklseky/dockerfile.git
mv dockerfile/`hostname` docker
rm -rf dockerfile
docker/ini_install.sh