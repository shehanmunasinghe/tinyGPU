`ifndef INC_CONSTANTS
    `define DATA_WORD_LENGTH 16 //Each data word is 16bit long
    `define DATAMEM_ADDR_WIDTH 16 //16bit address
    `define DATAMEM_N_LOCATIONS 64 //Increase this accordingly
    `define DATAMEM_ADDR_WIDTH_TRUNC 6 //Increase this accordingly

    `define DATAMEM_FILEPATH "PleaseSpecifyAFilePath"
`endif

module DataMemory(input     clk, MemWrite,
           input  [`DATAMEM_ADDR_WIDTH-1:0]   Address, 
           input  [`DATA_WORD_LENGTH-1:0]  WriteData,
           output [`DATA_WORD_LENGTH-1:0]  ReadData);

    reg  [`DATA_WORD_LENGTH-1:0] RAM[`DATAMEM_N_LOCATIONS-1:0]; //8bit x 64 locations

    // Memory Initialization 
    initial begin
        // $readmemh("data_hex.txt",RAM);
        $readmemh(`DATAMEM_FILEPATH,RAM);
    end

    // Memory Read  
    assign ReadData = RAM[Address[`DATAMEM_ADDR_WIDTH_TRUNC-1:0]];

    // Memory Write  
    // always @(negedge clk) begin
    always @(posedge clk) begin
        if (MemWrite) begin
            RAM[Address[`DATAMEM_ADDR_WIDTH_TRUNC-1:0]] <= WriteData;
            $display("Writing to DataMemory ADDR %d",Address);
        end
    end

endmodule
