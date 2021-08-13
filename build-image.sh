#!/usr/bin/env bash

#### halt script on error
set -xe

git clone https://github.com/springjk/web-dev-docker.git
cd web-dev-docker

echo '##### Print docker version'
docker --version

echo '##### Print environment'
env | sort


#### Build the Docker Images

echo  build version is ${NODE_VERSION}


docker build  --build-arg NODE_VERSION=${NODE_VERSION}  -t webdev .
#####################################

# push to docker hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker tag webdev:latest ${DOCKER_USERNAME}/webdev:latest

docker images

docker push ${DOCKER_USERNAME}/webdev

if [[ ${NODE_VERSION} != "latest" && ${NODE_VERSION} != "NA" ]]; then
    # push build version
    docker tag ${DOCKER_USERNAME}/webdev:latest ${DOCKER_USERNAME}/webdev:${NODE_VERSION}
    docker push ${DOCKER_USERNAME}/webdev:${NODE_VERSION}
fi


# push to aliyun docker hub
echo "$ALIYUN_DOCKER_PASSWORD" | docker login -u "$ALIYUN_DOCKER_USERNAME" --password-stdin registry.cn-hangzhou.aliyuncs.com

docker tag webdev:latest registry.cn-hangzhou.aliyuncs.com/${DOCKER_USERNAME}/webdev:latest

docker images

docker push registry.cn-hangzhou.aliyuncs.com/${DOCKER_USERNAME}/webdev

if [[ ${NODE_VERSION} != "latest" && ${NODE_VERSION} != "NA" ]]; then
    # push build version
    docker tag ${DOCKER_USERNAME}/webdev:latest registry.cn-hangzhou.aliyuncs.com/${DOCKER_USERNAME}/webdev:${NODE_VERSION}
    docker push registry.cn-hangzhou.aliyuncs.com/${DOCKER_USERNAME}/webdev:${NODE_VERSION}
fi