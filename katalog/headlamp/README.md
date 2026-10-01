# Headlamp

<!-- <SD-DOCS> -->

[Headlamp](https://headlamp.dev) is a web UI for Kubernetes. This package deploys the
**SIGHUP Distribution build of Headlamp**: the upstream Headlamp server with the SD plugins
(alerts, certificates, events, logs, backups, policy and more).

This package contains the Namespace, the ServiceAccount, the Service and the Deployment of
Headlamp, and works with any authentication model. You choose how the users reach the UI and
log in with an overlay. The [`examples/`](../../examples) directory has three ready to use
overlays:

| Overlay                                        | Entry point  | Identity seen by the API server         | SD `utilities.headlamp.type`     |
| ---------------------------------------------- | ------------ | --------------------------------------- | -------------------------------- |
| [token-auth](../../examples/token-auth)        | TLS Ingress  | The token supplied by the user          | `token-auth`                     |
| [oidc-rbac](../../examples/oidc-rbac)          | Pomerium SSO | The end user, via OIDC group RBAC       | `sso`                            |
| [oidc-capsule](../../examples/oidc-capsule)    | Pomerium SSO | The end user, filtered by Capsule Proxy | apply the example with kustomize |

From SD v1.36.0, on OnPremises and Immutable clusters, furyctl renders the `token-auth` and
`sso` models from `spec.distribution.modules.utilities.headlamp`. Each example README
describes the differences between the example and the version that the distribution renders.

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
every request, so the users get the permissions of their own token. Add the RBAC that your
access model needs in an overlay, as the examples do.

- Namespace: `headlamp`
- Service: `ClusterIP` on port `80`, to the `http` port of the container (`4466`)

## Deployment

Deploy the package through an overlay that adds the Ingress and the access model. To apply
one of the examples, run from the root of the repository:

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
