`include "../constants_local.v"
`include "../constants.v"

`include "../Modules/DataMemory/DataMemory.v"
`include "../Modules/MemoryController/MemoryController_NCores.v"

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

    wire memclk;
    assign memclk=~clk;
    // assign memclk=clk;

    //Instantiate modules
    DataMemory DMem(memclk,wren,addr_mem,data_to_mem,data_from_mem);
    MemoryController MemController(
        clk,reset, 
        MRead, MWrite, MReady,
        en, addr, data,q,
        data_to_mem,addr_mem,data_from_mem,wren
    );

    //Testing    
    initial begin
        /*********  Delay for Reset *********/
        #(`CLK_PERIOD/2)
        /************************************/

         MRead   = 0;
        MWrite  = 0;
        

        en[0] = 0;
        en[1] = 1;
        en[2] = 0;
        en[3] = 0;

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

        #(`CLK_PERIOD*4)

        en[0] = 1;
        en[1] = 1;
        en[2] = 1;
        en[3] = 1;

        addr[0] = 15'd20;
        addr[1] = 15'd21;
        addr[2] = 15'd22;
        addr[3] = 15'd23;
        
        /////////
        MRead   = 0;
        MWrite   = 1;
        #(`CLK_PERIOD*1)
        MWrite   = 0;
        #(`CLK_PERIOD*3)
        ///
        
        MRead   = 0;
        #(`CLK_PERIOD*4)


        // #250


        $finish; 
    end







    //Logging
	initial begin
        // $monitor(">> clk=%d inst_addr=%b x=%b y=%b z=%b I=%b  @ %0t", clk_cycle, inst_addr, x,y,z,I,  $time);

        // $monitor("next_state= %b  ; idx= %d   ; readyState= %b ",MemController.next_state,MemController.idx,MemController.readyState);
        $dumpfile("dump.vcd");
		$dumpvars(0);
	end


endmodule