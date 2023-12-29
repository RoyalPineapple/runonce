#!/bin/sh

set -eux

USER=pi

SERVICE_FILE=/etc/systemd/system/runonce.service
SERVICE_PATH="/etc/local/runonce.d"

BIN_PATH="/etc/local/bin"
SCRIPT_NAME="runonce.sh"



# copy runonce script to bin
mkdir -p "$SERVICE_PATH"
mkdir -p "$BIN_PATH"
cp "$(dirname "$0")/$SCRIPT_NAME" "$BIN_PATH"/
chmod +x "$BIN_PATH/$SCRIPT_NAME"

# copy service definition to file
cat > $SERVICE_FILE <<- EOM
[Unit]
Description="Run Once Service"
After=network.target

[Service]
Type=simple
Restart=no
User="$USER"
ExecStart="$BIN_PATH/$SCRIPT_NAME $SERVICE_PATH"
[Install]
WantedBy=multi-user.target
EOM

# Enable Service
systemctl enable runonce

# View Status
systemctl status runonce