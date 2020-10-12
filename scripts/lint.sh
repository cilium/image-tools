#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-docker.io/cilium/image-maker:dfa9d802a6575eca2da064a4ccb6356079a81c91}"

root_dir="$(git rev-parse --show-toplevel)"

if [ -z "${MAKER_CONTAINER+x}" ] ; then
   exec docker run --rm --volume "${root_dir}:/src" --workdir /src "${MAKER_IMAGE}" "/src/scripts/$(basename "${0}")"
fi

cd "${root_dir}"
find . -name '*.sh' -exec shellcheck {} +
find . -name Dockerfile -exec hadolint {} +
