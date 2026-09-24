# Headlamp

<!-- <SD-DOCS> -->

[Headlamp](https://headlamp.dev) is a web UI for Kubernetes. This package deploys the
**SIGHUP Distribution build of Headlamp** - the upstream Headlamp server bundled with the
SD plugins (alerts, certificates, events, logs, backups, policy, …) - into an SD cluster.

This `katalog/headlamp` package is intentionally **auth-agnostic**: it ships only the
Namespace, ServiceAccount, Service and Deployment. It deliberately does **not** include an
Ingress, a `ClusterRoleBinding`, or any front-door authentication. How users reach and
authenticate to the UI is an overlay concern - see the ready-made overlays under
[`examples/`](../../examples):

- [`examples/token-auth`](../../examples/token-auth) - a `ClusterRoleBinding` granting the
  Headlamp ServiceAccount cluster access, over a plain TLS ingress. Headlamp talks directly
  to the API server as a single identity; access is gated by Headlamp's own Kubernetes token
  login.
- [`examples/oidc-capsule`](../../examples/oidc-capsule) - Headlamp behind Pomerium SSO,
  with requests proxied to Capsule Proxy for per-tenant filtering (the pattern used by the
  SD dev environment).

## Requirements

- Kubernetes >= `1.33.0`
- Kustomize >= `v5.0.0`

## Image repository and tag

- Headlamp + SD plugins image: `registry.sighup.io/fury/sd-ui`
- Built from the SD-UI source repository's `Dockerfile` (Headlamp base image + pre-built
  plugin `dist/main.js` bundles): https://github.com/sighupio/new-sd-ui

Pin a specific build by editing the `images:` transformer in `kustomization.yaml`, or:

```shell
kustomize edit set image registry.sighup.io/fury/sd-ui=registry.sighup.io/fury/sd-ui:<tag>
```

## Configuration

The base Deployment runs Headlamp with:

```
-in-cluster
-plugins-dir=/headlamp/plugins
```

so it authenticates to the in-cluster API server with its own ServiceAccount token. The
ServiceAccount has **no** RBAC bound by this package - grant access in an overlay (e.g. a
`ClusterRoleBinding`) appropriate to your access model.

- Namespace: `headlamp`
- Service: `ClusterIP` on port `80`, targeting the container's `http` port (`4466`)

## Deployment

This package is not meant to be applied directly (it has no front door). Apply one of the
overlays instead:

```shell
kustomize build examples/token-auth | kubectl apply -f -
# or
kustomize build examples/oidc-capsule | kubectl apply -f -
```

To render just the base:

```shell
kustomize build katalog/headlamp
```

<!-- </SD-DOCS> -->

## License

This package is governed by a BSD-style license - see the repository for details.
