#!/usr/bin/env bash
# Must be run as sudo
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
SEED_PATH="docs/appliance/seed"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
EXPORTS_PATH="docs/appliance/exports/dbs"

# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh
# soff databases to import 
soff caster player alloy steamfitter vm
echo "Waiting 20 seconds for applications to shutdown"
sleep 20
# Replace domain
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh dev.anvil.cert.org "${DOMAIN}" "${DEPLOY}/${EXPORTS_PATH}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh staging.anvil.cert.org "${DOMAIN}" "${DEPLOY}/${EXPORTS_PATH}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh anvil.cert.org "${DOMAIN}" "${DEPLOY}/${EXPORTS_PATH}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh foundry.local "${DOMAIN}" "${DEPLOY}/${EXPORTS_PATH}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh this.ws "${DOMAIN}" "${DEPLOY}/${EXPORTS_PATH}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh crucible.ws "${DOMAIN}" "${DEPLOY}/${EXPORTS_PATH}"
source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh crucible.io "${DOMAIN}" "${DEPLOY}/${EXPORTS_PATH}"
FILES=$(find ${DEPLOY}/${EXPORTS_PATH} -type f -iname "*.sql" | sed "s/.*\///; s/\.sql//")
for file in $FILES; do
  PGPASSWORD=postgres dropdb -h localhost -U postgres ${file}
  PGPASSWORD=postgres createdb -h localhost -U postgres -T template0 ${file}
  PGPASSWORD=postgres psql -h localhost -U postgres < ${DEPLOY}/${EXPORTS_PATH}/${file}.sql
done

son caster player alloy steamfitter vm