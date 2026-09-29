FROM node:20-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server tmux mosh git curl \
    python3 python3-pip python3-venv sudo \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd \
    && cp -r /etc/ssh /etc/ssh.default

RUN useradd -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY sshd_config /etc/ssh.default/sshd_config.d/ai-workspace.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 22002/udp

VOLUME /home/dev
VOLUME /workspace

ENTRYPOINT ["/entrypoint.sh"]
