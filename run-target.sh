#!/usr/bin/bash

PERFSIM_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT_DIR="$(dirname "$PERFSIM_DIR")"

TARGET_GROUP="custom"

GCC_ARCH="rv32im_zve32x"
VLEN="64"
VLANE_WIDTH="32"
TARGET_SW=""
GDB_FLAG=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --arch)
      ARCH="$2"
      shift # past argument
      shift # past value
      ;;
    --vlen)
      VLEN="$2"
      shift # past argument
      shift # past value
      ;;
    --vlane_width)
      VLANE_WIDTH="$2"
      shift # past argument
      shift # past value
      ;;
    --target)
      TARGET_SW="$2"
      shift # past argument
      shift # past value
      ;;
    --gdb)
      GDB_FLAG="-gdbh"
      shift # past argument
      ;;
    -*|--*)
      >&2 echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

TARGET_ARCH="Vicuna_zvl${VLEN}b"
# TARGET_ARCH="Vicuna"

ZVL_STRING="zvl${VLEN}b"
VLANE_STRING="vlane${VLANE_WIDTH}"

echo "Running $TARGET_SW build with ${GCC_ARCH}_$ZVL_STRING and VLANE_WIDTH ${VLANE_WIDTH}"

ARCH_SUBPATH="$GCC_ARCH/$ZVL_STRING/$VLANE_STRING"
TARGET_SW_EXPLICIT=$GCC_ARCH/$ZVL_STRING/bin/$TARGET_SW

OUT_DIR="$PERFSIM_DIR/out/$ARCH_SUBPATH/$TARGET_SW"
DYN_PATH="$PERFSIM_DIR/etiss-perf-sim/simulator/dyn_inis/$ARCH_SUBPATH/$TARGET_SW"
mkdir -p $OUT_DIR
PARAMS="--dyn_path=$DYN_PATH -tp=$OUT_DIR -ta=$OUT_DIR $GDB_FLAG"
# PARAMS="--dyn_path=$DYN_PATH $GDB_FLAG"
# PARAMS="-tp=$OUT_DIR"

COMPARISON_DIR="$PROJECT_ROOT_DIR/Perf_Comparison/comparison"
VICUNA_DIR="$PROJECT_ROOT_DIR/Vicuna2"
TRACE_DIR="$COMPARISON_DIR/etiss/$ARCH_SUBPATH"
mkdir -p $TRACE_DIR

export VLEN=$VLEN
export VLANE_WIDTH=$VLANE_WIDTH

cd $PERFSIM_DIR

./scripts/run.sh $TARGET_GROUP $TARGET_SW_EXPLICIT $TARGET_ARCH $PARAMS
TRACE_FILE=$TRACE_DIR/${TARGET_SW}_trace.txt
# > $TRACE_DIR/${TARGET_SW}_output.txt

cd $OUT_DIR

find . -name "Vicuna*_timing_*" -print0 | sort -zV | xargs -0 cat > $TRACE_DIR/${TARGET_SW}_timing.csv
find . -name "asm_trace_*" -print0 | sort -zV | xargs -0 cat > $TRACE_DIR/${TARGET_SW}_trace.txt
# cat $OUT_DIR/Vicuna*_timing_* > $TRACE_DIR/${TARGET_SW}_timing.csv
# cat $OUT_DIR/asm_trace_* > $TRACE_DIR/${TARGET_SW}_trace.txt

# rm -f $OUT_DIR/*
find . -name "*.txt" -print0 | xargs -0 rm -f
find . -name "*.csv" -print0 | xargs -0 rm -f

sed -i '/^0x/!d' $TRACE_FILE
