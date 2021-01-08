`include "../constants_local.v"
`include "../constants.v"

`include "../Modules/InstructionMemory/InstructionMemory.v"
`include "../Modules/SMCore/Scheduler/CU/CU.v"
`include "../Modules/SMCore/Scheduler/PC/PC.v"

`include "../Modules/SMCore/Scheduler/Scheduler.v"



`timescale 1ms/10ns

module testbench ();
    
    //Clock
	reg clk = 1'b0; integer clk_cycle=0;
    always begin
		#(`CLK_PERIOD/2) clk <= !clk;
        
        if (!clk)
            clk_cycle+=1;
	end
    // always begin
	// 	#(`CLK_PERIOD) clk_cycle+=1;
	// end

    //reg
    wire[`INST_LENGTH-1:0] inst;
    wire[`INSTMEM_ADDR_WIDTH-1:0] inst_addr;//0

    wire [3:0]     x;
    wire [3:0]     y;
    wire [3:0]     z;
    wire [15:0]    I;//0

    //control
    reg reset;



    Scheduler Scheduler(clk, reset, inst_addr,inst, x,y,z,I);

    InstructionMemory InstMem(clk,inst_addr,inst);


    //test
    initial begin
        
        reset=1; #41 reset=0; //reset PC register at the begining
        #25 
        #50
        #5 
        // #50 I=26; loadFromI=1;
        #200 $finish;

    end    

    initial begin
        // $monitor("monitor inst_addr=%b inst=%b  @ %0t", inst_addr,inst,  $time);
        $monitor(">> clk=%d inst_addr=%b x=%b y=%b z=%b I=%b  @ %0t", clk_cycle, inst_addr, x,y,z,I,  $time);
        
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end


endmodule