module mux3x16(In0,In1,In2,S2,D_out);
    input [15:0] In0,In1,In2;
    input [1:0] S2;
    output reg [15:0] D_out;
    
    always @ (In0,In1,In2,S2) begin
        case(S2)
        2'b01:
            D_out <= In1;
        2'b10:
            D_out <= In2;
        default:
        begin
            D_out <= In0;
        end
        endcase
    end
endmodule