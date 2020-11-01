`include "../constants.v"

module instmem(input     clk,
           input  [`INSTMEM_ADDR_WIDTH-1:0]   Address, 
           output [`INST_LENGTH-1:0]  IOut);

    reg  [`INST_LENGTH-1:0] RAM[`INSTMEM_N_LOCATIONS-1:0]; //8bit x 64 locations

    // Memory Initialization 
    initial begin
        // $readmemh("prog_hex.txt",RAM);
        $readmemb("prog_bin.txt",RAM);
    end

    // Memory Read  
    assign IOut = RAM[Address[`INSTMEM_ADDR_WIDTH_TRUNC-1:0]]; 



endmodule
