`ifndef CU
    `include "CU/CU.v"
`endif
`ifndef PC
    `include "PC/PC.v"
`endif
`ifndef PStack
    `include "PStack/PStack.v"
`endif

`ifndef Scheduler
    `define Scheduler 1
`endif

`ifndef INSTMEM_ADDR_WIDTH
    `define INSTMEM_ADDR_WIDTH 16
`endif
`ifndef INST_LENGTH
    `define INST_LENGTH 32
`endif

module Scheduler 
#(
    parameter N_CORES = 4
)
(
    input                                   clk,
    input                                   reset,
    output [`INSTMEM_ADDR_WIDTH-1:0]    inst_addr,
    input [`INST_LENGTH-1:0]                inst,
    
    output    [3:0]                        x,
    output    [3:0]                        y,
    output    [3:0]                        z,
    output   [15:0]                        I,
    
    output      reg_we,
    output      [3:0] aluc,
    output      [1:0] s2,  

    output      MRead,
    output      MWrite,
    input       MReady,

    output      [N_CORES  -1:0] en_mask,
    input       [N_CORES  -1:0] p_array    
    );

    //
    wire incPC;
    wire loadFromI;
    //
    wire [31:28] opcode;
    assign opcode = inst[31:28];
    assign x = inst[27:24];
    assign y = inst[23:20];
    assign z = inst[19:16]; 
    assign I = inst[15:0]; 

    //
    wire pstack_push;
    wire pstack_pop;
    wire pstack_complement;
    wire all_mask_true;
    wire all_mask_false;


    //modules
    PC PC(clk,reset,inst_addr,incPC,loadFromI,I);
    CU CU(
        clk, reset, 
        opcode,z,MReady, 
        all_mask_true,all_mask_false, 
        
        incPC,loadFromI, s2, aluc, reg_we,
        MRead,MWrite,
        pstack_push,pstack_pop,pstack_complement
    );
    
    PStack #(N_CORES) PStack(
        clk,reset,
        p_array,en_mask,
        pstack_push,pstack_pop,pstack_complement,
        all_mask_true,all_mask_false
    );
    // defparam PStack.N_CORES = N_CORES;
    


endmodule