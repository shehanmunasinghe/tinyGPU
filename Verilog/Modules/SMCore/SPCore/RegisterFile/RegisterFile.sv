`ifndef RegisterFile
    `define RegisterFile 1
`endif

module RegisterFile (
	input clk,
	input Reset,			//reset


	input [3:0] nA, 		// reg # of read port A
	input [3:0] nB, 		// reg # of read port B
	input [3:0] nC, 		// reg # of read port C
	input [3:0] nD,		// reg # of write port

	output [15:0] A,	// Output ports A,B and C
	output [15:0] B,
	output [15:0] C,
	input [15:0] D,	// data to write

	input RegWE); 		// write enable
	

	
	reg [15:0] register [0:15]  ; 	// 16 16-bit registers
		
	assign A =  register[nA]; 		// read port A
	assign B =  register[nB]; 		// read port B
	assign C =  register[nC]; 		// read port C
	
	integer i;

	always @(posedge clk or posedge Reset) 	
		
		if (Reset)
			for (i = 1; i < 16; i = i + 1)
				register[i] <= 0; // reset			
		else begin
			if (RegWE) 	begin// If write enabled
				register[nD] <= D; 	// write D to reg[nD]
				// $display("Writing to Register : R[%d]=%d",nD, D);
			end
		end
endmodule