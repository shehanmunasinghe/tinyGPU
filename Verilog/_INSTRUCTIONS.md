# Instructions for compiling and simulation

## Setup

* Make a copy of [./constants_local-copy.sv ](./constants_local-copy.sv)  and rename it as constants_local.sv
* Edit the definitions for INSTMEM_FILEPATH and DATAMEM_FILEPATH, giving the paths for .txt files containing the Instruction Memory binary and Data Memory hex content.

## Instructions for using Icarus Verilog


Compilation

    iverilog -o module1.vvp module1_tb.v

Simulation

    vvp module1.vvp

Or Single Line Command (Windows Powershell)

    iverilog -o tb.vvp tb.v ; vvp tb.vvp

Displaying the Waveform - open the module1.vcd file using Scansion or GTKwave or any other VCD viewer


## Instructions for using Questa Sim (Experimental)

Compilation

Open a new project and add the module files along with the necessary testbench
If there is a hierachchy, arrange the files to that order 
Compile all the files

Simulation

	vsim -voptargs=""+acc"" <filename>
	
This creates a simulation with objects and the waveform of the shown

	vsim -debugDB <filename>

This creates a schematic of the simulated file