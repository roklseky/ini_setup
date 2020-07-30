#!/bin/bash
# git clone https://github.com/roklseky/ini_setup.git
# run as root (su root)

VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if [ "$VENDOR" = "GenuineIntel" ] 
then
DVC=NUC
PTH=`eval echo ~$USER`
USR=$( echo ${PTH##/*/} )
sudo usermod -aG sudo $USR
else
DVC=pi
PTH=`eval echo ~$USER`
mkdir $PTH/.ssh
USR=$( echo ${PTH##/*/} )
fi

# Generate SSH keys
HST=`hostname`
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
chown -R $USR:$USR $PTH/.ssh
cat $PTH/.ssh/id_$HST.pub

# Add pub key to git
echo "$(tput setaf 1)$(tput setab 7)\
"Add pub key to github "->" https://github.com/settings/keys for SSH git clone. \
Press [ENTER] when done"$(tput sgr 0)"
read continue

# Clone personal git repo
eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST; 
git clone git@github.com:roklseky/dockerfile.git

#Discover if pi of NUC
VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if [ "$VENDOR" = "GenuineIntel" ] 
then
DVC=NUC
else
DVC=pi
fi

if [ "$DVC" = "NUC" ] 
then
mv dockerfile/ini_install_NUC.sh $PTH/ini_install_NUC.sh

echo "$(tput setaf 1)$(tput setab 7)\
"It is NUC "->" going to execute "sh $PTH/ini_install_NUC.sh" \
Press [ENTER] to continue"$(tput sgr 0)"
read continue
sh $PTH/ini_install_NUC.sh

else
mv dockerfile/ini_install_pi.sh $PTH/ini_install_pi.sh
mv dockerfile/ini_reboot_install_pi.sh $PTH/ini_reboot_install_pi.sh
mv dockerfile/pisn.txt $PTH/pisn.txt

echo "$(tput setaf 1)$(tput setab 7)\
"It is pi "->" going to execute "sh $PTH/ini_install_pi.sh" \
Press [ENTER] to continue"$(tput sgr 0)"
read continue
sh $PTH/ini_install_pi.sh
fi
