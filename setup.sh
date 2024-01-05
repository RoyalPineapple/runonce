#!/bin/bash

set -eu

USER=pi

SERVICE_FILE=/etc/systemd/system/runonce.service
SERVICE_PATH="/etc/local/runonce.d"

SCRIPT_PATH="/etc/local/bin"
SCRIPT_NAME="runonce.sh"

BIN_NAME=reboot-defer
BIN_PATH=/usr/local/bin/

if [[ $(id -u) != 0 ]]; then 
	echo "Pleae run setup.sh as root."
	exit 1
fi

echo "Creating service directory at $SERVICE_PATH"
mkdir -p "$SERVICE_PATH"
chown $USER "$SERVICE_PATH"

echo "Installing $SCRIPT_NAME at $SCRIPT_PATH"
mkdir -p "$SCRIPT_PATH"
cp "$(dirname "$0")/$SCRIPT_NAME" "$SCRIPT_PATH"/
chmod +x "$SCRIPT_PATH/$SCRIPT_NAME"

echo "Installing $BIN_NAME command at $BIN_PATH"
cat > $BIN_PATH/$BIN_NAME <<- EOM
#!/bin/bash
if [[ ! -f \$1 || ! -x \$1 ]]; then
	echo "Please provide an executable script file"
	exit 1
fi
cp \$1 $SERVICE_PATH && echo "Deferred: \$1"
EOM
chmod +x $BIN_PATH/$BIN_NAME


echo "Creating service definition at $SERVICE_FILE"
cat > $SERVICE_FILE <<- EOM
[Unit]
Description="Run Once Service"
After=network.target
[Service]
Type=simple
Restart=no
User=$USER
ExecStart=/bin/bash -c '$SCRIPT_PATH/$SCRIPT_NAME $SERVICE_PATH'
[Install]
WantedBy=multi-user.target
EOM

echo "Reoloading systemd"
systemctl daemon-reload

echo "Enabling service"
systemctl enable runonce
