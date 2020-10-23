#!/bin/bash
## auto start / stop with systemd

cat <<EOF > /etc/systemd/system/appliance.service
[Unit]
Description=Appliance Stack
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/deploy/docs/appliance
ExecStart=/bin/bash scripts/start.sh
ExecStop=/bin/bash scripts/stop.sh

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
systemctl enable appliance