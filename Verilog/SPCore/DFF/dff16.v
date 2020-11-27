module dff16 ( // a 16-bit register
    input clk,
    input [15:0] d,
    output reg [15:0] q);     
   
    always @ (posedge clk) begin // always block
        q <= d; // else store d to dff
    end
endmodule