#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

if [ "$#" -ne 1 ] ; then
  echo "$0 supports exactly 1 argument"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

root_dir="$(git rev-parse --show-toplevel)"

cd "${root_dir}"

image_name="${1}/image-tester"

image_tag="$(WITHOUT_SUFFIX=1 "${script_dir}/make-image-tag.sh" images/tester)"

image_digest="$("${script_dir}/get-image-digest.sh" "${image_name}:${image_tag}")"

# shellcheck disable=SC2207
used_by=($(git grep -l TESTER_IMAGE= images))

for i in "${used_by[@]}" ; do
  sed -i "s|\(TESTER_IMAGE=${image_name}\):.*\$|\1:${image_tag}@${image_digest}|" "${i}"
done
