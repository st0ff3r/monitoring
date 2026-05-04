#!/bin/sh
sed -e "s|\${MYSQL_EXPORTER_USER}|$MYSQL_EXPORTER_USER|" \
    -e "s|\${MYSQL_EXPORTER_PASS}|$MYSQL_EXPORTER_PASS|" \
    -e "s|\${MYSQL_HOST}|$MYSQL_HOST|" \
    -e "s|\${MYSQL_PORT}|$MYSQL_PORT|" \
    /etc/mysql/my.cnf > /tmp/my.cnf

exec mysqld_exporter \
  --log.level=info \
  --config.my-cnf=/tmp/my.cnf \
  \
  # -------------------------
  # CORE METRICS (YOU NEED THESE)
  # -------------------------
  --collect.global_status \
  --collect.global_variables \
  \
  # -------------------------
  # CONNECTION / THREADS
  # -------------------------
  --collect.info_schema.processlist \
  \
  # -------------------------
  # QUERY LOAD + ACTIVITY
  # -------------------------
  --collect.perf_schema.eventsstatements \
  --collect.perf_schema.eventswaits \
  \
  # -------------------------
  # TABLE / SCHEMA (used for table stats panels)
  # -------------------------
  --collect.info_schema.tables \
  --collect.info_schema.tablestats \
  \
  # -------------------------
  # INNODB (memory + buffer pool panels)
  # -------------------------
  --collect.info_schema.innodb_metrics \
  \
  # -------------------------
  # OPTIONAL BUT USED IN YOUR DASHBOARD
  # -------------------------
  --collect.binlog_size \
  --collect.auto_increment.columns
