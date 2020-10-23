#!/bin/bash
## clean up and shutdown for distribution

cd /home/crucible/appliance

# shutdown and delete apps
docker-compose down
docker volume prune -f

# remove yum cache
apt clean
apt autoremove --purge

# remove any proxy info
rm -f /etc/profile.d/http_proxy.sh
rm -f /etc/systemd/system/docker.service.d/http-proxy.conf
sed -i s,proxy=.*$,, /etc/yum.conf

#remove any certs
rm -rf /home/crucible/appliance/cfssl/output
rm -f /home/crucible/appliance/cfssl/scripts/*.pem
rm -f /home/crucible/appliance/vols/nginx/conf.d/*.pem
rm -f /home/crucible/appliance/vols/nginx/html/*.pem
rm -f /home/crucible/appliance/vols/entry.d/*.crt

# remove history
rm -rf /home/crucible/.ssh
rm -rf /home/crucible/.vscode-server
rm -f /home/crucible/.bash_history
rm -f /root/.bash_history
