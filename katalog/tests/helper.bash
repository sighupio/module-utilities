#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2086,SC2154,SC2034

set -o pipefail

# Module root, resolved from this test file's location: tests -> katalog -> root.
REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"

build() {
  kustomize build "$1"
}

apply() {
  kustomize build "$1" >&2
  kustomize build "$1" | kubectl apply -f - --server-side 2>&3
}

delete() {
  kustomize build "$1" | kubectl delete -f - 2>&3 || true
}

info() {
  echo -e "${BATS_TEST_NUMBER}: ${BATS_TEST_DESCRIPTION}" >&3
}

loop_it() {
  retry_counter=0
  max_retry=${2:-100}
  wait_time=${3:-2}
  run ${1}
  ko=${status}
  loop_it_result=${ko}
  while [[ ko -ne 0 ]]; do
    if [ $retry_counter -ge $max_retry ]; then echo "Timeout waiting a condition"; return 1; fi
    sleep ${wait_time} && echo "# waiting..." $retry_counter >&3
    run ${1}
    ko=${status}
    loop_it_result=${ko}
    retry_counter=$((retry_counter + 1))
  done
  return 0
}

check_deploy_ready() {
  local name=$1
  local namespace=$2
  local replicas ready_replicas
  replicas=$(kubectl get deploy "$name" -n "$namespace" -o jsonpath='{.status.replicas}' 2>/dev/null || echo "0")
  ready_replicas=$(kubectl get deploy "$name" -n "$namespace" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
  [ "$replicas" == "$ready_replicas" ] && [ "$replicas" -gt 0 ]
}

# HTTP status code for a request (insecure TLS), optionally with basic-auth creds in $2.
http_status() {
  local url=$1
  local creds=${2:-}
  if [ -n "$creds" ]; then
    curl -k -s -o /dev/null -w "%{http_code}" -u "$creds" "$url"
  else
    curl -k -s -o /dev/null -w "%{http_code}" "$url"
  fi
}
