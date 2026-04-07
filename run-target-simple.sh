#!/usr/bin/bash

PERFSIM_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT_DIR="$(dirname "$SCRIPTS_DIR")"

VLEN="128"
VLANE_WIDTH="32"
TARGET_SW=""
ARCH_EXT=""
USE_PERF="false"
PROFILER=""

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
  --target)
    TARGET_SW="$2"
    shift # past argument
    shift # past value
    ;;
  --ca)
    ARCH_EXT="_ca"
    shift # past argument
    ;;
  --perf)
    USE_PERF="true"
    shift # past argument
    ;;
  --profile)
    echo "Using profiler"
    PROFILER="valgrind --tool=callgrind "
    shift # past argument
    ;;
  -* | --*)
    >&2 echo "Unknown option $1"
    exit 1
    ;;
  *)
    POSITIONAL_ARGS+=("$1") # save positional arg
    shift                   # past argument
    ;;
  esac
done

ZVL_STRING="zvl${VLEN}b"
TARGET_ARCH="Vicuna_$ZVL_STRING"

SIM_DIR="$PERFSIM_DIR/etiss-perf-sim/simulator"
DYN_DIR="$SIM_DIR/dyn_inis/rv32im_zve32x/${ZVL_STRING}/vlane32/${TARGET_SW}"

COMMON_INI="$SIM_DIR/ini/common.ini"
ADDR_INI="$SIM_DIR/ini/AddressLayout.ini"
ARCH_INI="$SIM_DIR/ini/Vicuna_${ZVL_STRING}${ARCH_EXT}.ini"
BIN_INI="$DYN_DIR/dyn.ini"
PLUGIN_INI="$DYN_DIR/plugin.ini"

ETISS_EXE="${PROFILER}${SIM_DIR}/build/main"

export VLEN=$VLEN
export VLANE_WIDTH=$VLANE_WIDTH

if [[ "$USE_PERF" = "true" ]]; then
  echo "Perf on"
  time $ETISS_EXE -i$COMMON_INI -i$ADDR_INI -i$ARCH_INI -i$BIN_INI -i$PLUGIN_INI
else
  echo "Perf off"
  time $ETISS_EXE -i$COMMON_INI -i$ADDR_INI -i$ARCH_INI -i$BIN_INI
fi
