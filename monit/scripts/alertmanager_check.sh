#!/usr/bin/env bash

QUERY_RESULT=$(http --check-status --ignore-stdin --body --timeout=3 "https://prometheus/api/v1/query?query=ALERTS_FOR_STATE")
QUERY_EXITCODE=$?

if [[ "${QUERY_EXITCODE}" -eq "0" ]]; then
    NUMBER_OF_ALERTS=$(echo "${QUERY_RESULT}" | jq -r '.data.result | length')
    if [[ "${NUMBER_OF_ALERTS}" -gt "0" ]]; then
        ALERT_NAMES=$(echo "${QUERY_RESULT}" | jq -r '.data.result[0].metric.alertname') 
        echo "${NUMBER_OF_ALERTS} active alert: ${ALERT_NAMES}"
        exit 1
    else
        echo "There are no active alerts"
        exit 0
    fi
else
    case ${QUERY_EXITCODE} in
        2) echo "(${QUERY_EXITCODE}) Request timed out!" ;;
        3) echo "(${QUERY_EXITCODE}) Unexpected HTTP 3xx Redirection!" ;;
        4) echo "(${QUERY_EXITCODE}) HTTP 4xx Client Error!" ;;
        5) echo "(${QUERY_EXITCODE}) HTTP 5xx Server Error!" ;;
        6) echo "(${QUERY_EXITCODE}) Exceeded --max-redirects=<n> redirects!" ;;
        *) echo "(${QUERY_EXITCODE}) Other Error!" ;;
    esac
    exit 2
fi
