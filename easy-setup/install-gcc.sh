#!/usr/bin/env bash

# Terminal color
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Clone RISC-V GCC
GCC_SOURCE_DIR="$HOME/sources/riscv-gcc"
echo -e "${BLUE}Downloading RISC-V GCC to $GCC_SOURCE_DIR${NC}"
git clone git@github.com:riscv-collab/riscv-gnu-toolchain.git $GCC_SOURCE_DIR

# Installation Path
GCC_INSTALL_PREFIX="$HOME/opt/riscv-gcc"

build_and_install_rv_gcc() {
  if [ "$#" -ne 2 ]; then
    echo "Error, build_and_install_rv_gcc() requires ARCH and ABI, skipping"
  else
    cd "$GCC_SOURCE_DIR" || exit
    make clean
    echo -e "${BLUE}Building with ARCH = $1, ABI = $2${NC}"
    echo -e "${BLUE}Installing to $INSTALL_PATH${NC}"
    ./configure --prefix=$GCC_INSTALL_PREFIX --with-arch=$1 --with-abi=$2 --enable-tui
    make -j$(nproc)
    make install
    echo -e "${GREEN}Done${NC}"
  fi
}

read -r -p "Install riscv32 & riscv64 GCC to $GCC_INSTALL_PREFIX? [y/N] " RESPONSE
case "$RESPONSE" in
[yY][eE][sS] | [yY])
  build_and_install_rv_gcc rv32gc ilp32d
  build_and_install_rv_gcc rv64gc lp64d
  ;;
*)
  echo -e "${RED}Aborting${NC}"
  exit
  ;;
esac

echo -e "${GREEN}All done, you can remove ${GCC_SOURCE_DIR}${NC}"
