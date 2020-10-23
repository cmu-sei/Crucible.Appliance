#!/usr/bin/env bash
# Must be run as sudo
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
EXPORTS_PATH="docs/appliance/exports/gitlab"
TIMEOUT=0
MAX_TIMEOUT=300
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

# Update Code (Dev)
echo "Appliance Mode set to ${APPLIANCE_DEV}"
if [[ ${APPLIANCE_DEV} == "true" && -d /home/crucible/crucible-deploy ]]; then
  echo "Appliance in DEV MODE copying environment file"
  cp -r "/home/crucible/crucible-deploy/${VARS_PATH}" "${DEPLOY}/${VARS_PATH}"
  # Apply variables again.
  source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh
fi

# set gitlab variables.
gitlab_host="https://gitlab.${DOMAIN}"
gitlab_user="root"
gitlab_password="${ADMIN_PASS}"
api_url="$gitlab_host/api/v4"

# Wait for gitllab to come up 
cat << EOF 

  Waiting for gitlab to become available, this may take a while...
  
  Timeout set to ${MAX_TIMEOUT} seconds
EOF

until $(curl --output /dev/null --silent --head --insecure --fail ${gitlab_host}/users/sign_in); do
  printf '.'
  sleep 1
  TIMEOUT=$((TIMEOUT+1))
  if [ $TIMEOUT -gt $MAX_TIMEOUT ]; then
    cat << EOF
    Gitlab connection timed out

    please rerun ${DEPLOY}/${SCRIPTS_PATH}/gitlab-seed.sh
EOF
    exit;
  fi
done


if [[ -z ${GITLAB_SECRET} ]]; then
  # 1. curl for the login page to get a session cookie and the sources with the auth tokens
  body_header=$(curl -k -c cookies.txt -i "${gitlab_host}/users/sign_in" -s)

  # grep the auth token for the user login for
  #   not sure whether another token on the page will work, too - there are 3 of them
  csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /new_user.*?authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)

  # 2. send login credentials with curl, using cookies and token from previous request
  curl -k -b cookies.txt -c cookies.txt -i "${gitlab_host}/users/sign_in" \
    --data "user[login]=${gitlab_user}&user[password]=${gitlab_password}" \
    --data-urlencode "authenticity_token=${csrf_token}"

  # 3. send curl GET request to personal access token page to get auth token
  body_header=$(curl -k -H 'user-agent: curl' -b cookies.txt -i "${gitlab_host}/profile/personal_access_tokens" -s)
  csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)

  # 4. curl POST request to send the "generate personal access token form"
  #      the response will be a redirect, so we have to follow using `-L`
  body_header=$(curl -k -L -b cookies.txt "${gitlab_host}/profile/personal_access_tokens" \
    --data-urlencode "authenticity_token=${csrf_token}" \
    --data 'personal_access_token[name]=golab-generated&personal_access_token[expires_at]=&personal_access_token[scopes][]=api')

  # 5. Scrape the personal access token from the response HTML
  GITLAB_SECRET=$(echo $body_header | perl -ne 'print "$1\n" if /created-personal-access-token"[[:blank:]]value="(.+?)"/' | sed -n 1p)

  # Update env file with secret
  sed -i "s/GITLAB_SECRET=.*/GITLAB_SECRET=${GITLAB_SECRET}/" "${DEPLOY}/${VARS_PATH}"
fi

echo "Personal Access Token is: ${GITLAB_SECRET}"
H_AUTH="Private-Token: ${GITLAB_SECRET}"
H_JSON="Content-Type: application/json"

# Set root to admin@${DOMAIN}
REQ=$(curl -ks --location --request GET "$api_url/users?username=root")
USER_ID=$(echo $REQ | jq -j '.[0] | .id')
DATA_JSON=$(echo $REQ | jq '.[0] | .provider = "foundry" | .extern_uid = "9fd3c38e-58b0-4af1-80d1-1895af91f1f9"')
REQ=$(curl -ks --location --request PUT "$api_url/users/${USER_ID}" \
--header "${H_JSON}" \
--header "${H_AUTH}" \
--data-raw "${DATA_JSON}")
echo "GITLAB_GROUP_ID: ${GITLAB_GROUP_ID}"
if [[ -z ${GITLAB_GROUP_ID} ]] || [[ ${GITLAB_GROUP_ID} -eq 'null' ]]; then
  # Check if the group exists by name
  REQ=$(curl -ks --location --request GET "$api_url/groups?search=${MODULES_GROUP}" \
  --header "${H_JSON}" \
  --header "${H_AUTH}")
  echo $REQ | jq .
  
  GROUP=$(echo $REQ | jq --arg name "$MODULES_GROUP" '.[] | select(.name=$name)')
  GITLAB_GROUP_ID=$(echo $GROUP | jq -j '.id')

  if [[ -z ${GROUP} ]]; then

    # Create caster modules group
    DATA_JSON=$(cat <<EOF
      {
        "name": "${MODULES_GROUP}",
        "path": "${MODULES_GROUP}"
      }
EOF
    )

    REQ=$(curl -ks --location --request POST "$api_url/groups" \
    --header "${H_JSON}" \
    --header "${H_AUTH}" \
    --data-raw "${DATA_JSON}")
    echo $REQ | jq .
    GITLAB_GROUP_ID=$(echo $REQ | jq -j '.id')
  fi

  echo $REQ | jq .
  # Update group id in env file
  sed -i "s/GITLAB_GROUP_ID=.*/GITLAB_GROUP_ID=${GITLAB_GROUP_ID}/" "${DEPLOY}/${VARS_PATH}"
fi

# Import all projects into group, file name without the extension will be the repo name.
FILES=$(find ${DEPLOY}/${EXPORTS_PATH} -type f -iname "*.tar.gz" | sed "s/.*\///; s/\.tar.gz//")
for file in $FILES; do
  REQ=$(curl -ks --location --request POST \
  --form "path=${file}" \
  --form "namespace=${MODULES_GROUP}" \
  --form "file=@${DEPLOY}/${EXPORTS_PATH}/${file}.tar.gz" \
  --header "${H_AUTH}" \
  ${api_url}/projects/import)
  echo $REQ | jq .
  echo "$file.tar.gz imported to github"
  sleep 5
done
echo "Redeploying Caster"
soff caster
echo "Sleeping for 10 seconds"
sleep 10
son caster
