`include "ALU/alu.v"
`include "RegisterFile/regfile.v"
`include "Mux/mux3x16.v"

module spcore
    #(parameter CORE_ID=0, parameter N_CORES=1) (
    input               clk,
    input               reset,

    input    [3:0]          x,
    input    [3:0]          y,
    input    [3:0]          z,
    input   [15:0]          I,

    output P,

    output  [15:0]  data_out,
    output  [15:0]  addr,
    input   [15:0]  data_in,

    input en, //control signal to enable/disable the core
    input reg_we,
    input [3:0] aluc,
    input [1:0] s2      );   


    //
    wire [15:0] A,B,C,D;
    wire [15:0] alu_out; wire P;

    wire clk_i;

    //modules
    regfile RegFile(clk_i,reset, x,y,z,x, A,B,C,D, reg_we);

    alu ALU(A,B,C,aluc,alu_out,P);
    defparam ALU.CORE_ID = CORE_ID;
	defparam ALU.N_CORES = N_CORES;

    mux3x16 MuxD(I,data_in,alu_out,s2,D);
    //    
    assign data_out = A;
    assign addr     = B;
    assign clk_i    = clk && en; //enable/disbale the core

endmodule