#!/usr/bin/bash

TARGET_GROUP="custom"


if [ "$#" -lt 4 ] || [ "$#" -gt 5 ]; then
    echo "run-target.sh <arch> <vlen> <vlane_width> <target> [--gdb]"
fi

GCC_ARCH=$1
VLEN=$2
VLANE_WIDTH=$3
TARGET_SW=$4
GDB_FLAG=""
TARGET_ARCH="Vicuna_zvl${VLEN}b"
# TARGET_ARCH="Vicuna"

if [ "$5" = "--gdb" ]; then
    GDB_FLAG="-gdbh"
fi

SCALAR_ARCH_INT="rv32im_zicsr"
SCALAR_ARCH_FLOAT="rv32imf_zicsr"
ZVL_STRING="zvl${VLEN}b"
VLANE_STRING="vlane${VLANE_WIDTH}"


echo "Running $TARGET_SW build with ${GCC_ARCH}_$ZVL_STRING and VLANE_WIDTH ${VLANE_WIDTH}"

ARCH_SUBPATH="$GCC_ARCH/$ZVL_STRING/$VLANE_STRING"
TARGET_SW_EXPLICIT=$GCC_ARCH/$ZVL_STRING/bin/$TARGET_SW
if [ "$ARCH" = "$SCALAR_ARCH_INT" ] || [ "$ARCH" = "$SCALAR_ARCH_FLOAT" ]; then
    ARCH_SUBPATH=$GCC_ARCH
    TARGET_SW_EXPLICIT=$GCC_ARCH/bin/$TARGET_SW
fi

OUT_DIR="$WS_PATH/gen_perfsim/out/$ARCH_SUBPATH/$TARGET_SW"
DYN_PATH="$WS_PATH/gen_perfsim/etiss-perf-sim/simulator/dyn_inis/$ARCH_SUBPATH/$TARGET_SW"
mkdir -p $OUT_DIR
rm -f $OUT_DIR/VICUNA*
rm -f $OUT_DIR/asm_trace*
PARAMS="-tp=$OUT_DIR --dyn_path=$DYN_PATH -ta=$OUT_DIR $GDB_FLAG"
# PARAMS="-tp=$OUT_DIR"

COMPARISON_DIR="$WS_PATH/rvv_testing/comparison"
VICUNA_DIR="$WS_PATH/vicuna2_tinyml_benchmarking"
TRACE_DIR="$COMPARISON_DIR/etiss/$ARCH_SUBPATH"
mkdir -p $TRACE_DIR

export VLEN=$VLEN
export VLANE_WIDTH=$VLANE_WIDTH

cd $WS_PATH/gen_perfsim

./scripts/run.sh $TARGET_GROUP $TARGET_SW_EXPLICIT $TARGET_ARCH $PARAMS
TRACE_FILE=$TRACE_DIR/${TARGET_SW}_trace.txt
# > $TRACE_DIR/${TARGET_SW}_output.txt

cat $OUT_DIR/VICUNA*_timing_* > $TRACE_DIR/${TARGET_SW}_timing.csv
cat $OUT_DIR/asm_trace_* > $TRACE_DIR/${TARGET_SW}_trace.txt
sed -i '/^0x/!d' $TRACE_FILE
