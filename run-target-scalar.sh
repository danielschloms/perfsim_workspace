#!/usr/bin/bash

VLEN="128"
VLANE_WIDTH="32"
TARGET_SW=""
PROFILER=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --target)
      TARGET_SW="$2"
      shift # past argument
      shift # past value
      ;;
    --profile)
      echo "Using profiler"
      PROFILER="valgrind --tool=callgrind "
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

SIM_DIR="$WS_PATH/gen_perfsim/etiss-perf-sim/simulator"
DYN_DIR="$SIM_DIR/dyn_inis/rv32im_zicsr/${TARGET_SW}"

COMMON_INI="$SIM_DIR/ini/common.ini"
ADDR_INI="$SIM_DIR/ini/AddressLayout.ini"
ARCH_INI="$SIM_DIR/ini/Vicuna_zvl128b.ini"
BIN_INI="$DYN_DIR/dyn.ini"
PLUGIN_INI="$DYN_DIR/plugin.ini"

ETISS_EXE="${PROFILER}${SIM_DIR}/build/main"

export VLEN=$VLEN
export VLANE_WIDTH=$VLANE_WIDTH

time $ETISS_EXE -i$COMMON_INI -i$ADDR_INI -i$ARCH_INI -i$BIN_INI
# time $ETISS_EXE -i$COMMON_INI -i$ADDR_INI -i$ARCH_INI -i$BIN_INI -i$PLUGIN_INI

