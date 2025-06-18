FROM --platform=$BUILDPLATFORM alpine:edge AS downloader

ARG TARGETARCH
# 新增 ARG AGENT_VERSION 来接收版本号
ARG AGENT_VERSION 
WORKDIR /builder

RUN apk add --no-cache curl unzip

# 下载对应架构的 nezha-agent
# URL 中使用 ${AGENT_VERSION} 变量来获取最新版本
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      curl -Lo agent.zip https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_amd64.zip; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      curl -Lo agent.zip https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_arm64.zip; \
    else \
      echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    unzip agent.zip

# 最终镜像阶段
FROM alpine:latest

WORKDIR /app

# 安装必要工具
RUN apk add --no-cache bash

# 拷贝 agent 可执行文件和配置脚本
COPY --from=downloader /builder/nezha-agent /app/nezha-agent
COPY config.sh /app/config.sh

# 权限设置
RUN chmod +x /app/nezha-agent /app/config.sh

# 如果没有外部映射配置文件，则用环境变量生成 config.yml
ENTRYPOINT ["/bin/sh", "-c", "[ -f /app/config.yml ] || /app/config.sh; exec /app/nezha-agent -c /app/config.yml"]
