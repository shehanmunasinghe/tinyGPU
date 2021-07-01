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
parameter STATE_FETCH = 31;
parameter STATE_DECODE = 29;

parameter STATE_LOADI_0    = 1;

parameter STATE_LOAD_0     = 0;
parameter STATE_LOAD_1     = 16;

parameter STATE_STORE_0    = 3;
parameter STATE_STORE_1    = 17;

parameter STATE_LOADC_0    = 2;

parameter STATE_CLEAR_0    = 4;
parameter STATE_INC_0      = 5;
parameter STATE_ADD_0      = 6;
parameter STATE_MUL_0      = 7;
parameter STATE_MAD_0      = 8;


parameter STATE_SETP_0     = 9;
parameter STATE_IF_P_0     = 10;
parameter STATE_ELSE_P_0   = 11;
parameter STATE_WHILE_P_0  = 12;
parameter STATE_WHILE_P_1  = 18;
parameter STATE_ENDIF_0    = 13;

parameter STATE_NOP_0      = 14;

module CU (
    input clk, 
    input reset,

    input [3:0] opcode,
    input [3:0] operand_op_c,
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

    reg [5:0]  current_state;
    reg [5:0]  next_state;

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


    //state switching
    always @(posedge clk) begin
                
        case (current_state)      

            STATE_FETCH:begin
                current_state <= STATE_DECODE;
                incPC	<= 0; loadFromI <= 0;
            end 

            STATE_DECODE:begin
                current_state <= getCurrentState(opcode);
                incPC	<= 0; loadFromI <= 0;
            end   

            STATE_LOADI_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_SETP_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end


            STATE_IF_P_0:begin
                current_state <= STATE_FETCH;
                if (all_mask_false) begin
                    incPC	<= 0; loadFromI <= 1;
                end
                else begin
                    incPC	<= 1; loadFromI <= 0;
                end
            end


            STATE_ELSE_P_0:begin
                current_state <= STATE_FETCH; 
                if (all_mask_true) begin
                    incPC	<= 0; loadFromI <= 1;
                end
                else begin
                    incPC	<= 1; loadFromI <= 0;
                end
            end

            STATE_ENDIF_0:begin
                  current_state <= STATE_FETCH;
                  incPC	<= 1; loadFromI <= 0;
            end

            STATE_NOP_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_STORE_0:begin
                current_state <= STATE_STORE_1;
            end

            STATE_STORE_1:begin
                if (MReady) begin
                    current_state <= STATE_FETCH;
                    incPC	<= 1; loadFromI <= 0;  
                end  
                else 
                    current_state <= STATE_STORE_1;
            end
            
            STATE_LOAD_0:begin
                current_state <= STATE_LOAD_1;
            end

            STATE_LOAD_1:begin
                if (MReady) begin
                    current_state <= STATE_FETCH;
                    incPC	<= 1; loadFromI <= 0;  
                end              
                else 
                    current_state <= STATE_LOAD_1;
            end

            STATE_LOADC_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_ADD_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_MUL_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_INC_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_CLEAR_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_MAD_0:begin
                current_state <= STATE_FETCH;
                incPC	<= 1; loadFromI <= 0;
            end

            STATE_WHILE_P_0:begin
                current_state <= STATE_WHILE_P_1;
            end

            STATE_WHILE_P_1:begin
                current_state <= STATE_FETCH;
                if (all_mask_true) begin
                    incPC	<= 0; loadFromI <= 1;
                end
                else begin
                    incPC	<= 1; loadFromI <= 0;
                end
            end

            default:begin
                
            end

        endcase

        
    end

    // What to do in each state
    always @(*) begin
        case (current_state)      

            STATE_FETCH:begin
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0; 
                MRead=0; MWrite=0;
                // incPC	= 0; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;

            end 

            STATE_DECODE:begin
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0; 
                MRead=0; MWrite=0;
                // incPC	= 0; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
                
            end   

            STATE_LOADI_0:begin
                s2	= `MuxD_fromI; aluc	= `ALUC_X; reg_we	= 1;
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;

            end

            STATE_SETP_0:begin
                s2	= `MuxD_X; reg_we	= 0; 
                // op = {EQ, LT, GT, NEQ}	{1,2,3,4} // ALUC_EQ, ALUC_LT, ALUC_GT, ALUC_NEQ
                case (operand_op_c)
                    1 : aluc	= `ALUC_EQ;
                    2 : aluc	= `ALUC_LT;
                    3 : aluc	= `ALUC_GT;
                    4 : aluc	= `ALUC_NEQ;
                    default: aluc = `ALUC_X;
                endcase
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
                
            end


            STATE_IF_P_0:begin
                pstack_push=1; pstack_pop=0; pstack_complement =0;
                // if (all_mask_false) begin
                //     incPC	= 0; loadFromI = 1;
                // end
                // else begin
                //     incPC	= 1; loadFromI = 0;
                // end
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;
            end


            STATE_ELSE_P_0:begin
                pstack_push=0; pstack_pop=0; pstack_complement =1;
                // if (all_mask_true) begin
                //     incPC	= 0; loadFromI = 1;
                // end
                // else begin
                //     incPC	= 1; loadFromI = 0;
                // end
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;
            end

            STATE_ENDIF_0:begin
                pstack_push=0; pstack_pop=1; pstack_complement =0;
                // incPC	= 1; loadFromI = 0;
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;
            end

            STATE_NOP_0:begin
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0; 
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end

            STATE_STORE_0:begin
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0; 
                MRead=0; MWrite=1;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end
            STATE_STORE_1:begin
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0; 
                MRead=0; MWrite=0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
                // incPC	= 0; loadFromI = 0; 
            end

            STATE_LOAD_0:begin
                s2	= `MuxD_fromMem; aluc	= `ALUC_X; reg_we	= 1; 
                MRead=1; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end
            STATE_LOAD_1:begin
                s2	= `MuxD_fromMem; aluc	= `ALUC_X; reg_we	= 1; 
                MRead=0; MWrite=0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
                // incPC	= 0; loadFromI = 0; 
            end

            STATE_LOADC_0:begin
                s2	= `MuxD_fromALU; aluc	= `ALUC_CORE_ID; reg_we	= 1;
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end

            STATE_ADD_0:begin
                s2	= `MuxD_fromALU; aluc	= `ALUC_ADD; reg_we	= 1; 
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end

            STATE_MUL_0:begin
                s2	= `MuxD_fromALU; aluc	= `ALUC_MUL; reg_we	= 1; 
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end

            STATE_INC_0:begin
                s2	= `MuxD_fromALU; aluc	= `ALUC_INC; reg_we	= 1; 
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end

            STATE_CLEAR_0:begin
                s2	= `MuxD_fromALU; aluc	= `ALUC_CLEAR; reg_we	= 1; 
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end

            STATE_MAD_0:begin
                s2	= `MuxD_fromALU; aluc	= `ALUC_MAD; reg_we	= 1; 
                MRead=0; MWrite=0;
                // incPC	= 1; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0; 
            end

            STATE_WHILE_P_0:begin
                pstack_push=1; pstack_pop=0; pstack_complement =0;
                // incPC	= 0; loadFromI = 0;
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;
            end

            STATE_WHILE_P_1:begin
                if (all_mask_true) begin
                    pstack_push=0; pstack_pop=1; pstack_complement =0;
                    // incPC	= 0; loadFromI = 1;
                end
                else begin
                    pstack_push=0; pstack_pop=0; pstack_complement =0;
                    // incPC	= 1; loadFromI = 0;
                end
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0;
                MRead=0; MWrite=0;
            end

            default:begin
                s2	= `MuxD_X; aluc	= `ALUC_X; reg_we	= 0; 
                MRead=0; MWrite=0;
                // incPC	= 0; loadFromI = 0;
                pstack_push=0; pstack_pop=0; pstack_complement =0;
            end

        endcase
        
    end


    //Reset
    always @(posedge reset) begin
        current_state = STATE_FETCH;
        next_state = STATE_DECODE;
    end

endmodule