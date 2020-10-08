`timescale 1ns/10ps

module testbench ();

//50 MHz clock period = 20 ns
	parameter clk_period = 20;
	
	reg clock = 1'b0;
	reg [15:0] A = 16'b110 ;				// 6
	reg [15:0] B = 16'b1110 ;				// 14
	reg [15:0] C = 16'b11 ;					// 3
	reg [3:0] ALU_c = 4'b0 ;
	
	wire z ;
	wire[15:0] result ;
	
	alu alu_test(A,B,C,ALU_c,result,z) ;
	
	//Clock
	always
		#(clk_period/2) clock <= !clock;
		
	always
#1000000 begin

				if (ALU_c == 4'b1000)
					$stop ;
				else
					ALU_c <= ALU_c + 4'b0001 ;
					
			end
			
	initial
		begin
			$dumpfile("dump.vcd");
			$dumpvars(0);
		end
		
	initial
		#250000000 $stop;
endmodule 
	
