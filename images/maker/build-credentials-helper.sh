#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

mkdir /src

cd /src

unset GOPATH

go mod init github.com/cilium/packaging/images/maker
go get github.com/errordeveloper/docker-credential-env@v0.1.4
go build github.com/errordeveloper/docker-credential-env
