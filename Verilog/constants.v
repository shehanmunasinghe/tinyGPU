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


//ALU Controls
`define ALUC_CLEAR      0
`define ALUC_INC        1
`define ALUC_ADD        2
`define ALUC_MUL        3
`define ALUC_MAD        4
`define ALUC_EQ         5
`define ALUC_LT         6
`define ALUC_GT         7
`define ALUC_NEQ        8
`define ALUC_CORE_ID    9
`define ALUC_N_CORES    10

//MuxD
`define MuxD_fromI      0
`define MuxD_fromMem    1
`define MuxD_fromALU    2
