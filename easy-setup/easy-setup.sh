#!/usr/bin/env bash

SETUP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT_DIR="$(dirname "$SETUP_DIR")"

# Clone ETISS programs repository and pull in submodules
cd $PROJECT_ROOT_DIR || exit
git clone git@github.com:danielschloms/etiss_riscv_examples.git risc-v-programs
cd risc-v-programs || exit
git checkout easy-setup
git submodule update --init --recursive

# Pull in Perfsim submodules
cd $PROJECT_ROOT_DIR || exit
git submodule update --init --recursive

# Apply Perfsim fixes
$PROJECT_ROOT_DIR/fixes/apply-fixes.sh

# Setup Perfsim workspace
$PROJECT_ROOT_DIR/scripts/setup_workspace.sh

# Install RISC-V GCC
$SETUP_DIR/install-gcc.sh
