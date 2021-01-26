#!/usr/bin/env bash
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

# Array of all available stacks
all_stacks=('alloy' 'caster' 'identity' 'player' 'steamfitter' 'traefik' 'utilities' 'logging' 'vm')

# Set the stacks
if [[ $# -gt 0 ]]; then
  STACKS=$@
else
  STACKS=${all_stacks[@]}
fi

for s in ${STACKS[@]}; do
  # Remove Stack
  echo "Removing ${s}_stack"
  docker stack rm "${s}_stack"
done
