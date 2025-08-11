#!/usr/bin/bash

TARGET_GROUP="custom"
TARGET_ARCH="Vicuna"

if [ "$#" -ne 4 ]; then
    echo "run-target.sh <arch> <vlen> <vlane_width> <target>"
fi

GCC_ARCH=$1
VLEN=$2
VLANE_WIDTH=$3
TARGET_SW=$4

ZVL_STRING="zvl${VLEN}b"
TARGET_SW_EXPLICIT=$GCC_ARCH/$ZVL_STRING/bin/$TARGET_SW

echo "Running $TARGET_SW build with ${GCC_ARCH}_$ZVL_STRING and VLANE_WIDTH ${VLANE_WIDTH}"

OUT_DIR="$WS_PATH/gen_perfsim/out/$GCC_ARCH/$ZVL_STRING"
mkdir -p $OUT_DIR
rm $OUT_DIR/VICUNA*
PARAMS="-tp=$OUT_DIR" # -ta=$OUT_DIR"

COMPARISON_DIR="$WS_PATH/rvv_testing/comparison"
VICUNA_DIR="$WS_PATH/vicuna2_tinyml_benchmarking"
TRACE_DIR="$COMPARISON_DIR/etiss/$GCC_ARCH/$ZVL_STRING/vlane$VLANE_WIDTH"
mkdir -p $TRACE_DIR

export VLEN=$VLEN
export VLANE_WIDTH=$VLANE_WIDTH

cd $WS_PATH/gen_perfsim

./scripts/run.sh $TARGET_GROUP $TARGET_SW_EXPLICIT $TARGET_ARCH $PARAMS > $TRACE_DIR/${TARGET_SW}_output.txt
sed '/^0x/!d' $TRACE_DIR/${TARGET_SW}_output.txt > $TRACE_DIR/${TARGET_SW}_trace.txt

cat $OUT_DIR/VICUNA_timing_* > $TRACE_DIR/${TARGET_SW}_timing.csv