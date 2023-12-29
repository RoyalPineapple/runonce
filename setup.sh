#!/bin/bash

set -eux

USER=pi

SERVICE_FILE=/etc/systemd/system/runonce.service
SERVICE_PATH="/etc/local/runonce.d"

BIN_PATH="/etc/local/bin"
SCRIPT_NAME="runonce.sh"



# copy runonce script to bin
sudo mkdir -p "$SERVICE_PATH"
sudo mkdir -p "$BIN_PATH"
sudo cp "$(dirname "$0")/$SCRIPT_NAME" "$BIN_PATH"/
sudo chmod +x "$BIN_PATH/$SCRIPT_NAME"

# copy service definition to file
sudo cat > $SERVICE_FILE <<- EOM
[Unit]
Description="Run Once Service"
After=network.target

[Service]
Type=simple
Restart=no
User=$USER
ExecStart=/bin/bash -c '$BIN_PATH/$SCRIPT_NAME $SERVICE_PATH'
[Install]
WantedBy=multi-user.target
EOM

# Enable Service
sudo systemctl enable runonce

# View Status
sudo systemctl status runonce