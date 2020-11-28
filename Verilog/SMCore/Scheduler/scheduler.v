`include "../constants.v"

`include "CU/control_unit.v"
// `include "../InstMem/instmem.v"
`include "PC/pc.v"

module scheduler (
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
    pc PC(clk,reset,inst_addr,incPC,loadFromI,I);
    control_unit CU(clk, reset, opcode,incPC,loadFromI);

    


endmodule