`include "../../constants.v"
`include "pstack.v"

`timescale 1ms/1ns

module testbench ();

    //Clock
	reg clk = 1'b0;
    always begin
		#(`CLK_PERIOD/2) clk <= !clk;
	end

    //reg        
    reg reset;
    reg [`N_CORES - 1:0] d;
    wire [`N_CORES - 1:0] q;

    reg push; reg pop; reg comp;
    
    //module PC
    pstack PStack(clk,reset,d,q,push,pop,comp);

    //test
    initial begin
        
        reset=1; #21 reset=0; //reset at the begining


        #50 d=10; push=1; #20 push=0;
        #55 d=3; push=1; #20 push=0;
        #50 d=7; push=1; #20 push=0;
        #5 d=0;

        #50 comp=1; #20; comp=0;
        #50 comp=1; #20; comp=0;

        #50 pop=1; #20 pop=0;
        #50 pop=1; #20 pop=0;
        #50 pop=1; #20 pop=0;
        #50 pop=1; #20 pop=0;
        #50 $finish;

    end    

    initial begin
        $monitor("monitor q=%b  @ %0t", q,  $time);
        
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

endmodule