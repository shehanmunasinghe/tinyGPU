`include "ALU/alu.v"
`include "RegisterFile/regfile.v"
`include "Mux/mux3x16.v"

module spcore (
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

    input en,
    input reg_we,
    input [3:0] aluc,
    input [1:0] s2      );   


    //
    wire [15:0] A,B,C,D;
    wire [15:0] alu_out; wire P;

    //modules
    regfile RegFile(clk,reset, x,y,z,x, A,B,C,D, reg_we);
    alu ALU(A,B,C,aluc,alu_out,P);
    mux3x16 MuxD(I,data_in,alu_out,s2,D);
    //    


endmodule