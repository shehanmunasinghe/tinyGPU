`include "../constants.sv"

`include "../Modules/DataMemory/DataMemory.sv"

`timescale 1ns/10ps

module testbench ();

    //params
    parameter clk_period = 20;	
	reg clk = 1'b0;

    //reg
    reg[15:0] AR = 16'b0000000000000000;//0
    reg wren = 1'b0;
    reg[15:0] din = 8'b00000001;//1
    wire[15:0] Q;

    integer i;

    //module
    DataMemory DMem(clk,wren,AR,din,Q);


    //test
    initial begin

        
        for (i = 0;i<16 ;i=i+1 ) begin
            #5
           $display("i=%d, AR=%h, Q=%h",i,AR,Q) ;
           AR=AR+1;
        end

        $finish;
    end

    //Clock
	always begin
		#(clk_period/2) clk <= !clk;
	end



endmodule