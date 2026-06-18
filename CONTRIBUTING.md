# ❤️‍🔥 Contributing to this project

Thank you for your interest in contributing to **mockoon-novnc**.

## 🐛 Reporting issues

Please report issues in our [GitHub repository](https://github.com/lasuillard/mockoon-novnc/issues). Before submitting an issue, please search for existing issues to avoid duplicates.

## 🏗️ Project overview

This project provide a Docker image for web-based access to the [Mockoon](https://mockoon.com/) GUI through noVNC.

### 🛠️ Tech stack

This project uses the following tech stack:

- [Debian](https://www.debian.org) Trixie as the base image
- [Mockoon](https://mockoon.com) as a mock API server
- [x11vnc](https://github.com/LibVNC/x11vnc), [websockify](https://github.com/novnc/websockify), [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) and [noVNC](https://novnc.com) for browser-based VNC access
- [Fluxbox](http://fluxbox.org) for window management
- [NGINX](https://nginx.org) for reverse proxy and port forwarding
- [Supervisor](https://supervisord.org) for process management
- [shfmt](https://github.com/mvdan/sh) and [shellcheck](https://github.com/koalaman/shellcheck) for formatting and linting shell scripts, and [BATS](https://github.com/bats-core/bats-core) for running tests

### 📂 Key directory structure

- `docs/`: Documentation resources
- `mockoon/storage/`: Mockoon mock API definitions and settings
- `nginx/`: NGINX configuration files
- `supervisord/`: Supervisord configuration files
- `test/`: Project tests (BATS)
- `docker-compose.yaml`: Docker Compose configuration for local development and testing
- `docker-entrypoint.sh`: Docker entrypoint script
- `Dockerfile`: Docker image definition
- `flake.nix`: Nix Flakes development environment
- `Justfile`: Commands for development

## 🔧 Set up the development environment

For development, the following tools are required:

### 🐳 System requirements

You need [Docker](https://www.docker.com) and [Docker Compose](https://docs.docker.com/compose/) installed on your system.

### ❄️ Tools managed via Nix Flakes

This repository uses [Nix Flakes](https://nix.dev/concepts/flakes.html) to manage development tools. The following tools are installed automatically when `nix` is available:

- `pre-commit`
- `just`
- `shfmt`
- `shellcheck`
- `mockoon`
- `nginx`

Simply run `nix develop` to enter the development environment, then run `just install` to set up dependencies. The Nix shell also installs the pre-commit hooks automatically.

If you prefer using a [Dev Container](https://containers.dev), an example configuration file ([`devcontainer.json`](./.devcontainer.example/devcontainer.json)) is provided with Nix and Docker-in-Docker preinstalled.

## ✅ Verifying changes

Before pushing your code, run `just ci` to verify that your changes adhere to the project's coding standards and pass all linters, formatters, and tests.

Alternatively, use the `pre-commit` hooks to handle formatting and linting automatically.

## ✨ Submitting changes

Please feel free to submit pull requests on GitHub. Before opening a PR, ensure your changes pass all checks by running `just ci`.

## 🚀 Release process

The Docker image is published to Docker Hub automatically on pushes to the `main` branch. To release a new version, create a release in GitHub Releases with a `v*` tag, which will trigger the [publish.yaml](./.github/workflows/publish.yaml) workflow to build and push the Docker image with semantic version tags.
