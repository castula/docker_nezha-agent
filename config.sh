#!/bin/sh

cat <<EOF > /app/config.yml
client_secret: ${CLIENT_SECRET}
uuid: ${UUID}
server: ${SERVER}
tls: ${TLS:-false}
debug: ${DEBUG:-false}
disable_auto_update: ${DISABLE_AUTO_UPDATE:-true}
disable_command_execute: ${DISABLE_COMMAND_EXECUTE:-true}
disable_force_update: ${DISABLE_FORCE_UPDATE:-true}
disable_nat: ${DISABLE_NAT:-true}
disable_send_query: ${DISABLE_SEND_QUERY:-false}
gpu: ${GPU:-false}
insecure_tls: ${INSECURE_TLS:-false}
ip_report_period: ${IP_REPORT_PERIOD:-1800}
report_delay: ${REPORT_DELAY:-1}
skip_connection_count: ${SKIP_CONNECTION_COUNT:-false}
skip_procs_count: ${SKIP_PROCS_COUNT:-false}
temperature: ${TEMPERATURE:-false}
use_gitee_to_upgrade: ${USE_GITEE_TO_UPGRADE:-false}
use_ipv6_country_code: ${USE_IPV6_COUNTRY_CODE:-true}
EOF
