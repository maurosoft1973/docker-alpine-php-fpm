FROM maurosoft1973/alpine:3.11.5-amd64

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

#CMD ["/usr/sbin/php-fpm7","--nodaemonize"]
