`ifndef PC
    `define PC 1
`endif

`ifndef INC_CONSTANTS
    `define INSTMEM_ADDR_WIDTH 16
`endif

module PC (
    input clk, input reset,
    output reg [`INSTMEM_ADDR_WIDTH-1:0]   Address,
    input incPC,
    input loadFromI,
    input [`INSTMEM_ADDR_WIDTH-1:0] I     );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Address<=0;
        end
        else if (incPC) begin
            Address<=Address+16'd1;
        end
        else if (loadFromI) begin
            Address<=I;
        end

    end

    
endmodule