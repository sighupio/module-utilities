#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -e

echo "🚀 Creating E2E Test Cluster for Module UI"
echo "=========================================="

# Configuration (CI provides these, local uses defaults from mise.toml)
KUBE_VERSION="${KUBE_VERSION:-1.33.0}"
export DRONE_BUILD_NUMBER="${DRONE_BUILD_NUMBER:-9999}"
export DRONE_REPO_NAME="${DRONE_REPO_NAME:-module-ui}"
CLUSTER_NAME="${DRONE_REPO_NAME}-${DRONE_BUILD_NUMBER}-${KUBE_VERSION}"
KUBECONFIG_PATH="${KUBECONFIG:-$(pwd)/kubeconfig-e2e}"

echo "📦 Step 1: Creating Kind cluster (K8s ${KUBE_VERSION})..."
kind create cluster \
  --config ./katalog/tests/kind/config.yml \
  --name "${CLUSTER_NAME}" \
  --image "kindest/node:v${KUBE_VERSION}"

echo "📋 Step 2: Setting up kubeconfig..."
kind get kubeconfig --name "${CLUSTER_NAME}" > "${KUBECONFIG_PATH}"
export KUBECONFIG="${KUBECONFIG_PATH}"

echo "⏳ Step 3: Waiting for cluster to be ready..."
until kubectl get serviceaccount default > /dev/null 2>&1; do
  echo "   Waiting for control-plane..."
  sleep 2
done

echo "✅ E2E cluster created successfully!"
echo "   Cluster: ${CLUSTER_NAME}"
echo "   Kubeconfig: ${KUBECONFIG_PATH}"
