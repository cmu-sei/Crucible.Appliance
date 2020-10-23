#!/usr/bin/env bash
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

echo "Downloading certs from ${VSPHERE_SERVER}"

wget --no-check-certificate https://${VSPHERE_SERVER}/certs/download.zip -O /tmp/vcenter-certs.zip
unzip -o /tmp/vcenter-certs -d /tmp

if [[ -d ${NFS_BASE_PATH}certificates/vcenter ]]; then
  cp -r /tmp/certs/. ${NFS_BASE_PATH}certificates/vcenter
  cp -r /tmp/certs/lin/. ${NFS_BASE_PATH}certificates/sei-ca/
  rename 's/.0/.crt/' ${NFS_BASE_PATH}certificates/sei-ca/*.0
  rename 's/.r0/.r0.crt/' ${NFS_BASE_PATH}certificates/sei-ca/*.r0
  cp -r ${NFS_BASE_PATH}certificates/sei-ca/. /usr/local/share/ca-certificates
  update-ca-certificates
elif [[ -d /app/certs/vcenter ]]; then 
  cp -R /tmp/certs/. /app/certs/vcenter
else
  echo "Can't place vSphere Certificates"
fi