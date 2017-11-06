#!/bin/bash
set -e
: ${TIMEOUT_CONNECT:=5s}
: ${TIMEOUT_CLIENT:=50s}
: ${TIMEOUT_SERVER:=50s}
: ${TIMEOUT_HTTP_KEEP_ALIVE:=50s}
#: ${MAXCONN:=2000}
MAXCONN=${MAXCONN:-2000}

# Make sure service is running
service rsyslog start

# Touch the log file so we can tail on it
touch /var/log/haproxy.log

# Throw the log to output
tail -f /var/log/haproxy.log &

# Create haproxy.cfg
confd -onetime -backend etcd -node http://${ETCD_CLIENT_IP}:2379 --prefix="/haproxy-config/${PROJECT_NAME}"

# Start haproxy
haproxy -f /usr/local/etc/haproxy/haproxy.cfg
