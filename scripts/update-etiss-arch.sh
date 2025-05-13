#!/bin/bash

M2_ISA_R_DIR="$WS_PATH/gen_perfsim/code_gen/generators/M2-ISA-R"
COREDSL_DIR="$WS_PATH/gen_perfsim/code_gen/descriptions/core_dsl/etiss_arch_riscv"
ETISS_DIR="$WS_PATH/gen_perfsim/etiss-perf-sim/etiss"
SCRIPTS_DIR="$WS_PATH/gen_perfsim/scripts"

cd $M2_ISA_R_DIR
source venv/bin/activate
python3 -m m2isar.frontends.coredsl2.parser $COREDSL_DIR/top.core_desc
python3 -m m2isar.backends.etiss.writer $COREDSL_DIR/gen_model/top.m2isarmodel --separate --static-scalars

cd $ETISS_DIR
cp -r $COREDSL_DIR/gen_output/top/RV32IMACFDV ArchImpl
git restore ArchImpl/RV32IMACFDV/RV32IMACFDV.h
git restore ArchImpl/RV32IMACFDV/RV32IMACFDVArch.cpp
git restore ArchImpl/RV32IMACFDV/RV32IMACFDVArchSpecificImp.cpp
git restore ArchImpl/RV32IMACFDV/RV32IMACFDVArchSpecificImp.h
git restore ArchImpl/RV32IMACFDV/RV32IMACFDVFuncs.h # See Notes!
git restore ArchImpl/RV32IMACFDV/RV32IMACFDVGDBCore.h
# Optional:
# git diff
# git commit -m 'update rvv arch'

cd $WS_PATH/gen_perfsim
./scripts/setup_workspace.sh