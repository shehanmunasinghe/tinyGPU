module alu(
    input [15:0] A,
    input [15:0] B,
    input [15:0] C,

    input [3:0] ALU_C,

    output reg [15:0] ALU_OUT,
    output reg P);

    always @ (A or B or C or ALU_C) begin
        case (ALU_C)        
            4'b0000:                    //CLEAR 
                ALU_OUT <= 16'h0000;
            4'b0001:                    //INC 
                ALU_OUT <= A + 1;
            4'b0010:                    //ADD
                ALU_OUT <= B + C;
            4'b0011:                    //MUL
                ALU_OUT <= B * C;
            4'b0100:                    //MAD
                ALU_OUT <= A + (B*C);
            4'b0101:                    //SETP EQ
                if (A == B)
                    P <= 1'b1;
                else
                    P <= 1'b0;
            4'b0110:                    //SETP LT
                if (A<B) 
                    P <= 1'b1;
                else
                    P <= 1'b0;
            4'b0111:                    //SETP GT
                if (A>B)
                    P <= 1'b1;
                else                    
                    P <= 1'b0;
            4'b1000:                    //SETP NEQ
                if (A!=B)
                    P <= 1'b1;
                else
                    P <= 1'b0;
            default: begin
                    ALU_OUT <= ALU_OUT;
                    P <= P;
        end
        endcase
    end
endmodule