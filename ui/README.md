<!-- markdownlint-disable MD033 -->
<h1 align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/black-logo.png">
  <img alt="Shows a black logo in light color mode and a white one in dark color mode." src="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
</picture><br/>
  UI Module
</h1>
<!-- markdownlint-enable MD033 -->

![Release](https://img.shields.io/badge/Latest%20Release-__MODULE_VERSION__-blue)
![License](https://img.shields.io/github/license/sighupio/module-utilities?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <SD-DOCS> -->

**UI Module** provides a unified web interface for [SIGHUP Distribution (SD)][kfd-repo].

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

**UI Module** deploys the SD build of [Headlamp][headlamp-repo] — the upstream Headlamp server bundled with the SD plugins that surface distribution-specific functionality: cluster overview, Prometheus alerts, certificate expiry, Kubernetes events, logs, Velero backups and policy violations.

All the components are deployed in the `headlamp` namespace in the cluster.

## Packages

The following packages are included in UI Module:

| Package                      | Version  | Description                                                    |
| ---------------------------- | -------- | -------------------------------------------------------------- |
| [Headlamp](katalog/headlamp) | `0.40.1` | Web UI for Kubernetes, bundled with the SD distribution plugins. |

Click on each package to see its full documentation.

The `headlamp` package is intentionally auth-agnostic: it ships the Namespace, ServiceAccount, Service and Deployment only. How users reach and authenticate to the UI is an overlay concern, covered by the ready-made overlays under [`examples/`](examples):

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

**UI Module** is part of SIGHUP Distribution (SD) and is deployed automatically by [`furyctl`][furyctl-repo] when you create or update a cluster. You don't need to download, vendor or install its packages manually.

### Configuration

TBD — the `furyctl.yaml` configuration surface for this module is not defined yet.

See the configuration reference for your cluster kind for the full list of available options: [OnPremises][schema-reference-onprem] or [Immutable][schema-reference-immutable].

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
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises
[schema-reference-immutable]: https://docs.sighup.io/docs/reference/Immutable
[compatibility-matrix]: https://github.com/sighupio/module-utilities/blob/main/docs/COMPATIBILITY_MATRIX.md

<!-- </SD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](https://github.com/sighupio/distribution/blob/main/docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/module-utilities/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE).

<!-- </FOOTER> -->
