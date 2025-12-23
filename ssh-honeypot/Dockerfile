FROM docker.io/library/alpine:latest
WORKDIR /root

RUN set -ex; \
    apk add --no-cache openssh bash runuser;

RUN mkdir -p /var/run/sshd; \
    cp -r /etc/ssh /etc/ssh.default;

RUN set -ex; \
    adduser login -D; \
    passwd login -d; \
    chown login:login /home/login; \
    chmod 700 /home/login;

COPY ./tunnel.conf /etc/ssh.default/sshd_config.d/
COPY ./force-command.sh /
COPY ./entrypoint.sh /

USER root

ENV SSH_PORT=22
ENV DEBUG_MODE=""
EXPOSE 22

# For storing ssh host key
VOLUME /etc/ssh

# For storing authorized keys
VOLUME /home/login

ENTRYPOINT ["/entrypoint.sh"]
