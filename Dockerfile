FROM haproxy:latest

MAINTAINER xingjiudong <25635680@qq.com>

ENV CONFD_VERSION 0.11.0 
ENV TIMEOUT_CONNECT 5000ms
ENV TIMEOUT_CLIENT 50000ms
ENV TIMEOUT_SERVER 50000ms

RUN apt-get update && apt-get install rsyslog wget -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 --no-check-certificate && \
    chmod +x confd-${CONFD_VERSION}-linux-amd64 && \
    mv confd-${CONFD_VERSION}-linux-amd64 /usr/local/bin/confd && \
    sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf && \
    sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf

COPY ./confd /etc/confd
COPY ./haproxy.conf /etc/rsyslog.d
COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
