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
  # Core global metrics
  # -------------------------
  --collect.global_status \
  --collect.global_variables \
  \
  # -------------------------
  # Process + workload
  # -------------------------
  --collect.info_schema.processlist \
  --collect.info_schema.processlist.processes_by_user \
  --collect.info_schema.processlist.processes_by_host \
  \
  # -------------------------
  # Schema / table level
  # -------------------------
  --collect.info_schema.tables \
  --collect.info_schema.tablestats \
  --collect.info_schema.schemastats \
  \
  # -------------------------
  # InnoDB internal metrics
  # -------------------------
  --collect.info_schema.innodb_metrics \
  --collect.info_schema.innodb_cmp \
  --collect.info_schema.innodb_cmpmem \
  --collect.info_schema.innodb_tablespaces \
  \
  # -------------------------
  # Performance Schema (THIS is key)
  # -------------------------
  --collect.perf_schema.eventsstatements \
  --collect.perf_schema.eventsstatementssum \
  --collect.perf_schema.eventswaits \
  --collect.perf_schema.tableiowaits \
  --collect.perf_schema.indexiowaits \
  --collect.perf_schema.tablelocks \
  --collect.perf_schema.file_events \
  --collect.perf_schema.file_instances \
  --collect.perf_schema.memory_events \
  \
  # -------------------------
  # Replication (safe even if unused)
  # -------------------------
  --collect.slave_status \
  --collect.slave_hosts \
  --collect.perf_schema.replication_applier_status_by_worker \
  --collect.perf_schema.replication_group_members \
  --collect.perf_schema.replication_group_member_stats \
  \
  # -------------------------
  # Optional extra insight layers
  # -------------------------
  --collect.auto_increment.columns \
  --collect.binlog_size \
  --collect.mysql.user \
  --collect.info_schema.userstats \
  --collect.info_schema.clientstats \
  \
  # -------------------------
  # Query response time (if enabled in MySQL/MariaDB)
  # -------------------------
  --collect.info_schema.query_response_time
  