/*
This is a Mealy state machine
*..*/

`define N_CORES 4 //Note:Edit if using more cores
module MemoryController(
    input clock, 
    input reset, //Active high async reset

    input MRead,
    input MWrite,
    output MReady,

    input [`N_CORES-1:0] en;
    input [15:0] addr [`N_CORES-1:0],
    input [15:0] data [`N_CORES-1:0],
    output  [15:0]  q[`N_CORES-1:0],

    //Memory Side
    output  reg [15:0]  data_to_mem,
    output  reg [15:0]  addr_mem,
    input   [15:0]  data_from_mem,
    output reg wren,
    
);

//----Internal constants----------
parameter n_states = `N_CORES+1; //Number of the states in the machine
parameter stateReady = n_states-1;

parameter stateADDR0 = 0;
parameter stateADDR1 = 1;
parameter stateADDR2 = 2;
parameter stateADDR3 = 3;


//----Internal variables----------
reg [n_states-1:0] current_state;
reg [n_states-1:0] next_state;


//--------Function for the state machine------
// function [n_states-1:0] getNextState([current_state,MRead,MWrite]);

//     ;
    
// endfunction

//----FSM------
always *(posedge clock) begin
    case (current_state) begin
        stateReady:begin
            //Current State 
            MReady=1;

            //Get next state
            if (MRead || MWrite) begin
                if(en0)
                    next_state = stateADDR0;
                else if (en1)
                    next_state = stateADDR1;
                else if (en2)
                    next_state = stateADDR2;
                else if (en3)
                    next_state = stateADDR3;
                else
                    next_state = stateReady;
            end
            
        end

        
        stateADDR0:begin
            //Current State
            MReady=0;
            addr_mem=addr[0]
            if MRead begin
                q[0] = data_from_mem;
            end 
            else if MWrite begin
                data_to_mem = data[0];
                wren = 1;
            end
            
            //Get next state
            if (en1) begin
                next_state = stateADDR1;
            end
            else if (en2) begin
                next_state = stateADDR2;
            end
            else if (en3) begin
                next_state = stateADDR3;
            end
            else begin
                next_state = stateReady;
            end
        end


        stateADDR1:begin
            //Current State
            MReady=0;
            addr_mem=addr[1]
            if MRead begin
                q[1] = data_from_mem;
            end 
            else if MWrite begin
                data_to_mem = data[1];
                wren = 1;
            end
            
            //Get next state
            if (en2) begin
                next_state = stateADDR2;
            end
            else if (en3) begin
                next_state = stateADDR3;
            end
            else begin
                next_state = stateReady;
            end
        end

        stateADDR2:begin
            //Current State
            MReady=0;
            addr_mem=addr[2]
            if MRead begin
                q[2] = data_from_mem;
            end 
            else if MWrite begin
                data_to_mem = data[2];
                wren = 1;
            end

            //Get next state
            if (en3) begin
                next_state = stateADDR3;
            end
            else begin
                next_state = stateReady;
            end
        end

        stateADDR3:begin
            //Current State
            MReady=0;
            addr_mem=addr[1]
            if MRead begin
                q[1] = data_from_mem;
            end 
            else if MWrite begin
                data_to_mem = data[1];
                wren = 1;
            end

            //Get next state
            next_state = stateReady;
        end

    end

    current_state=next_state;
end


IDLE: 




