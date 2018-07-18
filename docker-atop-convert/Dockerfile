FROM    ubuntu:16.04

ENV DEBIAN_FRONTEND  noninteractive
ENV INFLUXDB_VERSION 0.13.0

RUN \
    apt-get -y update && apt-get -y upgrade ; \
    apt-get -y install wget libfontconfig ;\
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && rm influxdb_${INFLUXDB_VERSION}_amd64.deb

#building extra version of atop
RUN \
    set -x -e; \
    apt-get install -y build-essential zlib1g-dev make libncurses-dev ;\
    wget http://www.atoptool.nl/download/atop-1.26.tar.gz   && tar -xvzf atop-1.26.tar.gz   && rm atop-1.26.tar.gz ;\
    wget http://www.atoptool.nl/download/atop-2.1.tar.gz && tar -xvzf atop-2.1.tar.gz && rm atop-2.1.tar.gz ;\
    wget http://www.atoptool.nl/download/atop-2.2.tar.gz  && tar -xvzf atop-2.2.tar.gz  && rm atop-2.2.tar.gz  ;\
    wget http://www.atoptool.nl/download/atop-2.3.0.tar.gz  && tar -xvzf atop-2.3.0.tar.gz  && rm atop-2.3.0.tar.gz  ;\
    D=$(pwd); ls -la / /root ; \
    cd /atop-1.26   &&  make all install clean && cd / rm -R /atop-1.26 ; \
    cd /atop-2.1 &&  make all install clean && cd / rm -R /atop-2.1 ; \
    cd /usr/bin; ln -fs atop-2.1 /usr/bin/atop-1.26 ;\
    cd /usr/bin; ln -fs atop-2.1 /usr/bin/atopsar-1.26 ;\
    cd /atop-2.2    &&  make all install clean && cd / rm -R /atop-2.2           ; \
    cd /atop-2.3.0  &&  make all genericinstall clean && cd / rm -R /atop-2.3.0  ; \
    cd /usr/bin; ln -fs atop-2.3.0 /usr/bin/atop-2.2    ;\
    cd /usr/bin; ln -fs atop-2.3.0 /usr/bin/atopsar-2.2 ;\
    rm -f /etc/atop/atop.daily /etc/rc.d/init.d/atop /etc/cron.d/atop ; \
    ls -la /usr/bin/a* /usr/sbin/a* ;\
    apt-get remove -y build-essential make; apt-get autoremove -y

RUN rm -f /etc/systemd/system/influxd.service /etc/systemd/system/multi-user.target.wants/influxdb.service

ADD     parse.awk       /
ADD     convert.sh      /

CMD     ["/convert.sh"]
