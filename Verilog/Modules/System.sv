module System (
    input clk,
    input reset );
    
    wire memclk;
    assign memclk=~clk;
    // assign memclk=clk;

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

endmodule