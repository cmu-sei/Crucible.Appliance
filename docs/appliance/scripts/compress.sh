#!/usr/bin/env bash
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
PROXY=${1:-http://proxy.sei.cmu.edu:8080}

tar --exclude=*/**/containers \
--exclude=*/**/node_modules \
--exclude=*/**/.git \
-C /home/crucible/crucible-deploy/ -czvf crucible-deploy-0.0.3.tar.gz .
rm -rf /home/crucible/crucible-deplo1y