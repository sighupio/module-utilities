# Maintenance

## Updating the Headlamp version

The Headlamp version is carried in two places that must be kept in sync:

1. The base image tag in the repository [`Dockerfile`](../../Dockerfile)
   (`FROM registry.sighup.io/fury/headlamp:vX.Y.Z`).
2. The `app.kubernetes.io/version` label on `serviceaccount.yaml` and `deployment.yaml`.

The image consumed by this package (`registry.sighup.io/fury/sd-ui`) is built from
that Dockerfile, so a Headlamp bump is: update the Dockerfile base tag, rebuild/publish the
`sd-ui` image, bump the `images:` `newTag` in `kustomization.yaml`, and update the version
labels above.

## Updating the image tag

Pin a published build via the `images:` transformer in `kustomization.yaml`:

```yaml
images:
  - name: registry.sighup.io/fury/sd-ui
    newTag: <new-tag>
```

## Checklist when bumping

- [ ] `Dockerfile` base image tag updated
- [ ] `sd-ui` image rebuilt and pushed
- [ ] `kustomization.yaml` `images:` `newTag` updated
- [ ] `app.kubernetes.io/version` labels updated
- [ ] `kustomize build` of both overlays still renders and applies
- [ ] `tests/tests.sh` passes
