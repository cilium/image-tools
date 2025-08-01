#!/bin/bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

MAKER_IMAGE="${MAKER_IMAGE:-quay.io/cilium/image-maker:e55375ca5ccaea76dc15a0666d4f57ccd9ab89de}"

with_root_context="${ROOT_CONTEXT:-false}"

if [ "$#" -lt 5 ] ; then
  echo "$0 supports minimum 5 argument"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

root_dir="$(git rev-parse --show-toplevel)"

cd "${root_dir}"

image_name="${1}"
image_dir="${2}"

platform="${3}"
builder="${4}"

shift 4

registries=("${@}")

do_build="${FORCE:-false}"

do_push="${PUSH:-false}"
output="type=image,push=${do_push}"

if [ "${do_push}" == "false" ]; then
  export DOCKER_HUB_PUBLIC_ACCESS_ONLY=true
  export QUAY_PUBLIC_ACCESS_ONLY=true
fi

do_export="${EXPORT:-false}"

if [ "${with_root_context}" = "false" ] ; then
  image_tag="$("${script_dir}/make-image-tag.sh" "${image_dir}")"
else
  image_tag="$("${script_dir}/make-image-tag.sh")"
fi

if [ "${registries[*]}" = "local" ] ; then
  echo "will build ${image_name}:${image_tag} due to local mode"
  output="type=docker"
  do_build="true"
fi

if [ "${do_export}" = "true" ] ; then
  output="type=docker,dest=${image_name}.oci"
fi

tag_args=()
for registry in "${registries[@]}" ; do
  tag_args+=(--tag "${registry}/${image_name}:${image_tag}")
done

check_image_tag() {
  if [ -n "${MAKER_CONTAINER+x}" ] || [ "${image_name}" == "image-maker" ] ; then
    which crane || (echo "WARNING: crane expected but not found, unable to check if image tag exists" ; return 1)
    crane digest "${1}" || (echo "error: crane returned $?" ; return 1)
  else
    # unlike with other utility scripts we don't want to self-re-exec inside the container, as native `docker buildx` is preferred
    docker run --env DOCKER_HUB_PUBLIC_ACCESS_ONLY=true --env QUAY_PUBLIC_ACCESS_ONLY=true --rm --volume "${root_dir}:/src" --workdir /src "${MAKER_IMAGE}" crane digest "${1}" || (echo "error: crane returned $?" ; return 1)
  fi
}

check_registries() {
  for registry in "${registries[@]}" ; do
    if [ "${registry}" = "local" ] ; then
      continue
    fi
    i="${registry}/${image_name}:${image_tag}"
    if ! check_image_tag "${i}" ; then
      echo "${i} doesn't exist"
      return 1
    fi
  done
}


if [ "${do_build}" = "true" ] ; then
  echo "will force-build ${image_name}:${image_tag} without checking the registries"
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
      if check_registries ; then
        echo "image ${image_name}:${image_tag} is already present in all of the registries"
        exit 0
      else
        echo "will build ${image_name}:${image_tag} as it's either a new version or not present in all of the registries"
        do_build="true"
      fi
      ;;
  esac
fi

do_test="${TEST:-false}"

run_buildx() {
  build_args=(
    "--platform=${platform}"
    "--builder=${builder}"
    "--file=${image_dir}/Dockerfile"
  )
  if [ "${with_root_context}" = "false" ] ; then
    build_args+=("${image_dir}")
  else
    build_args+=("${root_dir}")
  fi
  if [ "${do_test}" = "true" ] ; then
    if ! docker buildx build --target=test "${build_args[@]}" ; then
      exit 1
    fi
  fi
  docker buildx build --output="${output}" "${tag_args[@]}" "${build_args[@]}"
}

if [ "${do_build}" = "true" ] ; then
  echo "building ${image_name}:${image_tag}"
  set -o xtrace
  if ! run_buildx ; then
    if [ -n "${DEBUG+x}" ] ; then
      buildkitd_container="$(docker ps --filter "ancestor=moby/buildkit:buildx-stable-1" --filter "name=${builder}" --format "{{.ID}}")"
      docker logs "${buildkitd_container}"
    fi
    exit 1
  fi
fi
