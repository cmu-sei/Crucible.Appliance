#!/usr/bin/env bash
# Must be run as sudo
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="/deploy"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
SON=/usr/local/bin/son
SOFF=/usr/local/bin/soff
proxy=${1:-http://proxy.sei.cmu.edu:8080}
mkdir -pv "${DEPLOY}"
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh
# Update Code (Dev)
echo "Appliance Mode set to ${APPLIANCE_DEV}"
if [[ ${APPLIANCE_DEV} == "true" && -d /home/crucible/crucible-deploy ]]; then
  echo "Appliance in DEV MODE copying files..."
  cp -r "/home/crucible/crucible-deploy/." "${DEPLOY}["
fi
cd "${DEPLOY}"
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh
# Set the proxy 
source ${DEPLOY}/${SCRIPTS_PATH}/set-proxy.sh "$proxy" "*.cmu.edu,*.cert.org,*.cwd.local,*.cyberforce.site"
# Configure nfs server
source ${DEPLOY}/${SCRIPTS_PATH}/nfs.sh
# Install docker
source ${DEPLOY}/${SCRIPTS_PATH}/install-packages.sh "$proxy" "*.cmu.edu,*.cert.org,*.cwd.local,*.cyberforce.site"
# Pull Images
source ${DEPLOY}/${SCRIPTS_PATH}/pull-images.sh
# Load local gzip images 
source ${DEPLOY}/${SCRIPTS_PATH}/save-load-docker-images.sh load -z -d "${DEPLOY}/${CONTAINER_PATH}"
# Replace Domain in config files with crucible.local
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh dev.anvil.cert.org ${DOMAIN}
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh staging.anvil.cert.org ${DOMAIN}
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh anvil.cert.org ${DOMAIN}
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh foundry.local ${DOMAIN}
# Change perminssions for deploy folder
chmod -R a+rw ${DEPLOY}
# Ensure scripts are exacutable
chmod -R +x "${DEPLOY}/${SCRIPTS_PATH}"
# Move son and soff to path 
cp -f ${DEPLOY}/${SCRIPTS_PATH}/son.sh ${SON}
cp -f ${DEPLOY}/${SCRIPTS_PATH}/soff.sh ${SOFF}
chmod -R +x /usr/local/bin/
# Init swarm
source ${DEPLOY}/${SCRIPTS_PATH}/swarm-config.sh
# Enable appliance as a service (future development)
# source ${DEPLOY}/${SCRIPTS_PATH}/enable-appliance.sh



