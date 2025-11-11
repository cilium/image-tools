#!/usr/bin/env bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

DOCKERFILE=$(dirname "$0")/Dockerfile
VERSION=$(sed -n 's/ARG IPERF_VERSION="\([^"]*\)"/\1/p' "$DOCKERFILE")
echo "${VERSION}"
