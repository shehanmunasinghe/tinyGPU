`include "../constants.v"
`include "spcore.v"
`timescale 1ns/10ps

module spcore_tb;




	// Registers and Wires
	reg clk 	= 1'b0;	
	reg reset;
	reg en 		= 1'b1;

	reg [1:0]  s2 		= 2'b00;
	reg [3:0]  x 		= 1;
	reg [3:0]  y 		= 2;
	reg [3:0]  z 		= 3;

	reg [3:0]  aluc 	= 4'b0111;
	reg [15:0] I 		= 16'h00A3;

	wire P;

	reg reg_we 	= 1'b0;
	wire [15:0] data_out;
	reg [15:0] data_in 	= 16'h00A7;
	wire [15:0] addr;



	spcore spcore_test(clk,reset,x,y,z,I,P,data_out,addr,data_in,en,reg_we,aluc,s2);
	


	//Clock
	parameter clk_period = 20;
	always
		#(`CLK_PERIOD/2) clk <= !clk;

	//Reset	
    initial begin        
        reset=1; #5 reset=0; //reset PC register at the begining
    end    

	//Test instructions

	initial begin
		/*
			R[x] <= Immediate			//LOADI
		*/
		//Inputs
			x=0; I=11;
		//Controls
			//1:
			s2= `MuxD_fromI ;
			// aluc=
			reg_we=1;
			#20

		/*
			R[x] <= Immediate			//LOADI
		*/		
		//Inputs
			x=1; I=22;
		//Controls
			//1:
			s2= `MuxD_fromI ;
			// aluc=
			reg_we=1;
			#20

		 
		/*
			R[x] <= R[y] + R[z]		//ADD
		*/
		//Inputs
			x=2;y=0;z=1;
		//Controls
			s2= `MuxD_fromALU;
			aluc = `ALUC_ADD;
			reg_we=1;
			#20


		/*
			M[R[y]] <= R[x]			//STORE
		*/
		//Inputs
			x=2;y=0;
		//Controls
			// s2= `MuxD_fromALU;
			// aluc = `ALUC_ADD;
			// reg_we=1;
			// mem_we ://TODO
			#20

			$finish;

	end

	//Logging
	initial begin
		$monitor("x = %d, y = %d,z = %d, I = %d, Data out = %d,Address = %d, P = %d, Data in = %d, Enable = %d,Multiplexer = %d",x,y,z,I,data_out,addr,P,data_in,en,s2);
		$dumpfile("dump.vcd");
		$dumpvars(0,spcore_tb);
	end

endmodule
