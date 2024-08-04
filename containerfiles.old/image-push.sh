#!/bin/bash

. my-env

case "${MY_CME}" in
  podman)
    podman image push "${MY_REGISTRY}/${MY_IMAGE}:${MY_TAG}"
    ;;
  docker)
    docker image push "${MY_REGISTRY}/${MY_IMAGE}:${MY_TAG}"
    ;;
  *)
    echo "unknown container management engine" >&2
    exit 1
esac
