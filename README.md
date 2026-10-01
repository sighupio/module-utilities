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

**Utilities Module** is a core module and provides general purpose tools to operate and use the clusters of [SIGHUP Distribution (SD)][kfd-repo]. Today it ships a web UI for Kubernetes based on the [Headlamp][headlamp-repo] project, extended with plugins for the SD modules.

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

The web UI gives you a single place to see the state of the cluster and of the SD modules: cluster overview, Prometheus alerts, certificate expiry, Kubernetes events, logs from Loki or OpenSearch, Velero backups, and Kyverno or Gatekeeper policy violations. Users log in with a Kubernetes token or with SSO through Pomerium, and see what their Kubernetes RBAC allows. All its components run in the `headlamp` namespace.

## Packages

The following packages are included in Utilities Module:

| Package                      | Version  | Description                                                     |
| ---------------------------- | -------- | --------------------------------------------------------------- |
| [headlamp](katalog/headlamp) | `0.40.1` | Web UI for Kubernetes, extended with plugins for the SD modules |

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.33.x`           | :white_check_mark: | No known issues |
| `1.34.x`           | :white_check_mark: | No known issues |
| `1.35.x`           | :white_check_mark: | No known issues |
| `1.36.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

**Utilities Module** is part of SIGHUP Distribution (SD). [`furyctl`][furyctl-repo] downloads and deploys its packages automatically when you create or update an OnPremises or Immutable cluster.

### Configuration

You choose whether and how to deploy the web UI under `spec.distribution.modules.utilities.headlamp` in your `furyctl.yaml`: the `type` field selects how the users log in (`token-auth` or `sso`), or disables the UI with `none`. The UI is exposed at `dashboard.<baseDomain>`.

With `token-auth`, the users log in with their own Kubernetes token and get the permissions of that token. Set the optional `clusterRole` field to bind a ClusterRole to the `headlamp` ServiceAccount, so that its token can also be used to log in:

```yaml
apiVersion: kfd.sighup.io/v1alpha2
kind: OnPremises
spec:
  distribution:
    modules:
      utilities:
        headlamp:
          # How the users log in: none, token-auth or sso
          type: token-auth
          clusterRole: view
```

With `sso`, the UI is behind Pomerium and the users log in with SSO. The group in `oidcGroup` gets read access to the cluster. This type requires the SSO auth provider:

```yaml
apiVersion: kfd.sighup.io/v1alpha2
kind: OnPremises
spec:
  distribution:
    modules:
      auth:
        provider:
          type: sso
      utilities:
        headlamp:
          type: sso
          oidcGroup: authors
```

See the configuration reference for your cluster kind for the full list of available options: [OnPremises][schema-reference-onprem] or [Immutable][schema-reference-immutable].

The [`examples/`](examples) directory shows how to deploy the web UI with `kustomize` on other clusters.

To install SD from scratch, follow the [Getting started][getting-started] guide.

<!-- Links -->

[kfd-repo]: https://github.com/sighupio/distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kfd-docs]: https://docs.sighup.io/docs/distribution/
[headlamp-repo]: https://github.com/kubernetes-sigs/headlamp
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesutilities
[schema-reference-immutable]: https://docs.sighup.io/docs/reference/immutable#specdistributionmodulesutilities
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
