FROM ubuntubase/ubuntubase:20.04 as mmonit

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y install vim apt-transport-https ca-certificates apt-utils tzdata jq curl dnsutils httpie iputils-ping monit netcat net-tools nmap nut nut-client freeradius-utils mosquitto-clients ntpdate python3.8-minimal python3-pip python3-openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt

ENV VERSION 5.32.0

#install fresh monit
# List here: https://mmonit.com/monit/dist/binary/
ADD https://mmonit.com/monit/dist/binary/${VERSION}/monit-${VERSION}-linux-x64.tar.gz /tmp/monit-${VERSION}-linux-x64.tar.gz
RUN \
 cd tmp && tar -zxf monit-${VERSION}-linux-x64.tar.gz  && \
 cp -f /tmp/monit-${VERSION}/bin/monit /usr/bin/monit && \
 ln -s /etc/monit/monitrc /etc/monitrc

# Prevent mosquitto_{pub|sub} warning "Warning: Unable to locate configuration directory, default config not loaded."
RUN mkdir /root/.config && touch /root/.config/mosquitto_pub && touch /root/.config/mosquitto_sub

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=10 CMD [ "CMD", "curl", "-f", "http://localhost:2812" ]

COPY monit /etc/monit
RUN chmod 700 /etc/monit/monitrc
RUN chmod u+x /etc/monit/scripts/*.sh
RUN chmod u+x /etc/monit/scripts/*.py

EXPOSE 2812

CMD exec /usr/bin/monit -I 2>&1
