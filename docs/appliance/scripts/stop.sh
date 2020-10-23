#!/bin/bash
DEPLOY="/deploy"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

docker stack rm appliance_stack
docker stack rm traefik_stack
docker secret rm anvil-private-key
docker secret rm anvil-certificate

