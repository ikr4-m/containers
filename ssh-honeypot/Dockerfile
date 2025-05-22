FROM docker.io/library/alpine:latest
WORKDIR /root

RUN set -ex; \
    apk add --no-cache openssh bash sudo;

RUN set -ex; \
    adduser login -D; \
    passwd login -d; \
    chown login:login /home/login; \
    chmod 700 /home/login;

COPY ./tunnel.conf /etc/ssh/sshd_config.d/
COPY ./force-command.sh /
COPY ./entrypoint.sh /

USER root
ENV SSH_PORT=22
ENV DEBUG_MODE=""
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
