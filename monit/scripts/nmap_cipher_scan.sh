#!/usr/bin/env bash

HOST=$1
PORT=$2
EXPECTED_RATING=$3

if [ -z "${PORT}" ]; then
    PORT="443"
fi

if [ -z "${EXPECTED_RATING}" ]; then
    EXPECTED_RATING="least strength: A"
fi

OUTPUT=$(nmap --script ssl-enum-ciphers -p "${PORT}" "${HOST}" | grep "${EXPECTED_RATING}")
EXITCODE=$?

if [ "${EXITCODE}" -ne "0" ]; then
    echo "nmap failed for $HOST:$PORT (exitcode ${EXITCODE})"
    exit 1
else 
    if [[ "${OUTPUT}" == *"${EXPECTED_RATING}"* ]]; then
        echo "OK: nmap for $HOST:$PORT contains '${EXPECTED_RATING}'" 
        exit 0
    else
        echo "NOT OK: nmap for $HOST:$PORT does not contain '${EXPECTED_RATING}'" 
        exit 2
    fi
fi