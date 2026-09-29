# Maintenance

## Updating the Headlamp version

The Headlamp version is carried in two places that must be kept in sync:

1. The base image tag in the [`sighupio/new-sd-ui`](https://github.com/sighupio/new-sd-ui)
   repository's `Dockerfile` (`FROM registry.sighup.io/fury/headlamp:vX.Y.Z`).
2. The `app.kubernetes.io/version` label on `serviceaccount.yaml` and `deployment.yaml`.

The image consumed by this package (`registry.sighup.io/fury/sd-ui`) is built from
that Dockerfile, so a Headlamp bump is: update the Dockerfile base tag, rebuild/publish the
`sd-ui` image, bump the image tag (see below), and update the version labels above.

## Updating the image tag

The `sd-ui` tag is pinned in two places that must match:

1. The `image:` field in `deployment.yaml`.
2. The `images:` transformer in `kustomization.yaml`, which is what actually ends up in the
   rendered manifests (it overrides the tag in `deployment.yaml`):

```yaml
images:
  - name: registry.sighup.io/fury/sd-ui
    newTag: <new-tag>
```

## Checklist when bumping

- [ ] `new-sd-ui` `Dockerfile` base image tag updated
- [ ] `sd-ui` image rebuilt and pushed
- [ ] `deployment.yaml` `image:` tag updated
- [ ] `kustomization.yaml` `images:` `newTag` updated to the same tag
- [ ] `app.kubernetes.io/version` labels updated
- [ ] `kustomize build` of both overlays still renders and applies
- [ ] `tests/tests.sh` passes
