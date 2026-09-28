#!/usr/bin/bash

PERFSIM_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
cd $PERFSIM_DIR
PERF_MODEL_DIR="$PERFSIM_DIR/code_gen/descriptions/core_perf_dsl"

VICUNA_PERF_MODEL_IN="$PERF_MODEL_DIR/CV32A60X_Vicuna2.corePerfDsl"
$VICUNA_CORE_PERF_DSL="$PERF_MODEL_DIR/out.corePerfDsl"

cpp -E -P -x c $VICUNA_PERF_MODEL_IN -o $VICUNA_CORE_PERF_DSL

./scripts/code_gen.sh $VICUNA_CORE_PERF_DSL