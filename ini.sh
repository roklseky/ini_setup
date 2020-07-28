#!/bin/bash
# git clone https://github.com/roklseky/ini_setup.git
# cd ini_setup
# sh ini.sh

VENDOR=$(lscpu | grep 'Vendor ID' | awk '{print $3}')
if [ "$VENDOR" = "GenuineIntel" ]

then
read -p "Add yourself to SUDO -> sudo usermod -aG sudo "$(whoami)""

read -p "Crontab config"
# add to cron to resume after reboot
sudo systemctl enable cron.service
sudo systemctl start cron.service

crontab -l | { cat; echo "@reboot $PTH/ini_setup/git_clone.sh"; } | crontab -

read -p "Server will be rebooted"
sudo reboot
fi

git_clone.sh


