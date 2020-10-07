module alu(
           input [15:0] A,
			  input [15:0] B,  	
			  input [15:0] C, 							// ALU 16-bit Inputs                 
           input [3:0] ALU_c,							// ALU control 4-bit
           output [15:0] ALU_Out, 					// ALU 16-bit Output
           output z_Out 								// Zero Flag
    );
	 
	 
    reg [15:0] ALU_Result;
	 reg z = 1'b0 ;
    
    assign ALU_Out = ALU_Result; 			// ALU out
	 assign z_Out = z ;
    
	 always @(*)
    begin
			
        case(ALU_c)
        4'b0001: 									// CLEAR x
           ALU_Result <= 1'b0 ; 
			  
			  
        4'b0010: 									// INC x
           ALU_Result <= A + 1'b1 ;
			  
		  4'b0111: 									// ADD x y z
           ALU_Result <= A + B ;
			  
		  4'b1000: 									// MUL x y z
           ALU_Result <= A * B ;
			  
		  4'b1001: 									// MAD x y z
           ALU_Result <= A + (B * C) ;
			  
		  4'b1010: 									// AND x y 
           ALU_Result <= A & B ;
			  
		  4'b1011: 									// CMPL x y 
           if (A < B) 
					ALU_Result <= 1'b1 ;
			  else 
					ALU_Result <= 1'b0 ;
					
		  4'b1100: 									// BEQ x y 
           if (A == B) 
					z <= 1'b1 ;
			  else 
					z <= 1'b0 ;
					
		  4'b1101: 									// BNQ x y 
           if (A == B) 
					z <= 1'b0 ;
			  else 
					z <= 1'b1 ;
			  
        
					
        default: ALU_Result = A + B ; 
        endcase
    end

endmodule