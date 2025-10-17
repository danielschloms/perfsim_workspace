#!/usr/bin/bash

cd $WS_PATH/gen_perfsim
PERF_MODEL_DIR="$WS_PATH/gen_perfsim/code_gen/descriptions/core_perf_dsl"
# VICUNA_PERF_MODEL_IN="$PERF_MODEL_DIR/Vicuna.corePerfDsl.in"
VICUNA_CORE_PERF_DSL="$PERF_MODEL_DIR/Vicuna.corePerfDsl"
# FIFO_SCRIPT="$PERF_MODEL_DIR/insert_fifos.py"

# if [[ "$1" = "--fifo" ]]; then
#   $FIFO_SCRIPT $VICUNA_PERF_MODEL_IN $VICUNA_CORE_PERF_DSL
# fi

./scripts/code_gen.sh $VICUNA_CORE_PERF_DSL