# Bink Python

Python 3.9, 3.10, 3.11, and 3.12 with additional components for easy deployments into Bink Infrastructure. If you're not sure what that means, you probably don't need/want this.

## Feature Matrix

| Tag | Base OS | Python Version | CPU Architectures | Additional Components | EOL Date |
| --- | ------- | -------------- | ----------------- | --------------------- | -------- |
| `ghcr.io/binkhq/python:3.9` | [Ubuntu 22.04](https://hub.docker.com/_/ubuntu) | [v3.9.19](https://www.python.org/downloads/release/python-3918/) | `amd64`, `arm64` | None | April 2025 |
| `ghcr.io/binkhq/python:3.10` | [Ubuntu 22.04](https://hub.docker.com/_/ubuntu) | [v3.10.14](https://www.python.org/downloads/release/python-31013/) | `amd64`, `arm64` | None | April 2026 |
| `ghcr.io/binkhq/python:3.11` | [Ubuntu 22.04](https://hub.docker.com/_/ubuntu) | [v3.11.9](https://www.python.org/downloads/release/python-3117/) | `amd64`, `arm64` | None | April 2027 |
| `ghcr.io/binkhq/python:3.12` | [Debian 12](https://hub.docker.com/_/debian) | [v3.12.3](https://www.python.org/downloads/release/python-3121/) | `amd64`, `arm64` | None | April 2028 |

## Base OS Changes

With Canonical agressively pushing its own products over standard Linux tooling, e.g. Netplan, Snap, we decided to skip our migration to Ubuntu 24.04 and move back to Debian. Debian 12 has everything we need from a feature perspective and will continue to recieve security updates until 2026, at which time we'll move our images to Debian 13.

## Removed Features

### Linkerd

Bink is no longer using Linkerd following the changes described [here](https://linkerd.io/2024/02/21/announcing-linkerd-2.15/#a-new-model-for-stable-releases) and as such will no longer support `linkerd-await` in this image.

### Rust

Previously these images shipped with special tags for [poetry](https://github.com/python-poetry/poetry), [pipenv](https://github.com/pypa/pipenv), and [pyo3](https://github.com/PyO3/pyo3), these have been removed as this project is built around the Python release schedule and often had out of date versions of the aformentioned projects.

The following images still exist, but are in an unmaintained state:
* `ghcr.io/binkhq/python:3.9-poetry`
* `ghcr.io/binkhq/python:3.9-pipenv`
* `ghcr.io/binkhq/python:3.9-pyo3`
* `ghcr.io/binkhq/python:3.10-poetry`
* `ghcr.io/binkhq/python:3.10-pipenv`
* `ghcr.io/binkhq/python:3.10-pyo3`
* `ghcr.io/binkhq/python:3.11-poetry`
* `ghcr.io/binkhq/python:3.11-pipenv`
* `ghcr.io/binkhq/python:3.11-pyo3`
