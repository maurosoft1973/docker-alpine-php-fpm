ARG DOCKER_ALPINE_VERSION

FROM maurosoft1973/alpine:$DOCKER_ALPINE_VERSION

ARG BUILD_DATE
ARG ALPINE_ARCHITECTURE
ARG ALPINE_RELEASE
ARG ALPINE_VERSION
ARG ALPINE_VERSION_DATE
ARG PHP_VERSION
ARG PHP_VERSION_DATE
ARG PHP_PACKAGES

LABEL \
    maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="$ALPINE_ARCHITECTURE" \
    php-version="$PHP_VERSION" \
    alpine-version="$ALPINE_VERSION" \
    build="$BUILD_DATE" \
    org.opencontainers.image.title="alpine-php-fpm" \
    org.opencontainers.image.description="PHP-FPM $PHP_VERSION Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v$PHP_VERSION" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/" \
    org.opencontainers.image.source="https://gitlab.com/maurosoft1973-docker/alpine-php-fpm" \
    org.opencontainers.image.created=$BUILD_DATE

RUN \
    deluser xfs 2> /dev/null && \
    delgroup www-data 2> /dev/null && \
    addgroup -g 33 www-data && \
    adduser -s /bin/false -h /var/www -u 33 -G www-data -D www-data && \
    mkdir -p /var/run/php && \
    mkdir -p /var/www && \
    echo "" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_RELEASE/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_RELEASE/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --update --no-cache \
    autoconf \
    build-base \
    $PHP_PACKAGES && \
    pecl install xdebug && \
    apk del \
    php-pear \
    build-base \
    autoconf && \
    rm -rf /tmp/* /var/cache/apk/* && \
    rm /etc/php7/php-fpm.d/www.conf

ADD files/run-alpine-php-fpm.sh /scripts/run-alpine-php-fpm.sh

RUN chmod -R 755 /scripts

VOLUME ["/var/www"]

ENTRYPOINT ["/scripts/run-alpine-php-fpm.sh"]
