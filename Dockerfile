FROM --platform=$BUILDPLATFORM debian:stable-slim AS downloader

ARG TARGETARCH
ARG AGENT_VERSION

WORKDIR /builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*


# 下载对应架构的 nezha-agent
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        curl -Lo agent.zip https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_amd64.zip; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        curl -Lo agent.zip https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_arm64.zip; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    unzip agent.zip && \
    rm agent.zip


# 最终运行镜像
FROM debian:stable-slim

WORKDIR /app


# 安装运行需要工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*


# 拷贝 agent 和配置脚本
COPY --from=downloader /builder/nezha-agent /app/nezha-agent
COPY config.sh /app/config.sh


# 权限设置
RUN chmod +x /app/nezha-agent /app/config.sh


# 没有 config.yml 时自动生成
ENTRYPOINT ["/bin/sh", "-c", "[ -f /app/config.yml ] || /app/config.sh; exec /app/nezha-agent -c /app/config.yml"]
