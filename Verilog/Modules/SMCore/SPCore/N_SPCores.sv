`ifndef SPCore
    `include "SPCore.v"
`endif

`ifndef N_SPCores
    `define N_SPCores 1
`endif

module N_SPCores
#(
    parameter  N_CORES = 4
)
(
    //Connections to Each Core
    input    [3:0]          x,
    input    [3:0]          y,
    input    [3:0]          z,
    input   [15:0]          I,

    input reg_we,
    input [3:0] aluc,
    input [1:0] s2,   

    //N 
    input [N_CORES-1:0] en,
    output [N_CORES-1:0] p,

    //Connections to Memory
    output reg [15:0] addr [N_CORES-1:0],
    output reg [15:0] data [N_CORES-1:0],
    input [15:0]  q[N_CORES-1:0],

    
    input clk, 
    input reset );

//Generate for loop to instantiate N times
genvar i;
generate 
    for ( i=0 ;i<N_CORES ; i=i+1) begin
        SPCore #(i,N_CORES) spcore_i(clk,reset,x,y,z,I,p[i],data[i],addr[i],q[i],en[i],reg_we,aluc,s2);
    end
endgenerate


endmodule