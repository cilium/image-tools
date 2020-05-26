#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

# This script provides two image tagging mechanisms.
#
# For general images that use most of the tree as input, it's most sensible to
# use git commit hash as a tag.
#
# For images that use contents of a subdirectory as input, it's convenient to use
# a git tree hash. Running `git show` with tree hash based tag will display the
# contents of the subdirectory that was used as build input, mitigating any doubts
# in what was used to build this image.
#
# For both types of tags To differentiate any non-authoritative builds, i.e.
# builds from development branches, `-dev` suffix is added. Any builds that may
# include uncommitted changes will have `-wip` tag.

# TODO: determine when the head is also a release tag; that it can be done with
# `git name-rev --name-only --tags --no-undefined HEAD` however Cilium usually
# gets two tags one with `v` prefix and one without, beacause of that the output
# of `git name-rev` maybe one or the other; to implement that with certainty
# release process/automation needs to be reviewed in detail

if [ "$#" -gt 1 ] ; then
  echo "$0 supports exactly 1 or no arguments"
  exit 1
fi

root_dir="$(git rev-parse --show-toplevel)"

cd "${root_dir}"

if [ "$#" -eq 1 ] ; then
  # if one argument was given, assume it's a directory and obtain a tree hash
  image_dir="${1}"
  if ! [ -d "${image_dir}" ] ; then
    echo "${image_dir} is not a directory (path is relative to git root)"
    exit 1
  fi
  git_ls_tree="$(git ls-tree --full-tree HEAD -- "${image_dir}")"
  if [ -z "${git_ls_tree}" ] ; then
    echo "${image_dir} exists, but it is not checked in git (path is relative to git root)"
    exit 1
  fi
  tag="$(printf "%s" "${git_ls_tree}" | sed 's/^[0-7]\{6\} tree \([0-9a-f]\{40\}\).*/\1/')"
else
  # if no arguments are given, use commit hash
  image_dir="${root_dir}"
  tag="$(git rev-parse --short HEAD)"
fi

if [ -z "${WITHOUT_SUFFIX+x}" ] ; then
  if ! git merge-base --is-ancestor "$(git rev-parse HEAD)" origin/master ; then
    tag="${tag}-dev"
  fi

  if [ "$(git status --porcelain "${image_dir}" | wc -l)" -gt 0 ] ; then
    tag="${tag}-wip"
  fi
fi

printf "%s" "${tag}"
