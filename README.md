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

![Release](https://img.shields.io/badge/Latest%20Release-v0.1.0-blue)
![License](https://img.shields.io/github/license/sighupio/module-utilities?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <SD-DOCS> -->

**Utilities Module** groups cross utility packages for [SIGHUP Distribution (SD)][kfd-repo] tools.

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

**Utilities Module** has packages for general purposes. Each package is independent and can be enabled on its own.

Today it ships the SD build of [Headlamp][headlamp-repo]: the upstream Headlamp server bundled with the SD plugins that surface functionality specific to the distribution (cluster overview, Prometheus alerts, certificate expiry, Kubernetes events, logs, Velero backups and policy violations). All its components are deployed in the `headlamp` namespace in the cluster.

## Packages

The following packages are included in Utilities Module:

| Package | Version | Description |
| --- | --- | --- |
| [Headlamp](katalog/headlamp) | `0.40.1` | Web UI for Kubernetes, bundled with the SD distribution plugins. |

Click on each package to see its full documentation.

### Headlamp

The `headlamp` package intentionally makes no assumption about authentication: it ships the Namespace, ServiceAccount, Service and Deployment only. How users reach and authenticate to the UI is an overlay concern, covered by the overlays already provided under [`examples/`](examples):

| Overlay                                          | Front door        | Identity seen by the API server         |
| ------------------------------------------------ | ----------------- | --------------------------------------- |
| [token-auth](examples/token-auth)                | Plain TLS ingress | The Headlamp ServiceAccount             |
| [oidc-capsule](examples/oidc-capsule)            | Pomerium SSO      | The end user, filtered by Capsule Proxy |
| [oidc-rbac](examples/oidc-rbac)                  | Pomerium SSO      | The end user, via OIDC group RBAC       |

## Compatibility

| Kubernetes Version |   Compatibility    | Notes            |
| ------------------ | :----------------: | ---------------- |
| `1.33.x`           | :white_check_mark: | No known issues. |
| `1.34.x`           | :white_check_mark: | No known issues. |
| `1.35.x`           | :white_check_mark: | No known issues. |
| `1.36.x`           | :white_check_mark: | No known issues. |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

**Utilities Module** is part of SIGHUP Distribution (SD) and is deployed automatically by [`furyctl`][furyctl-repo] when you create or update a cluster. You don't need to download, vendor or install its packages manually.

### Image

The Headlamp + SD plugins image is `registry.sighup.io/fury/sd-ui`, built from the SD-UI source repository. Pin a specific build by overriding the `images:` transformer in `katalog/headlamp/kustomization.yaml` or in your own overlay:

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
