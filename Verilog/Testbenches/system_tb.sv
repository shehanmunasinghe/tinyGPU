`include "../constants_local.sv"
`include "../constants.sv"

`include "../Modules/SMCore/SPCore/ALU/ALU.sv"
`include "../Modules/SMCore/SPCore/RegisterFile/RegisterFile.sv"
`include "../Modules/SMCore/SPCore/Mux/Mux3x16.sv"

`include "../Modules/SMCore/SPCore/SPCore.sv"
`include "../Modules/SMCore/SPCore/N_SPCores.sv"

`include "../Modules/SMCore/Scheduler/PC/PC.sv"
`include "../Modules/SMCore/Scheduler/CU/CU.sv"
`include "../Modules/SMCore/Scheduler/PStack/PStack.sv"

`include "../Modules/SMCore/Scheduler/Scheduler.sv"
`include "../Modules/MemoryController/MemoryController_NCores.sv"

`include "../Modules/SMCore/SMCore.sv"

`include "../Modules/DataMemory/DataMemory.sv"
`include "../Modules/InstructionMemory/InstructionMemory.sv"

`include "../Modules/System.sv"

`timescale 1ns/10ps

module smcore_tb;

    //Filet to save memory content
    integer  mem_dumpfile;
    
    //Reset
    reg reset;
    initial begin        
        reset=1; #5 reset=0; //reset PC register at the begining
    end   

    //Clock
    parameter clk_period = 20;	
	reg clk = 1'b0;
	always begin
		#(clk_period/2) clk <= !clk;
	end

    // Unit under test
    System UUT(clk, reset);
    

    // Dump Variables to file
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0,smcore_tb);
	end

    //Finish simulation when there are no more instructions in the instruction memory
    always @(posedge clk) begin
        if (UUT.SMCore.Scheduler.CU.state == 19) begin //STATE_END

            // Save memory to file
            mem_dumpfile = $fopen("MemoryFiles/memory_out.txt","w");
            for (integer i = 0;i < 32;i = i + 1)
                $fdisplay(mem_dumpfile,"%d ",UUT.DMem.RAM[i]); 

            //Finish
            $display("------------------------\nEnding Simulation \n------------------------\n");
            $finish;
        end
    end


endmodule
