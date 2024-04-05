# mockoon-novnc

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Docker image for Mockoon GUI with noVNC.

## ✨ Features

[Mockoon](https://mockoon.com/) is great free, open-source mock server GUI application provides rich features except it does not provide web-based UI. This image aims to provide an workaround for web-based UI of Mockoon.

This image built based on [theasp/novnc](https://github.com/theasp/docker-novnc/) and reuse most of its feature, but with extra functionalities:

- NGINX for path-based port forwarding

    Mockoon provides features to run multiple Mockoon environments however you will need additional ports. Behind load balancers, for example, AWS Application Load Balancers (ALB), it's not easy to expose range of ports easily, if you wish to expose hundreds of ports (e.g. 3000-3999).

    Here NGINX comes in. Instead of specifying port to host, send request as following:

        http://localhost/3000/path/to/mock

    NGINX will handle it for you just as you've sent it like:

        http://localhost:3000/path/to/mock

    > Only port range in 3000-3999 will be forwarded by configuration, otherwise NGINX will respond with **404 Not Found**.

## 📔 Usage

You can try this image with Docker Compose by simply checking it out and running `docker compose up --build`. For more details, please check `docker-compose.yaml` file.

To pull and run image from [Docker Hub](https://hub.docker.com/r/lasuillard/mockoon-novnc), as follow:

```bash
$ docker run --rm \
    -p 127.0.0.1:3000-3010:3000-3010 \
    -p 127.0.0.1:8000:8000 \
    -p 127.0.0.1:80:80 \
    -e DISPLAY_WIDTH=1024 \
    -e DISPLAY_HEIGHT=768 \
    -e RUN_XTERM=no \
    -e RUN_PATHPORT=yes \
    -e NGINX_PATHPORT=yes \
    lasuillard/mockoon-novnc:main
```

This image extends base image trying to preserve all its features. Variables such as `DISPLAY_WIDTH` and `DISPLAY_HEIGHT` should available, see details from the corresponding repository, [theasp/novnc](https://github.com/theasp/docker-novnc/).

Below are variables defined by this image:

- `NGINX_PATHPORT`

    To enable path-based port forwarding, set environment variable `NGINX_PATHPORT` to `"yes"` when you run the container.

Once the container is up, you can access to noVNC UI at port http://localhost:8080. By default, demo mock API will be available at http://localhost:3000 (or http://localhost/3000 if you've enabled the NGINX path port).

Test it with following simple `curl` command:

```bash
$ curl http://localhost:3000/users
[{"id":"054bf92d-cf1f-4c66-8fc9-256a1f41c480","username":"Kaela10"},...]
```

Or,

```bash
$ curl http://localhost/3000/users
[{"id":"054bf92d-cf1f-4c66-8fc9-256a1f41c480","username":"Kaela10"},...]
```

## ⚠️ Limitations

There are known limitations so far:

- As base image built for amd64 architecture, it won't work properly on other architectures such as Apple with M chips. You will observe the QEMU crash logs.

- Clipboard may not work properly for some languages due to limitations of noVNC itself, which the base image relies on. See related issue [here](https://github.com/novnc/noVNC/issues/1708).

## 🙏 Thanks

This image built based on [theasp/novnc](https://github.com/theasp/docker-novnc/).
