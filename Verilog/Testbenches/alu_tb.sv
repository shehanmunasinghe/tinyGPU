`include "../Modules/SMCore/SPCore/ALU/ALU.sv"

`timescale 1ns/10ps
module alu_tb;
	parameter clk_period = 20;
	reg clock = 1'b0;     //Clock is zero


	reg[15:0] A = 16'h0019; //25
	reg[15:0] B = 16'h0002; //2
	reg[15:0] C = 16'h0005; //5

	reg[3:0] ALU_C = 4'b0000;//CLEAR instructon is the starting point

	wire [15:0] ALU_OUT;
	wire P;

	ALU ALU_test(A,B,C,ALU_C,ALU_OUT,P);

	always
		#(clk_period/2) clock <= !clock;


	always
	#1000000 begin
		if (ALU_C == 4'b1001)
			$stop;
		else
			ALU_C <= ALU_C +1 ;
		$display("Instruction = %d, a = %d,b = %d, c = %d, output = %d, P = %b",ALU_C,A,B,C,ALU_OUT,P);
	end
		initial
			begin
				$dumpfile("dump.vcd");
				$dumpvars(0,alu_tb);
			end
		initial
			#250000000 $finish;
endmodule 
	