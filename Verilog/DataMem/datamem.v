module datamem(input     clk, MemWrite,
           input  [15:0]   Address, 
           input  [15:0]  WriteData,
           output [15:0]  ReadData);

    reg  [15:0] RAM[63:0]; //8bit x 64 locations

    // Memory Initialization 
    initial begin
        $readmemh("data.txt",RAM);
    end

    // Memory Read  
    assign ReadData = RAM[Address[5:0]]; 

    // Memory Write  
    always @(posedge clk) begin
        if (MemWrite)
                RAM[Address[5:0]] <= WriteData;
    end

endmodule
