#!/usr/bin/bash

TARGET_GROUP="custom"
TARGET_SW="vector_add"
TARGET_ARCH="Vicuna"

OUT_DIR="$WS_PATH/gen_perfsim/out"
PARAMS="-tp=$OUT_DIR -ta=$OUT_DIR"

cd $WS_PATH/gen_perfsim
./scripts/run.sh $TARGET_GROUP $TARGET_SW $TARGET_ARCH $PARAMS

VICUNA_DIR="$WS_PATH/vicuna2_tinyml_benchmarking"
TRACE_DIR="$VICUNA_DIR/trace_comparison"

cat $OUT_DIR/VICUNA_timing_* > $TRACE_DIR/etiss/etiss_timing.csv