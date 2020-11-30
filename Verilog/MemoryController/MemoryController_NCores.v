`ifndef N_CORES_LOG
    `define N_CORES_LOG 2
    `define N_CORES 4//2**N_CORES_LOG  
`endif

module MemoryController(
    input clk, 
    input reset, //Active high async reset

    input MRead,
    input MWrite,
    output reg MReady,

    //Connections to Each Core
    input [`N_CORES-1:0] en,
    input [15:0] addr [`N_CORES-1:0],
    input [15:0] data [`N_CORES-1:0],
    output reg [15:0]  q[`N_CORES-1:0],

    //Connections to Memory 
    output  reg [15:0]  data_to_mem,
    output  reg [15:0]  addr_mem,
    input   [15:0]  data_from_mem,
    output reg wren
    
);

//----Internal constants----------
// parameter n_states = `N_CORES+1; //Number of the states in the machine

//----Internal variables----------
// reg [n_states-1:0] current_state;
reg [`N_CORES_LOG-1:0]  idx=0; reg readyState=1'b1;
reg [`N_CORES_LOG:0] next_state=0;//next_state[`N_CORES_LOG]=readyState;


//--------Function for the state machine------
/* 
function [`N_CORES_LOG:0] getNextState( [`N_CORES_LOG-1:0] idx,   readyState );
    // input [`N_CORES-1:0]  idx; input readyState;

    // reg [`N_CORES_LOG-1:0] i,next_idx;
    integer i; 
    reg [`N_CORES_LOG-1:0] next_idx;
    reg found_en;
    integer start;

    begin
        start=idx+1;
        found_en=1'b0;
        // $display("start=%d",start);
        for (i = start;i<`N_CORES ; i=i+1) begin

            if (en[i]) begin
                // $display("en[%01d]=%b",i,en[i]);
                if (!found_en) begin
                    next_idx = i;
                    found_en = 1'b1;
                    readyState = 0;
                end             
            end
        end
        if (idx==`N_CORES-1 ||!found_en ) begin
            // $display("!found_en");
            next_idx = 0;
            readyState = 1;
        end

        // for (i=0;i<`N_CORES;i=i+1) begin
        //     getNextState[i] = next_idx[i];
        // end
        // getNextState[`N_CORES]=readyState;
        // getNextState = {next_idx, readyState};
        $display("next_idx= %d  ; idx= %d   ; readyState= %d ",next_idx,idx,readyState);
        // $display("comb %b",{next_idx, readyState});
        // return {next_idx, readyState};
        // return {readyState, next_idx};

        for (i=0;i<`N_CORES_LOG;i=i+1) begin
                getNextState[i] = next_idx[i];
            end
        getNextState[`N_CORES_LOG]=readyState;
        // idx = next_idx;
        // readyState=readyState;
    end
    
endfunction  */

/*
function [`N_CORES_LOG:0] getNextState( [`N_CORES_LOG-1:0] idx,   readyState );
    // input [`N_CORES-1:0]  idx; input readyState;

    // reg [`N_CORES_LOG-1:0] i,next_idx;
    integer i; 
    reg [`N_CORES_LOG-1:0] next_idx;
    reg found_en;
    integer start;

    begin
        start=idx+1;
        found_en=1'b0;
        // $display("start=%d",start);
        for (i = start;i<`N_CORES ; i=i+1) begin

            if (en[i]) begin
                // $display("en[%01d]=%b",i,en[i]);
                if (!found_en) begin
                    next_idx = i;
                    found_en = 1'b1;
                    readyState = 0;
                end             
            end
        end
        if (idx==`N_CORES-1 ||!found_en ) begin
            // $display("!found_en");
            next_idx = 0;
            readyState = 1;
        end

        // for (i=0;i<`N_CORES;i=i+1) begin
        //     getNextState[i] = next_idx[i];
        // end
        // getNextState[`N_CORES]=readyState;
        // getNextState = {next_idx, readyState};
        $display("next_idx= %d  ; idx= %d   ; readyState= %d ",next_idx,idx,readyState);
        // $display("comb %b",{next_idx, readyState});
        // return {next_idx, readyState};
        // return {readyState, next_idx};

        for (i=0;i<`N_CORES_LOG;i=i+1) begin
                getNextState[i] = next_idx[i];
            end
        getNextState[`N_CORES_LOG]=readyState;
        // idx = next_idx;
        // readyState=readyState;
    end
    
endfunction 
*/

function [`N_CORES_LOG-1:0] getFirstIdx();
    // input [`N_CORES-1:0]  idx; input readyState;

    // reg [`N_CORES_LOG-1:0] i,next_idx;
    integer i; 
    reg [`N_CORES_LOG-1:0] next_idx;
    // reg all_false;
    integer start;

    begin
        all_false=1'b1;
        // $display("start=%d",start);
        for (i = 0;i<`N_CORES ; i=i+1) begin
            $display("en[%01d]=%b",i,en[i]);
            if (en[i]) begin                
                if (all_false) begin
                    next_idx = i;
                    all_false = 1'b0;
                end             
            end
        end
        // if (idx==`N_CORES-1 ||!found_en ) begin
            // $display("!found_en");
        //     next_idx = 0;
        //     readyState = 1;
        // end
        $display("next_idx= %d  ; idx= %d   ; all_false= %d ",next_idx,idx,all_false);


        // for (i=0;i<`N_CORES_LOG;i=i+1) begin
        //         getNextIdx[i] = next_idx[i];
        //     end
        // getNextIdx[`N_CORES_LOG]=all_false;

        getFirstIdx=next_idx;

    end
    
endfunction 

function [`N_CORES_LOG-1:0] getNextIdx( [`N_CORES_LOG-1:0] idx );
    // input [`N_CORES-1:0]  idx; input readyState;

    // reg [`N_CORES_LOG-1:0] i,next_idx;
    integer i; 
    reg [`N_CORES_LOG-1:0] next_idx;
    // reg all_false;
    integer start;

    begin
        start=idx+1;
        all_false=1'b1;
        // $display("start=%d",start);
        for (i = start;i<`N_CORES ; i=i+1) begin
            $display("en[%01d]=%b",i,en[i]);
            if (en[i]) begin                
                if (all_false) begin
                    next_idx = i;
                    all_false = 1'b0;
                end             
            end
        end
        // if (idx==`N_CORES-1 ||!found_en ) begin
            // $display("!found_en");
        //     next_idx = 0;
        //     readyState = 1;
        // end
        $display("next_idx= %d  ; idx= %d   ; all_false= %d ",next_idx,idx,all_false);


        // for (i=0;i<`N_CORES_LOG;i=i+1) begin
        //         getNextIdx[i] = next_idx[i];
        //     end
        // getNextIdx[`N_CORES_LOG]=all_false;

        getNextIdx=next_idx;

    end
    
endfunction 

// assign MReady = readyState;

function automatic RW();
    //R/W
    addr_mem=addr[idx];
    if (MRead) begin
        q[idx] = data_from_mem;
        wren = 0;
    end else if (MWrite) begin
        data_to_mem = data[idx];
        wren = 1;
    end
    
    return 1'b1;
endfunction

reg readyStateNext=0;
//----FSM------

reg all_false;
reg [`N_CORES_LOG-1:0] next_idx=0;

reg trw;

always @(posedge clk) begin

    if (MRead || MWrite) begin        

        idx = getFirstIdx();  
           
        //if all false readyState=1;
        if (all_false) begin
            readyState=1;
            MReady=1;            
        end
        else begin
            readyState =1'b0;   
            MReady=0;
            //R/W
            trw = RW();
        end
    end else  if (!readyState) begin
        idx = getNextIdx(idx);  
        // idx = next_state[`N_CORES_LOG:0];all_false = next_state[`N_CORES_LOG];

        //if all false readyState=1;
        if (all_false) begin
            readyState=1;
            MReady=1;
            
        end
        else begin
            //R/W
            trw = RW();
        end
    end

    // if(readyStateNext ) begin
    //     readyStateNext=0;
    //     readyState=1;
    //     MReady=1;
    // end

    



    


/*     //MReady State
    if (readyState) begin 
        //Current State 
        // MReady=1;
        // idx=0;
        //Get next state
        if (MRead || MWrite) begin
            // next_state = getNextState(idx, readyState); idx = next_state[`N_CORES_LOG:1]; readyState = next_state[0];
            next_state = getNextState(idx, readyState); readyState = next_state[`N_CORES_LOG]; //idx = next_state[`N_CORES_LOG:0];readyState = next_state[`N_CORES_LOG];
            // $display("idx= %b   ; readyState= %b ",idx,readyState);
            // $display("next_state= %b  ; idx= %b   ; readyState= %b ",next_state,idx,readyState);
        end
    end else begin //R/W States
        //Current State 
        // MReady=0;

        //Get next state
        next_state = getNextState(idx, readyState);  //idx = next_state[`N_CORES_LOG:0];readyState = next_state[`N_CORES_LOG];
        // $display("idx= %d   ; readyState= %b ",idx,readyState);
            // $display("next_state= %b  ; idx= %b   ; readyState= %b ",next_state,idx,readyState);

    end 
    if (!readyState && (MRead || MWrite)) begin
        //R/W
        addr_mem=addr[idx];
        if (MRead) begin
            q[idx] = data_from_mem;
            wren = 0;
        end else if (MWrite) begin
            data_to_mem = data[idx];
            wren = 1;
        end
    end
    idx = next_state[`N_CORES_LOG:0];
    readyState = next_state[`N_CORES_LOG];
    */



end

//----Reset------
always @(posedge reset) begin
    MReady = 1;
    readyState = 1;
    next_state[`N_CORES_LOG]=readyState;
end


endmodule




// //----Unit Test------
// initial begin    
//     readyState = 1;#20
//     $display("next_state= %d  ; idx= %d   ; readyState= %b ",next_state,idx,readyState);
    
//     next_state = getNextState(idx, readyState); idx = next_state[`N_CORES_LOG:1]; readyState = next_state[0];#20
//     $display("next_state= %b  ; idx= %d   ; readyState= %b ",next_state,idx,readyState);
//     $display(en[0]);
// end