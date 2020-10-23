#!/usr/bin/env bash
# Must be run as sudo
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="/deploy"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh


# setup ssl
source ${DEPLOY}/docs/appliance/cfssl/setup.sh ${DOMAIN}
# Configure swarm
source "${DEPLOY}/${SCRIPTS_PATH}/swarm-config.sh"

printf "$ADMIN_PASS" | docker secret create portainer-admin-pass -
printf "$ADMIN_PASS" | docker secret create gitlab_root_password -
docker secret create anvil-private-key "${NFS_BASE_PATH}certificates/cfssl/output/appliance-key.pem"
docker secret create anvil-certificate "${NFS_BASE_PATH}certificates/cfssl/output/appliance.pem"

if [[ ${ENABLE_SSL} == "true" ]]; then 
  docker stack deploy -c "${DEPLOY}/traefik/traefik-stack-ssl.yml" -c "${DEPLOY}/${COMPOSE_PATH}/traefik/traefik.yml" traefik_stack
else
  docker stack deploy -c "${DEPLOY}/traefik/traefik-stack.yml" -c "${DEPLOY}/${COMPOSE_PATH}/traefik/traefik.yml" traefik_stack
fi
docker stack deploy -c "${DEPLOY}/${COMPOSE_PATH}/appliance/appliance-stack.yml" appliance_stack

