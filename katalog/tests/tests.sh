#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2154

# Headlamp katalog test suite.
#
# The render checks always run and do not need a cluster.
# The deploy checks need a cluster that can pull the sd-ui image. The live check also needs
# an NGINX ingress controller. The checks are skipped when their requirements are missing.
#
# Environment variables:
#   HEADLAMP_IMAGE   image to deploy instead of the default (for example a build loaded in kind)
#   HEADLAMP_HOST    host for the token-auth Ingress that the test can reach. It enables the
#                    live check (for example headlamp.<NIP_DOMAIN>)
#   LOCAL_DEV_ENV    when set, the cleanup test deletes the overlays

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
  # The overlay uses a placeholder host and the published image. For a live run,
  # HEADLAMP_HOST sets a host that the test can reach and HEADLAMP_IMAGE sets a local build.
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
