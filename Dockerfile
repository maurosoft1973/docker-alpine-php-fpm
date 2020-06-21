FROM maurosoft1973/alpine

ARG BUILD_DATE

LABEL \
  maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
  architecture="amd64/x86_64" \
  php-version="7.3.18" \
  alpine-version="3.11.6" \
  build="20-May-2020" \
  org.opencontainers.image.title="alpine-php-fpm" \
  org.opencontainers.image.description="PHP-FPM 7.3.18 Docker image running on Alpine Linux" \
  org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
  org.opencontainers.image.vendor="Mauro Cardillo" \
  org.opencontainers.image.version="v7.3.18" \
  org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/" \
  org.opencontainers.image.source="https://github.com/maurosoft1973/alpine-php-fpm" \
  org.opencontainers.image.created=$BUILD_DATE

RUN \
  deluser xfs && \
  adduser -s /bin/false -H -u 33 -D www-data && \
  mkdir -p /var/run/php && \	
  mkdir -p /var/www && \	
  apk add --update --no-cache \
  php7-common \
  php7-cli \ 
  php7-mysqlnd \
  php7-mysqli \
  php7-json \
  php7-curl \
  php7-opcache \ 
  php7-xml \ 
  php7-zip \ 
  php7-apcu \ 
  php7-gd \ 
  php7-mbstring \
  php7-session \
  php7-fpm \
  php7-dom \
  php7-simplexml \
  php7-intl && \
  apk add php7-xdebug --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \
  rm -rf /tmp/* /var/cache/apk/* && \
  rm /etc/php7/php-fpm.d/www.conf

COPY conf/etc/php7/ /etc/php7/

ADD files/run-alpine-php-fpm.sh /scripts/run-alpine-php-fpm.sh

RUN chmod -R 755 /scripts

VOLUME ["/var/www"]

ENTRYPOINT ["/scripts/run-alpine-php-fpm.sh"]