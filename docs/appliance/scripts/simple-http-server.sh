#!/usr/bin/env bash
dir=$PWD
port=8000
cd /mnt/data/certificates/sei-ca 

# Start server
python -m SimpleHTTPServer $port &> /dev/null &
pid=$!
ip="$(docker node inspect self | jq -r ".[0].Status.Addr")"
cat << EOF 

Download the appliance certificate

Server PID $pid

wget http://$ip:$port/appliance-ca.crt


EOF
