#!/bin/bash

set -e

for DIR in op6-fedora op6-fedora-phosh op6-fedora-plasma-mobile
do
  pushd "${DIR}"
    ../image-build.sh
    ../image-push.sh
  popd
done

