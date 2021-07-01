`ifndef ALU
    `include "ALU/ALU.v"
`endif
`ifndef RegisterFile
    `include "RegisterFile/RegisterFile.v"
`endif
`ifndef Mux
    `include "Mux/Mux3x16.v"
`endif

`ifndef SPCore
    `define SPCore 1
`endif


module SPCore
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
    RegisterFile RegFile(clk_i,reset, x,y,z,x, A,B,C,D, reg_we);

    ALU ALU(A,B,C,aluc,alu_out,P);
    defparam ALU.CORE_ID = CORE_ID;
	defparam ALU.N_CORES = N_CORES;

    Mux3x16 MuxD(I,data_in,alu_out,s2,D);
    //    
    assign data_out = A;
    assign addr     = B;
    assign clk_i    = clk && en; //enable/disbale the core

    initial begin
        $display("Initializing SPCore:  (CORE_ID=%d)",CORE_ID);
    end

endmodule