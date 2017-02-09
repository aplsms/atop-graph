FROM    ubuntu:16.04

ENV GRAFANA_VERSION  4.1.1-1484211277
ENV INFLUXDB_VERSION 1.2.0

# Prevent some error messages
ENV DEBIAN_FRONTEND noninteractive

ENV     GRAFANA_PORT            3000
ENV     PRE_CREATE_DB           data grafana
ENV     INFLUXDB_URL            http://localhost:8086
ENV     INFLUXDB_DATA_USER      data
ENV     INFLUXDB_DATA_PW        data
ENV     INFLUXDB_GRAFANA_USER   grafana
ENV     INFLUXDB_GRAFANA_PW     grafana
ENV     ROOT_PW                 root

RUN     apt-get -y update && apt-get -y upgrade ; \
        apt-get -y install wget supervisor curl  libfontconfig netcat ;\
        wget -q https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb && \
            dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb && rm grafana_${GRAFANA_VERSION}_amd64.deb ; \
        wget -q https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
            dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && rm influxdb_${INFLUXDB_VERSION}_amd64.deb ; \
        curl -s -q -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu && \
        chmod +x /usr/sbin/gosu

# ----------------- #
#   Configuration   #
# ----------------- #

# Configure InfluxDB
ADD     influxdb/config.toml /etc/influxdb/config.toml
ADD     influxdb/run.sh      /usr/local/bin/run_influxdb

# Configure Grafana
ADD     ./grafana/grafana.ini /etc/grafana/grafana.ini
ADD     ./grafana/run.sh      /usr/local/bin/run_grafana
#ADD    ./grafana/scripted.json /src/grafana/app/dashboards/default.json

ADD     ./configure.sh /configure.sh
ADD     ./set_grafana.sh /set_grafana.sh
ADD     ./set_influxdb.sh /set_influxdb.sh
RUN     /configure.sh

# Set dashboards
ADD    ./dashboards/ /var/lib/grafana/dashboards/

# Configure nginx and supervisord
ADD     ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN     apt-get autoremove -y wget curl && \
            apt-get -y clean && \
            rm -rf /var/lib/apt/lists/* && rm /*.sh

# Grafana
EXPOSE  3000

# InfluxDB Admin server
EXPOSE  8083

# InfluxDB HTTP API
EXPOSE  8086

# InfluxDB HTTPS API
EXPOSE  8084

CMD     ["/usr/bin/supervisord"]
