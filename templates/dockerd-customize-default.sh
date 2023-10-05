#!/usr/bin/env bash

# Start the Docker daemon
echo "Starting docker daemon"
dockerd-entrypoint.sh ${INSECURE_REGISTRY_FLAG} > /dev/null 2>&1 &
DOCKER_PID=$!
disown ${DOCKER_PID}

# Allow time for daemon to start
echo "Allowing time for docker daemon to come up"
sleep 10