#!/usr/bin/env bash

HOST=$1
PORT=$2
TOPIC=$3
EXPECTED_MESSAGE=$4

if [ -z "${HOST}" ]; then
    echo "HOST server not provided"
    exit 1
fi

if [ -z "${PORT}" ]; then
    echo "PORT server not provided"
    exit 1
fi

if [ -z "${TOPIC}" ]; then
    echo "TOPIC server not provided"
    exit 1
fi

if [ -z "${EXPECTED_MESSAGE}" ]; then
    echo "EXPECTED_MESSAGE server not provided"
    exit 1
fi

PROCESS_OUTPUT=$(mosquitto_sub -i "mosquitto_pub_monit_${TOPIC}" -h "${HOST}" -p "${PORT}" -t "${TOPIC}" -C 1 -W 3 | grep "${EXPECTED_MESSAGE}")
EXITCODE=$?

if [ "${EXITCODE}" -eq "0" ]; then
    echo "MQTT ${TOPIC} contains '${EXPECTED_MESSAGE}'"
    exit 0
else
    echo "MQTT topic ${TOPIC} failed with exitcode ${EXITCODE}"
    exit ${EXITCODE}
fi
