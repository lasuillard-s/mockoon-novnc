# mockoon-novnc

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/lasuillard/mockoon-novnc/main.svg)](https://results.pre-commit.ci/latest/github/lasuillard/mockoon-novnc/main)
![GitHub Release](https://img.shields.io/github/v/release/lasuillard/mockoon-novnc)

Docker image for Mockoon GUI with noVNC.

![Demo](/docs/demo.png)

## ✨ Features

[Mockoon](https://mockoon.com/) is great free, open-source mock server GUI application provides rich features except it does not provide web-based UI. This image aims to provide an workaround for web-based UI of Mockoon, providing extra mocking functionalities for development environments:

- Provide access to Mockoon GUI through web UI (noVNC)

- NGINX for path-based port forwarding

    Mockoon provides features to run multiple Mockoon environments however you will need additional ports. Behind load balancers, for example, AWS Application Load Balancers (ALB), it's not easy to expose range of ports easily, if you wish to expose hundreds of ports (e.g. 3000-3999).

    Here NGINX comes in. Instead of specifying port to host, send request as following:

        http://localhost/3000/path/to/mock

    NGINX will handle it for you just as you've sent it like:

        http://localhost:3000/path/to/mock

    By default, if port not specified in path it will be redirected to port 3000. Request to `http://localhost/path/to/mock` is equal to `http://localhost/3000/path/to/mock`.

    > Only port range in 3000-3999 will be forwarded by configuration, otherwise NGINX will respond with **404 Not Found**.

- Header-based port forwarding

    Instead of port in path, you can use `X-Port-Forward` header to desired port number. It would be useful if you don't want path modification.

    ```bash
    $ curl --fail --silent http://localhost --header 'X-Port-Forward: 3678'
    {"Hello": "World!"}
    ```

    Port range here also restricted to range of 3000-3999.

    > Path-based port forwarding may take precedence.

## 📔 Usage

You can try this image with Docker Compose by simply checking it out and running `docker compose up --build`. For more details, please check `docker-compose.yaml` file.

To pull and run image from [Docker Hub](https://hub.docker.com/r/lasuillard/mockoon-novnc), as follow:

```bash
$ docker run --rm \
    -p 127.0.0.1:3000:3000 \
    -p 127.0.0.1:8080:8080 \
    -p 127.0.0.1:80:80 \
    -e DISPLAY_WIDTH=1024 \
    -e DISPLAY_HEIGHT=768 \
    -e NGINX_PATHPORT=yes \
    lasuillard/mockoon-novnc:main
```

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

Supported environment variables:

- `DISPLAY_WIDTH`, `DISPLAY_HEIGHT`: noVNC display geometry. Each defaults to `1024` and `768`.

- `NGINX_PATHPORT`: Whether to use NGINX path-based and header-based port forwarding. Disabled by default.

## ⚠️ Limitations

There are known limitations so far:

- As base image built for amd64 architecture, it won't work properly on other architectures such as Apple with M chips. You will observe the QEMU crash logs.

- Clipboard may not work properly for some languages due to limitations of noVNC itself, which the base image relies on. See related issue [here](https://github.com/novnc/noVNC/issues/1708).

## 🙏 Thanks

This image previously has been built based on [theasp/novnc](https://github.com/theasp/docker-novnc/).
