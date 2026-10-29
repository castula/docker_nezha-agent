# ============================================
# Builder
# ============================================
FROM --platform=$BUILDPLATFORM alpine:latest AS downloader

ARG TARGETARCH
ARG AGENT_VERSION

WORKDIR /builder

RUN apk add --no-cache curl unzip

# 根据 Docker 的 $TARGETARCH 映射到哪吒官方的架构命名
RUN case "${TARGETARCH}" in \
      amd64) ARCH="amd64" ;; \
      arm64) ARCH="arm64" ;; \
      arm)   ARCH="arm"   ;; \
      *)     echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac && \
    echo "Downloading nezha-agent for linux_${ARCH} (version ${AGENT_VERSION})..." && \
    curl -fsSL -o agent.zip \
      https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_${ARCH}.zip && \
    unzip agent.zip

# 下载 Mozilla CA Bundle
RUN mkdir -p /builder/etc/ssl/certs && \
    curl -fsSL \
      https://curl.se/ca/cacert.pem \
      -o /builder/etc/ssl/certs/ca-certificates.crt


# ============================================
# Runtime (Slim)
# ============================================
FROM busybox:uclibc

WORKDIR /app

# SSL 证书
COPY --from=downloader /builder/etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Agent
COPY --from=downloader /builder/nezha-agent /app/nezha-agent

# 配置脚本
COPY config.sh /app/config.sh

# 权限
RUN chmod +x /app/nezha-agent /app/config.sh

# 若没有挂载 config.yml，则自动根据环境变量生成
ENTRYPOINT ["sh", "-c", "[ -f /app/config.yml ] || /app/config.sh; exec /app/nezha-agent -c /app/config.yml"]
