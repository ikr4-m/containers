#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

qecho() {
    printf "[%s] [SSH] %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

qecho "Initialize SSH configuration"
DEFAULT_CONF_DIR="/etc/ssh.default"
CONF_DIR="/etc/ssh"

if [ ! -f "$CONF_DIR/sshd_config" ]; then
    qecho "Backuping SSH configuration for first timer initialization"
    cp -R $DEFAULT_CONF_DIR/* $CONF_DIR/
fi

if [ ! -f "$CONF_DIR/ssh_host_rsa_key" ]; then
    qecho "Generating SSH host keys"
    ssh-keygen -A
fi

qecho "Fixing SSH host keys permissions"
chmod 600 /etc/ssh/ssh_host_*_key 2>/dev/null || true
chmod 644 /etc/ssh/ssh_host_*_key.pub 2>/dev/null || true

qecho "Setup home user"
chmod 750 /home/login
chown -R login:login /home/login

runuser -u login -g login -- bash <<EOF
    set -eu

    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    if [ ! -f ~/.ssh/authorized_keys ]; then
        touch ~/.ssh/authorized_keys
    fi
    chmod 600 ~/.ssh/authorized_keys
EOF

qecho "Start SSH Daemon"
/usr/sbin/sshd $([ "${DEBUG_MODE}" != "" ] && echo "-d") -D -e -p "${SSH_PORT}"
