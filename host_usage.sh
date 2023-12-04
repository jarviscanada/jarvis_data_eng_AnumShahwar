#! /bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check # of args
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
date


vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

memory_free=$vmstat --unit M | awk '{print $4}'| tail -n1 | xargs
disk_io=$vmstat --unit M | awk '{print $10}' | tail -n1 | xargs
disk_available=(df -BM / ...)
cpu_idle=$vmstat --unit M | awk '{print $15}' | tail -n1 | xargs
cpu_kernel=$vmstat --unit M | awk '{print $14}' | tail -n1 | xargs
timestamp=$(vmstat -t | awk'{print $18}' | tail -n1 | xargs

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";

insert_stmt=" INSERT INTO host_usage (host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available, timestamp) VALUES ('$1', $2099, $63, $27, $12, $21130, '2023-11-29 23:59:39');"




