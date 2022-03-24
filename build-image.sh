#!/bin/bash
# Description: Build image
# Maintainer: Mauro Cardillo
BUILD_DATE=$(date +"%Y-%m-%d")
DOCKER_IMAGE=maurosoft1973/alpine-php-fpm
ALPINE_ARCHITECTURE=x86_64

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -di=*|--docker-image=*)
        DOCKER_IMAGE="${arg#*=}"
        shift # Remove
        ;;
        -aa=*|--alpine-architecture=*)
        ALPINE_ARCHITECTURE="${arg#*=}"
        shift # Remove
        ;;
        -ar=*|--alpine-release=*)
        export ALPINE_RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -av=*|--alpine-version=*)
        ALPINE_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -ad=*|--alpine-version-date=*)
        ALPINE_VERSION_DATE="${arg#*=}"
        shift # Remove
        ;;
        -pv=*|--php-version=*)
        PHP_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -pd=*|--php-version-date=*)
        PHP_VERSION_DATE="${arg#*=}"
        shift # Remove
        ;;
        -r=*|--release=*)
        RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -di=|--docker-image         -> ${DOCKER_IMAGE:-""} (docker image name)"
        echo -e "  -aa=|--alpine-architecture  -> ${ALPINE_ARCHITECTURE:-""} (alpine architecture)"
        echo -e "  -ar=|--alpine-release       -> ${ALPINE_RELEASE:-""} (alpine release)"
        echo -e "  -av=|--alpine-version       -> ${ALPINE_VERSION:-""} (alpine version)"
        echo -e "  -ad=|--alpine-version-date  -> ${ALPINE_VERSION_DATE:-""} (alpine version date)"
        echo -e "  -pv=|--php-version          -> ${PHP_VERSION:-""} (php version)"
        echo -e "  -pd=|--php-version-date     -> ${PHP_VERSION_DATE:-""} (php version date)"
        echo -e "  -r=|--release               -> ${RELEASE:-""} (release of image.Values: TEST, CURRENT, LATEST)"
        exit 0
        ;;
    esac
done

echo "# Build Date                -> ${BUILD_DATE}"
echo "# Docker Image              -> ${DOCKER_IMAGE}"
echo "# Docker Image Release      -> ${RELEASE}"
echo "# Alpine Architecture       -> ${ALPINE_ARCHITECTURE}"
echo "# Alpine Release            -> ${ALPINE_RELEASE}"
echo "# Alpine Version            -> ${ALPINE_VERSION}"
echo "# Alpine Version Date       -> ${ALPINE_VERSION_DATE}"
echo "# PHP Version               -> ${PHP_VERSION}"
echo "# PHP Version Date          -> ${PHP_VERSION_DATE}"

ARGUMENT_ERROR=0

if [ "${DOCKER_IMAGE}" == "" ]; then
    echo "ERROR: The variable DOCKER_IMAGE is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${ALPINE_ARCHITECTURE}" == "" ]; then
    echo "ERROR: The variable ALPINE_ARCHITECTURE is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${ALPINE_RELEASE}" == "" ]; then
    echo "ERROR: The variable ALPINE_RELEASE is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${ALPINE_VERSION}" == "" ]; then
    echo "ERROR: The variable ALPINE_VERSION is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${ALPINE_VERSION_DATE}" == "" ]; then
    echo "ERROR: The variable ALPINE_VERSION_DATE is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${PHP_VERSION}" == "" ]; then
    echo "ERROR: The variable PHP_VERSION is not set!"
    ARGUMENT_ERROR=1
fi

if [ "${PHP_VERSION_DATE}" == "" ]; then
    echo "ERROR: The variable PHP_VERSION_DATE is not set!"
    ARGUMENT_ERROR=1
fi

if [ ${ARGUMENT_ERROR} -ne 0 ]; then
    exit 1
fi

#linux/amd64, linux/386, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/arm/v7, linux/arm/v6
PLATFORM="linux/amd64"
if [ "${ALPINE_ARCHITECTURE}" == "aarch64" ]; then
    PLATFORM="linux/arm64"
    PHP_PACKAGES="php7-pear php7-dev php7-common php7-cli php7-ctype php7-mysqlnd php7-mysqli php7-json php7-curl php7-opcache php7-xml php7-zlib php7-phar php7-tokenizer php7-zip php7-apcu php7-gd php7-iconv php7-mbstring php7-mcrypt php7-fileinfo php7-posix php7-imap php7-ssh2 php7-session php7-openssl php7-pdo php7-pdo_mysql php7-fpm php7-dom php7-simplexml php7-xmlwriter php7-intl "
elif [ "${ALPINE_ARCHITECTURE}" == "armhf" ]; then
    PLATFORM="linux/arm/v6"
    PHP_PACKAGES="php7-pear php7-dev php7-common php7-cli php7-ctype php7-mysqlnd php7-mysqli php7-json php7-curl php7-opcache php7-xml php7-zlib php7-phar php7-tokenizer php7-zip php7-apcu php7-gd php7-iconv php7-mbstring php7-mcrypt php7-fileinfo php7-posix php7-imap php7-ssh2 php7-session php7-openssl php7-pdo php7-pdo_mysql php7-fpm php7-dom php7-simplexml php7-xmlwriter php7-intl "
elif [ "${ALPINE_ARCHITECTURE}" == "armv7" ]; then
    PLATFORM="linux/arm/v7"
    PHP_PACKAGES="php7-pear php7-dev php7-common php7-cli php7-ctype php7-mysqlnd php7-mysqli php7-json php7-curl php7-opcache php7-xml php7-zlib php7-phar php7-tokenizer php7-zip php7-apcu php7-gd php7-iconv php7-mbstring php7-mcrypt php7-fileinfo php7-posix php7-imap php7-ssh2 php7-session php7-openssl php7-pdo php7-pdo_mysql php7-fpm php7-dom php7-simplexml php7-xmlwriter php7-intl "
elif [ "${ALPINE_ARCHITECTURE}" == "ppc64le" ]; then
    PLATFORM="linux/ppc64le"
    PHP_PACKAGES="php7-pear php7-dev php7-common php7-cli php7-ctype php7-mysqlnd php7-mysqli php7-json php7-curl php7-opcache php7-xml php7-zlib php7-phar php7-tokenizer php7-zip php7-apcu php7-gd php7-iconv php7-mbstring php7-mcrypt php7-fileinfo php7-posix php7-imap php7-ssh2 php7-session php7-openssl php7-pdo php7-pdo_mysql php7-fpm php7-dom php7-simplexml php7-xmlwriter php7-intl "
elif [ "${ALPINE_ARCHITECTURE}" == "x86" ]; then
    PLATFORM="linux/386"
    PHP_PACKAGES="php7-pear php7-dev php7-common php7-cli php7-ctype php7-mysqlnd php7-mysqli php7-json php7-curl php7-opcache php7-xml php7-zlib php7-phar php7-tokenizer php7-zip php7-apcu php7-gd php7-iconv php7-mbstring php7-mcrypt php7-fileinfo php7-posix php7-imap php7-ssh2 php7-session php7-openssl php7-pdo php7-pdo_mysql php7-fpm php7-dom php7-simplexml php7-xmlwriter php7-intl "
elif [ "${ALPINE_ARCHITECTURE}" == "x86_64" ]; then
    PLATFORM="linux/amd64"
    PHP_PACKAGES="php7-pear php7-dev php7-common php7-cli php7-ctype php7-mysqlnd php7-mysqli php7-json php7-curl php7-opcache php7-xml php7-zlib php7-phar php7-tokenizer php7-zip php7-apcu php7-gd php7-iconv php7-imagick php7-mbstring php7-mcrypt php7-fileinfo php7-posix php7-imap php7-ssh2 php7-session php7-openssl php7-pdo php7-pdo_mysql php7-fpm php7-dom php7-simplexml php7-xmlwriter php7-intl "
fi

echo $PHP_PACKAGES

if [ "$RELEASE" == "TEST" ]; then
    echo "Remove image ${DOCKER_IMAGE}:test-${ALPINE_ARCHITECTURE}"
    docker rmi -f ${DOCKER_IMAGE}:test-${ALPINE_ARCHITECTURE} > /dev/null 2>&1

    echo "Build Image: ${DOCKER_IMAGE} -> $RELEASE"
    docker buildx build --platform ${PLATFORM} \
            --build-arg DOCKER_ALPINE_VERSION=${ALPINE_VERSION} \
            --build-arg BUILD_DATE=${BUILD_DATE} \
            --build-arg ALPINE_ARCHITECTURE=${ALPINE_ARCHITECTURE} \
            --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} \
            --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
            --build-arg ALPINE_VERSION_DATE="${ALPINE_VERSION_DATE}" \
            --build-arg PHP_VERSION=${PHP_VERSION} \
            --build-arg PHP_VERSION_DATE="${PHP_VERSION_DATE}" \
            --build-arg PHP_PACKAGES="${PHP_PACKAGES}" \
            -t ${DOCKER_IMAGE}:test-${ALPINE_ARCHITECTURE} \
            -f ./Dockerfile .
elif [ "$RELEASE" == "CURRENT" ]; then
    echo "Remove image ${DOCKER_IMAGE}:${ALPINE_VERSION}-${ALPINE_ARCHITECTURE}"
    docker rmi -f ${DOCKER_IMAGE}:${ALPINE_VERSION}-${ALPINE_ARCHITECTURE}> /dev/null 2>&1

    echo "Remove image ${DOCKER_IMAGE}:${ALPINE_VERSION}-${PHP_VERSION}-${ALPINE_ARCHITECTURE}"
    docker rmi -f ${DOCKER_IMAGE}:${ALPINE_VERSION}-${PHP_VERSION}-${ALPINE_ARCHITECTURE}> /dev/null 2>&1

    echo "Build Image: ${DOCKER_IMAGE} -> $RELEASE"
    docker buildx build --platform ${PLATFORM} \
            --build-arg DOCKER_ALPINE_VERSION=${ALPINE_VERSION} \
            --build-arg BUILD_DATE=${BUILD_DATE} \
            --build-arg ALPINE_ARCHITECTURE=${ALPINE_ARCHITECTURE} \
            --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} \
            --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
            --build-arg ALPINE_VERSION_DATE="${ALPINE_VERSION_DATE}" \
            --build-arg PHP_VERSION=${PHP_VERSION} \
            --build-arg PHP_VERSION_DATE="${PHP_VERSION_DATE}" \
            --build-arg PHP_PACKAGES="${PHP_PACKAGES}" \
            -t ${DOCKER_IMAGE}:${ALPINE_VERSION}-${ALPINE_ARCHITECTURE} \
            -t ${DOCKER_IMAGE}:${ALPINE_VERSION}-${PHP_VERSION}-${ALPINE_ARCHITECTURE} \
            -f ./Dockerfile .
else
    echo "Remove image ${DOCKER_IMAGE}:${ALPINE_ARCHITECTURE}"
    docker rmi -f ${DOCKER_IMAGE}:${ALPINE_ARCHITECTURE} > /dev/null 2>&1

    echo "Remove image ${DOCKER_IMAGE}:${PHP_VERSION}-${ALPINE_ARCHITECTURE}"
    docker rmi -f ${DOCKER_IMAGE}:${PHP_VERSION}-${ALPINE_ARCHITECTURE}> /dev/null 2>&1

    echo "Build Image: ${DOCKER_IMAGE} -> $RELEASE"
    docker buildx build --platform ${PLATFORM} \
            --build-arg DOCKER_ALPINE_VERSION=${ALPINE_VERSION} \
            --build-arg BUILD_DATE=${BUILD_DATE} \
            --build-arg ALPINE_ARCHITECTURE=${ALPINE_ARCHITECTURE} \
            --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} \
            --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
            --build-arg ALPINE_VERSION_DATE="${ALPINE_VERSION_DATE}" \
            --build-arg PHP_VERSION=${PHP_VERSION} \
            --build-arg PHP_VERSION_DATE="${PHP_VERSION_DATE}" \
            --build-arg PHP_PACKAGES="${PHP_PACKAGES}" \
            -t ${DOCKER_IMAGE}:${ALPINE_ARCHITECTURE} \
            -t ${DOCKER_IMAGE}:${PHP_VERSION}-${ALPINE_ARCHITECTURE} \
            -f ./Dockerfile .
fi
