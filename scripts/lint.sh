#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-quay.io/cilium/image-maker:53e0a6dcaf1d282c890e220ad069bbaa6cd9c72c}"

root_dir="$(git rev-parse --show-toplevel)"

if [ -z "${MAKER_CONTAINER+x}" ] ; then
   exec docker run --rm --volume "${root_dir}:/src" --workdir /src "${MAKER_IMAGE}" \
    sh -c "git config --global --add safe.directory /src && /src/scripts/$(basename "${0}")"
fi

cd "${root_dir}"
find . -name '*.sh' -exec shellcheck {} +
find . -name Dockerfile -exec hadolint {} +
