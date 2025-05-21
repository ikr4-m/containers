FROM docker.io/library/alpine:latest
WORKDIR /root

RUN set -ex; \
    apk add --no-cache openssh bash;

RUN set -ex; \
    adduser login -D; \
    passwd login -d; \
    ssh-keygen -A;

COPY ./tunnel.conf /etc/ssh/sshd_config.d/
COPY ./force-command.sh /

USER login
RUN set -ex; \
    mkdir -p /home/login/.ssh; \
    touch /home/login/.ssh/authorized_keys; \
    chmod 600 /home/login/.ssh/authorized_keys;

USER root
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
