# alpine-utils [![ci](https://github.com/patrickdappollonio/alpine-utils/actions/workflows/ci.yml/badge.svg)](https://github.com/patrickdappollonio/alpine-utils/actions/workflows/ci.yml)

Alpine base image with the following Linux apps:

* Standard Alpine Linux applications
* `bash`
* `curl`
* `file`
* `zip`
* `unzip`

And the following utilities:

* `kubectl` (version `1.22`)
* `helm` (version `3.7.1`)
* `helm-push` (version `0.10.1`)
* [`wait-for-it.sh`](https://github.com/vishnubob/wait-for-it) (latest version available)
* [`tgen`](https://github.com/patrickdappollonio/tgen) (latest version available)
* [`dotenv`](https://github.com/patrickdappollonio/dotenv) (latest version available)

### Daily updated

The Docker Image [is built automatically by Github actions daily at 00:00 UTC](https://github.com/patrickdappollonio/alpine-utils/actions/workflows/ci.yml). The image is then pushed to the Docker Registry. If you need stability, consider pulling by SHA since it's not easy to version all the apps above in a way that makes sense.

### Use

```bash
docker run -it patrickdappollonio/alpine-utils bash
```
