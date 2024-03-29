# Registry Data Generator
Generate uniquely named Docker images made up of unique layers with a given layer size and number of layers (`layer size` X `number of layers` = `image total size`) and upload them to a registry.

The build and upload can run in parallel processes for increased resource utilization and time savings.

## Use case
I use this to upload unique container images and load test a registry.

## Design
The generator runs locally using your installed Docker engine or in a Docker container (based on `docker:dind`), generating images using pre-defined parameters and then uploads to the set registry.

## Variables
The following environment variables are used to configure the execution

|         Variable        |           Description                             |   Default                       |
|-------------------------|---------------------------------------------------|---------------------------------|
| `NUMBER_OF_IMAGES`      | Total number of unique images to create           | `1`                             |
| `NUMBER_OF_LAYERS`      | Number of layers per image                        | `1`                             |
| `SIZE_OF_LAYER_KB`      | Size in KB of each layer                          | `1`                             |
| `NUM_OF_THREADS`        | Number of parallel processes to run               | `1`                             |
| `TAG`                   | Tag for the generated image                       | `1`                             |
| `REGISTRY_URI`          | The registry to push the built images to          | (Must pass value or will fail)  |
| `INSECURE_REGISTRY`     | Allow insecure registry connection                | `false`                         |
| `REPO_PATH`             | Path under `REGISTRY_URI` to push images to       | `docker-auto`                   |
| `REMOVE_IMAGES`         | Remove created images from host                   | `true`                          |
| `DEBUG`                 | Provide debug output (shell set -x)               | ``                              |

## Build an image
Build the generator Docker image
```shell
export REGISTRY=
export REPOSITORY=
export IMAGE_TAG=

docker build -t ${REGISTRY}/${REPOSITORY}:${IMAGE_TAG} .
```

## Running Generator 

### Run In Local Shell
You can run the generator directly with your Docker engine
1. Copy `templates/env-default.sh` to `env.sh` (if not copied, it will be copied with its current values in the first run)
2. Edit `env.sh` to adjust your configuration
3. Run the script
```shell
./run-local.sh
```

### Run In A Docker container
You can run the Docker container directly on your Docker enabled host (currently needs docker socket access or `--privileged` flag to work).<br>
You can use the already built image `eldada.jfrog.io/docker/docker-data-generator:0.16`
```shell
# Example for creating 100 images with 10 layers 1MB each and uploading to docker.artifactory/test
# in 3 parallel sub processes (the 100 images are slit between the processes).
export REGISTRY=eldada.jfrog.io/docker
export REPOSITORY=docker-data-generator
export IMAGE_TAG=0.16

export NUMBER_OF_IMAGES=100
export NUMBER_OF_LAYERS=10
export SIZE_OF_LAYER_KB=1024
export NUM_OF_THREADS=3
export TAG=1
export REGISTRY_URI=docker.artifactory
export INSECURE_REGISTRY=true
export REPO_PATH=test
export REMOVE_IMAGES=true
export DEBUG=

docker run --rm --name registry-data-gen \
    -e NUMBER_OF_IMAGES=${NUMBER_OF_IMAGES} \
    -e NUMBER_OF_LAYERS=${NUMBER_OF_LAYERS} \
    -e SIZE_OF_LAYER_KB=${SIZE_OF_LAYER_KB} \
    -e NUM_OF_THREADS=${NUM_OF_THREADS} \
    -e TAG=${TAG} \
    -e REGISTRY_URI=${REGISTRY_URI} \
    -e INSECURE_REGISTRY=${INSECURE_REGISTRY} \
    -e REPO_PATH=${REPO_PATH} \
    -e REMOVE_IMAGES=${REMOVE_IMAGES} \
    -e DEBUG=${DEBUG} \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ${REGISTRY}/${REPOSITORY}:${IMAGE_TAG}
```

### Run in Kubernetes with provided Helm chart
It's possible to deploy the registry data generator with the helm chart in [registry-data-generator](registry-data-generator).

It's recommended to prepare a custom `values.yaml` file for each scenario with the custom `env` needed. See [values-example-1gb.yaml](registry-data-generator/values-example-1gb.yaml) as example.

**IMPORTANT:** Be aware that the Job is set to run with `privileged: true`
```
...
    securityContext:
      privileged: true
...
```

#### Deploy
**IMPORTANT:** The Job deployed in K8s is not removed after completed, so you'll need to remove a deployed release before deploying again

Example using the [values-example-1gb.yaml](registry-data-generator/values-example-1gb.yaml) as custom parameters
```shell
# Deploy
cd registry-data-generator
helm install --upgrade data-gen -f values-example-1gb.yaml .

# Remove once done
helm uninstall data-gen
```


#### Attribution
This project is based on [docker-image-generator](https://github.com/eldada/docker-image-generator). Big thank you to [@eldada](https://github.com/eldada) for all the hard work.