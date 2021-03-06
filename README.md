# COMP_ENG 493 Project

## Project Repository structure
The repository is structured to group like-files together. Here is a short description of the file folders:
 * [model/](./model): All modelling files, both in C++ and MATLAB.
 * [hdl/](./hdl): All HDL files are stored here, written in Verilog.
 * [test/](./test): All Verilog test bench files.
 * [simulation/](./simulation): Simulation files generated by Cadence Xcelium. Navigate to this file prior to executing any Xcelium commands.
 * [backend/](./backend): Backend files generated during routing with Cadence Innovus. Navigate to this file prior to executing any Innovus commands.

## Verilog Simulation
Larger project modules have test benches written to test functionality independently. Note that this can often be run directly from the command line, without needing to wait for the GUI to pop up. For example, the MAC can be tested by running the following command:
```bash
cd simulation/
xrun -64bit -access r ../hdl/*.v ../test/tb_MAC.v
```

The `pe.v` module functionality can be tested with the following commands:
```bash
cd simulation/
xrun -64bit -access r ../hdl/pe.v ../hdl/mac.v ../hdl/multiplier.v ../hdl/accumulator.v ../test/tb_pe.v
```
