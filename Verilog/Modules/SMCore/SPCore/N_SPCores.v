`include "SPCore.v"

`ifndef N_CORES
    `define N_CORES 8
`endif

module N_SPCores(
    //Connections to Each Core
    input    [3:0]          x,
    input    [3:0]          y,
    input    [3:0]          z,
    input   [15:0]          I,

    input reg_we,
    input [3:0] aluc,
    input [1:0] s2,   

    input MRead,
    input MWrite,
    output reg MReady,

    input clk, 
    input reset,

    //N 
    input [`N_CORES-1:0] en,
    output [`N_CORES-1:0] p,

    //Connections to Memory
    output reg [15:0] addr [`N_CORES-1:0],
    output reg [15:0] data [`N_CORES-1:0],
    input [15:0]  q[`N_CORES-1:0]

);

//Generate for loop to instantiate N times
genvar i;
generate 
    for ( i=0 ;i<`N_CORES ; i=i+1) begin
        SPCore spcore_i(clk,reset,x,y,z,I,p[i],data[i],addr[i],q[i],en[i],reg_we,aluc,s2);
    end
endgenerate


endmodule