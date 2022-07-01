#!/usr/bin/env bash

url=$1
jq_json_match=$2
expected_string_result=$3

if [ -z "${url}" ]; then
    echo "url server not provided"
    exit 1
fi

if [ -z "${jq_json_match}" ]; then
    echo "jq_json_match not provided"
    exit 1
fi

if [ -z "${expected_string_result}" ]; then
    echo "expected_string_result not provided"
    exit 1
fi

STATUSCODE=$(curl -4 --connect-timeout 2 --max-time 3 -s -X GET "${url}" | jq "${jq_json_match}" | grep "${expected_string_result}")
EXITCODE=$?

if [ "${EXITCODE}" -eq "0" ]; then
    echo "Exitcode was as expected (${EXITCODE}). JSON body contains string '${expected_string_result}'" 
    exit 0
else
    echo "Exitcode was not as expected (${EXITCODE}). JSON body does not contain '${expected_string_result}'"
    exit ${EXITCODE}
fi
