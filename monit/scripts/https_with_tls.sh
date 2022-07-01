#!/usr/bin/env bash

url=$1
expected_statuscode=$2

if [ -z "${url}" ]; then
    echo "url server not provided"
    exit 1
fi

if [ -z "${expected_statuscode}" ]; then
    echo "expected_statuscode server not provided"
    exit 1
fi

STATUSCODE=$(curl -4 --tlsv1.3 --silent --fail --output /dev/null --write-out "%{http_code}" --tcp-nodelay --connect-timeout 5 --retry 2 --retry-delay 0 --retry-max-time 6 --max-time 6 "${url}" 2>/dev/null)
EXITCODE=$?

if [ "${STATUSCODE}" != "${expected_statuscode}" ]; then
    echo "NOT OK. ${STATUSCODE} != ${expected_statuscode}"
else
    echo "TLS v1.3 connection success (${STATUSCODE})"
fi

exit ${EXITCODE}
