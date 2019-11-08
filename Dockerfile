FROM debian:stretch-slim
LABEL maintainer "jetinzhang@gmail.com"

# 设置了默认值，--build-arg 不传值的时候使用默认值
ARG FASTDFS_VERSION=6.01
ARG NGINX_VERSION=1.15.4
ARG LIBFASTCOMMON_VERSION=1.0.41
ARG FASTDFS_NGINX_MODULE_VERSION=1.21

ADD sources.list /etc/apt/sources.list
ADD fastdfs-${FASTDFS_VERSION}.tar.gz /usr/local/src/
ADD libfastcommon-${LIBFASTCOMMON_VERSION}.tar.gz /usr/local/src/
ADD fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}.tar.gz /usr/local/src/
ADD nginx-${NGINX_VERSION}.tar.gz /usr/local/src/

RUN apt-get update
RUN apt-get -y install make cmake gcc gcc-6 libpcre3 libpcre3-dev openssl libssl-dev libperl-dev zlib1g-dev

RUN set -ex; \
	cd /usr/local/src/libfastcommon-${LIBFASTCOMMON_VERSION}; \
        ./make.sh && ./make.sh install

RUN set -ex; \
        cd /usr/local/src/fastdfs-${FASTDFS_VERSION}; \
        ./make.sh && ./make.sh install 

RUN set -ex; \
        cd /usr/local/src/nginx-${NGINX_VERSION}; \
        ./configure --add-module=/usr/local/src/fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}/; \
        make && make install

RUN apt-get remove -y make cmake gcc gcc-6 && apt-get clean && apt-get autoclean  && rm -rf /usr/local/src/* 

ENV FASTDFS_VERSION ${FASTDFS_VERSION}
ENV FASTDFS_TRACKER tracker
ENV FASTDFS_STORAGE storage
ENV SERVER storage

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

