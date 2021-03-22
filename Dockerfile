FROM maurosoft1973/alpine

ARG BUILD_DATE
ARG ALPINE_RELEASE
ARG ALPINE_VERSION
ARG PHP_VERSION

LABEL \
    maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="amd64/x86_64" \
    php-version="$PHP_VERSION" \
    alpine-version="$ALPINE_VERSION" \
    build="$BUILD_DATE" \
    org.opencontainers.image.title="alpine-php-fpm" \
    org.opencontainers.image.description="PHP-FPM 7.4.16 Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v$PHP_VERSION" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/" \
    org.opencontainers.image.source="https://github.com/maurosoft1973/alpine-php-fpm" \
    org.opencontainers.image.created=$BUILD_DATE

RUN \
    deluser xfs && \
    adduser -s /bin/false -H -u 33 -D www-data && \
    mkdir -p /var/run/php && \
    mkdir -p /var/www && \
    echo "" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_RELEASE/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_RELEASE/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --update --no-cache \
    php7-pear \
    php7-dev \
    php7-common \
    php7-cli \ 
    php7-ctype \
    php7-mysqlnd \
    php7-mysqli \
    php7-json \
    php7-curl \
    php7-opcache \ 
    php7-xml \
    php7-zlib \
    php7-phar \
    php7-tokenizer \
    php7-zip \ 
    php7-apcu \ 
    php7-gd \ 
    php7-iconv \
    php7-imagick \
    php7-mbstring \
    php7-mcrypt \
    php7-fileinfo \
    php7-posix \
    php7-imap \
    php7-ssh2 \
    php7-session \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-fpm \
    php7-dom \
    php7-simplexml \
    php7-xmlwriter \
    php7-intl && \
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
