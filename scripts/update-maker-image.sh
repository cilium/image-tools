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

image_name="${1}/image-maker"

image_tag="$(WITHOUT_SUFFIX=1 "${script_dir}/make-image-tag.sh" images/maker)"

# shellcheck disable=SC2207
used_by_workflows=($(git grep -l "docker://${image_name}:" .github/workflows))

for i in "${used_by_workflows[@]}" ; do
  sed -i "s|\(docker://${image_name}\):.*\$|\1:${image_tag}|" "${i}"
done

# shellcheck disable=SC2207
used_by_scripts=($(git grep -l "MAKER_IMAGE=\"\${MAKER_IMAGE:-${image_name}:" "${script_dir}"))

for i in "${used_by_scripts[@]}" ; do
  sed -i "s|\(MAKER_IMAGE=\"\${MAKER_IMAGE:-${image_name}\):.*\(}\"\)\$|\1:${image_tag}\2|" "${i}" && chmod +x "${i}"
done
