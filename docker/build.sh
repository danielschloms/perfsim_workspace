#!/bin/bash

DOCKER_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd $DOCKER_DIR || exit
echo "Building Ubuntu 24.04 image for performance estimation"
docker build -t perfsim-img --build-arg USERNAME=$USER --build-arg USER_UID=$UID --build-arg USER_GID=$(id -g $USER) .
