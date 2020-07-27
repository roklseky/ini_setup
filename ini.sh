#!/bin/bash

su root
sudo usermod -aG sudo "$(whoami)"
sudo reboot

PTH=`eval echo ~$USER`
HST=`hostname`
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
cat $PTH/.ssh/id_$HST.pub

read -p "add pub to github https://github.com/settings/keys"

eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST
git clone git@github.com:roklseky/dockerfile.git
cd dockerfile/`hostname`

if false; then

fi
