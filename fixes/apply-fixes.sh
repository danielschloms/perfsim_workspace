#!/usr/bin/env bash

FIXES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT_DIR="$(dirname "$FIXES_DIR")"
SCRIPTS_DIR="$PROJECT_ROOT_DIR/scripts"
SW_EVAL_LIB_DIR="$PROJECT_ROOT_DIR/etiss-perf-sim/etiss_plugins/SoftwareEvalLib"

cp $FIXES_DIR/setup_workspace.sh $SCRIPTS_DIR
cp $FIXES_DIR/PerformanceEstimatorPlugin.cpp $SW_EVAL_LIB_DIR/src
cp $FIXES_DIR/Channel.h $SW_EVAL_LIB_DIR/libs/backends/include/api/softwareEval-backends
