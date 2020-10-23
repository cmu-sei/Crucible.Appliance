#!/usr/local/env sh
# Set Environment variables from file 
DEPLOY=${DEPLOY:-/deploy}
VARS_PATH=${VARS_PATH:-env}
export $(cat "${DEPLOY}/${VARS_PATH}" | grep '^[A-Z]')