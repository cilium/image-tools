#!/bin/bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

# This script find the commit hash for a given subdir tree hash.
# It can be used to find what commit in the subdir was used to build a given image tag.

# TODO: allow different modes, e.g.
# - show last revision of top-level tree for the given sudir hash, which would encompas
#   top-level changees since e.g. `.github` and `scripts` etc

if [ "$#" -gt 2 ] ; then
  echo "$0 supports exactly 2 arguments - tree hash & subdir"
  exit 1
fi

tree_hash="${1}"
dir="${2}"

for i in $(git rev-list @ -- "${dir}") ; do
  if git ls-tree --full-tree "${i}" -- "${dir}" | grep -q "${tree_hash}" ; then
    echo "${i}"
    exit 0
  fi
done

exit 1
