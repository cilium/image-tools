#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-docker.io/cilium/image-maker:2831b3fa8bc8a1412ed8eb59b158a123fe0459ef}"

if [ -z "${MAKER_CONTAINER+x}" ] ; then
   exec docker run --rm --volume "$(pwd):/src" --workdir /src "${MAKER_IMAGE}" "/src/scripts/$(basename "${0}")"
fi

find . -name '*.sh' -exec shellcheck {} +
find . -name Dockerfile -exec hadolint {} +
