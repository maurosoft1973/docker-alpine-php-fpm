#!/bin/sh

IP=${IP:-"0.0.0.0"}
PORT=${PORT:-"7000"}
WWW_USER=${WWW_USER:-"www"}
WWW_USER_UID=${WWW_USER_UID:-"5001"}
WWW_GROUP=${WWW_GROUP:-"www-data"}
WWW_GROUP_UID=${WWW_GROUP_UID:-"33"}
PHP_POOL_MAX_CHILDREN=${PHP_POOL_MAX_CHILDREN:-"5"}
PHP_POOL_START_SERVERS=${PHP_POOL_START_SERVERS:-"1"}
PHP_POOL_MIN_SPARE_SERVERS=${PHP_POOL_MIN_SPARE_SERVERS:-"1"}
PHP_POOL_MAX_SPARE_SERVERS=${PHP_POOL_MAX_SPARE_SERVERS:-"3"}

source /scripts/init-alpine.sh

#Create User (if not exist)
CHECK=$(cat /etc/passwd | grep $WWW_USER | wc -l)
if [ ${CHECK} == 0 ]; then
    echo "Create User $WWW_USER with uid $WWW_USER_UID"
    adduser -s /bin/false -H -u ${WWW_USER_UID} -D ${WWW_USER}
else
    echo -e "Skipping,user $WWW_USER exist"
fi

#Create User (if not exist)
CHECK=$(cat /etc/passwd | grep $WWW_GROUP | wc -l)
if [ ${CHECK} == 0 ]; then
    echo "Create User $WWW_GROUP with uid $WWW_GROUP_UID"
    adduser -s /bin/false -H -u ${WWW_GROUP_UID} -D ${WWW_GROUP}
else
    echo -e "Skipping,user $WWW_GROUP exist"
fi

echo "Change Timezone ${TIMEZONE} php.ini file"
TIMEZONE_PHP=${TIMEZONE//\//\\/}
sed "s/{timezone}/${TIMEZONE_PHP}/g" /etc/php7/php.ini > /tmp/php.ini
cp /tmp/php.ini /etc/php7/php.ini

PHP_POOL_USER=/etc/php7/php-fpm.d/$WWW_USER.conf

if [ -f "$PHP_POOL_USER" ]; then
    rm -rf $PHP_POOL_USER
fi

echo "Create configuration php for user $WWW_USER"
echo "[$WWW_USER]" >> $PHP_POOL_USER
echo "user = $WWW_USER"  >> $PHP_POOL_USER
echo "group = $WWW_GROUP"  >> $PHP_POOL_USER
echo "listen = $IP:$PORT" >> $PHP_POOL_USER
echo "pm = dynamic" >> $PHP_POOL_USER
echo "pm.max_children = $PHP_POOL_MAX_CHILDREN" >> $PHP_POOL_USER
echo "pm.start_servers = $PHP_POOL_START_SERVERS" >> $PHP_POOL_USER
echo "pm.min_spare_servers = $PHP_POOL_MIN_SPARE_SERVERS" >> $PHP_POOL_USER
echo "pm.max_spare_servers = $PHP_POOL_MAX_SPARE_SERVERS" >> $PHP_POOL_USER
echo "pm.status_path = /status" >> $PHP_POOL_USER
echo "ping.path = /ping" >> $PHP_POOL_USER
echo "ping.response = pong" >> $PHP_POOL_USER
echo "request_terminate_timeout = 300" >> $PHP_POOL_USER

echo "Listen on $IP:$PORT"

if [ "$WWW_USER" == "root" ]; then
    /usr/sbin/php-fpm7 --nodaemonize -R
else 
    /usr/sbin/php-fpm7 --nodaemonize
fi