#!/bin/bash
## helper script for toggling web proxy config

if [ -z "$1" ]; then
 echo usage: $0 http://proxy.my.domain:8080 [no-proxy-string]
 exit
fi
# Set the hostname and ping proxy omit proxy if it can't ping
proxy_hostname=$(awk -F[/:] '{print $4}' <<<$1)
target=/etc/systemd/system/docker.service.d
if ping -c 1 -W 1 "$proxy_hostname"; then
  echo "PROXY Available"
  proxy="$1"
  noproxy="$2"
  export http_proxy="$proxy"
  export https_proxy="$proxy"
  export no_proxy="$noproxy"
  export HTTP_PROXY="$proxy"
  export HTTPS_PROXY="$proxy"
  export NO_PROXY="$noproxy"

# set for docker
mkdir -p $target
cat <<EOF > $target/http-proxy.conf
[Service]
Environment="HTTP_PROXY=$proxy"
Environment="HTTPS_PROXY=$proxy"
Environment="NO_PROXY=$noproxy"
EOF

systemctl daemon-reload
systemctl restart docker

else
  unset http_proxy
  unset https_proxy
  unset no_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset NO_PROXY
  rm -f "$target/http-proxy.conf"
  systemctl daemon-reload
  systemctl restart docker
  proxy=""
  echo "Proxy couldn't be reached NOT SETTING PROXY"
fi

echo Proxy Configured.
