#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-docker.io/cilium/maker:21ef672a968d35ba113764705ddbfb32325afb05}"

if [ "$#" -ne 5 ] ; then
  echo "$0 supports exactly 5 argument"
  exit 1
fi

root_dir="$(git rev-parse --show-toplevel)"

cd "${root_dir}"

image_name="${1}"
image_dir="${2}"

platform="${3}"
output="${4}"
builder="${5}"

image_tag="$("${root_dir}/scripts/make-image-tag.sh" "${image_dir}")"

check_tag_exists() {
  if [ -n "${MAKER_CONTAINER+x}" ] ; then
    crane ls "${image_name}" 2> /dev/null | grep -q "${image_tag}"
  else
    # unlike with other utility scripts we don't want to selt-re-exec inside container, as native `docker buildx` is preferred
    docker run --rm --volume "$(pwd):/src" --workdir /src "${MAKER_IMAGE}" crane ls "${image_name}" 2> /dev/null | grep -q "${image_tag}"
  fi
}

do_build="${FORCE:-false}"

if [ "${do_build}" = "true" ] ; then
  echo "will force-build ${image_name}:${image_tag} without checking the registry"
fi

if [ "${do_build}" = "false" ] ; then
  case "${image_tag}" in
    *-dev)
      echo "will build ${image_name}:${image_tag} as it has dev suffix"
      do_build="true"
      ;;
    *-wip)
      echo "will build ${image_name}:${image_tag} as it has wip suffix"
      do_build="true"
      ;;
    *)
      if check_tag_exists ; then
        echo "image ${image_name}:${image_tag} is already present in the registry"
        exit 0
      else
        echo "will build ${image_name}:${image_tag} as it is a new version"
        do_build="true"
      fi
      ;;
  esac
fi

if [ "${do_build}" = "true" ] ; then
  echo "building ${image_name}:${image_tag}"
  set -o xtrace
  docker buildx build \
    --tag "${image_name}:${image_tag}" \
    --platform "${platform}" \
    --output "${output}" \
    --builder "${builder}" \
      "${image_dir}"
fi
