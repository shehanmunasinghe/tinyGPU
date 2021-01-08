`ifndef CU
    `define CU 1
`endif

module CU (
    input clk, 
    input reset,
    input [3:0]  opcode,

    input all_mask_true,
    input all_mask_false,

    output incPC,
    output loadFromI   );

    ///
    reg [5:0]  current_state=0;
    reg [5:0]  next_state=0;

    /**      Microinstructions   **/
    parameter
        FETCH0 = 0,
        



   

    always @(posedge clk) begin
        case (current_state)

            FETCH0: begin
                incPC       =0;
                loadFromI   =0;
                s2          =`MuxD_X;
                aluc        =`ALUC_X;
                reg_we      =0;
                next_state  =getNextMicroinstruction(opcode);
            end 
            

            default: 
        endcase 

        current_state = next_state;
    end
    
endmodule