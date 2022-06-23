#!/bin/bash

# Copyright 2017-2021 Authors of Cilium
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

image="${1:-docker.io/library/golang:1.18.3}"

image_digest="$("${script_dir}/get-image-digest.sh" "${image}")"

# shellcheck disable=SC2207
used_by=($(git grep -l GOLANG_IMAGE= images))

for i in "${used_by[@]}" ; do
  sed "s|\(GOLANG_IMAGE=\)docker.io/library/golang:.*\$|\1${image}@${image_digest}|" "${i}" > "${i}.sedtmp" && mv "${i}.sedtmp" "${i}"
done
