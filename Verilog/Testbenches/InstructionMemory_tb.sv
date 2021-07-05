`include "../constants.sv"
`include "../Modules/InstructionMemory/InstructionMemory.sv"

`timescale 1ns/10ps

module testbench ();

    //Clock
	reg clk = 1'b0;
    always begin
		#(`CLK_PERIOD/2) clk <= !clk;
	end
	

    //reg
    reg[`INSTMEM_ADDR_WIDTH-1:0] AR = 0;//0
    wire[`INST_LENGTH-1:0] Q;

    integer i;

    //module
    InstructionMemory IMem(clk,AR,Q);


    //test
    initial begin

        
        for (i = 0;i<16 ;i=i+1 ) begin
            #5
           $display("i=%d, AR=%h, Q=%b",i,AR,Q) ;
           AR=AR+1;
        end

        $finish;
    end





endmodule