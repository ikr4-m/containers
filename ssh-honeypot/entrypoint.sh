#!/bin/bash

set -eu

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "[INFO] Setup home user"
sudo -i -u login bash <<EOF
    set -ex
    mkdir -p ~/.ssh
    if [ ! -f ~/.ssh/authorized_keys ]; then
        touch ~/.ssh/authorized_keys
    fi
    chmod 600 ~/.ssh/authorized_keys
EOF

echo "[INFO] Start SSH Daemon"
/usr/sbin/sshd -d -p 22
