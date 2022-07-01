#!/usr/bin/env bash

if [ -z "${SLACK_WEBHOOK_URL}" ]; then
    echo "SLACK_WEBHOOK_URL is not defined"
    exit 1
fi

if [ -z "${SLACK_CHANNEL}" ]; then
    echo "SLACK_CHANNEL is not defined"
    exit 1
fi

if [[ ${MONIT_EVENT} == *"succeeded"* ]]; then
    curl -4 --silent --fail --tcp-nodelay --tlsv1.2 --connect-timeout 5 --retry 1 --retry-delay 0 --retry-max-time 6 --max-time 6 -X POST -H 'Content-type: application/json' \
    --data "{\"channel\": \"${SLACK_CHANNEL}\", \"icon_emoji\": \":white_check_mark:\", \"username\": \"${SLACK_CHANNEL}\", \"text\":\"${MONIT_HOST} ${MONIT_SERVICE} - ${MONIT_DESCRIPTION}\"}" \
     "${SLACK_WEBHOOK_URL}"
else
    curl -4 --silent --fail --tcp-nodelay --tlsv1.2 --connect-timeout 5 --retry 1 --retry-delay 0 --retry-max-time 6 --max-time 6 -X POST -H 'Content-type: application/json' \
    --data "{\"channel\": \"${SLACK_CHANNEL}\", \"icon_emoji\": \":x:\", \"username\": \"${SLACK_CHANNEL}\", \"text\":\"${MONIT_HOST} ${MONIT_SERVICE} - ${MONIT_DESCRIPTION}\"}" \
    "${SLACK_WEBHOOK_URL}"
fi
 