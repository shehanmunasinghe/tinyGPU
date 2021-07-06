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
    wire memclk;
    // assign memclk=~clk;
    assign memclk=clk;

    //Connections to Instruction Memory
    wire  [`INSTMEM_ADDR_WIDTH-1:0]   inst_addr;
    wire   [`INST_LENGTH-1:0]          inst;

    //Connections to Data Memory
    wire  [`DATAMEM_ADDR_WIDTH-1:0]   DataAddress;
    wire  [`DATA_WORD_LENGTH-1:0]     DataToWrite;
    wire   [`DATA_WORD_LENGTH-1:0]     DataToRead;
    wire  DataMemWrEn;

    // Modules
    DataMemory DMem(memclk,DataMemWrEn,DataAddress,DataToWrite,DataToRead);
    InstructionMemory IMem(clk,inst_addr,inst);
    SMCore SMCore(inst_addr,inst,DataAddress,DataToWrite,DataToRead,DataMemWrEn, clk, reset);

    // Dump Variables to file
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0,smcore_tb);
	end

    // Logging
    initial begin
        $monitor("DMem[0]= %d   DMem[1]= %d DMem[2]= %d   DMem[3]= %d \n ",DMem.RAM[0],DMem.RAM[1],DMem.RAM[2],DMem.RAM[3]);
    end

    //Finish simulation when there are no more instructions in the instruction memory
    always @(posedge clk) begin
        if (SMCore.Scheduler.CU.state == 19) begin //STATE_END

            // Save memory to file
            mem_dumpfile = $fopen("MemoryFiles/memory_out.hex","w"); // Change the "w" to "a" to append data to an existing file
            for (integer i = 0;i < 32;i = i + 1)
                $fdisplay(mem_dumpfile,"%d ",DMem.RAM[i]); 

            //Finish
            $display("------------------------\nEnding Simulation \n------------------------\n");
            $finish;
        end
    end


endmodule
