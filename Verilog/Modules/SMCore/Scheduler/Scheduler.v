`ifndef CU
    `include "CU/CU.v"
`endif
`ifndef PC
    `include "PC/PC.v"
`endif



`ifndef INSTMEM_ADDR_WIDTH
    `define INSTMEM_ADDR_WIDTH 16
`endif
`ifndef INST_LENGTH
    `define INST_LENGTH 32
`endif

module Scheduler (
    input                                   clk,
    input                                   reset,
    output [`INSTMEM_ADDR_WIDTH-1:0]    inst_addr,
    input [`INST_LENGTH-1:0]                inst,
    
    output    [3:0]                        x,
    output    [3:0]                        y,
    output    [3:0]                        z,
    output   [15:0]                        I );    //TODO add inputs/outputs to SP-Core, Memory, etc   




    //
    wire [31:28] opcode;

    assign opcode = inst[31:28];
    assign x = inst[27:24];
    assign y = inst[23:20];
    assign z = inst[19:16]; 
    assign I = inst[15:0];


    //Control Unit
    wire incPC;
    wire loadFromI;

    // all_mask_true
    // all_mask_false

    wire[`INST_LENGTH-1:0] inst;

    //modules
    PC PC(clk,reset,inst_addr,incPC,loadFromI,I);
    CU CU(clk, reset, opcode,incPC,loadFromI);

    


endmodule