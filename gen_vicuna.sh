#!/usr/bin/bash

cd $WS_PATH/gen_perfsim
VICUNA_CORE_PERF_DSL="$WS_PATH/gen_perfsim/code_gen/descriptions/core_perf_dsl/Vicuna.corePerfDsl"

./scripts/code_gen.sh $VICUNA_CORE_PERF_DSL