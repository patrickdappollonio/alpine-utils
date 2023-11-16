# alpine-utils [![ci](https://github.com/patrickdappollonio/alpine-utils/actions/workflows/ci.yml/badge.svg)](https://github.com/patrickdappollonio/alpine-utils/actions/workflows/ci.yml)

```bash
docker run -it ghcr.io/patrickdappollonio/alpine-utils:latest bash
```

Alpine base image with the following Linux apps:

* Standard Alpine Linux applications
* `bash`
* `curl`
* `make`
* `file`
* `zip`
* `unzip`
* `dig`
* `nslookup`
* `host`
* `git`
* `jq`
* `pause` (from `google/pause:latest`)

And the following utilities:

* `kubectl` (version `1.24`)
* `helm` (version `3.12.1`)
* `helm-push` (version `0.10.4`)
* [`wait-for-it`](https://github.com/roerohan/wait-for-it) (v0.29)
* [`wait-for`](https://github.com/patrickdappollonio/wait-for) (latest version available)
* [`tgen`](https://github.com/patrickdappollonio/tgen) (latest version available)
* `docker` (v24.0.3)

### Quick launch in Kubernetes

```bash
kubectl -n default run debug --image=ghcr.io/patrickdappollonio/alpine-utils --command=true --restart=Never pause
```

### Weekly updated

The Docker Image [is built automatically by Github actions weekly on Monday at 00:00 UTC](https://github.com/patrickdappollonio/alpine-utils/actions/workflows/ci.yml). The image is then pushed to the Github Container Registry.

> **Warning**
> If you need stability, consider pulling by SHA since it's not easy to version all the apps above in a way that makes sense.
