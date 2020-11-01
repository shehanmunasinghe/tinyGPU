`include "../../constants.v"
`include "pc.v"

`define CLK_PERIOD 20
`define INSTMEM_ADDR_WIDTH 16

`timescale 1ns/10ps

module testbench ();
    
    //Clock
	reg clk = 1'b0;
    always begin
		#(`CLK_PERIOD/2) clk <= !clk;
	end

    //reg
    wire[`INSTMEM_ADDR_WIDTH-1:0] AR;//0
    reg[`INSTMEM_ADDR_WIDTH-1:0] I = 0;//0
    reg incPC=0;
    reg loadFromI=0;
    reg reset;

    //module PC
    pc PC(clk,reset, AR,incPC,loadFromI,I);



    //test
    initial begin

        
        // for (i = 0;i<16 ;i=i+1 ) begin
        //     #5
        //    $display("i=%d, AR=%h, Q=%h",i,AR,Q) ;
        //    AR=AR+1;
        // end
        reset=1; #21 reset=0; //reset PC register at the begining
        #5 incPC=1;
        #55 incPC=0;
        #50 I=4; loadFromI=1;
        #50 $finish;

    end    

    initial begin
        $monitor("monitor AR=%b  @ %0t", AR,  $time);
        
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end


endmodule