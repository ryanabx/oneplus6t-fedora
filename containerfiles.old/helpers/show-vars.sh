#!/bin/bash

show_var() {
  local VARNAME="${@}"
  echo "${VARNAME}: ${!VARNAME}"
}

for VAR in MY_REGISTRY MY_IMAGE MY_TAG MY_CONTAINER
do
  show_var "${VAR}"
done

