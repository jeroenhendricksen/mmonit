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

STATUSCODE=$(curl -4 --silent --fail --output /dev/null --write-out "%{http_code}" --tcp-nodelay --tlsv1 --connect-timeout 5 --retry 2 --retry-delay 0 --retry-max-time 6 --max-time 6 "${url}" 2>/dev/null)
EXITCODE=$?
echo "${STATUSCODE}"
exit ${EXITCODE}
