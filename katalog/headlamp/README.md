# Headlamp

<!-- <SD-DOCS> -->

[Headlamp](https://headlamp.dev) is a web UI for Kubernetes. This package deploys the
**SIGHUP Distribution build of Headlamp**: the upstream Headlamp server with the SD plugins
(alerts, certificates, events, logs, backups, policy and more).

This package does **not** choose an authentication model. It contains only the Namespace,
the ServiceAccount, the Service and the Deployment. It does **not** contain an Ingress, a
`ClusterRoleBinding` or any authentication. How the users reach the UI and log in is up to
an overlay. The [`examples/`](../../examples) directory has three overlays:

- [`examples/token-auth`](../../examples/token-auth): a TLS Ingress and the Kubernetes token
  login of Headlamp. A `ClusterRoleBinding` gives permissions to the Headlamp ServiceAccount,
  so that its token can be used to log in.
- [`examples/oidc-rbac`](../../examples/oidc-rbac): Headlamp behind Pomerium SSO. Each user
  reaches the API server with their own identity, and RBAC bound to an OIDC group decides
  what they can see.
- [`examples/oidc-capsule`](../../examples/oidc-capsule): Headlamp behind Pomerium SSO, with
  the requests sent through Capsule Proxy, so that each tenant sees only its own namespaces.

On SIGHUP Distribution (from v1.36.0, OnPremises and Immutable kinds), furyctl deploys this
package for you with `spec.distribution.modules.utilities.headlamp.type` set to `token-auth`
or `sso`. Each example README describes what the distribution does.

## Requirements

- Kubernetes >= `1.33.0`
- Kustomize >= `v5.0.0`

## Image repository and tag

- Headlamp and SD plugins image: `registry.sighup.io/fury/sd-ui`

Each module release pins a published build (see [MAINTENANCE.md](MAINTENANCE.md)). To use a
different build, override the `images:` transformer in your overlay, or run:

```shell
kustomize edit set image registry.sighup.io/fury/sd-ui=registry.sighup.io/fury/sd-ui:<tag>
```

## Configuration

The Deployment runs Headlamp with:

```text
-in-cluster
-plugins-dir=/headlamp/plugins
```

Headlamp calls the in-cluster API server and sends it the bearer token of the user with
every request. The users get the permissions of their own token. This package does **not**
bind any RBAC to the Headlamp ServiceAccount: add the permissions that your access model
needs in an overlay.

- Namespace: `headlamp`
- Service: `ClusterIP` on port `80`, to the `http` port of the container (`4466`)

## Deployment

You cannot use this package alone, because it has no Ingress. Apply one of the overlays
from the root of the repository:

```shell
kustomize build examples/token-auth | kubectl apply -f -
# or
kustomize build examples/oidc-rbac | kubectl apply -f -
# or
kustomize build examples/oidc-capsule | kubectl apply -f -
```

To render only the base package:

```shell
kustomize build katalog/headlamp
```

<!-- </SD-DOCS> -->

## License

This package is governed by a BSD-style license. See the [LICENSE](../../LICENSE) file.
