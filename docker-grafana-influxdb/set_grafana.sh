#!/bin/bash
set -e

if [ -f /.grafana_configured ]; then
    echo "=> grafana has been configured!"
    exit 0
fi

echo "=> Configuring grafana"

sed -i -e "s#<--GRAFANA_PORT-->#${GRAFANA_PORT}#g" /etc/grafana/grafana.ini && \
    chown root:grafana /etc/grafana/grafana.ini

# starting grafana server for adding datasource
/etc/init.d/grafana-server start
/etc/init.d/grafana-server status

START_TIMEOUT=120
T=1
while ! nc -z -w 3 localhost 3000 </dev/null; do 
    let T=$T+1
    echo -n "."
    if [[ $START_TIMEOUT -le $T ]] ; then 
        echo "unable  to start grafana"
        exit 1
    fi
    sleep 1
done

echo ""
echo "Grafana accessible"

curl -s  "http://admin:admin@127.0.0.1:${GRAFANA_PORT}/api/datasources" -X POST \
    -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary '{"name":"influx","type":"influxdb", "url":"'${INFLUXDB_URL}'", "access":"proxy","isDefault":true, "database":"grafana","user":"'${INFLUXDB_GRAFANA_USER}'","password":"'${INFLUXDB_GRAFANA_PW}'"}'

echo ""

/etc/init.d/grafana-server stop


touch /.grafana_configured

echo "=> Grafana has been configured as follows:"
echo "   InfluxDB DB DATA NAME:  data"
echo "   InfluxDB URL: ${INFLUXDB_URL}"
echo "   InfluxDB USERNAME: ${INFLUXDB_DATA_USER}"
echo "   InfluxDB PASSWORD: ${INFLUXDB_DATA_PW}"
echo "   InfluxDB DB GRAFANA NAME:  grafana"
echo "   InfluxDB USERNAME: ${INFLUXDB_GRAFANA_USER}"
echo "   InfluxDB PASSWORD: ${INFLUXDB_GRAFANA_PW}"
echo "   ** Please check your environment variables if you find something is misconfigured. **"
echo "=> Done!"

exit 0
