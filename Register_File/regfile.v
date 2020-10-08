module regfile (rna,rnb,rnc,d,wn,we,clk,qa,qb,qc,DR,AR); 					// 16x16 regfile

	input [15:0] d; 																		// data of write port
	input [3:0] rna; 																		// reg # of read port A
	input [3:0] rnb; 																		// reg # of read port B
	input [3:0] rnc; 																		// reg # of read port C
	
	input [3:0] wn; 																		// reg # of write port
	input we; 																				// write enable
	input clk; 																				// clock and reset
	
	output [15:0] qa, qb, qc; 															// read ports A,B and C
	output [15:0] DR, AR ;																// Read DR & AR 
	
	reg [15:0] register [0:15]  ; 											// 16 16-bit registers
	
	//register[4'b0010] = 16'h0009 ;
	
	assign qa =  register[rna]; 														// read port A
	assign qb =  register[rnb]; 														// read port B
	assign qc =  register[rnc]; 														// read port C
	
	assign DR =  register[rna]; 														// read port DR
	assign AR =  register[4'b1111]; 														// read port AR
	
	always @(posedge clk) 																// write port
		
		if (we) 																				// If write enabled
			register[wn] <= d; 															// write d to reg[wn]
				
endmodule