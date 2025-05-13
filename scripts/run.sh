#!/bin/bash

set -e

cd $WS_PATH/gen_perfsim
. .env
# . $ENVPATH
# . $(dirname "${0}")/../.env

SW_DIR=$1
# SW_NAME=$(basename "$2")
SW_NAME=$2
TARGET_SW="$SW_DIR:$SW_NAME"
shift
shift
CMD_OPTIONS=""
CORE_SPECIFIED=0

while [ "$#" -gt 0 ];
do
    # arg=$(basename "$1")
    arg=$1
    if [ "$arg" = "cv32e40p" ] && [ ${CORE_SPECIFIED} == 0 ]; then
	CMD_OPTIONS="${CMD_OPTIONS} --core cv32e40p"
	CORE_SPECIFIED=1
    elif [ "$arg" = "Vicuna" ] && [ ${CORE_SPECIFIED} == 0 ]; then
	CMD_OPTIONS="${CMD_OPTIONS} --core Vicuna"
	CORE_SPECIFIED=1
    elif [ "$arg" = "cva6" ] && [ ${CORE_SPECIFIED} == 0 ]; then
	CMD_OPTIONS="${CMD_OPTIONS} --core cva6"
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
