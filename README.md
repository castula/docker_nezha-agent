# Nezha-Agent Docker 🚀

> 自动构建最新的 [nezha-agent](https://github.com/nezhahq/agent) Docker 镜像  
> 本仓库 Dockerfile、CI/CD Workflow、镜像构建方案均由 ChatGPT 辅助设计并编写完成。

---

## 🌟 仓库简介

本项目自动检测 nezha-agent 最新 Release，并自动构建 multi-arch（amd64 + arm64）Docker 镜像，同时同步发布到 GitHub Container Registry 和 DockerHub。

本项目采用 **BusyBox:musl 作为基础镜像**，在保证 nezha-agent 正常运行的同时，尽可能降低镜像体积和运行资源占用。

默认镜像地址：

* GitHub Container Registry:
  ```
  ghcr.io/castula/nezha-agent:latest
  ```

* DockerHub:
  ```
  spousal4806/nezha-agent:latest
  ```
---

## ✨ 镜像特点

* 基于 **BusyBox:musl** 构建
* 极小镜像体积
* 低内存占用
* 支持 amd64 / arm64 多架构
* 自动追踪 nezha-agent 最新 Release
* GitHub Actions 自动构建
* 支持 DockerHub 与 GHCR 双仓库同步
* 支持环境变量快速配置
* 支持外部 config.yml 配置文件
* 支持自动生成 UUID

---

## 🔧 镜像构建逻辑

* 基于 Busybox:muslin 构建简洁小镜像
* 先通过 curl + unzip 下载并解压 nezha-agent release 包
* 支持 TARGETARCH (amd64/arm64)
* 支持多张原生架构
* 支持用户通过环境变量传入 config.yml 配置
* 如果插入了 config.yml，则使用外部配置，否则动态生成

---

## 🔄 快速启动
* 留空或删除`UUID`变量时会自动生成`UUID`
### 最简单启动：

```bash
docker run -d \
  --name nezha-agent \
  --network host \
  --restart always \
  -v /proc:/proc:ro \
  -e CLIENT_SECRET="your_client_secret" \
  -e UUID="your_uuid" \
  -e SERVER="your.server.com:443" \
  -e TLS="false" \
  spousal4806/nezha-agent:latest
```

### 全环境变量启动：

```bash
docker run -d \
  --name nezha-agent \
  --network host \
  --restart always \
  -v /proc:/proc:ro \
  -e CLIENT_SECRET="your_client_secret" \
  -e UUID="your_uuid" \
  -e SERVER="your.server.com:443" \
  -e TLS="false" \
  -e DEBUG="false" \
  -e DISABLE_AUTO_UPDATE="true" \
  -e DISABLE_COMMAND_EXECUTE="true" \
  -e DISABLE_FORCE_UPDATE="true" \
  -e DISABLE_NAT="true" \
  -e DISABLE_SEND_QUERY="false" \
  -e GPU="false" \
  -e INSECURE_TLS="false" \
  -e IP_REPORT_PERIOD="1800" \
  -e REPORT_DELAY="3" \
  -e SELF_UPDATE_PERIOD="0" \
  -e SKIP_CONNECTION_COUNT="true" \
  -e SKIP_PROCS_COUNT="true" \
  -e TEMPERATURE="false" \
  -e USE_ATOMGIT_TO_UPGRADE="false" \
  -e USE_GITEE_TO_UPGRADE="false" \
  -e USE_IPV6_COUNTRY_CODE="true" \
  spousal4806/nezha-agent:latest
```

---

## 🚿 Docker Compose 启动示例

```yaml
services:
  nezha-agent:
    image: spousal4806/nezha-agent:latest
    container_name: nezha-agent
    network_mode: host
    restart: always
    environment:
      CLIENT_SECRET: "your_client_secret"
      UUID: "your_uuid"
      SERVER: "your.server.com:443"
      TLS: "false"
    volumes:
      - /proc:/proc:ro
```

---

## 🔧 外部配置文件映射启动

你可以自己编写好 config.yml ，传入到容器内：

```bash
docker run -d \
  --name nezha-agent \
  --network host \
  --restart always \
  -v /proc:/proc:ro \
  -v /path/to/your/config.yml:/app/config.yml \
  spousal4806/nezha-agent:latest
```

若插入 config.yml ，则会忽略环境变量，直接启动。

---

## 📊 支持环境变量

| 环境变量                      | 备注                | 默认值   |
| ------------------------- | ----------------- | ----- |
| `CLIENT_SECRET`           | 必填，Agent 秘钥       | -     |
| `UUID`                    | 服务器 UUID，留空则自动生成       | -     |
| `SERVER`                  | 必填，服务器地址：IP/域名:PORT | -     |
| `TLS`                     | 是否使用 TLS          | false     |
| `DEBUG`                   | 开启调试日志            | false |
| `DISABLE_AUTO_UPDATE`     | 禁止自动更新            | true  |
| `DISABLE_COMMAND_EXECUTE` | 禁止运行命令            | true  |
| `DISABLE_FORCE_UPDATE`    | 禁止强制更新            | true  |
| `DISABLE_NAT`             | 禁止 NAT 模式         | true  |
| `DISABLE_SEND_QUERY`      | 禁止发送 query        | false |
| `GPU`                     | 开启 GPU 监控         | false |
| `INSECURE_TLS`            | 不验证 TLS           | false |
| `IP_REPORT_PERIOD`        | IP 上报周期(秒)        | 1800  |
| `REPORT_DELAY`            | 上报延时(秒)           | 3     |
| `SELF_UPDATE_PERIOD`      | 自我更新周期(分钟)，0 为禁用  | 0     |
| `SKIP_CONNECTION_COUNT`   | 略过连接计数            | true  |
| `SKIP_PROCS_COUNT`        | 略过进程计数            | true  |
| `TEMPERATURE`             | 温度监控              | false |
| `USE_ATOMGIT_TO_UPGRADE`  | 使用 AtomGit 更新     | false |
| `USE_GITEE_TO_UPGRADE`    | 使用 Gitee 更新       | false |
| `USE_IPV6_COUNTRY_CODE`   | 使用 IPv6 上报地理位置        | true  |

---

## 🚀 GitHub Action 自动构建

* 每 6 小时检测 nezha-agent 最新 Release
* 自动构建 amd64 / arm64
* 自动推送 GHCR 与 DockerHub
* 自动维护版本记录 `.github/last_version.txt`
---

## 🎉 感谢

* 原项目：
  [Nezha Agent](https://github.com/nezhahq/agent)

* Docker 镜像设计、Dockerfile 编写、GitHub Actions 自动化构建：

  **ChatGPT Assisted Development**


  
