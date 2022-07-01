#!/usr/bin/env bash

url=$1
jq_json_match=$2
fail_on_this_string_result=$3

if [ -z "${url}" ]; then
    echo "url server not provided"
    exit 1
fi

if [ -z "${jq_json_match}" ]; then
    echo "jq_json_match not provided"
    exit 1
fi

if [ -z "${fail_on_this_string_result}" ]; then
    echo "fail_on_this_string_result not provided"
    exit 1
fi

OUTPUT=$(curl -4 --connect-timeout 2 --max-time 3 -s -X GET "${url}" | jq "${jq_json_match}" | grep "${fail_on_this_string_result}")
EXITCODE=$?

if [ "${EXITCODE}" -eq "0" ]; then
    echo "Alertmanager shows errors. JSON body contains string '${fail_on_this_string_result}'." 
    exit 1
else
    echo "No match ('${OUTPUT}') or unable to determine error (${EXITCODE})."
    exit 0
fi
