#!/bin/bash
# Description: Script for alpine php-fpm container
# Maintainer: Mauro Cardillo
#

# Default values of arguments
IMAGE=maurosoft1973/alpine-php-fpm:test
CONTAINER=alpine-php-fpm
LC_ALL=it_IT.UTF-8
TIMEZONE=Europe/Rome
IP=0.0.0.0
PORT=7000
WWW=/var/www
WWW_USER=root
WWW_USER_UID=0
WWW_GROUP=www-data
WWW_GROUP_UID=33
PHP_POOL_MAX_CHILDREN=5
PHP_POOL_START_SERVERS=1
PHP_POOL_MIN_SPARE_SERVERS=1
PHP_POOL_MAX_SPARE_SERVERS=3

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -c=*|--container=*)
        CONTAINER="${arg#*=}"
        shift # Remove
        ;;
        -l=*|--lc_all=*)
        LC_ALL="${arg#*=}"
        shift # Remove
        ;;
        -t=*|--timezone=*)
        TIMEZONE="${arg#*=}"
        shift # Remove
        ;;
		-i=*|--ip=*)
        IP="${arg#*=}"
        shift # Remove
        ;;
        -p=*|--port=*)
        PORT="${arg#*=}"
        shift # Remove
        ;;
        -wu=*|--www_user=*)
        WWW_USER="${arg#*=}"
        shift # Remove
        ;;
        -wui=*|--www_user_id=*)
        WWW_USER_UID="${arg#*=}"
        shift # Remove
        ;;
        -wg=*|--www_group=*)
        WWW_GROUP="${arg#*=}"
        shift # Remove
        ;;
        -wgi=*|--www_group_id=*)
        WWW_GROUP_UID="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
		echo -e "  -c=|--container=${CONTAINER} -> name of container"
        echo -e "  -l=|--lc_all=${LC_ALL} -> locale"
        echo -e "  -t=|--timezone=${TIMEZONE} -> timezone"
        echo -e "  -i=|--ip -> ${IP} (address ip listen)"
		echo -e "  -p=|--port -> ${PORT} (port listen)"
        echo -e "  -w=|--www -> ${WWW} (www data)"
        echo -e "  -wu=|--www_user -> ${WWW_USER} (www user)"
		echo -e "  -wui=|--www_user_id -> ${WWW_USER_UID} (www user uid)"
        echo -e "  -wg=|--www_group -> ${WWW_GROUP} (www user group)"
		echo -e "  -wgi=|--www_group_id -> ${WWW_GROUP_UID} (www user group uid)"
		exit 0
        ;;
    esac
done

echo "# Image               : ${IMAGE}"
echo "# Container Name      : ${CONTAINER}"
echo "# Locale              : ${LC_ALL}"
echo "# Timezone            : ${TIMEZONE}"
echo "# IP Listen           : $IP"
echo "# Port Listen         : $PORT"
echo "# WWW Data            : $WWW"
echo "# WWW User            : $WWW_USER"
echo "# WWW User UID        : $WWW_USER_UID"
echo "# WWW Group           : $WWW_GROUP"
echo "# WWW Group UID       : $WWW_GROUP_UID"

echo -e "Check if container ${CONTAINER} exist"
CHECK=$(docker container ps -a | grep ${CONTAINER} | wc -l)
if [ ${CHECK} == 1 ]; then
    echo -e "Stop Container -> ${CONTAINER}"
    docker stop ${CONTAINER} > /dev/null

    echo -e "Remove Container -> ${CONTAINER}"
    docker container rm ${CONTAINER} > /dev/null
else 
    echo -e "The container ${CONTAINER} not exist"
fi

echo -e "Create and run container"
docker run -dit --name ${CONTAINER} -p ${IP}:${PORT}:${PORT} -v ${WWW}:/var/www -e LC_ALL=${LC_ALL} -e TIMEZONE=${TIMEZONE} -e WWW_USER=${WWW_USER} -e WWW_USER_UID=${WWW_USER_UID} -e WWW_GROUP=${WWW_GROUP} -e WWW_GROUP_UID=${WWW_GROUP_UID} -e IP=${IP} -e PORT=${PORT} ${IMAGE}

echo -e "Sleep 5 second"
sleep 5

IP=$(docker exec -it ${CONTAINER} /sbin/ip route | grep "src" | awk '{print $7}')
echo -e "IP Address is: ${IP}";

echo -e ""
echo -e "Environment variable";
docker exec -it ${CONTAINER} env

echo -e ""
echo -e "Test Locale (date)";
docker exec -it ${CONTAINER} date

echo -e ""
echo -e "Check FCGI Connection"
SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect ${IP}:${PORT}

echo -e ""
echo -e "Container Logs"
docker logs ${CONTAINER}