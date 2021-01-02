/* `timescale 1ns/10ps

`include "../Modules/SMCore/SPCore/RegisterFile/RegisterFile.v"

module testbench ();

//50 MHz clock period = 20 ns
	parameter clk_period = 20;
	
	reg clock = 1'b0;
	reg [3:0] rna = 4'b0000 ;					// reg # of read port A
	reg [3:0] rnb = 4'b0001 ;					// reg # of read port B
	reg [3:0] rnc = 4'b0010 ;					// reg # of read port C
	reg [15:0] d = 16'h1001 ;					// 16 bit data
	reg [3:0] wn = 4'b0 ;						// reg # of write port
	
	reg we = 1'b1 ;
	
	wire[15:0] qa ;								// read port A
	wire[15:0] qb ;								// read port B
	wire[15:0] qc ;								// read port C
	wire[15:0] DR ;								// read port DR
	wire[15:0] AR ;								// read port AR
	
	reg [15:0]count = 0 ;						// for testing
	
	RegisterFile regfile_test(rna,rnb,rnc,d,wn,we,clock,qa,qb,qc,DR,AR) ;
	
	//Clock
	always begin
		#(clk_period/2) clock <= !clock;
	end
		
		
	always
#1000000 begin
				if (count==16'h0008)
					begin
					we <= 1'b0 ;
					rna <= 4'b0011 ;
					count <= count + 1'b1 ;
					end
					
				else if (count==16'h000F)
					$stop ;
				
				else if (count==16'h000A)
					begin
					rna <= 4'b0010 ;
					count <= count + 1'b1 ;
					end
					
				else 
					begin
					count <= count + 1'b1 ;
					d <= d + 1'b1 ;
					wn <= wn + 1'b1 ;
					rna <= rna + 1'b1 ;
					end
				
			end
			
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0);
	end
		
	initial begin
		#1000000000 $stop;
	end
		
endmodule 
	
 */