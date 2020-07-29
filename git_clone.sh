#!/bin/bash
# git clone https://github.com/roklseky/ini_setup.git

VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if [ "$VENDOR" = "GenuineIntel" ] 
then
DVC=NUC
PTH=`eval echo ~$USER`
USR=$( echo ${PTH##/*/} )
sudo usermod -aG sudo $USR
fi
DVC=pi
PTH=`eval echo ~$USER`
HST=`hostname`
mkdir $PTH/.ssh
USR=$( echo ${PTH##/*/} )

# Generate SSH keys
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
chown -R $USR:$USR $PTH/.ssh
cat $PTH/.ssh/id_$HST.pub

# Add pub key to git
echo "$(tput setaf 1)$(tput setab 7)\
"Add pub key to github "->" https://github.com/settings/keys for SSH git clone. \
Press [ENTER] when done"$(tput sgr 0)"
read continue
echo yes

# Clone personal git repo
eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST; 
git clone git@github.com:roklseky/dockerfile.git

#Discover if pi of NUC
mv $PTH/dockerfile/ini_install_NUC.sh $PTH/ini_install_NUC.sh
mv $PTH/dockerfile/ini_install_pi.sh $PTH/ini_install_pi.sh
mv $PTH/dockerfile/ini_reboot_install_pi.sh $PTH/dockerfile/ini_reboot_install_pi.sh
mv $PTH/dockerfile/pisn.txt $PTH/pisn.txt
if [ "$DVC" = "NUC" ] 
then
sh $PTH/ini_install_NUC.sh
else
sh $PTH/ini_install_pi.sh
fi
