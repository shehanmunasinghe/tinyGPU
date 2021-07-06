`ifndef N_SPCores
    `include "SPCore/N_SPCores.v"
`endif
`ifndef Scheduler
    `include "Scheduler/Scheduler.v"
`endif
`ifndef MemoryController
    `include "MemoryController/MemoryController_NCores.v"
`endif

`ifndef SMCore
    `define SMCore 1
`endif

`ifndef INC_CONSTANTS
    `define INST_LENGTH 32 //Each instruction is 32bit long
    `define INSTMEM_ADDR_WIDTH 16 //16bit address

    `define DATA_WORD_LENGTH 16 //Each data word is 16bit long
    `define DATAMEM_ADDR_WIDTH 16 //16bit address
`endif

module SMCore 
#(
    parameter  N_CORES = 4
)
(
    //Connections to Instruction Memory
    output  [`INSTMEM_ADDR_WIDTH-1:0]   inst_addr, 
    input   [`INST_LENGTH-1:0]          inst,

    //Connections to Data Memory
    output  [`DATAMEM_ADDR_WIDTH-1:0]   DataAddress, 
    output  [`DATA_WORD_LENGTH-1:0]     DataToWrite,
    input   [`DATA_WORD_LENGTH-1:0]     DataToRead,
    output  DataMemWrEn,

    //
    input clk, 
    input reset );


  //
    wire [3:0]     x;
    wire [3:0]     y;
    wire [3:0]     z;
    wire [15:0]    I;

    //
    wire MRead;
    wire MWrite;
    wire MReady;

    wire [15:0] eachcore_addr [N_CORES  -1:0];
    wire [15:0] eachcore_data_to_write [N_CORES  -1:0];
    wire [15:0]  eachcore_data_to_read[N_CORES  -1:0];

    //
    wire [N_CORES  -1:0] en_mask;
    wire [N_CORES  -1:0] p;

    wire      reg_we;
    wire      [3:0] aluc;
    wire      [1:0] s2;

    //modules
    Scheduler #(N_CORES) Scheduler(
        clk, reset, 
        inst_addr,inst,
        x,y,z,I,
        reg_we, aluc, s2,MRead, MWrite,MReady,
        en_mask, p
        );
    // defparam Scheduler.N_CORES = N_CORES;

    MemoryController #(N_CORES) MemController(
        clk,reset, 
        MRead, MWrite, MReady,
        en_mask, 
        eachcore_addr, eachcore_data_to_write,eachcore_data_to_read,
        DataToWrite,DataAddress,DataToRead,DataMemWrEn
    );
    // defparam MemController.N_CORES = N_CORES;

    N_SPCores #(N_CORES) N_SPCores(
        x,y,z,I,
        reg_we, aluc, s2,
        
        en_mask, p, 
        eachcore_addr, eachcore_data_to_write, eachcore_data_to_read,
        clk, reset
        );
    // defparam N_SPCores.N_CORES = N_CORES;

    


    
endmodule