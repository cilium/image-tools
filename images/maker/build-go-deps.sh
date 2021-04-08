#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

cd /src

unset GOPATH

export CGO_ENABLED=0

mkdir -p /out/usr/local/bin

go mod download
go build -ldflags '-s -w' -o /out/usr/local/bin/docker-credential-env github.com/errordeveloper/docker-credential-env
go build -ldflags '-s -w' -o /out/usr/local/bin/imagine github.com/errordeveloper/imagine
go build -ldflags '-s -w' -o /out/usr/local/bin/kg github.com/errordeveloper/kue/cmd/kg
go build -ldflags '-s -w' -o /out/usr/local/bin/docker-buildx github.com/docker/buildx/cmd/buildx
