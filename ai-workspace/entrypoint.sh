#!/usr/bin/env bash
set -euo pipefail

qecho() {
    printf "[%s] [AI-WS] %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

DEFAULT_CONF_DIR="/etc/ssh.default"
CONF_DIR="/etc/ssh"

# Initialize /etc/ssh if fresh volume mount
if [ ! -f "$CONF_DIR/sshd_config" ]; then
    qecho "Initializing SSH configuration from template"
    cp -R $DEFAULT_CONF_DIR/* $CONF_DIR/
else
    # Always keep custom config up to date
    mkdir -p $CONF_DIR/sshd_config.d
    cp -f $DEFAULT_CONF_DIR/sshd_config.d/* $CONF_DIR/sshd_config.d/ 2>/dev/null || true
fi

# Generate host keys if missing (first run with fresh /etc/ssh PVC)
if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
    qecho "Generating SSH host keys"
    ssh-keygen -A
fi

qecho "Fixing SSH host key permissions"
chmod 600 /etc/ssh/ssh_host_*_key 2>/dev/null || true
chmod 644 /etc/ssh/ssh_host_*_key.pub 2>/dev/null || true

# Setup dev user home (PVC may be empty on first mount)
qecho "Setting up dev home directory"
chown dev:dev /home/dev
chmod 750 /home/dev

# Ensure .ssh dir exists
runuser -u dev -- bash <<'EOF'
set -eu
mkdir -p ~/.ssh
chmod 700 ~/.ssh
[ -f ~/.ssh/authorized_keys ] || touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Setup workspace symlink
[ -L ~/workspace ] || ln -sf /workspace ~/workspace

# npm global prefix to home (idempotent)
if ! grep -q 'npm-global' ~/.bashrc 2>/dev/null; then
    mkdir -p ~/.npm-global
    npm config set prefix ~/.npm-global
    echo 'export PATH=~/.npm-global/bin:~/.local/bin:$PATH' >> ~/.bashrc
fi
EOF

# Ensure workspace owned by dev
chown dev:dev /workspace

qecho "Starting SSH daemon"
exec /usr/sbin/sshd -D -e
