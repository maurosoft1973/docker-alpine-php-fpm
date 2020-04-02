FROM maurosoft1973/alpine:3.11.5-amd64

ARG BUILD_DATE

LABEL maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="amd64/x86_64" \
    php-version="7.3.16" \
    alpine-version="3.11.5" \
    build="02-Apr-2020" \
    org.opencontainers.image.title="alpine-php-fpm" \
    org.opencontainers.image.description="PHP-FPM 7.0 Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v7.3.16" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/" \
    org.opencontainers.image.source="https://github.com/maurosoft1973/alpine-php-fpm" \
    org.opencontainers.image.created=$BUILD_DATE

RUN \
	deluser xfs && \
	adduser -s /bin/false -H -u 33 -D www-data && \
	mkdir -p /var/run/php && \	
	mkdir -p /var/www && \	
	apk add --update --no-cache \
	tzdata \
	php7-common \
	php7-cli \ 
	php7-pear \ 
	php7-mysqlnd \
	php7-mysqli \
	php7-json \
	php7-curl \
	php7-opcache \ 
	php7-xml \ 
	php7-apcu \ 
	php7-gd \ 
	php7-mbstring \
	php7-session \
	php7-fpm && \
	apk add php7-xdebug --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \
	rm -rf /tmp/* /var/cache/apk/* && \
	rm /etc/php7/php-fpm.d/www.conf

COPY conf/etc/php7/php.ini /etc/php7/php.ini
COPY conf/etc/php7/php-fpm.conf /etc/php7/php-fpm.conf

ADD files/run.sh /scripts/run.sh

RUN chmod -R 755 /scripts

VOLUME ["/var/www"]

ENTRYPOINT ["/scripts/run.sh"]
