#!/usr/bin/env bash

function retry()
{
  local n=0
  local try=$1
  local cmd="${@: 2}"
  [[ $# -le 1 ]] && {
  echo "Usage $0 <retry_number> <Command>"; }

  until [[ $n -ge $try ]]
  do
    output=$($cmd)
    exitcode=$?
    if [ "${exitcode}" -eq 0 ]; then
      echo "${output}"
      exit ${exitcode}
    else
      #echo "Command Fail with ${output} and exitcode ${exitcode}."
      ((n++))
      #echo "retry $n ::"
      sleep 1;
      if [[ $n -ge $try ]]; then
        #echo "Exit with non-zero exit code"
        echo "${output}"
        exit ${exitcode}
      fi
    fi
  done
}

retry $*
