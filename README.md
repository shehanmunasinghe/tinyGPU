# tinyGPU

Designing a **SIMT (Single Instruction Multiple Thread) Processor** under **EN3030 Circuits and Systems** module.

This repository contains
* Python programs for simulation of programs written in assembly language of the proposed Instruction Set Architecture (ISA)
* SystemVerilog implementation of the hardware modules


## Processor Design

### Instruction Set Architecture (ISA)
![ISA](docs/images/ISA.png "ISA")


### Datapath

![datapath](docs/images/datapath.png "datapath")

### RTL Modules

The information about the RTL Modules can be found [here](./Verilog/_Info.md).


## How to Run the Project

### Requirements

* Python 3
    * Numpy
* IcarusVerilog

### ISA Simulation

Find instructions [here](./Simulator/_INSTRUCTIONS.md).

### SystemVerilog Simulation
Find instructions [here](./Verilog/_INSTRUCTIONS.md).

### Evaluation

    python3 Evaluation/evaluation_script.py