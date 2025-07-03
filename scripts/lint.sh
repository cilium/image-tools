#!/usr/bin/env bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-quay.io/cilium/image-maker:1755027480-74de989@sha256:be90a4b1ccb7553e54f8eb8224a82a5f886cdbd6057dafc9d36205615f46d696}"

root_dir="$(git rev-parse --show-toplevel)"

if [ -z "${MAKER_CONTAINER+x}" ] ; then
   exec docker run --rm --volume "${root_dir}:/src" --workdir /src "${MAKER_IMAGE}" \
    sh -c "git config --global --add safe.directory /src && /src/scripts/$(basename "${0}")"
fi

cd "${root_dir}"
find . -name '*.sh' -exec shellcheck {} +
find . -name Dockerfile -exec hadolint {} +
