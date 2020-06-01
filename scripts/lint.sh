#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-docker.io/cilium/image-maker:391ddcd9a463f4056546f298965722764aee5b43}"

if [ -z "${MAKER_CONTAINER+x}" ] ; then
   exec docker run --rm --volume "$(pwd):/src" --workdir /src "${MAKER_IMAGE}" "/src/scripts/$(basename "${0}")"
fi

find . -name '*.sh' -exec shellcheck {} +
find . -name Dockerfile -exec hadolint {} +
