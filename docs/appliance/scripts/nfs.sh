#!/usr/bin/env bash
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}

# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh
pwd=$(pwd)
apt install nfs-kernel-server nfs-common -y
# Initial appliance config
if [[ ! -d ${NFS_BASE_PATH} ]]; then
  mkdir -p "${NFS_BASE_PATH}"
  cd "${NFS_BASE_PATH}"
  grep -qxF "${NFS_BASE_PATH} *(rw,async,no_root_squash)" /etc/exports || echo "${NFS_BASE_PATH} *(rw,async,no_root_squash)" >> /etc/exports
  exportfs -af
# Reconfigure within appliance
fi
cd "${NFS_BASE_PATH}"
mkdir -p javatar \
certificates/sei-ca \
certificates/vcenter/lin \
terraform \
stackstorm \
stackstorm/packs \
stackstorm/virtualenvs \
stackstorm/configs \
stackstorm/logs \
osticket \
postgres-data \
mariadb-data \
gitlab/data \
gitlab/logs \
gitlab/config \
elasticsearch \
identity-data \
portainer \
iso/player

cd $pwd
echo "returning to $pwd"


