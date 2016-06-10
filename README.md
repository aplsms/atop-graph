#Graphing __atop__ metrics in grafana/influxdb

Just simple way to create graphics from atop metrics. Now it works for:

- __CPU__ information
- __cpu__ infirmation per core
- __CPL__ CPU load statistic
- __MEM__ Memory usage statistics
- __SWP__ swapping statistics
- __PAG__ paging statistics
- __LVM/MDD/DSK__ disk subsystem statistics
- __NET__ network statistics per interface and upper level

__NOT__ working for process-level statistics:

- "PRG" (general),
- "PRC" (cpu),
- "PRM" (memory),
- "PRD" (disk, only if the kernel-patch has been installed)
- "PRN" (network, only if the kernel-patch has been installed).

## exporting atop metrics

For example, you have atop logs per host:

```
./C1/atop_20160531
./C1/atop_20160601
./C1/atop_20160602
./C1/atop_20160603
./C2/atop_20160531
./C2/atop_20160601
./C2/atop_20160602
./C2/atop_20160603
./C3/atop_20160531
./C3/atop_20160601
./C3/atop_20160602
./C3/atop_20160603

```

To export metrics, please run `for i in `find . -type f -name atop\*` ; do atop -r $i -P ALL |grep -v '^PR' >$i.ST1; done

based on github.com/kamon-io/docker-grafana-influxdb but almost 90% rewrited.

This image contains a sensible default configuration of InfluxDB and Grafana. It explicitly doesn't bundle an example dashboard.

### Using the Dashboard ###

Once your container is running all you need to do is open your browser pointing to the host/port you just published and play with the dashboard at your wish. We hope that you have a lot of fun with this image and that it serves it's purpose of making your life easier.

### Building the image yourself ###

The Dockerfile and supporting configuration files are available in this Github repository. This comes specially handy if you want to change any of the InfluxDB or Grafana settings, or simply if you want to know how the image was built.
The repo also has `build`, `start` and `stop` scripts to make your workflow more pleasant.

### Configuring the settings  ###

The container exposes the following ports by default:

- `3000`: Grafana web interface.
- `8083`: InfluxDB Admin web interface.
- `8084`: InfluxDB HTTPS API (not usable by default).
- `8086`: InfluxDB HTTP API.

To start a container with your custom config: see `start` script.

To change ports, consider the following:

- `3000`: edit  `Dockerfile, and start script`.
- `8083`: edit: `Dockerfile, influxDB/config.toml and start script`. _TODO: fix it for config_
- `8084`: edit: to be announced.
- `8086`: edit: `Dockerfile, influxDB/config.toml, grafana/grafana.ini, set_influxdb.sh and start script`. _TODO: fix it for config_

### Running container under boot2docker on Mac OS X ###
```bash
docker run -d -p 80:80 -p 8083:8083 -p 8084:8084 -p 8086:8086 --name grafana-influxdb_con grafana_influxdb
```

InfluxDB is configured by default with two databases. `grafana` DB for storing your measurements. You can edit all default passwords in `Dockerfile`. If you wanna edit DB names, users and passwords, have a look at the following files: `grafana/grafana.ini, set_grafana.sh, set_influxdb.sh and Dockerfile`

HTTPS API wasn't tested yet, that's why it isn't configured. Some boilerplate code can be found in `Dockerfile and set_influxdb.sh`. Needs testing and possibly more.
