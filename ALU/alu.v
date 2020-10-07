module alu(
    input [15:0] A,
    input [15:0] B,  	
    input [15:0] C, 							// ALU 16-bit Inputs                 
    input [3:0] ALU_c,							// ALU control 4-bit
    output [15:0] ALU_out, 					// ALU 16-bit Output
    output Z_out 								// Zero Flag
    );
	 
	 
    reg [15:0] ALU_result;
    reg z = 1'b0 ;
    
    assign ALU_out = ALU_result; 			// ALU out
    assign Z_out = z ;
    
    always @(*) begin			
        case(ALU_c)
            4'b0001: 									// CLEAR x
                ALU_result <= 1'b0 ; 
			  			  
            4'b0010: 									// INC x
                ALU_result <= A + 1'b1 ;
                
            4'b0111: 									// ADD x y z
                ALU_result <= A + B ;
                
            4'b1000: 									// MUL x y z
                ALU_result <= A * B ;
                
            4'b1001: 									// MAD x y z
                ALU_result <= A + (B * C) ;
                
            4'b1010: 									// AND x y 
                ALU_result <= A & B ;
                
            4'b1011: 									// CMPL x y 
                if (A < B) 
                    ALU_result <= 1'b1 ;
                else 
                    ALU_result <= 1'b0 ;
                        
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
                        					
            default: 
                ALU_result = A + B ; 

        endcase
    end

endmodule