#!/usr/bin/bash

TARGET_GROUP="custom"
TARGET_SW="vector_add"
TARGET_ARCH="Vicuna"

if [ "$#" -eq 1 ]; then
    TARGET_SW=$1
fi

echo "Running $TARGET_SW."

OUT_DIR="$WS_PATH/gen_perfsim/out"
rm $OUT_DIR/VICUNA*
PARAMS="-tp=$OUT_DIR" # -ta=$OUT_DIR"

cd $WS_PATH/gen_perfsim

VICUNA_DIR="$WS_PATH/vicuna2_tinyml_benchmarking"
TRACE_DIR="$VICUNA_DIR/trace_comparison"

./scripts/run.sh $TARGET_GROUP $TARGET_SW $TARGET_ARCH $PARAMS > $TRACE_DIR/etiss/${TARGET_SW}_output.txt
sed '/^0x/!d' $TRACE_DIR/etiss/${TARGET_SW}_output.txt > $TRACE_DIR/etiss/${TARGET_SW}_trace.txt

cat $OUT_DIR/VICUNA_timing_* > $TRACE_DIR/etiss/${TARGET_SW}_timing.csv