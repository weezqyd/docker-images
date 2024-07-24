# Docker Base Images

This repository contains a collection of images that can be used as a starting point for most Laravel projects

## PHP Images

We have backed some awwesome images that you can use to run any PHP appliactio with sane defalts to get you up and running as fast as possible.

### Swoole

Swoole is a high-performance networking framework using an event-driven, asynchronous, non-blocking I/O model. It can be used to develop high-performance, scalable, concurrent TCP, UDP, Unix socket, HTTP, Websocket services. To get started, please check the >> [Swoole Docs](https://wiki.swoole.com).

Run the command below to build and tag all images. Currently we support the following PHP versions. `8.1, 8.2, 8.3`.

```bash
cd php && GOOGLE_PROJECT_ID=my-project SERVICE_NAME=laravel ZONE=europe ./build.sh
```
