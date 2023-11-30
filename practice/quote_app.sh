#!/bin/bash

echo "This is my quote app script!"


psql_host=$1
psql_port=$2
psql_db=$3
psql_user=$4
psql_password=$5

# Check # of args
if [ "$#" -ne 5 ]; then
    echo "Incorrect number of arguments"
    exit 1
fi








echo "All arguments provided: $1, $2, $3, $4, $5"













