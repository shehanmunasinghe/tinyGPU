`include "../constants.v"

`include "../DataMem/datamem.v"
`include "MemoryController_NCores.v"

`timescale 1ms/10ns

module testbench ();

    //Clock
	reg clk = 0; integer clk_cycle=0;
    always begin
		#(`CLK_PERIOD/2) clk <= !clk;
        
        if (!clk)
            clk_cycle+=1;
	end

	//Reset	
    reg reset;
    initial begin        
        reset=1; #(`CLK_PERIOD/2) reset=0; //reset PC register at the begining
    end   


    // Registers and Wires
    reg MRead =0;
    reg MWrite =0;
    wire MReady;

    reg [`N_CORES-1:0] en;
    reg [15:0] addr [`N_CORES-1:0];
    reg [15:0] data [`N_CORES-1:0];
    wire [15:0]  q[`N_CORES-1:0];

    wire [15:0]  data_to_mem;
    wire [15:0]  addr_mem;
    wire   [15:0]  data_from_mem;
    wire wren;

    //Instantiate modules
    datamem DMem(clk,wren,addr_mem,data_to_mem,data_from_mem);
    MemoryController MemController(
        clk,reset, 
        MRead, MWrite, MReady,
        en, addr, data,q,
        data_to_mem,addr_mem,data_from_mem,wren
    );

    //--------Function for the state machine------

    reg [`N_CORES_LOG-1:0]  idx=0; reg readyState=1'b1;
    reg [`N_CORES_LOG:0] next_state=0;


    function [`N_CORES_LOG:0] getNextState( [`N_CORES_LOG-1:0] idx,   readyState );
        // input [`N_CORES-1:0]  idx; input readyState;

        // reg [`N_CORES_LOG-1:0] i,next_idx;
        integer i; 
        reg [`N_CORES_LOG-1:0] next_idx;
        reg found_en;
        integer start;

        begin
            start=idx;
            found_en=1'b0;
            $display("start=%d",start);
            for (i = start;i<`N_CORES ; i=i+1) begin

                if (en[i]) begin
                    $display("en[%01d]=%b",i,en[i]);
                    if (!found_en) begin
                        next_idx = i+1;
                        found_en = 1;
                        readyState = 0;
                    end             
                end
            end
            if (!found_en) begin
                $display("!found_en");
                next_idx = 0;
                readyState = 1;
            end

            for (i=0;i<`N_CORES_LOG;i=i+1) begin
                getNextState[i] = next_idx[i];
            end
            getNextState[`N_CORES_LOG]=readyState;
            // getNextState = {next_idx, readyState};
            $display("next_idx= %b  ; idx= %b   ; readyState= %b ",next_idx,idx,readyState);
            // $display("comb %b",{next_idx, readyState});
            // return {next_idx, readyState};
            // idx = next_idx;
            // readyState=readyState;
        end
        
    endfunction 





    //Testing    
    initial begin
        /*********  Delay for Reset *********/
        #(`CLK_PERIOD/2)
        /************************************/

         MRead   = 0;
        MWrite  = 0;
        

        en[0] = 0;
        en[1] = 1;
        en[2] = 1;
        en[3] = 1;

        addr[0] = 15'd10;
        addr[1] = 15'd11;
        addr[2] = 15'd12;
        addr[3] = 15'd13;

        data[0] = 15'd9;
        data[1] = 15'd20;
        data[2] = 15'd55;
        data[3] = 15'd24;

        #(`CLK_PERIOD)
        // #(`CLK_PERIOD)

        /////////
        MRead   = 1;
        #(`CLK_PERIOD*1)
        MRead   = 0;
        #(`CLK_PERIOD*3)
        ///

        // next_state = getNextState(idx, readyState);        
        // idx = next_state[`N_CORES_LOG:0];
        // readyState = next_state[`N_CORES_LOG];

        // $display("#next_state= %b  ; idx= %d   ; readyState= %b ",next_state,idx,readyState);



        // #(`CLK_PERIOD)
    //    next_state = getNextState(idx, readyState);      
    //     idx = next_state[`N_CORES_LOG:0];
    //     readyState = next_state[`N_CORES_LOG];
    //     $display("#next_state= %b  ; idx= %d   ; readyState= %b ",next_state,idx,readyState);


        // #(`CLK_PERIOD)
        // $display("#next_state= %b  ; idx= %d   ; readyState= %b ",next_state,idx,readyState);

        #(`CLK_PERIOD*4)

        MRead   = 0;
        #(`CLK_PERIOD*4)
        
        MRead   = 1;
        #(`CLK_PERIOD*1)
        MRead   = 0;
        #(`CLK_PERIOD*3)
        
        MRead   = 0;
        #(`CLK_PERIOD*4)


        // #250


        $finish; 
    end


    // integer i,start;
    // reg[4:0] idx=11;
    
    
    // initial begin  
    //     start=idx;
    //     i=0;      
    //     for (i = start;i<20 ; i=i+1) begin
    //             $display("[%01d]",i);
                
    //     end

    //     idx+=5;
    //     $display("idx%d",idx);
    //     start=idx;
    //     i=0;      
    //     for (i = start;i<20 ; i=i+1) begin
    //             $display("[%01d]",i);
                
    //     end


    // end






    //Logging
	initial begin
        // $monitor(">> clk=%d inst_addr=%b x=%b y=%b z=%b I=%b  @ %0t", clk_cycle, inst_addr, x,y,z,I,  $time);

        $monitor("next_state= %b  ; idx= %d   ; readyState= %b ",MemController.next_state,MemController.idx,MemController.readyState);
        $dumpfile("dump.vcd");
		$dumpvars(0);
	end


endmodule