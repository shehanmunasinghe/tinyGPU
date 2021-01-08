//To know whether constants has been included. If not will use local definitions inside modules.
`define INC_CONSTANTS 1

/***********************************/
/****   Instruction Memory       **/

/***********************************/
`define INST_LENGTH 32 //Each instruction is 32bit long
`define INSTMEM_ADDR_WIDTH 16 //16bit address

//64=2^6 
// INSTMEM_N_LOCATIONS=2^INSTMEM_ADDR_WIDTH_TRUNC
`define INSTMEM_N_LOCATIONS 64 //TODO - Increase this accordingly
`define INSTMEM_ADDR_WIDTH_TRUNC 6 //TODO - Increase this accordingly

`ifndef INC_CONSTANTS_LOCAL
    `define INSTMEM_FILEPATH "PleaseSpecifyAFilePath"
`endif
/*---------------------------------*/

/***********************************/
/****   Data Memory              **/
/***********************************/
`define DATA_WORD_LENGTH 16 //Each data word is 16bit long
`define DATAMEM_ADDR_WIDTH 16 //16bit address

`define DATAMEM_N_LOCATIONS 64 //TODO - Increase this accordingly
`define DATAMEM_ADDR_WIDTH_TRUNC 6 //TODO - Increase this accordingly

`ifndef INC_CONSTANTS_LOCAL
    `define DATAMEM_FILEPATH "PleaseSpecifyAFilePath"
`endif
/*---------------------------------*/

/***********************************/
/****    Scheduler                **/
/***********************************/
//PStack
`define STACK_DEPTH 3 //2^3 = 8 locations in stack
/*---------------------------------*/

/***********************************/
/****    SPCore                   **/
/***********************************/
//ALU Controls
`define ALUC_X          0 //Don't care state
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
`define MuxD_X          0 //Don't care state
`define MuxD_fromI      0
`define MuxD_fromMem    1
`define MuxD_fromALU    2
/*---------------------------------*/


/***********************************/
/****    SMCore                   **/
/***********************************/

//No of Cores
`define N_CORES_LOG 2
`define N_CORES 4 //2**N_CORES_LOG   //4//No of cores

/*---------------------------------*/



/***********************************/
/****    Other                    **/
/***********************************/
//Clock
`define CLK_PERIOD 20
/*---------------------------------*/
