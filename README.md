# Nezha-Agent Docker 🚀

> 自动构建最新的 [nezha-agent](https://github.com/nezhahq/agent) Docker 镜像  
> **本仓库 Dockerfile、CI/CD Workflow、镜像构建方案均由 ChatGPT 辅助设计并编写完成。**

---

## 🌟 仓库简介

本项目自动检测 nezha-agent 最新 Release，并自动构建 multi-arch（amd64 + arm64）Docker 镜像，同时同步发布到 GitHub Container Registry 和 DockerHub。

本项目采用 **BusyBox:slim 作为基础镜像**，在保证 nezha-agent 正常运行的同时，尽可能降低镜像体积和运行资源占用。

默认镜像地址：

* GitHub Container Registry:
  ```
  ghcr.io/castula/nezha-agent:latest
  ```

* DockerHub:
  ```
  spousal4806/nezha-agent:latest
  ```

* 极简版本：
  ```
  spousal4806/nezha-agent:slim
  ```

---

## ✨ 镜像特点

* 基于 **BusyBox:slim** 构建
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

构建流程：

1. GitHub Action 定时检测 nezha-agent upstream 最新 Release
2. 自动下载对应架构版本
3. 使用 BusyBox:slim 作为最终运行环境
4. 自动配置运行环境
5. 构建 multi-platform Docker 镜像
6. 推送至 GHCR 和 DockerHub

---

## 🔄 快速启动

> 留空或删除 `UUID` 变量时，会自动生成 UUID。

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
  -e TLS="true" \
  spousal4806/nezha-agent:latest
```

---

## 🚀 GitHub Action 自动构建

* 每 6 小时检测 nezha-agent 最新 Release
* 自动构建 amd64 / arm64
* 自动推送 GHCR 与 DockerHub
* 自动维护版本记录
* slim 标签独立维护

---

## 🎉 感谢

* 原项目：
  [Nezha Agent](https://github.com/nezhahq/agent)

* Docker 镜像设计、Dockerfile 编写、GitHub Actions 自动化构建：

  **ChatGPT Assisted Development**
