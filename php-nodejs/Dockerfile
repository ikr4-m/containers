ARG PHP_VERSION="8.2"
FROM docker.io/serversideup/php:${PHP_VERSION}-fpm-nginx-alpine

USER root
RUN set -ex; \
    apk add --no-cache \
        nodejs \
        npm \
        git \
        vim \
        nano \
        mariadb-client \
        htop \
        openssh \
        ncdu;

RUN install-php-extensions gd

USER www-data
ENV PHP_OPCACHE_ENABLE=1
