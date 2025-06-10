#!/bin/sh

cat <<EOF > /app/config.yml
client_secret: ${CLIENT_SECRET}
debug: ${DEBUG:-false}
disable_auto_update: ${DISABLE_AUTO_UPDATE:-false}
disable_command_execute: ${DISABLE_COMMAND_EXECUTE:-true}
disable_force_update: ${DISABLE_FORCE_UPDATE:-false}
disable_nat: ${DISABLE_NAT:-true}
disable_send_query: ${DISABLE_SEND_QUERY:-true}
gpu: ${GPU:-false}
insecure_tls: ${INSECURE_TLS:-false}
ip_report_period: ${IP_REPORT_PERIOD:-1800}
report_delay: ${REPORT_DELAY:-1}
server: ${SERVER}
skip_connection_count: ${SKIP_CONNECTION_COUNT:-true}
skip_procs_count: ${SKIP_PROCS_COUNT:-true}
temperature: ${TEMPERATURE:-true}
tls: ${TLS:-true}
use_gitee_to_upgrade: ${USE_GITEE_TO_UPGRADE:-false}
use_ipv6_country_code: ${USE_IPV6_COUNTRY_CODE:-false}
uuid: ${UUID}
EOF
