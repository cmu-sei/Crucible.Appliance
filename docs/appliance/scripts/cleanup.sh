#!/usr/bin/env sh

SSH_USER=${SSH_USERNAME:-crucible}

echo "==> Cleaning up tmp"
rm -rf /tmp/*

# Cleanup apt cache
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/${SSH_USER}/.bash_history

# Clean up log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

echo "==> Clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

# remove apt cache
apt clean
apt autoremove --purge -y

# remove any proxy info
rm -f /etc/profile.d/http_proxy.sh
rm -f /etc/systemd/system/docker.service.d/http-proxy.conf

#remove any certs
rm -rf /mnt/data/certificates/.
# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
rm /boot/whitespace

# Make sure we wait until all the data is written to disk
rm -rf /home/${SSH_USERNAME}/crucible-deploy
sync
