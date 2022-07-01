#!/usr/bin/env bash

url=$1
expected_http_response=$2

if [ -z "${url}" ]; then
    echo "url server not provided"
    exit 1
fi

if [ -z "${expected_http_response}" ]; then
    echo "expected_http_response port not provided"
    exit 1
fi

STATUSCODE=$(/etc/monit/scripts/retry.sh 3 /etc/monit/scripts/isup.pure.sh "${url}" "${expected_http_response}")
EXITCODE=$?

if [ -z "${STATUSCODE}" ]; then
    echo "curl output was empty"
    exit 1
fi
if [ "${STATUSCODE}" -eq "${expected_http_response}" ]; then
    echo "OK. Statuscode was '${STATUSCODE}' as expected. Exitcode: ${EXITCODE}" 
    exit 0
else
    echo "NOT OK. Statuscode expected '${expected_http_response}' but was '${STATUSCODE}'. Exitcode: ${EXITCODE}"
    if [ "${EXITCODE}" -eq "0" ]; then
        exit 1
    fi
    exit ${EXITCODE}
fi