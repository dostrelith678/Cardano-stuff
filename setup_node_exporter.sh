#!/bin/bash

######################################################################
#### Environment Variables
######################################################################
CNODE_IP=0.0.0.0
NEXP_PORT=9091
NEXP_DIR="~/tmp/monitoring/node_exporter-1.0.1.linux-amd64"

#get node_exporter to tmp directorty
cd ~/tmp
mkdir monitoring
cd monitoring
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.0.1.linux-amd64.tar.gz

#create systemd service
sudo touch /etc/systemd/system/node_exporter.service
cat > /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=$(whoami)
Restart=on-failure
ExecStart=$NEXP_DIR/node_exporter --web.listen-address="$CNODE_IP:$NEXP_PORT"
WorkingDirectory=$NEXP_DIR
LimitNOFILE=3500
[Install]
WantedBy=multi-user.target
EOF

#restart daemon and enable service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

echo -e "
=====================================================
Installation is completed
=====================================================
Node exp metrics:   http://$CNODE_IP:$NEXP_PORT
"
