#!/usr/bin/env bash

url=$1
expected_http_body=$2

if [ -z "${url}" ]; then
    echo "url server not provided"
    exit 1
fi

if [ -z "${expected_http_body}" ]; then
    echo "expected_http_body port not provided"
    exit 1
fi

STATUSCODE=$(curl -4 -s "${url}" | grep -F "${expected_http_body}")
EXITCODE=$?

if [ "${EXITCODE}" -eq "0" ]; then
    echo "Exitcode was as expected (${EXITCODE}). HTTP body contains string '${expected_http_body}'" 
    exit 0
else
    echo "Exitcode was not as expected (${EXITCODE}). HTTP body does not contain '${expected_http_body}'"
    exit ${EXITCODE}
fi
