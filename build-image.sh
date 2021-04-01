#!/bin/bash
# Description: Build image and push to repository
# Maintainer: Mauro Cardillo
# DOCKER_HUB_USER and DOCKER_HUB_PASSWORD is user environment variable
#!/bin/bash
# Description: Build image and push to repository
# Maintainer: Mauro Cardillo
# DOCKER_HUB_USER and DOCKER_HUB_PASSWORD is user environment variable
echo "Get Remote Environment Variable"
wget -q "https://gitlab.com/maurosoft1973-docker/alpine-variable/-/raw/master/.env" -O ./.env
source ./.env

echo "Get Remote Settings"
wget -q "https://gitlab.com/maurosoft1973-docker/alpine-variable/-/raw/master/settings.sh" -O ./settings.sh
chmod +x ./settings.sh
source ./settings.sh

BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE=maurosoft1973/alpine-php-fpm

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
       -ar=*|--alpine-release=*)
        ALPINE_RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -av=*|--alpine-version=*)
        ALPINE_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -avd=*|--alpine-version-date=*)
        ALPINE_VERSION_DATE="${arg#*=}"
        shift # Remove
        ;;
        -r=*|--release=*)
        RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -ar=|--alpine-release -> ${ALPINE_RELEASE} (alpine release)"
        echo -e "  -av=|--alpine-version -> ${ALPINE_VERSION} (alpine version)"
        echo -e "  -avd=|--alpine-version-date -> ${ALPINE_VERSION_DATE} (alpine version date)"
        echo -e "  -r=|--release -> ${RELEASE} (release of image.Values: TEST, CURRENT, LATEST)"
        echo -e ""
        echo -e "  Version of PHP installed is ${PHP_VERSIONS["$ALPINE_RELEASE"]} (Released ${PHP_VERSIONS_DATE["$ALPINE_RELEASE"]})"
        exit 0
        ;;
    esac
done

PHP_VERSION=${PHP_VERSIONS["$ALPINE_RELEASE"]}
PHP_VERSION_DATE=${PHP_VERSIONS_DATE["$ALPINE_RELEASE"]}

echo "# Image               : ${IMAGE}"
echo "# Image Release       : ${RELEASE}"
echo "# Build Date          : ${BUILD_DATE}"
echo "# Alpine Release      : ${ALPINE_RELEASE}"
echo "# Alpine Version      : ${ALPINE_VERSION}"
echo "# Alpine Version Date : ${ALPINE_VERSION_DATE}"
echo "# PHP Version         : ${PHP_VERSION}"
echo "# PHP Version Date    : ${PHP_VERSION_DATE}"

ALPINE_RELEASE_REPOSITORY=v${ALPINE_RELEASE}

if [ ${ALPINE_RELEASE} == "edge" ]; then
    ALPINE_RELEASE_REPOSITORY=${ALPINE_RELEASE}
fi

if [ "$RELEASE" == "TEST" ]; then
    echo "Remove image ${IMAGE}:test"
    docker rmi -f ${IMAGE}:test > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${PHP_VERSION}-test"
    docker rmi -f ${IMAGE}:${PHP_VERSION}-test > /dev/null 2>&1

    echo "Build Image: ${IMAGE} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} --build-arg ALPINE_RELEASE_REPOSITORY=${ALPINE_RELEASE_REPOSITORY} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg ALPINE_VERSION_DATE=${ALPINE_VERSION_DATE} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg PHP_VERSION_DATE=${PHP_VERSION_DATE} -t ${IMAGE}:test -t ${IMAGE}:${PHP_VERSION}-test -f ./Dockerfile .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:${PHP_VERSION}-test"
    docker push ${IMAGE}:${PHP_VERSION}-test

    echo "Push Image -> ${IMAGE}:test"
    docker push ${IMAGE}:test
elif [ "$RELEASE" == "CURRENT" ]; then
    echo "Remove image ${IMAGE}:${PHP_VERSION}"
    docker rmi -f ${IMAGE}:${PHP_VERSION} > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${PHP_VERSION}-amd64"
    docker rmi -f ${IMAGE}:${PHP_VERSION}-amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${PHP_VERSION}-x86_64"
    docker rmi -f ${IMAGE}:${PHP_VERSION}-x86_64 > /dev/null 2>&1

    echo "Build Image: ${IMAGE}:${PHP_VERSION} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} --build-arg ALPINE_RELEASE_REPOSITORY=${ALPINE_RELEASE_REPOSITORY} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg ALPINE_VERSION_DATE=${ALPINE_VERSION_DATE} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg PHP_VERSION_DATE=${PHP_VERSION_DATE} -t ${IMAGE}:${PHP_VERSION} -t ${IMAGE}:${PHP_VERSION}-amd64 -t ${IMAGE}:${PHP_VERSION}-x86_64 -f ./Dockerfile .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:${PHP_VERSION}-amd64"
    docker push ${IMAGE}:${PHP_VERSION}-amd64

    echo "Push Image -> ${IMAGE}:${PHP_VERSION}-x86_64"
    docker push ${IMAGE}:${PHP_VERSION}-x86_64

    echo "Push Image -> ${IMAGE}:${PHP_VERSION}"
    docker push ${IMAGE}:${PHP_VERSION}
else
    echo "Remove image ${IMAGE}:latest"
    docker rmi -f ${IMAGE} > /dev/null 2>&1

    echo "Remove image ${IMAGE}:amd64"
    docker rmi -f ${IMAGE}:amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:x86_64"
    docker rmi -f ${IMAGE}:x86_64 > /dev/null 2>&1

    echo "Build Image: ${IMAGE} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} --build-arg ALPINE_RELEASE_REPOSITORY=${ALPINE_RELEASE_REPOSITORY} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg ALPINE_VERSION_DATE=${ALPINE_VERSION_DATE} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg PHP_VERSION_DATE=${PHP_VERSION_DATE} -t ${IMAGE}:latest -t ${IMAGE}:amd64 -t ${IMAGE}:x86_64 -f ./Dockerfile .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:amd64"
    docker push ${IMAGE}:amd64

    echo "Push Image -> ${IMAGE}:x86_64"
    docker push ${IMAGE}:x86_64

    echo "Push Image -> ${IMAGE}:latest"
    docker push ${IMAGE}:latest
fi

rm -rf ./.env
rm -rf ./settings.sh
