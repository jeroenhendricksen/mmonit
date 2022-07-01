#!/usr/bin/env bash

HOST=$1
PORT=$2

if [ -z "${HOST}" ]; then
    echo "HOST server not provided"
    exit 1
fi

if [ -z "${PORT}" ]; then
    echo "PORT server not provided"
    exit 1
fi

mosquitto_pub -i mosquitto_pub_monit -h "${HOST}" -p "${PORT}" -m "$(date +\"%T\")" -t test/monit-meter
EXITCODE=$?

if [ "${EXITCODE}" -eq "0" ]; then
    echo "MQTT publish successful"
    exit 0
else
    echo "MQTT publish failed with exitcode ${EXITCODE}"
    exit ${EXITCODE}
fi
