#!/usr/bin/env bash

# Force sudo, shouldn't be needed in docker containers. But keeping as a failsafe. 
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }

ID_SEED_CLIENT=${ID_CLIENT-'bash-client'}
ID_SEED_SECRET=${ID_SECRET-'304591078a3949fbae82cfd3306694da'}
ID_RESEED=${ID_RESEED-true}
ID_SEED_CONF=${ID_SEED_CONF-'{
  "name": "player-api",
  "displayName": "Player API",
  "description": "Player API (Self Provisioned)",
  "grants": "implicit",
  "requireConsent": true,
  "published": true,
  "scopes": "player-api",
  "url": "http://localhost:4300",
  "redirectUrls": [
    "http://localhost:4300/auth-callback",
    "http://localhost:4300/auth-callback-silent"
  ],
  "postLogoutUrls":
  [
    "http://localhost:4300"
  ]
}'}
RESOURCE_TEMPLATE='
  {
  "type": "api",
  "name": "string",
  "displayName": "string",
  "description": "string",
  "enabled": true,
  "default": false,
  "required": false,
  "emphasize": false,
  "showInDiscoveryDocument": true
}
'
DOMAIN=${DOMAIN-'crucible.io'}
CLIENT_NAME=${CLIENT_NAME-'player-api'}

if [[ -z ${ID_SEED_SECRET} || -z ${ID_SEED_CLIENT} || -z ${DOMAIN} ]]; then 
  echo "Identity Environment variables not supplied skipping identity client registration"
  exit 0
else
  # Check for jq 
  JQ=$(which jq)
  if [[ -z ${JQ} ]]; then
    # Check distro
    if [[ -f /etc/os-release ]]; then
      . /etc/os-release
      DISTRO=$ID
      # Install from distro package manager
      case ${DISTRO,,} in
        ubuntu | debian)
        echo "installing jq for ${DISTRO}"
        apt update && apt install jq -y
        ;;
        alpine)
        echo "installing jq for ${DISTRO}"
        apk add jq
        ;;
        centos)
        echo "installing jq for ${DISTRO}"
        yum install jq -y
        ;;
      esac
    else
      echo "'jq' not found and OS detection failed, jq is required for this script to run."
      exit 0
    fi
  else 
    echo "'jq' exists skipping installation"
  fi
  
  # Make sure IDENTITY or DOMAIN is set. 
  if [[ -z ${ID_SERVER} && -z "${DOMAIN}" ]]; then
    echo 'Environment variables: ID_SERVER or DOMAIN must be set. Exiting...'
    exit 0;
  else
    ID_SERVER="${ID_SERVER-id.${DOMAIN}}"
  fi
  # get the spec for templateing new resources
  SPEC=$(curl -k https://${ID_SERVER}/api/v1/openapi.json | jq '.')
  echo "${SPEC}"
  # Get an access token
  REQ=$(curl -ks --location --request POST "${ID_SERVER}/connect/token" \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=client_credentials' \
  --data-urlencode "client_id=${ID_SEED_CLIENT}" \
  --data-urlencode "client_secret=${ID_SEED_SECRET}" \
  --data-urlencode 'scope=identity-api identity-api-privileged')

  ACCESS_TOKEN=$(echo "${REQ}" | jq -j ".access_token")

  if [[ -z ${ACCESS_TOKEN} ]]; then 
    echo "Failed to get access token is ${ID_SERVER} correct?"
    echo "${REQ}"
    exit 0
  fi

  # Set Common Headers
  H_AUTH="Authorization: Bearer ${ACCESS_TOKEN}"
  H_JSON="Content-Type: application/json"
  
  # Check if the client already exists
  NAME=$(echo "${ID_SEED_CONF}" | jq -j '.name')
  REQ=$(curl -ks --location --request GET "${ID_SERVER}/api/clients?term=${NAME}" \
  --header "${H_JSON}" \
  --header "${H_AUTH}")
  
  echo "${REQ}"
  # term filter returns multiple similar clients get the exect client.
  CLIENT=$(echo "${REQ}" | jq --arg name "${NAME}" '.[] | select(.name==$name)')
  
  echo "${CLIENT}"
  
  if [ -n "${CLIENT}" ] && "${ID_RESEED}"; then
    ID=$(echo "${CLIENT}" | jq -j '.id')
    # Reconfigure the client
    echo "CLIENT EXISTS GETTING FULL CLIENT SPEC"
    REQ=$(curl -ks --location --request GET "${ID_SERVER}/api/client/${ID}" \
    --header "${H_JSON}" \
    --header "${H_AUTH}")
    echo "${REQ}"
    
    : '
    Array values need special handling, the API expects:
    redirectUrls: [
      {"value": "string"},
      {"value": "string"}
    ]
    but we want the configuration to be simple
    redirectUrls: [
      "string",
      "string"
    ]
    '
    echo "DEBUG: ARRAYS"

    # TODO: Find a way to make this more dynamic. We want to find all array properties in the config, 
    #       not just hardcoded ones. 
    # Transform 'redirectUrls'
    RU=$(echo "${ID_SEED_CONF}" | jq '{"redirectUrls": .redirectUrls | map(. | {"value": .})}')
    # Transform 'postLogoutUrls'
    PLU=$(echo "${ID_SEED_CONF}" | jq '{"postLogoutUrls": .postLogoutUrls | map(. | {"value": .})}')
    
    echo "DEBUG: OBJECTS"
    echo $(echo "${ID_SEED_CONF}" | jq '[.redirectUrls[] | {"value": .}]')



    # Merge client json with seed configuration
    DATA_JSON=$(
      echo "${REQ} ${ID_SEED_CONF} ${RU} ${PLU}" | jq -s add 
    )

    echo "${DATA_JSON}"
    # Update the client
    REQ=$(curl -ks --location --request PUT "${ID_SERVER}/api/client" \
    --header "${H_JSON}" \
    --header "${H_AUTH}" \
    --data-raw "${DATA_JSON}")

    echo "${REQ}"

  elif [[ -z "${CLIENT}" ]]; then
    echo "CREATING NEW CLIENT"
    # JSON for initial client
    DATA_JSON=$(
        jq -n \
        --argjson conf "${ID_SEED_CONF}" \
        '{
          "name":$conf.name, 
          "displayName":$conf.displayName, 
          "description": $conf.description
        }'
      )
    
    echo "$DATA_JSON"
    
    echo "Configuring the identity client with ${H_AUTH}"
    # Create the client
    REQ=$(curl -k --location --request POST "${ID_SERVER}/api/client" \
    --header "${H_JSON}" \
    --header "${H_AUTH}" \
    --data-raw "${DATA_JSON}")

    ID=$(echo "$REQ" | jq '.id')
    
    # Get the newly created client by id, needed for the structure of the client json and sane defaults. 
    REQ=$(curl -ks --location --request GET "${ID_SERVER}/api/client/${ID}" \
    --header "${H_JSON}" \
    --header "${H_AUTH}")
    
    echo "${REQ}"

    # Merge client json with seed configuration
    DATA_JSON=$(
      echo "${REQ} ${ID_SEED_CONF}" | jq -s add 
    )

    echo "${DATA_JSON}"
    # Update the client
    REQ=$(curl -ks --location --request PUT "${ID_SERVER}/api/client" \
    --header "${H_JSON}" \
    --header "${H_AUTH}" \
    --data-raw "${DATA_JSON}")

    echo "${REQ}"
  else
    echo "Client exist and not set to reconfigure. Exiting"
    exit 0;
  fi
fi