`ifndef INC_CONSTANTS
    `define INST_LENGTH 32 //Each instruction is 32bit long
    `define INSTMEM_ADDR_WIDTH 16 //16bit address
    //64=2^6 // INSTMEM_N_LOCATIONS=2^INSTMEM_ADDR_WIDTH_TRUNC
    `define INSTMEM_N_LOCATIONS 64 //Increase this accordingly
    `define INSTMEM_ADDR_WIDTH_TRUNC 6 //Increase this accordingly

    `define INSTMEM_FILEPATH "PleaseSpecifyAFilePath"
`endif

module InstructionMemory(input     clk,
           input  [`INSTMEM_ADDR_WIDTH-1:0]   Address, 
           output [`INST_LENGTH-1:0]  IOut);

    reg  [`INST_LENGTH-1:0] RAM[`INSTMEM_N_LOCATIONS-1:0]; //8bit x 64 locations

    // Memory Initialization 
    initial begin
        // $readmemh("prog_hex.txt",RAM);
        $readmemb(`INSTMEM_FILEPATH,RAM);
    end

    // Memory Read  
    assign IOut = RAM[Address[`INSTMEM_ADDR_WIDTH_TRUNC-1:0]]; 



endmodule
