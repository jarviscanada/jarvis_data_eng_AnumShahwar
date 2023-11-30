#!/bin/bash

echo "This is my quote app script!"


AMZN=$1
MSFT=$2
AAPL=$3


# Check # of args
if [ "$#" -ne 3 ]; then
    echo "Incorrect number of arguments"
    exit 1
fi


echo "All arguments provided: $1, $2, $3"













