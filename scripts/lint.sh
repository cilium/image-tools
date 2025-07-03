#!/usr/bin/env bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-quay.io/cilium/image-maker:1751527462-bb24228@sha256:b17984cf427f921c65409816b8890bbf893ea44a42c226a3a56aca90f3205939}"

root_dir="$(git rev-parse --show-toplevel)"

if [ -z "${MAKER_CONTAINER+x}" ] ; then
   exec docker run --rm --volume "${root_dir}:/src" --workdir /src "${MAKER_IMAGE}" \
    sh -c "git config --global --add safe.directory /src && /src/scripts/$(basename "${0}")"
fi

cd "${root_dir}"
find . -name '*.sh' -exec shellcheck {} +
find . -name Dockerfile -exec hadolint {} +
