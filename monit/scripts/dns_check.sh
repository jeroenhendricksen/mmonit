#!/usr/bin/env bash

HOST=$1
DNS_SERVER=$2

OUTPUT=$(nslookup $HOST $DNS_SERVER)
EXITCODE=$?

if [ "${EXITCODE}" -ne "0" ]; then
    echo "nslookup failed for $HOST: ${OUTPUT}"
    exit 1
else 

    echo "nslookup ok for $HOST: ${OUTPUT}" 
    exit 0
fi