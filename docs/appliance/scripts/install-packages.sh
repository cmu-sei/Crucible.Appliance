#!/bin/bash
#
# docker install
#
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="/deploy"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}
proxy=${1:-http://proxy.sei.cmu.edu:8080}
mkdir -pv "${DEPLOY}"
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

apt update
apt install apt-transport-https ca-certificates curl software-properties-common apache2-utils jq unzip rename python postgresql-client -y
snap install powershell --classic
pwsh -c 'Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; Install-Module -Name VMWare.PowerCLI -Confirm:$false'
pwsh -c 'Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt install docker-ce -y

mkdir -p /etc/docker
cat <<EOF >> /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m"
  }
}
EOF

groupadd docker -f
usermod -aG docker "${SUDO_USER}"
echo "Added ${SUDO_USER} to docker and sudo group"
systemctl enable docker
systemctl start docker

# install compose
tag=`curl -s https://github.com/docker/compose/releases/latest | awk -F'"' '{print $2}' | awk -F/ '{print $NF}'`
curl -L https://github.com/docker/compose/releases/download/$tag/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo Done installing docker.