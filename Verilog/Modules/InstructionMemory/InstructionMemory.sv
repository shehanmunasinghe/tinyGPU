`ifndef INC_CONSTANTS
    `define INST_LENGTH 32 //Each instruction is 32bit long
    `define INSTMEM_ADDR_WIDTH 16 //16bit address

    `define INSTMEM_FILEPATH "PleaseSpecifyAFilePath"
`endif

module InstructionMemory(input     clk,
           input  [`INSTMEM_ADDR_WIDTH-1:0]   Address, 
           output [`INST_LENGTH-1:0]  IOut);

    reg  [`INST_LENGTH-1:0] RAM[65536-1:0];

    // Memory Initialization 
    initial begin
        // $readmemh("prog_hex.txt",RAM);
        $readmemb(`INSTMEM_FILEPATH,RAM);
    end

    // Memory Read  
    assign IOut = RAM[Address[`INSTMEM_ADDR_WIDTH-1:0]]; 



endmodule
