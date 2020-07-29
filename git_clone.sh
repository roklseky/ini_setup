#!/bin/bash
# git clone https://github.com/roklseky/ini_setup.git

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

echo "$(tput setaf 1)$(tput setab 7)\
"Add pub key to github "->" https://github.com/settings/keys for SSH git clone. \
Press [ENTER] when done"$(tput sgr 0)"
read continue
echo yes

#echo Host github > $PTH/.ssh/config
#echo HostName github.com >> $PTH/.ssh/config
#echo IdentityFile $PTH/.ssh/id_$HST >> $PTH/.ssh/config
#echo IdentitiesOnly yes >> $PTH/.ssh/config

#echo Host wdmycloud >> $PTH/.ssh/config
#echo HostName 10.0.0.122 >> $PTH/.ssh/config
#echo IdentityFile $PTH/.ssh/id_$HST >> $PTH/.ssh/config
#echo IdentitiesOnly yes >> $PTH/.ssh/config

#git clone git@github.com:roklseky/dockerfile.git
eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST; 
git clone git@github.com:roklseky/dockerfile.git

PTH=`eval echo ~$USER`
mv dockerfile/`hostname` $PTH/docker
rm -rf dockerfile

sh $PTH/docker/ini_install.sh
