#!/bin/bash
# Must be run as sudo
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
# Remove stacks except the appliance
soff
# Remove Secrets
docker secret rm $(docker secret ls -q)
docker config rm $(docker config ls -q)
echo "Sleeping for 20 seconds to wait for volumes and networks"
sleep 20
docker volume rm $(docker volume ls -q)
docker network rm traefik-net
docker network rm utilities

# clear data
rm -rf /mnt/data/*
rm -rf /tmp/*

sudo rm -rf /deploy && sudo mkdir /deploy && sudo cp -r /home/crucible/crucible-deploy/. /deploy
echo "Rebooting in 10 seconds"
sleep 10
shutdown -r now 
echo "Appliance has been reset, Please Reconfigure"
