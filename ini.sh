#!/bin/bash
# git clone https://github.com/roklseky/ini_setup.git
# cd ini_setup
# sh ini.sh

VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if $VENDOR=GenuineIntel

su root
sudo usermod -aG sudo "$(whoami)"

#prepare to continue after reboot
echo #!/bin/bash >nuc.sh
echo PTH=`eval echo ~$USER` >>nuc.sh
echo HST=`hostname` >>nuc.sh
echo ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST >>nuc.sh
echo cat $PTH/.ssh/id_$HST.pub >>nuc.sh

echo read -p "Add pub to github https://github.com/settings/keys for SSH git clone" >>nuc.sh

echo eval $(ssh-agent) >>nuc.sh
echo ssh-add $PTH/.ssh/id_$HST >>nuc.sh
echo git clone git@github.com:roklseky/dockerfile.git >>nuc.sh
echo mv dockerfile/`hostname` docker >>nuc.sh
echo rm -rf dockerfile >>nuc.sh
echo docker/ini_install.sh

# add to cron to resume after reboot
sudo systemctl enable cron.service
sudo systemctl start cron.service

PTH=`eval echo ~$USER`
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


