# ENGR 330 - Test 2

A paramtized set of adders written in System Verilog.

## Building

The `Makefile` implements a build system using the Vivado toolchain.

Inside, the `MODULE` variable determines which module to simulate.
Available options are:
* `tb_rca`
* `tb_cla`
* `tb_pa`

* `make simulation` - Runs a full behavioral simulation.

## Release

The v1.0 release supports 3 different adder implementation with test benches.

See `Building` for more information.