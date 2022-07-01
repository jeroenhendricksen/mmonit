#!/usr/bin/env bash

url=$1
expected_http_response=$2
measurement=$3

if [ -z "${url}" ]; then
    echo "url server not provided"
    exit 1
fi

if [ -z "${expected_http_response}" ]; then
    echo "expected_http_response port not provided"
    exit 1
fi

if [ -z "${measurement}" ]; then
    echo "measurement not provided"
    exit 1
fi

STATUSCODE=$(curl -4 --silent --fail --output /dev/null --write-out "%{http_code}" --connect-timeout 5 --retry 5 --retry-delay 3 "${url}" 2>/dev/null)
EXITCODE=$?

if [ -z "${STATUSCODE}" ]; then
    echo "curl output was empty"
    exit 1
fi
if [ "${STATUSCODE}" -eq "${expected_http_response}" ]; then
    echo "statuscode was '${STATUSCODE}' as expected. exitcode: ${EXITCODE}" 
    exit 0
else
    echo "expected statuscode ${expected_http_response} but was '${STATUSCODE}'. exitcode: ${EXITCODE}"
    if [ "${EXITCODE}" -eq "0" ]; then
        exit 1
    fi
    exit ${EXITCODE}
fi
