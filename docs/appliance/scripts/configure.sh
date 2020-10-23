#!/usr/bin/env bash
# Must be run as sudo
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
PROXY=${1:-http://proxy.sei.cmu.edu:8080}

# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

# Update Code (Dev)
echo "Appliance Mode set to ${APPLIANCE_DEV}"
if [[ ${APPLIANCE_DEV} == "true" && -d /home/crucible/crucible-deploy ]]; then
  echo "Appliance in DEV MODE copying files..."
  cp -r "/home/crucible/crucible-deploy/." "${DEPLOY}"
  source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh
fi

# Set the proxy 
source ${DEPLOY}/${SCRIPTS_PATH}/set-proxy.sh "$PROXY" "*.cmu.edu,*.cert.org,*.cwd.local,*.cyberforce.site"
# Replace Creds
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh administrator@this.ws "admin@${DOMAIN}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh ChangeMe321! "${ADMIN_PASS}"
# Replace domain
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh dev.anvil.cert.org "${DOMAIN}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh staging.anvil.cert.org "${DOMAIN}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh anvil.cert.org "${DOMAIN}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh foundry.local "${DOMAIN}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh this.ws "${DOMAIN}"

# Replace Domain Reconfigure
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh crucible.local "${DOMAIN}"

if [[ ${ENABLE_SSL} == "false" ]]; then 
  source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh "https:\/\/" "http:\/\/"
fi
# Load local gzip images 
# source ${DEPLOY}/${SCRIPTS_PATH}/save-load-docker-images.sh load -z -d "${DEPLOY}/${CONTAINER_PATH}"
# Ensure nfs 
source ${DEPLOY}/${SCRIPTS_PATH}/nfs.sh
# Configure swarm
source "${DEPLOY}/${SCRIPTS_PATH}/swarm-config.sh"
# Download vcenter certs
source ${DEPLOY}/${SCRIPTS_PATH}/vcenter-certs.sh
# Install terraform
${DEPLOY}/${SCRIPTS_PATH}/install-terraform.sh
# setup ssl
source ${DEPLOY}/docs/appliance/cfssl/setup.sh ${DOMAIN}

docker secret create anvil-ca "${NFS_BASE_PATH}certificates/sei-ca/appliance-ca.crt"
docker secret create anvil-private-key "${NFS_BASE_PATH}certificates/cfssl/output/appliance-key.pem"
docker secret create anvil-certificate "${NFS_BASE_PATH}certificates/cfssl/output/appliance.pem"
echo "Attempting to get vsphere cluster"
MOID=$(pwsh -c 'Connect-VIServer -server $env:VSPHERE_SERVER -user $env:VSPHERE_USER -password $env:VSPHERE_PASSWORD | Out-Null; Get-Cluster -Name $env:VSPHERE_CLUSTER | select id | %{$arr = $_.id.split("-"); write-host ($arr[1..($arr.length)] -join "-")}')
echo "${MOID}"
if [[ -n ${MOID} ]]; then
  sed -i "s/STEAM_CLUSTER_MOID=.*/STEAM_CLUSTER_MOID=${MOID}/" "${DEPLOY}/${VARS_PATH}"
  echo "vsphere cluster set"
fi
printf "$ADMIN_PASS" | docker secret create portainer-admin-pass -
printf "$ADMIN_PASS" | docker secret create gitlab_root_password -
son utilities
sleep 20
#source ${DEPLOY}/${SCRIPTS_PATH}/crucible-seed.sh

# Deploy
son

# Add hosts entry to the appliance. neccessary for configuring seed data. 
source ${DEPLOY}/${SCRIPTS_PATH}/generate-hosts.sh

source ${DEPLOY}/${SCRIPTS_PATH}/gitlab-seed.sh

# Serve certificate
source ${DEPLOY}/${SCRIPTS_PATH}/simple-http-server.sh





