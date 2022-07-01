#!/usr/bin/env bash

ip=$1

if [ -z "${ip}" ]; then
    echo "ip server not provided"
    exit 1
fi

OUTPUT=$(ntpdate -q "${ip}")
EXITCODE=$?

if [ "${EXITCODE}" -ne "0" ]; then
    echo "ntpdate failed: ${OUTPUT}"
    exit 1
else 

    echo "ntpdate ok: ${OUTPUT}" 
    exit 0
fi
