# Maintenance

## Updating the Headlamp version

The Headlamp version is in two places, and they must match:

1. The base image tag in the `Dockerfile` of the SD UI source repository
   (`FROM registry.sighup.io/fury/headlamp:vX.Y.Z`).
2. The `app.kubernetes.io/version` label in `serviceaccount.yaml` and `deployment.yaml`.

The image of this package (`registry.sighup.io/fury/sd-ui`) is built from that `Dockerfile`.
To update Headlamp: change the base tag in the `Dockerfile`, build and publish the `sd-ui`
image, update the image tag (see below), and update the version labels above.

## Updating the image tag

The `sd-ui` tag is set only in the `images:` transformer of `kustomization.yaml`. The
`image:` field in `deployment.yaml` has no tag:

```yaml
images:
  - name: registry.sighup.io/fury/sd-ui
    newTag: <new-tag>
```

## Checklist for an update

- [ ] Base image tag updated in the `Dockerfile` of the SD UI source repository
- [ ] `sd-ui` image built and pushed
- [ ] `newTag` of the `images:` transformer in `kustomization.yaml` updated
- [ ] `app.kubernetes.io/version` labels updated
- [ ] `mise run validate-manifests` passes (all the examples render)
- [ ] `katalog/tests/tests.sh` passes
