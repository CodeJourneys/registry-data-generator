#!/usr/bin/env bash

# Login to registry
echo "Docker login to ${DOCKER_REGISTRY}"
docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY} || errorExit "Docker login failed."