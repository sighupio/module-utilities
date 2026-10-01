<!-- markdownlint-disable MD033 -->
<h1 align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/black-logo.png">
  <img alt="Shows a black logo in light color mode and a white one in dark color mode." src="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
</picture><br/>
  Utilities Module
</h1>
<!-- markdownlint-enable MD033 -->

![Release](https://img.shields.io/badge/Latest%20Release-v0.1.1-blue)
![License](https://img.shields.io/github/license/sighupio/module-utilities?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <SD-DOCS> -->

**Utilities Module** is a core module of [SIGHUP Distribution (SD)][kfd-repo]. It groups general purpose tools that help you operate and use the cluster.

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

**Utilities Module** has packages for general purposes. Each package is independent and can be enabled on its own.

The first package is the SD build of [Headlamp][headlamp-repo]: the upstream Headlamp server with the SD plugins that show data specific to the distribution (cluster overview, Prometheus alerts, certificate expiry, Kubernetes events, logs, Velero backups and policy violations). All its components are deployed in the `headlamp` namespace.

## Packages

The following packages are included in Utilities Module:

| Package | Version | Description |
| --- | --- | --- |
| [Headlamp](katalog/headlamp) | `0.40.1` | Web UI for Kubernetes, bundled with the SD distribution plugins. |

Click on each package to see its full documentation.

### Headlamp

The `headlamp` package contains the Namespace, the ServiceAccount, the Service and the Deployment, and works with any authentication model. You choose how the users reach the UI and log in with an overlay. The [`examples/`](examples) directory has three ready to use overlays:

| Overlay                                          | Entry point       | Identity seen by the API server         | SD `utilities.headlamp.type`     |
| ------------------------------------------------ | ----------------- | --------------------------------------- | -------------------------------- |
| [token-auth](examples/token-auth)                | Plain TLS ingress | The token supplied by the user          | `token-auth`                     |
| [oidc-capsule](examples/oidc-capsule)            | Pomerium SSO      | The end user, filtered by Capsule Proxy | apply the example with kustomize |
| [oidc-rbac](examples/oidc-rbac)                  | Pomerium SSO      | The end user, via OIDC group RBAC       | `sso`                            |

From SD v1.36.0, on OnPremises and Immutable clusters, furyctl renders the `token-auth` and `sso` models from `spec.distribution.modules.utilities.headlamp`. Each example README describes the differences between the example and the version that the distribution renders.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes            |
| ------------------ | :----------------: | ---------------- |
| `1.33.x`           | :white_check_mark: | No known issues. |
| `1.34.x`           | :white_check_mark: | No known issues. |
| `1.35.x`           | :white_check_mark: | No known issues. |
| `1.36.x`           | :white_check_mark: | No known issues. |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

### With SIGHUP Distribution

From SD v1.36.0, on the OnPremises and Immutable kinds, [`furyctl`][furyctl-repo] downloads and deploys the packages of this module when you enable them in the configuration file, for example with `spec.distribution.modules.utilities.headlamp.type`. See the [SD documentation][kfd-docs] for the configuration fields.

### With kustomize

You can also use the packages with `kustomize` on any Kubernetes cluster. Reference the package, or one of the examples, in your `kustomization.yaml`, and apply it:

```bash
kustomize build examples/token-auth | kubectl apply -f -
```

### Headlamp image

The image of Headlamp with the SD plugins is `registry.sighup.io/fury/sd-ui`. Each module release pins a published build. To use a different build, override the `images:` transformer in your overlay:

```bash
kustomize edit set image registry.sighup.io/fury/sd-ui=registry.sighup.io/fury/sd-ui:<tag>
```

To install SD from scratch, follow the [Getting started][getting-started] guide.

<!-- Links -->

[kfd-repo]: https://github.com/sighupio/distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kfd-docs]: https://docs.sighup.io/docs/distribution/
[headlamp-repo]: https://github.com/kubernetes-sigs/headlamp
[getting-started]: https://docs.sighup.io/docs/getting-started/
[compatibility-matrix]: https://github.com/sighupio/module-utilities/blob/main/docs/COMPATIBILITY_MATRIX.md

<!-- </SD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](https://github.com/sighupio/distribution/blob/main/docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/module-utilities/issues/new/choose).

## License

This module is open source and it's released under the following [LICENSE](LICENSE).

<!-- </FOOTER> -->
