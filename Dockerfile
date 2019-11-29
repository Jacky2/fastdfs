# build server
FROM fastdfs-builder:0.0.1 AS builder

# ARG FASTDFS_VERSION=6.01 如果像这样设置了默认值，--build-arg 不传值的时候使用默认值
ARG FASTDFS_VERSION
ARG NGINX_VERSION
ARG LIBFASTCOMMON_VERSION
ARG FASTDFS_NGINX_MODULE_VERSION

ADD fastdfs-${FASTDFS_VERSION}.tar.gz /usr/local/src/
ADD libfastcommon-${LIBFASTCOMMON_VERSION}.tar.gz /usr/local/src/
ADD fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}.tar.gz /usr/local/src/
ADD nginx-${NGINX_VERSION}.tar.gz /usr/local/src/

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

# build release image
FROM debian:buster-slim
LABEL maintainer "jetinzhang@gmail.com"

ADD sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y libpcre3 libpcre3-dev openssl libssl-dev libperl-dev zlib1g-dev && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# ARG FASTDFS_VERSION=6.01 如果像这样设置了默认值，--build-arg 不传值的时候使用默认值
ARG FASTDFS_VERSION

# copy build file from builder image (--from=0 把前一阶段构建的产物拷贝到了当前的镜像中)
COPY --from=builder /usr/bin/fdfs_* /usr/bin/
COPY --from=builder /usr/lib/libfastcommon.so /usr/lib/
COPY --from=builder /usr/lib64/libfastcommon.so /usr/lib64/
COPY --from=builder /etc/fdfs /etc/fdfs/
COPY --from=builder /etc/init.d/fdfs_* /etc/init.d/
COPY --from=builder /usr/local/nginx /usr/local/nginx/

# copy config sample file
RUN cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf && cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf && cp /etc/fdfs/storage_ids.conf.sample  /etc/fdfs/storage_ids.conf && cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf

ENV FASTDFS_VERSION ${FASTDFS_VERSION}
ENV FASTDFS_TRACKER tracker
ENV FASTDFS_STORAGE storage
ENV SERVER storage

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

