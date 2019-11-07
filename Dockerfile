FROM debian:stretch-slim

ADD sources.list /etc/apt/sources.list
ADD fastdfs-5.11.tar.gz /usr/local/src/
ADD libfastcommon-1.0.39.tar.gz /usr/local/src/
ADD fastdfs-nginx-module.tar.gz /usr/local/src/
ADD nginx-1.15.4.tar.gz /usr/local/src/

RUN apt-get update
RUN apt-get -y install make cmake gcc gcc-6 libpcre3 libpcre3-dev openssl libssl-dev libperl-dev zlib1g-dev

RUN set -ex; \
	cd /usr/local/src/libfastcommon-1.0.39; \
        ./make.sh && ./make.sh install

RUN set -ex; \
        cd /usr/local/src/fastdfs-5.11; \
        ./make.sh && ./make.sh install 

RUN set -ex; \
        cd /usr/local/src/nginx-1.15.4; \
        ./configure --add-module=/usr/local/src/fastdfs-nginx-module/; \
        make && make install

RUN apt-get remove -y make cmake gcc gcc-6 && apt-get clean && apt-get autoclean  && rm -rf /usr/local/src/* 

ENV FASTDFS_VERSION 5.11
ENV FASTDFS_TRACKER tracker
ENV FASTDFS_STORAGE storage
ENV SERVER storage

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

