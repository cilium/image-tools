#!/bin/bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

cd /src

unset GOPATH
export CGO_ENABLED=0
export GOBIN=/out/usr/local/bin
mkdir -p $GOBIN

go install -ldflags '-s -w' github.com/errordeveloper/docker-credential-env@v0.1.5
go install -ldflags '-s -w' github.com/docker/buildx/cmd/buildx@v0.13.1
mv $GOBIN/buildx $GOBIN/docker-buildx
