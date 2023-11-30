#!/bin/bash

echo "This is my quote app script!"

api_key=$1
psql_host=$2
psql_port=$3
psql_db=$4
psql_user=$5
psql_password=$6
symbols=$7

# Check # of args
if [ "$#" -ne 7 ]; then
    echo "Incorrect number of arguments"
    exit 1
fi


