#!/bin/bash
# git clone https://github.com/roklseky/ini_setup.git
# cd ini_setup
# sh ini.sh

VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if [ $VENDOR -eq GenuineIntel ]
then
su root
sudo usermod -aG sudo "$(whoami)"

#prepare to continue after reboot
PTH=`eval echo ~$USER`

echo #!/bin/bash >$PTH/nuc.sh
echo PTH=`eval echo ~$USER` >>$PTH/nuc.sh
echo HST=`hostname` >>$PTH/nuc.sh
echo ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST >>$PTH/nuc.sh
echo cat $PTH/.ssh/id_$HST.pub >>$PTH/nuc.sh

echo read -p "Add pub to github https://github.com/settings/keys for SSH git clone" >>$PTH/nuc.sh

echo eval $(ssh-agent) >>$PTH/nuc.sh
echo ssh-add $PTH/.ssh/id_$HST >>$PTH/nuc.sh
echo git clone git@github.com:roklseky/dockerfile.git >>$PTH/nuc.sh
echo mv dockerfile/`hostname` docker >>$PTH/nuc.sh
echo rm -rf dockerfile >>$PTH/nuc.sh
echo docker/ini_install.sh >>$PTH/nuc.sh

# add to cron to resume after reboot
sudo systemctl enable cron.service
sudo systemctl start cron.service

crontab -l | { cat; echo "@reboot $PTH/nuc.sh"; } | crontab -

sudo reboot

fi

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


