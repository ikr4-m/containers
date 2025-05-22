FROM docker.io/library/alpine:latest
WORKDIR /root

RUN set -ex; \
    apk add --no-cache openssh bash sudo;

RUN set -ex; \
    adduser login -D; \
    passwd login -d; \
    ssh-keygen -A;

COPY ./tunnel.conf /etc/ssh/sshd_config.d/
COPY ./force-command.sh /
COPY ./entrypoint.sh /

USER root
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
