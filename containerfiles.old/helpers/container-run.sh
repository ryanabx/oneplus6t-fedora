#!/bin/bash

. my-env

podman container run --arch "${MY_ARCH}" -it --name "${MY_CONTAINER}" "${MY_REGISTRY}/${MY_IMAGE}:${MY_TAG}"
