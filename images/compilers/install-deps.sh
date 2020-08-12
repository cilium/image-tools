#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

packages=(
  automake
  binutils
  binutils-aarch64-linux-gnu
  bison
  build-essential
  ca-certificates
  cmake
  crossbuild-essential-arm64
  curl
  flex
  g++
  g++-aarch64-linux-gnu
  gcc
  gcc-aarch64-linux-gnu
  git
  libelf-dev
  libelf-dev:arm64
  libmnl-dev
  libtool
  make
  ninja-build
  pkg-config
  pkg-config-aarch64-linux-gnu
  python2
  python3
  python3-pip
  unzip
)

export DEBIAN_FRONTEND=noninteractive

cat > /etc/apt/sources.list << EOF
deb [arch=amd64] http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb [arch=amd64] http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse
deb [arch=amd64] http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ focal main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ focal-security main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ focal-backports main restricted universe multiverse
EOF

dpkg --add-architecture arm64

apt-get update

ln -fs /usr/share/zoneinfo/UTC /etc/localtime

apt-get install -y --no-install-recommends "${packages[@]}"

update-alternatives --install /usr/bin/python python /usr/bin/python2 1
