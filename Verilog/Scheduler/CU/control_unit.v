module control_unit (
    input clk, input reset,
    input [3:0] opcode,
    // input all_mask_true,
    // input all_mask_false,

    output incPC,
    output loadFromI   );


    assign incPC =1;

    always @(posedge clk) begin
        //TODO: Implement state machine
        
    end
    
endmodule