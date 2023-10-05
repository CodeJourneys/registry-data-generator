#!/usr/bin/env bash

# Login to registry
echo "Docker login to ${REGISTRY_URI}"
docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${REGISTRY_URI} || errorExit "Docker login failed."