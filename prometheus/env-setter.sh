#!/bin/bash
# - targets: ['raphtory_partitionManager_1:19200', 'raphtory_router_1:19300', 'raphtory_updater_1:19400']

TARGETS="        - targets: ["
PREFIX=`ip addr show eth1 | tail -n 2 | head -n 1 | sed "s/.*inet \([0-9]\+\..*\)\.[0-9]\+\/[0-9]\+.*/\1/"`
PORT=11600

for i in `seq 0 253`; do
    TARGETS="${TARGETS}'${PREFIX}.${i}:${PORT}', "
done
TARGETS="${TARGETS}'${PREFIX}.254:${PORT}']"
echo $TARGETS
echo "${TARGETS}" >> /etc/prometheus/prometheus.yml

/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles
