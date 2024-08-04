#!/bin/bash

. my-env

podman container start -a -i "${MY_CONTAINER}"
