#!/usr/bin/env bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-quay.io/cilium/image-maker:1751996942-195b4d9@sha256:9ede3d0c9202b4feaa88c459e57b77bbb5dca422db065a387e58263608491c24}"

if [ "$#" -ne 1 ] ; then
  echo "$0 supports exactly 1 argument"
  exit 1
fi

root_dir="$(git rev-parse --show-toplevel)"

if [ -z "${MAKER_CONTAINER+x}" ] ; then
   exec docker run --env DOCKER_HUB_PUBLIC_ACCESS_ONLY=true --env QUAY_PUBLIC_ACCESS_ONLY=true --rm --volume "${root_dir}:/src" --workdir /src "${MAKER_IMAGE}" \
    sh -c "git config --global --add safe.directory /src && /src/scripts/$(basename "${0}") \"${1}\""
fi

crane digest "${1}" 2> /dev/null
