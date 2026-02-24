#!/bin/sh
sed -e "s|\${MYSQL_EXPORTER_USER}|$MYSQL_EXPORTER_USER|" \
    -e "s|\${MYSQL_EXPORTER_PASS}|$MYSQL_EXPORTER_PASS|" \
    -e "s|\${MYSQL_HOST}|$MYSQL_HOST|" \
    -e "s|\${MYSQL_PORT}|$MYSQL_PORT|" \
    /etc/mysql/my.cnf > /tmp/my.cnf

exec mysqld_exporter --config.my-cnf=/tmp/my.cnf \
  --collect.info_schema.processlist \
  --collect.info_schema.tables \
  --collect.info_schema.innodb_metrics \
  --collect.perf_schema.eventsstatements \
  --collect.perf_schema.eventswaits \
  --collect.perf_schema.file_events \
  --no-collect.slave_status
