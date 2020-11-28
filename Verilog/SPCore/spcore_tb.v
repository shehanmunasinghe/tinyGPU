`include "../constants.v"
`include "spcore.v"
`timescale 1ns/10ps

module spcore_tb;




	// Registers and Wires
	reg clk 	= 1'b0;	
	reg reset;
	reg en 		= 1'b1;

	reg [1:0]  s2;
	reg [3:0]  x;
	reg [3:0]  y;
	reg [3:0]  z;

	reg [3:0]  aluc;
	reg [15:0] I;

	wire P;

	reg reg_we 	= 1'b0;
	wire [15:0] data_out;
	reg [15:0] data_in;
	wire [15:0] addr;


	//Instantiate SPCore
	spcore SPCore(clk,reset,x,y,z,I,P,data_out,addr,data_in,en,reg_we,aluc,s2);
	defparam SPCore.CORE_ID = 100;
	defparam SPCore.N_CORES = 200;
	// defparam SPCore.ALU.CORE_ID = 100;
	// defparam SPCore.ALU.N_CORES = 200;


	//Clock
	always
		#(`CLK_PERIOD/2) clk <= !clk;

	//Reset	
    initial begin        
        reset=1; #10 reset=0; //reset PC register at the begining
    end    

	//Test instructions

	initial begin

		#10 //Delay for Reset
		// aluc= `ALUC_CLEAR;

		
		/****************************************
			R[x] <= Immediate			//LOADI
		****************************************/
		//Inputs
			x=0; I=11;
		//1: Source Operand Read Cycle
			s2= `MuxD_fromI ;
			reg_we=1;
			#20			

		
		/****************************************
			R[x] <= Immediate			//LOADI
		****************************************/
		//Inputs
			x=1; I=20;
		//1: Source Operand Read Cycle
			s2= `MuxD_fromI ;
			reg_we=1;
			#20	

		$display("R[0]=%d R[1]=%d R[2]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2]);
		
		/****************************************
			R[x] <= R[y] + R[z]		//ADD
		****************************************/
		//Inputs 
			x=2;y=0;z=1;
		//1: ID,EXE
			aluc = `ALUC_ADD;
			s2= `MuxD_fromALU;
			reg_we=0;			
			#20			
		//2: WB
			reg_we=1;
			#20

		$display("R[0]=%d R[1]=%d R[2]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2]);

		/****************************************
			R[x]<=R[x] + R[y]*R[z] 	//MAD
		****************************************/
		//Inputs
			x=2;y=0;z=1;
		//1: ID,EXE
			s2= `MuxD_fromALU;
			aluc = `ALUC_MAD;
			reg_we=0;						
			#20				
		//2: WB
			reg_we=1;
			#20
			
		$display("R[0]=%d R[1]=%d R[2]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2]);


		/****************************************
			R[x] <= R[y] + R[z]		//ADD
		****************************************/
		//Inputs
			x=2;y=0;z=1;
		//1: ID,EXE
			aluc = `ALUC_ADD;
			s2= `MuxD_fromALU;
			reg_we=0;			
			#20
		//2: WB
			reg_we=1;
			#20
			
		$display("R[0]=%d R[1]=%d R[2]=%d R[3]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2], SPCore.RegFile.register[3]);



		/****************************************
			R[x] <= R[y] * R[z]		//MUL
		****************************************/
		//Inputs
			x=2;y=0;z=1;
		//1: ID,EXE
			aluc = `ALUC_MUL;
			s2= `MuxD_fromALU;
			reg_we=0;			
			#20			
		//2: WB
			reg_we=1;
			#20

		$display("R[0]=%d R[1]=%d R[2]=%d R[3]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2], SPCore.RegFile.register[3]);


		/****************************************
			R[x] <= CORE_ID			//LOADC
		****************************************/
		//Inputs
			x=3;z=1;
		//1: ID,EXE
			aluc = `ALUC_CORE_ID;
			s2= `MuxD_fromALU;
			reg_we=0;			
			#20
		//2: WB
			reg_we=1;
			#20
			
		$display("R[0]=%d R[1]=%d R[2]=%d R[3]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2], SPCore.RegFile.register[3]);


		/****************************************
			R[x] <=0				//CLEAR
		****************************************/
		//Inputs
			x=3;
		//1: ID,EXE
			aluc = `ALUC_CLEAR;
			s2= `MuxD_fromALU;
			reg_we=0;			
			#20
		//2: WB
			reg_we=1;
			#20

		$display("R[0]=%d R[1]=%d R[2]=%d R[3]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2], SPCore.RegFile.register[3]);


		/****************************************
			R[x] <= R[x] + 1		//INC
		****************************************/
		//Inputs
			x=3;
		//1: ID,EXE
			aluc = `ALUC_INC;
			s2= `MuxD_fromALU;
			reg_we=0;			
			#20
		//2: WB
			reg_we=1;
			#20

		$display("R[0]=%d R[1]=%d R[2]=%d R[3]=%d",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2], SPCore.RegFile.register[3]);

	
		/****************************************
			P <= (R[x] op R[y])		//SETP
		****************************************/
		//Inputs
			x=1;y=1;
		//1: ID,EXE
			aluc = `ALUC_EQ;
			// s2= `MuxD_fromALU;//Not used
			reg_we=0;			
			#20

		$display("R[0]=%d R[1]=%d R[2]=%d R[3]=%d ALU.P=%d ",SPCore.RegFile.register[0],SPCore.RegFile.register[1], SPCore.RegFile.register[2], SPCore.RegFile.register[3], SPCore.ALU.P);




		/****************************************
			M[R[y]] <= R[x]			//STORE
		****************************************/
		//Inputs
			// x=2;y=0;
		//Controls
			// s2= `MuxD_fromALU;
			// aluc = `ALUC_ADD;
			// reg_we=1;
			// mem_we ://TODO
			// #20

			$finish;

	end

	//Logging
	initial begin
		// $monitor("x = %d, y = %d,z = %d, I = %d, Data out = %d,Address = %d, P = %d, Data in = %d, Enable = %d,Multiplexer = %d",x,y,z,I,data_out,addr,P,data_in,en,s2);
		$dumpfile("dump.vcd");
		$dumpvars(0,spcore_tb);
	end

endmodule
