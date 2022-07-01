#!/usr/bin/env bash

nc -q 2 -w 2 $1 $2 < /dev/null
EXITSTATUS=$?

if [ "${EXITSTATUS}" -eq 0 ]; then
    echo "Port open for $1 $2 (exit status ${EXITSTATUS})"
else
    echo "Port closed for $1 $2 (exit status ${EXITSTATUS})"
fi

exit ${EXITSTATUS}
