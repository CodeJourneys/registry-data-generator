#!/usr/bin/env bash

# Example configuration for the generator
# Copy this file to env.sh and set your desired configuration

# Configuration parameters
# Set these to override the defaults.
export NUMBER_OF_IMAGES=1
export NUMBER_OF_LAYERS=1
export SIZE_OF_LAYER_KB=1
export NUM_OF_THREADS=1
export REGISTRY_URI=localhost:8082
export INSECURE_REGISTRY=false
export DOCKER_USER=admin
export DOCKER_PASSWORD=password
export REPO_PATH=docker-local
export REMOVE_IMAGES=true
export TAG=0.1
export DEBUG=false

# Optional override script paths
# Set these to add additional functionality, such as customizing the Docker daemon or authenticating to the registry.

export DOCKERD_CUSTOMIZE_SCRIPT_PATH=""         # Path to a script to customize the Docker daemon. See templates/dockerd-customize-default.sh for an example.
export AUTH_SCRIPT_PATH=""                      # Path to a script to authenticate to the registry. See templates/auth/auth-docker-default.sh for an example.