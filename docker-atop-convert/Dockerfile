FROM    ubuntu:16.04

ENV DEBIAN_FRONTEND  noninteractive
ENV INFLUXDB_VERSION 0.13.0

RUN \
    apt-get -y update && apt-get -y upgrade ; \
    apt-get -y install atop wget libfontconfig ;\
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && rm influxdb_${INFLUXDB_VERSION}_amd64.deb

RUN rm -f /etc/systemd/system/influxd.service /etc/systemd/system/multi-user.target.wants/influxdb.service

ADD     parse.awk       /
ADD     convert.sh      /

CMD     ["/convert.sh"]
