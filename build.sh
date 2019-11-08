#!/bin/env bash

IMAGE_URL="jacky90/fastdfs"
IMAGE_TAG="6.01"
DOCKERFILE="Dockerfile-6.01"

fastdfs_version="6.01"
nginx_version="1.15.4"
libfastcommon_version="1.0.41"
fastdfs_nginx_module_version="1.21"

# 如果Dockerfile未设置默认值时，--build-arg必须传值
# 设置了默认值
# ARG FASTDFS_VERSION=6.01
# 未设置默认值
# ARG FASTDFS_VERSION

docker build --build-arg FASTDFS_VERSION=${fastdfs_version} --build-arg NGINX_VERSION=${nginx_version} --build-arg LIBFASTCOMMON_VERSION=${libfastcommon_version} --build-arg FASTDFS_NGINX_MODULE_VERSION=${fastdfs_nginx_module_version} -t ${IMAGE_URL}:${IMAGE_TAG} . -f ${DOCKERFILE}
