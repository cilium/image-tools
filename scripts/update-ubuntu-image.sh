#!/bin/bash

# Copyright 2021 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

if [ "$#" -gt 1 ] ; then
  echo "$0 supports at most 1 argument"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

root_dir="$(git rev-parse --show-toplevel)"

cd "${root_dir}"

image="${1:-docker.io/library/ubuntu:22.04}"

image_digest="$("${script_dir}/get-image-digest.sh" "${image}")"

# shellcheck disable=SC2207
used_by=($(git grep -l UBUNTU_IMAGE= images))

for i in "${used_by[@]}" ; do
  sed "s|\(UBUNTU_IMAGE=\)docker.io/library/ubuntu:.*\$|\1${image}@${image_digest}|" "${i}" > "${i}.sedtmp" && mv "${i}.sedtmp" "${i}"
done
