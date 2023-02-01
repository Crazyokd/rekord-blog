---
layout: post
title: docker on wsl2
date: 2022/09/03
updated: 2022/09/03
cover: https://cdn.sxrekord.com/blog/docker.png
coverWidth: 279
coverHeight: 131
comments: true
categories: 
- 技术
tags:
- docker
---

## installation:

```bash
curl -sSL https://get.docker.com/ | sh
```

## start/stop/restart docker daemon:

```bash
sudo service docker start
sudo service docker stop
sudo service docker restart
```

## access docker with no sudo

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
# check: groups $USER | grep docker
```

## check

### check version
```bash
docker version --format '{{.Server.Version}}'
# dump raw JSON data:
docker version --format '{{json .}}'
```

### hello-world

```bash
docker run --rm hello-world
```

## registry configuration:
- [官方文档](https://docs.docker.com/registry/configuration/)
- [阿里云容器镜像服务 ACR](https://help.aliyun.com/document_detail/60750.html?accounttraceid=6762af4bd3de4c77b3111c6bd2402cf7fmmx)
- [Docker Series 3:Docker Mirror Details](https://programmer.group/docker-series-3-docker-mirror-details.html)

```bash
# check registry mirrors
docker info | tail
```

`/etc/docker/daemon.json`:
```json
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

## [start the tutorial](https://docs.docker.com/get-started/):

```bash
# -p host-port:container-port
docker run -d -p 80:80 docker/getting-started
# then open a web browser and navigate to http://localhost:80 .
```

## build container image:

```bash
docker build -t image-name .
```

## remove container

```bash
# get the id of the container
docker ps
# stop the container
docker stop <the-container-id>
# remove container
docker rm <the-container-id>
# or use a single command: docker rm -f <the-container-id>
```

## push image

```bash
# login to the Docker Hub
docker login -u YOUR-USER-NAME
# use the docker tag to give the image a new name
docker tag image-name YOUR-USER-NAME/image-name
# push image
docker push YOUR-USER-NAME/image-name
```

## enter container environment then execute command

```bash
docker exec <container-id> command
```

## docker volume

### volume type comparison

|     | Named Volumes | Bind Mounts |
| ---- | --- | --- |
|Host Location	| Docker chooses	|You control |
|Mount Example (using -v)	| my-volume:/usr/local/data|	/path/to/data:/usr/local/data
|Populates new volume with container contents	|Yes|	No
|Supports Volume Drivers	| Yes	|No

### named volume

```bash
# create a volume
docker volume create <volume-name>
# use the named volume and mount it to mount-dir.
docker run [option] -v <volume-name>:<mount-dir> <image-name>
# actual location
docker volume inspect <volume-name>
```

### bind mounts

```bash
docker run [option] -v <host-dir>:<mount-dir> <image-name>
```

## docker logs

```bash
docker logs -f <container-id>
```

## docker network

```bash
# create the network
docker network create <network-name>
# join network and assign network alias
docker run --network <network-name> --network-alias <network-alias> <...>
```

## docker scan

```bash
# see the layers in the image
docker scan <image-name>
```

## docker image

```bash
docker image history [--no-trunc] <image-name>
```

## docker-compose

```bash
# version info
docker-compose version
# start up the application stack
docker-compose up
# logs
docker-compose logs -f <service>
# tearing down
docker-compose down
```

## 参考
- [wsargent/docker-cheat-sheet](https://github.com/wsargent/docker-cheat-sheet)
- [yeasy/docker_practice](https://github.com/yeasy/docker_practice)
- [Play with Docker](https://labs.play-with-docker.com/)