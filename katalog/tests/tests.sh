#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2154

# Headlamp katalog test suite.
#
# Render checks are always run (deterministic, no cluster needed).
# Deploy/functional checks need a cluster with the SD-UI image available and an NGINX
# ingress controller; they self-skip when prerequisites are missing.
#
# Env knobs:
#   HEADLAMP_IMAGE   override the image before deploying (e.g. a locally-loaded build)
#   HEADLAMP_HOST    routable host for the token-auth ingress; enables the live reachability
#                    assertion (e.g. headlamp.<NIP_DOMAIN>)
#   LOCAL_DEV_ENV    when set, the cleanup test tears the overlays down again

load helper

set -o pipefail

@test "render: katalog/headlamp builds" {
  info
  build "${REPO_ROOT}/katalog/headlamp"
}

@test "render: examples/token-auth builds" {
  info
  build "${REPO_ROOT}/examples/token-auth"
}

@test "render: examples/oidc-capsule builds" {
  info
  build "${REPO_ROOT}/examples/oidc-capsule"
}

@test "render: examples/oidc-rbac builds" {
  info
  build "${REPO_ROOT}/examples/oidc-rbac"
}

@test "apply: token-auth overlay" {
  info
  # The committed overlay uses a placeholder host and the published image. For a live run,
  # HEADLAMP_HOST swaps in a routable host and HEADLAMP_IMAGE a locally-loaded build.
  rendered=$(build "${REPO_ROOT}/examples/token-auth")
  if [ -n "${HEADLAMP_HOST}" ]; then
    rendered=$(echo "$rendered" | sed "s/headlamp.example.com/${HEADLAMP_HOST}/g")
  fi
  if [ -n "${HEADLAMP_IMAGE}" ]; then
    rendered=$(echo "$rendered" | sed "s#registry.sighup.io/fury/sd-ui:[^[:space:]\"]*#${HEADLAMP_IMAGE}#g")
  fi
  echo "$rendered" >&2
  echo "$rendered" | kubectl apply -f - --server-side 2>&3
}

@test "object: ClusterRoleBinding and Ingress exist" {
  info
  kubectl get clusterrolebinding headlamp-admin
  kubectl -n headlamp get ingress headlamp
}

@test "object: ingress has no ingress-level auth annotations" {
  info
  at=$(kubectl -n headlamp get ingress headlamp -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/auth-type}')
  [ -z "$at" ]
}

@test "deploy: headlamp becomes ready" {
  info
  if ! kubectl -n headlamp get deploy headlamp >/dev/null 2>&1; then skip "headlamp deployment not present"; fi
  test() { check_deploy_ready "headlamp" "headlamp"; }
  loop_it test 60 5
  [[ "${loop_it_result}" -eq 0 ]]
}

@test "live: ingress serves the Headlamp UI (200)" {
  info
  if [ -z "${HEADLAMP_HOST}" ]; then skip "set HEADLAMP_HOST to run the live reachability check"; fi
  url="https://${HEADLAMP_HOST}"
  test_200() { [ "$(http_status "$url")" == "200" ]; }
  loop_it test_200 30 5
  [[ "${loop_it_result}" -eq 0 ]]
}

@test "cleanup" {
  if [ -z "${LOCAL_DEV_ENV}" ]; then skip; fi
  delete "${REPO_ROOT}/examples/token-auth"
}
