#!/bin/bash

# Shows swap usage per process
# mhammer@zendesk.com, 2012/09/14

SELECT_PID=${1}
FIND_NAME=""
if [ ! "${SELECT_PID}" == "" ]; then
  FIND_NAME="-name ${SELECT_PID}"
fi

for PROC_FILE in `find /proc/ -maxdepth 1 -type d ${FIND_NAME}`; do
  echo `basename ${PROC_FILE}` | egrep -q '^[0-9]+'
  if [ $? -eq 0 ]; then
    echo -n "PID `basename ${PROC_FILE}`: "
    let SWAP_TOTAL=0
    SWAPS=`cat ${PROC_FILE}/smaps | grep ^Swap | awk '{ print $2 }' | tr '\n' ' '`
    for SWAP_KB in ${SWAPS}; do
      let SWAP_TOTAL=(${SWAP_KB}+${SWAP_TOTAL}) 
    done
    echo "${SWAP_TOTAL}Kb"
  fi
done
