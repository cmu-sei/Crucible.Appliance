#!/bin/bash
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-docs/appliance/env}
CFSSL=/usr/local/bin/cfssl
CFSSLJSON=/usr/local/bin/cfssljson

if [ ! -f "$CFSSL" ]; then
  curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 --output $CFSSL
fi

if [ ! -f "$CFSSLJSON" ]; then
  curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 --output $CFSSLJSON
fi

chmod +x $CFSSL $CFSSLJSON
mkdir -p "${NFS_BASE_PATH}certificates/cfssl/output"
mkdir -p "${NFS_BASE_PATH}certificates/sei-ca"
mkdir -p "${NFS_BASE_PATH}certificates/vcenter/lin"
path="${NFS_BASE_PATH}certificates/cfssl"
certs=$path/output
cd "${DEPLOY}/docs/appliance/cfssl" 
cp ./scripts/*.json $path
if [ ! -f $path/output/appliance-ca.pem ]; then
  source ./scripts/generate-certificate.sh $@ $path
  cat $path/appliance.pem $path/appliance-ca.pem > $certs/appliance.pem
  cp "$path/appliance-key.pem" "$certs/appliance-key.pem"
  cp "$path/appliance-ca.pem" "$certs/appliance-ca.crt"
  cp "$path/appliance-int.pem" "$certs/appliance-int.crt"
  cp "$path/appliance-ca.pem" "${NFS_BASE_PATH}certificates/sei-ca/appliance-ca.crt"
  cp "$path/appliance-int.pem" "${NFS_BASE_PATH}certificates/sei-ca/appliance-int.crt"
fi
