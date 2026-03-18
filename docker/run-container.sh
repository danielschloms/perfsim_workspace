#!/usr/bin/env bash

DOCKER_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT_DIR="$(dirname "$DOCKER_DIR")"
PROJECT_ROOT_DIRNAME="$(basename "$PROJECT_ROOT_DIR")"
IMAGE="perfsim-img"
CONTAINER_NAME="perfsim"
echo "$DOCKER_DIR"
echo "$PROJECT_ROOT_DIR"
echo "$PROJECT_ROOT_DIRNAME"
if docker ps -a --filter "status=exited" | grep -q -E " perfsim$"; then
  echo "Stopped container found, starting..."
  docker start $CONTAINER_NAME
  docker exec -it $CONTAINER_NAME bash
  exit
elif docker ps -a | grep -q -E " perfsim$"; then
  echo "Running container found, executing bash..."
  docker exec -it $CONTAINER_NAME bash
  exit
else
  docker run -it \
    -v "${PROJECT_ROOT_DIR}":"${HOME}"/"${PROJECT_ROOT_DIRNAME}" \
    -v "${HOME}"/.ssh:"${HOME}"/.ssh \
    -v /dev/dri:/dev/dri \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --net=host --pid=host --ipc=host --hostname=perfsim --add-host=perfsim:127.0.0.1 --name=perfsim -e DISPLAY=unix:0 $IMAGE
fi

echo "Goodbye"
