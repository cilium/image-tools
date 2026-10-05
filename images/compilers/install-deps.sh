#!/bin/bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

packages=(
  automake
  binutils
  bison
  build-essential
  ca-certificates
  cmake
  curl
  flex
  g++
  gcc
  git
  libelf-dev
  libmnl-dev
  libtool
  make
  ninja-build
  pkg-config
  python3
  python3-pip
  unzip
)

packages_amd64=(
  binutils-aarch64-linux-gnu
  crossbuild-essential-arm64
  g++-aarch64-linux-gnu
  gcc-aarch64-linux-gnu
  libelf-dev:arm64
)

export DEBIAN_FRONTEND=noninteractive

if [ "$(uname -m)" == "x86_64" ] ; then
  dpkg --add-architecture arm64
fi

apt-get update

ln -fs /usr/share/zoneinfo/UTC /etc/localtime

apt-get install -y --no-install-recommends "${packages[@]}"
if [ "$(uname -m)" == "x86_64" ] ; then
  apt-get install -y --no-install-recommends "${packages_amd64[@]}"
fi
