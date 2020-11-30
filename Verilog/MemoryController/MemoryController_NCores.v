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
    output reg  [15:0]  data_to_mem,
    output  reg [15:0]  addr_mem,
    input   [15:0]  data_from_mem,
    output   wren
    
);

//----Internal constants----------

//----Internal variables----------
// reg [n_states-1:0] current_state;
reg [`N_CORES_LOG-1:0]  idx=0; reg readyState=1'b1;
reg [`N_CORES_LOG:0] next_state=0;//next_state[`N_CORES_LOG]=readyState;

reg all_false;
reg [`N_CORES_LOG-1:0] next_idx=0;

reg trw;
reg readyStateNext=0;

reg RW_Operation = 0;//0-Read,W-Write;

//--------Functions------

function [`N_CORES_LOG-1:0] getFirstIdx();

    integer i; 
    reg [`N_CORES_LOG-1:0] next_idx;
    // reg all_false;
    integer start;

    begin
        all_false=1'b1;
        // $display("start=%d",start);
        for (i = 0;i<`N_CORES ; i=i+1) begin
            // $display("en[%01d]=%b",i,en[i]);
            if (en[i]) begin                
                if (all_false) begin
                    next_idx = i;
                    all_false = 1'b0;
                end             
            end
        end

        // $display("next_idx= %d  ; idx= %d   ; all_false= %d ",next_idx,idx,all_false);


        getFirstIdx=next_idx;

    end
    
endfunction 

function [`N_CORES_LOG-1:0] getNextIdx( [`N_CORES_LOG-1:0] idx );

    integer i; 
    reg [`N_CORES_LOG-1:0] next_idx;
    // reg all_false;
    integer start;

    begin
        start=idx+1;
        all_false=1'b1;
        // $display("start=%d",start);
        for (i = start;i<`N_CORES ; i=i+1) begin
            // $display("en[%01d]=%b",i,en[i]);
            if (en[i]) begin                
                if (all_false) begin
                    next_idx = i;
                    all_false = 1'b0;
                end             
            end
        end

        // $display("next_idx= %d  ; idx= %d   ; all_false= %d ",next_idx,idx,all_false);

        getNextIdx=next_idx;

    end
    
endfunction 

function automatic RW();
    //R/W
    addr_mem=addr[idx];
    if (RW_Operation==0) begin//Read
        q[idx] = data_from_mem;
        // wren = 0;
    end else begin //Write
        $display("MWrite [%d]",idx);
        data_to_mem = data[idx];
        // wren = 1;
    end
    
    return 1'b1;
endfunction
assign wren = RW_Operation;

//----FSM------
// assign data_to_mem = data[idx];
// assign q[idx] = data_from_mem;

always @(posedge clk) begin

    if (MRead || MWrite) begin     
        if (MWrite) begin
            RW_Operation=1;
        end else begin
            RW_Operation=0;
        end

        idx = getFirstIdx();  
           
        //if all false readyState=1;
        if (all_false) begin
            readyState=1;
            MReady=1;
            RW_Operation=0;            
        end
        else begin
            readyState =1'b0;   
            MReady=0;
            //R/W
            trw = RW();
        end
    end else  if (!readyState) begin
        idx = getNextIdx(idx);  

        //if all false readyState=1;
        if (all_false) begin
            readyState=1;
            MReady=1;
            RW_Operation=0;
            
        end
        else begin
            //R/W
            trw = RW();
        end
    end

end

//----Reset------
always @(posedge reset) begin
    MReady = 1;
    readyState = 1;
    next_state[`N_CORES_LOG]=readyState;
end


endmodule