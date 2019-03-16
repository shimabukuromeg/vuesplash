FROM php:7.2-fpm-alpine

WORKDIR /tmp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN apk --no-cache add zip libzip-dev && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install zip

RUN apk --no-cache add \
        curl-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev \
        zlib-dev && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} \
        bcmath \
        curl \
        dom \
        mbstring \
        pdo \
        pdo_mysql \
        simplexml

RUN apk add --no-cache $PHPIZE_DEPS && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug

RUN mkdir -p /var/run/php-fpm && \
    chown root:root /var/run/php-fpm

RUN composer global require "laravel/installer" && \
    composer self-update && \
    composer global require hirak/prestissimo

COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
RUN apk add --no-cache gettext && \
    envsubst < /usr/local/etc/php/php.ini > /usr/local/etc/php/php.ini.tmp && \
    mv /usr/local/etc/php/php.ini.tmp /usr/local/etc/php/php.ini

# volumes でマウントしているケースで、 uid, gid を変更したい場合: 主に docker-machine や linux で volumes を用いているマウントしている場合、ホスト側の uid, gid が設定される為、それらの uid, gid をプロセス実行ユーザーに override する事で Permission の問題を回避する。
ARG CHANGE_UID_GID="false"
ARG CHANGE_UID_GID_BEFORE_UID
ARG CHANGE_UID_GID_BEFORE_GID
RUN if [ "${CHANGE_UID_GID}" = "true" ]; then \
    apk add shadow \
    && usermod -u "${CHANGE_UID_GID_BEFORE_UID}" www-data && groupmod -g "${CHANGE_UID_GID_BEFORE_GID}" www-data \
;fi

ENV COMPOSER_ALLOW_SUPERUSER 1
ARG PHP_XDEBUG_PHP_IDE_CONFIG=""
ENV PHP_IDE_CONFIG ${PHP_XDEBUG_PHP_IDE_CONFIG}

ARG PHP_XDEBUG_REMOTE_ENABLE="On"
ARG PHP_XDEBUG_REMOTE_AUTO_START="On"
ARG PHP_XDEBUG_REMOTE_CONNECT_BACK="Off"
ARG PHP_XDEBUG_REMOTE_HOST="docker.for.mac.localhost"
ARG PHP_XDEBUG_REMOTE_PORT="9001"
ARG PHP_XDEBUG_IDEKEY="phpstorm"

RUN mkdir -p /app
WORKDIR /app
