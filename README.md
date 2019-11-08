# Fastdfs Docker镜像

## 1. 使用说明

因官方Dockerfile的只适合单机部署，根据github上Guu-mc这位朋友的项目[Guu-mc/fastdfs](https://github.com/Guu-mc/fastdfs)开源代码进行了一些功能增加，可单机可分布式部署。

### 1.1. 构建说明

构建最新版本fastdfs镜像, 默认的镜像地址和tag, 根据自己需求更改脚本内的值。
IMAGE_URL="jacky90/fastdfs"
IMAGE_TAG="6.01"

构建命令

```bash
bash build.sh
```

### 1.2. 镜像使用说明

环境变量

默认值
SERVER=storage
FASTDFS_VERSION=构建时指定的版本 (5.11或6.01)
FASTDFS_TRACKER=tracker
FASTDFS_STORAGE=storage

默认启动，使用默认值时，会启动应用 storage 和 nginx，默认端口为23000 8888

当环境变量SERVER=tracker时，仅启动应用tracker。默认端口为22122。

## docker-compose一键启动

docker-compose.yml所在路径deploy/standalone/
docker-compose运行是host模式，一台机需要部署多个请修改配置文件的端口号。
所需目录结构，数据在当前data目录，配置文件在etc/fdfs。需要修改参数，请根据自行情况调整配置文件

```bash
[root@localhost fastdfs]# tree -L 3
.
├── data
│   └── fastdfs
│       ├── data
│       └── logs
├── docker-compose.yml
└── etc
    └── fdfs
        ├── anti-steal.jpg
        ├── client.conf
        ├── client.txt
        ├── conf-default
        ├── http.conf
        ├── mime.types
        ├── mod_fastdfs.conf
        ├── mod_fastdfs.txt
        ├── nginx.conf
        ├── sample
        ├── storage.conf
        ├── storage.txt
        └── tracker.conf
```

运行命令

```bash
docker-compose up -d
```
