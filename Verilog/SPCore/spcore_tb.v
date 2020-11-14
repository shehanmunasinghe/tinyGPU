`include"spcore.v"
`timescale 1ns/10ps
module spcore_tb;
parameter clk_period = 20;
reg clk = 1'b0;
reg reset = 1'b1;
reg en = 1'b1;
reg reg_we = 1'b0;
reg[1:0] s2 = 2'b00;
reg[3:0] x = 4'b0001;
reg[3:0] y = 4'b0010;
reg[3:0] z = 4'b0011;
reg[3:0] aluc = 4'b0111;
reg[15:0] I = 16'h00A3;
reg[15:0] data_in = 16'h00A7;
wire P;
wire[15:0] data_out;
wire[15:0] addr;
spcore spcore_test(clk,reset,x,y,z,I,P,data_out,addr,data_in,en,reg_we,aluc,s2);
always
#(clk_period/2) 
clk <= !clk;
always
#1000000 begin
	reset <= 1'b0;
#2000000
if (s2 == 2'b11)
        $stop;
    else
        s2 <= s2 +1 ;
        reg_we <= reg_we +1 ;
	$display("x = %d, y = %d,z = %d, I = %d, Data out = %d,Address = %d, P = %d, Data in = %d, Enable = %d,Multiplexer = %d",x,y,z,I,data_out,addr,P,data_in,en,s2);
end
	initial
		begin
			$dumpfile("dump.vcd");
			$dumpvars(0,spcore_tb);
		end
	initial
		#350000000 $stop;
endmodule
