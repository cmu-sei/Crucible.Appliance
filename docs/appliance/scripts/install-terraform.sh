#!/bin/bash
#
# terraform install
#
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="/deploy"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
proxy=${1:-http://proxy.sei.cmu.edu:8080}
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

proxy=$1
noproxy=${2:-localhost,.local}
if ping -c 1 -W 1 "$proxy_hostname"; then
  echo "PROXY Available"
  export http_proxy="$proxy"
  export https_proxy="$proxy"
  export no_proxy="$noproxy"
  export HTTP_PROXY="$proxy"
  export HTTPS_PROXY="$proxy"
  export NO_PROXY="$noproxy"
fi

# install terraform
IFS=','; for v in ${TERRAFORM_VERSIONS[@]} ; do
  echo $v
  if [[ ! -d ${NFS_BASE_PATH}terraform/${v} ]] || [[ ! -f ${NFS_BASE_PATH}terraform/${v}/terraform ]]; then
    wget https://releases.hashicorp.com/terraform/${v}/terraform_${v}_linux_amd64.zip -O /tmp/terraform_${v}.zip
    unzip -o /tmp/terraform_${v}.zip -d ${NFS_BASE_PATH}terraform/${v}/
    chmod -R +x ${NFS_BASE_PATH}terraform/${v}/
  fi
done



