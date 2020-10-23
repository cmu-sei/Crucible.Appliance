#!/usr/bin/env bash
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

find "${DEPLOY}" -not -path '*/\.*' -type f -name "*.yml" -exec sed -n -e 's/traefik.frontend.rule=Host://p' {} \; > /tmp/compose-files
sed '/find/d' /tmp/compose-files > /tmp/compose-files.parse
# Remove white space
sed -i 's/ //g' /tmp/compose-files.parse
# Remove quotes
sed -i "s/['\"]//g" /tmp/compose-files.parse
# Remove '-'
sed -i 's/^-//g' /tmp/compose-files.parse
# Substitue environment variables
envsubst < "/tmp/compose-files.parse" > "/tmp/compose-files.sub"
sort -o /tmp/compose-files /tmp/compose-files.sub
# Remove duplicates
awk '!seen[$0]++' /tmp/compose-files > /tmp/compose-files.dup
# Remove anomolies.
sed -i '/.*;.*/d' /tmp/compose-files.dup
# Output
files=`cat /tmp/compose-files.dup`
string="$(docker node inspect self | jq -r ".[0].Status.Addr") "
for file in $files; do
  string+="$file "
done
echo ${string}
if grep -Fxq "${string}" /etc/hosts; then
  echo "Hosts entry already exists on appliance"
else
  echo "${string}" | sudo tee -a /etc/hosts > /dev/null
  echo "Updated hosts file on the appliance"
fi

cat << EOF 
Run this script on your local workstation

LINUX:

sudo grep -qxF '$string' /etc/hosts || sudo echo '$string' | sudo tee -a /etc/hosts > /dev/null

MACOS:

sudo /bin/sh -c "sudo grep -qxF '$string' /etc/hosts || sudo echo '$string' >> /etc/hosts"

WINDOWS:
https://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/

$string

EOF
rm -rf /tmp/compose-files /tmp/compose-files.parse /tmp/compose-files.sub /tmp/compose-files.dup