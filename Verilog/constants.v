//Clock
`define CLK_PERIOD 20

//Instruction Memory
`define INST_LENGTH 32 //Each instruction is 32bit long
`define INSTMEM_ADDR_WIDTH 16 //16bit address

`define INSTMEM_N_LOCATIONS 64 //TODO - Increase this accordingly
`define INSTMEM_ADDR_WIDTH_TRUNC 6 //TODO - Increase this accordingly


//No of Cores
`define N_CORES 4 //No of cores


//PStack
`define STACK_DEPTH 3 //2^3 = 8 locations in stack