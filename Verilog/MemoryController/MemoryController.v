/*
This is a Mealy state machine
*..*/
module MemoryController(
    clock,
    reset, //Active high syn reset
    en0,
    en1,
    en2,
    en3,
);
//------External ports--------
input clock,reset,en0,en1,en2,en3,RW;
output reg addr0,addr1,addr2,addr3,mready;
//----Internal constants----------
parameter size = 5; //Number of the states in the machine
parameter ADDR0 = 5'b00001,ADDR1 = 5'b00010, ADDR2 = 5'b00100, ADDR3 = 5'b01000, mready = 5'b10000;//Used one hot encoding to name the states
//----Internal variables----------
reg [size-1:0] state;
wire [size-1:0] next_state;

assign next_state = fsm_function(state,en0,en1,en2,en3);
//--------Function for the state machine------
function [size-1:0] fsm_function;
input [size-1:0] state;
input en0,en1,en2,en3,RW;
case (state)
IDLE: 




