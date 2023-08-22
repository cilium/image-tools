#!/bin/bash
# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

# This image enables calling a simle scripts inlined in a pod spec as
# an environment variable `STARTUP_SCRIPT`. It will normally only call
# once. It can be use as a container, not an init container (although
# that maybe change). If pod gets restarted with the new version of
# `STARTUP_SCRIPT`, the scrips will re-run, otherwise it won't (see
# `CHECKPOINT_PATH` below).
#
# Example usage:
#
#   kind: DaemonSet
#   apiVersion: extensions/v1beta1
#   metadata:
#     name: startup-script
#     labels:
#       app: startup-script
#   spec:
#     template:
#       metadata:
#         labels:
#           app: startup-script
#       spec:
#         hostPID: true
#         containers:
#           - name: startup-script
#             image: quay.io/cilium/startup-script:<tag>
#             imagePullPolicy: Always
#             securityContext:
#               privileged: true
#             env:
#             - name: STARTUP_SCRIPT
#               value: |
#                 #! /bin/bash
#                 set -o errexit
#                 set -o pipefail
#                 set -o nounset
#                 touch /tmp/foo
#                 echo done

CHECKPOINT_PATH="${CHECKPOINT_PATH:-/tmp/startup-script.kubernetes.io_$(md5sum <<<"${STARTUP_SCRIPT}" | cut -c-32)}"
CHECK_INTERVAL_SECONDS="30"
EXEC=(nsenter -t 1 -m -u -i -n -p --)

do_startup_script() {
  local err=0;

  "${EXEC[@]}" bash -c "${STARTUP_SCRIPT}" && err=0 || err=$?
  if [[ ${err} != 0 ]]; then
    echo "!!! startup-script failed! exit code '${err}'" 1>&2
    return 1
  fi

  "${EXEC[@]}" touch "${CHECKPOINT_PATH}"
  echo "!!! startup-script succeeded!" 1>&2
  return 0
}

while :; do
  "${EXEC[@]}" stat "${CHECKPOINT_PATH}" > /dev/null 2>&1 && err=0 || err=$?
  if [[ ${err} != 0 ]]; then
    do_startup_script
  fi

  sleep "${CHECK_INTERVAL_SECONDS}"
done
