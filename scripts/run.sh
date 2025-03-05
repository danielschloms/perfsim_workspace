#!/bin/bash

set -e

cd $(dirname $(realpath -s $0))
. ../.env
# . $(dirname "${0}")/../.env

TARGET_SW=$1
shift

CMD_OPTIONS=""
CORE_SPECIFIED=0

while [ "$#" -gt 0 ];
do
    arg="$1"
    if [ "$arg" = "cv32e40p" ] && [ ${CORE_SPECIFIED} == 0 ]; then
	CMD_OPTIONS="${CMD_OPTIONS} --core cv32e40p"
	CORE_SPECIFIED=1
    elif [ "$arg" = "cva6" ] && [ ${CORE_SPECIFIED} == 0 ]; then
	CMD_OPTIONS="${CMD_OPTIONS} --core cva6"
	CORE_SPECIFIED=1
    elif [ "$arg" = "cv32e40xv" ] && [ ${CORE_SPECIFIED} == 0 ]; then
	CMD_OPTIONS="${CMD_OPTIONS} --core cv32e40xv"
	CORE_SPECIFIED=1
    else
	CMD_OPTIONS="${CMD_OPTIONS} ${arg}"
    fi
    shift
done

if [ ${CORE_SPECIFIED} == 1 ]; then
    ${PSW_SCRIPTS_SUPPORT}/run_helper.py ${TARGET_SW} ${CMD_OPTIONS}
else
    echo "No valid core specified!"
fi
