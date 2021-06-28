`include "../constants_local.v"
`include "../constants.v"

`include "../Modules/SMCore/SPCore/ALU/ALU.v"
`include "../Modules/SMCore/SPCore/RegisterFile/RegisterFile.v"
`include "../Modules/SMCore/SPCore/Mux/Mux3x16.v"

`include "../Modules/SMCore/SPCore/SPCore.v"
`include "../Modules/SMCore/SPCore/N_SPCores.v"

`include "../Modules/SMCore/Scheduler/PC/PC.v"
`include "../Modules/SMCore/Scheduler/CU/CU.v"
`include "../Modules/SMCore/Scheduler/PStack/PStack.v"

`include "../Modules/SMCore/Scheduler/Scheduler.v"
`include "../Modules/MemoryController/MemoryController_NCores.v"

`include "../Modules/SMCore/SMCore.v"

`include "../Modules/DataMemory/DataMemory.v"
`include "../Modules/InstructionMemory/InstructionMemory.v"

`timescale 1ns/10ps

module smcore_tb;
    
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
    assign memclk=~clk;

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

    //Logging
	initial begin
		// $monitor("x = %d, y = %d,z = %d, I = %d, Data out = %d,Address = %d, P = %d, Data in = %d, Enable = %d,Multiplexer = %d",x,y,z,I,data_out,addr,P,data_in,en,s2);
		$dumpfile("dump.vcd");
		$dumpvars(0,smcore_tb);
	end

    //Finish after certain time
    initial
	#300 $finish;

endmodule
