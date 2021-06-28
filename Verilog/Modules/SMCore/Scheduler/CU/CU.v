`ifndef CU
    `define CU 1
`endif

//Opcodes
// `define OPCODE_LOAD     0
// `define OPCODE_LOADI    1
// `define OPCODE_LOADC    2
// `define OPCODE_STORE    3
// `define OPCODE_CLEAR    4
// `define OPCODE_INC      5
// `define OPCODE_ADD      6
// `define OPCODE_MUL      7
// `define OPCODE_MAD      8
// `define OPCODE_SETP     9
// `define OPCODE_IF_P     10
// `define OPCODE_ELSE_P   11
// `define OPCODE_WHILE_P  12
// `define OPCODE_ENDIF    13
// `define OPCODE_NOP      14

// Opcodes
parameter OPCODE_LOAD     = 0;
parameter OPCODE_LOADI    = 1;
parameter OPCODE_LOADC    = 2;
parameter OPCODE_STORE    = 3;
parameter OPCODE_CLEAR    = 4;
parameter OPCODE_INC      = 5;
parameter OPCODE_ADD      = 6;
parameter OPCODE_MUL      = 7;
parameter OPCODE_MAD      = 8;
parameter OPCODE_SETP     = 9;
parameter OPCODE_IF_P     = 10;
parameter OPCODE_ELSE_P   = 11;
parameter OPCODE_WHILE_P  = 12;
parameter OPCODE_ENDIF    = 13;
parameter OPCODE_NOP      = 14;

// States
parameter STATE_INITIAL = 31;
parameter STATE_DECODE = 0;

parameter STATE_LOADI_0    = 1;
parameter STATE_LOADC_0    = 2;
parameter STATE_LOAD_0     = 0;
parameter STATE_STORE_0    = 3;
parameter STATE_CLEAR_0    = 4;
parameter STATE_INC_0      = 5;
parameter STATE_ADD_0      = 6;
parameter STATE_MUL_0      = 7;
parameter STATE_MAD_0      = 8;
parameter STATE_SETP_0     = 9;
parameter STATE_IF_P_0     = 10;
parameter STATE_ELSE_P_0   = 11;
parameter STATE_WHILE_P_0  = 12;
parameter STATE_ENDIF_0    = 13;
parameter STATE_NOP_0      = 14;

module CU (
    input clk, 
    input reset,

    input [3:0] opcode,
    input MReady,

    input all_mask_true,
    input all_mask_false,

    output reg incPC,
    output reg loadFromI,   
    output reg [1:0] s2,
    output reg [3:0] aluc,
    output reg reg_we,


    output reg MRead,
    output reg MWrite,

    output reg pstack_push,
    output reg pstack_pop,
    output reg pstack_complement );

    reg [5:0]  current_state=STATE_DECODE;
    reg [5:0]  next_state=STATE_DECODE;

    function automatic [5:0] getCurrentState( [3:0] opcode );
        case (opcode)
            OPCODE_LOAD: begin
                getCurrentState=STATE_LOAD_0;
            end
            OPCODE_LOADI: begin
                getCurrentState=STATE_LOADI_0;
            end
            OPCODE_LOADC: begin
                getCurrentState=STATE_LOADC_0;
            end
            OPCODE_STORE: begin
                getCurrentState=STATE_STORE_0;
            end
            OPCODE_CLEAR: begin
                getCurrentState=STATE_CLEAR_0;
            end
            OPCODE_INC: begin
                getCurrentState=STATE_INC_0;
            end
            OPCODE_ADD: begin
                getCurrentState=STATE_ADD_0;
            end
            OPCODE_MUL: begin
                getCurrentState=STATE_MUL_0;
            end
            OPCODE_MAD: begin
                getCurrentState=STATE_MAD_0;
            end
            OPCODE_SETP: begin
                getCurrentState=STATE_SETP_0;
            end
            OPCODE_IF_P: begin
                getCurrentState=STATE_IF_P_0;
            end
            OPCODE_ELSE_P: begin
                getCurrentState=STATE_ELSE_P_0;
            end
            OPCODE_WHILE_P: begin
                getCurrentState=STATE_WHILE_P_0;
            end
            OPCODE_ENDIF: begin
                getCurrentState=STATE_ENDIF_0;
            end
            OPCODE_NOP: begin
                getCurrentState=STATE_NOP_0;
            end

            // default: begin
            // end
        endcase
        
        
    endfunction 

    //decoder
    reg [5:0] decoded_state;
    always @(posedge clk) begin
        case (opcode)
            OPCODE_LOAD: begin
                decoded_state=STATE_LOAD_0;
            end
            OPCODE_LOADI: begin
                decoded_state=STATE_LOADI_0;
            end
            OPCODE_LOADC: begin
                decoded_state=STATE_LOADC_0;
            end
            OPCODE_STORE: begin
                decoded_state=STATE_STORE_0;
            end
            OPCODE_CLEAR: begin
                decoded_state=STATE_CLEAR_0;
            end
            OPCODE_INC: begin
                decoded_state=STATE_INC_0;
            end
            OPCODE_ADD: begin
                decoded_state=STATE_ADD_0;
            end
            OPCODE_MUL: begin
                decoded_state=STATE_MUL_0;
            end
            OPCODE_MAD: begin
                decoded_state=STATE_MAD_0;
            end
            OPCODE_SETP: begin
                decoded_state=STATE_SETP_0;
            end
            OPCODE_IF_P: begin
                decoded_state=STATE_IF_P_0;
            end
            OPCODE_ELSE_P: begin
                decoded_state=STATE_ELSE_P_0;
            end
            OPCODE_WHILE_P: begin
                decoded_state=STATE_WHILE_P_0;
            end
            OPCODE_ENDIF: begin
                decoded_state=STATE_ENDIF_0;
            end
            OPCODE_NOP: begin
                decoded_state=STATE_NOP_0;
            end

            default: begin
                decoded_state=STATE_INITIAL;
            end
        endcase        
    end

/*
    always @(posedge clk) begin
        if (current_state == STATE_DECODE ) begin
           current_state = decoded_state; //getCurrentState(opcode); 
        end
                
        case (current_state)
            
            // STATE_DECODE:begin
            //     s2	<= `MuxD_X; aluc	<= `ALUC_X; reg_we	<= 0;
            //     MRead<=0; MWrite<=0;
            //     incPC	<= 0; loadFromI <= 0;
            //     pstack_push<=0; pstack_pop<=0; pstack_complement <=0;

            //     // next_state <= getCurrentState(opcode); 
            //     case (opcode)
                    
            //         OPCODE_LOADI: begin
            //             next_state<=STATE_LOADI_0;
            //         end
            //         OPCODE_SETP: begin
            //             next_state<=STATE_SETP_0;
            //         end
            //         // OPCODE_STORE: begin
            //         //     next_state=STATE_STORE_0;
            //         // end
            //     endcase
            // end
            

            STATE_LOADI_0:begin
                s2	<= `MuxD_fromI; aluc	<= `ALUC_X; reg_we	<= 1;
                MRead=0; MWrite=0;
                incPC	<= 1; loadFromI <= 0;
                pstack_push<=0; pstack_pop<=0; pstack_complement <=0;

                next_state = STATE_DECODE;
                // next_state <= getCurrentState(opcode); 
            end

            STATE_SETP_0:begin
                s2	<= `MuxD_X; aluc	<= `ALUC_EQ; reg_we	<= 0; //TODO : Consider other SETP operands - ALUC_EQ, ALUC_LT, ALUC_GT, ALUC_NEQ
                MRead<=0; MWrite<=0;
                incPC	<= 1; loadFromI <= 0;
                pstack_push<=0; pstack_pop<=0; pstack_complement <=0;
                
                next_state = STATE_DECODE;
                // next_state <= getCurrentState(opcode); 
            end


            STATE_IF_P_0:begin
                pstack_push=1; pstack_pop=0; pstack_complement =0;
                if (all_mask_false) begin
                    incPC	= 0; loadFromI = 1;
                end
                else begin
                    incPC	= 1; loadFromI = 0;
                end
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;

                next_state = STATE_DECODE;
            end

            STATE_ELSE_P_0:begin
                pstack_push=0; pstack_pop=0; pstack_complement =1;
                if (all_mask_true) begin
                    incPC	= 0; loadFromI = 1;
                end
                else begin
                    incPC	= 1; loadFromI = 0;
                end
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;

                next_state = STATE_DECODE; 
            end

            STATE_ENDIF_0:begin
                pstack_push=0; pstack_pop=1; pstack_complement =0;
                incPC	= 1; loadFromI = 0;
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;

                next_state = STATE_DECODE; 
            end

            STATE_NOP_0:begin
                next_state = STATE_NOP_0; //TODO - Exit Simulation?
            end



            default:begin
                s2	<= `MuxD_X; aluc	<= `ALUC_EQ; reg_we	<= 0; 
                MRead<=0; MWrite<=0;
                incPC	<= 0; loadFromI <= 0;
                pstack_push<=0; pstack_pop<=0; pstack_complement <=0;
            end

        endcase

        current_state <= next_state;
    end

    */

    always @(posedge clk) begin
        // current_state <= next_state;

        // if (next_state == STATE_DECODE ) begin
        //    current_state <= getCurrentState(opcode); 
        // end
        // else begin
        //     current_state <= next_state;
        // end
        incPC	<= 1;
    end

    always @(posedge reset) begin
        current_state <= STATE_DECODE;
    end

endmodule