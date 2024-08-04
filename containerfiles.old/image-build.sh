#!/bin/bash

. my-env

case "${MY_CME}" in
  podman)
    podman image build --arch "${MY_ARCH}" -t "${MY_REGISTRY}/${MY_IMAGE}:${MY_TAG}" -f Containerfile
    ;;
  docker)
    docker image build -t "${MY_REGISTRY}/${MY_IMAGE}:${MY_TAG}" -f Containerfile .
    ;;
  *)
    echo "unknown container management engine" >&2
    exit 1
esac
