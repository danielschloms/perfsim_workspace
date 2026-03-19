## Requirements
To effectively use this workspace, both ETISS and a compiler for RISC-V are necessary.
The required tools to build both ETISS and the RISC-V GCC toolchain can be found in the Dockerfile (`docker/Dockerfile`).

## Using Docker
If you choose to use Docker, simply run `docker/build.sh` to create an image.
Afterwards, either use VSCode through `.devcontainer/devcontainer.json` to develop in a container,
or run `docker/run-container.sh` to run bash in the container.
Using both methods might result in conflicts, but creating a container first through VSCode and then attaching via `docker exec -it perfsim bash` should work.

## Workspace fixes
There are a few issues when trying to setup the workspace, which are described in `fixes/fixes.txt`.
Since I don't want to mess around with the submodule structure and pull in different repositories,
`fixes/apply-fixes.sh` will simply replace the offending files.

## Setting up the workspace
To set up the performance simulation workspace, as well run performance models, follow the instructions in `README.md`.

## Running other programs
Check out `https://github.com/tum-ei-eda/etiss_riscv_examples` and install the RISC-V GNU toolchain.
An adapted version of this repository which includes building for Verilator (HW simulation) can be found at `https://github.com/danielschloms/etiss_riscv_examples` with branch `daniel-dev`.
Be aware that both of these repositories have to be further adapted to your use case, i.e. installation paths etc., and will not work out of the box.

## Installing the RISC-V GCC toolchain
Using `easy-setup/install-gcc.sh` will install both the `riscv32-unknown-elf` and `riscv64-unknown-elf` tools,
with `arch=rv32gc, abi=ilp32d` and `arch=rv64gc, abi=lp64d` respectively.
The repository is cloned to `~/sources/riscv-gcc` and installed to `~/opt/riscv-gcc`.
To have these commands available everywhere, add this location to `PATH`.
When using bash, this can be done by adding `export PATH="$PATH:$HOME/opt/riscv-gcc"` to your `.bashrc`.
