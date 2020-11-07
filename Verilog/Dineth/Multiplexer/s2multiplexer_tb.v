`timescale 1ns/10ps
module s2multiplexer_tb;
parameter clk_period = 20;
reg clock = 1'b0;
reg[15:0] In0 = 16'h0000;
reg[15:0] In1 = 16'h0001;
reg[15:0] In2 = 16'h0002;
reg[1:0]  S2 = 2'b00;
wire[15:0] D_out;
s2multiplexer s2multiplexer_test(In0,In1,In2,S2,D_out);
always
#(clk_period/2) 
clock <= !clock;
always
#1000000 begin
    if (S2 == 2'b11)
        $stop;
    else
        S2 <= S2 +1 ;
	$display("Control signal = %d, Input 0 = %d,Input 1 = %d, Input 2 = %d, output = %d",S2,In0,In1,In2,D_out);
end
	initial
		begin
			$dumpfile("dump.vcd");
			$dumpvars(0,s2multiplexer_tb);
		end
	initial
		#250000000 $stop;
endmodule