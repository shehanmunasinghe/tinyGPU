module control(input clock,
input [15:0] z,
input [15:0] instruction ,
output reg [2:0] alu_op,
output reg [15:0] write_en ,
output reg [15:0] inc_en,
output reg [3:0] read_en,
output reg end_process ,
input [1:0] status );

reg [5:0] present = 6'd0;
reg [5:0] next = 6'd0;


parameter
fetch1 = 6'd1,
fetch2 = 6'd2,
loadac1 = 6'd3,
loadac2 = 6'd4,
sub1 = 6'd22,
sub2 = 6'd23,
lshift1 = 6'd24,
lshift2 = 6'd25,
rshift1 = 6'd26,
rshift2 = 6'd27,
jumpz4x = 6'd48,
jumpnz1 = 6'd39,
jump1 = 6'd40,
nop = 6'd41,
endop = 6'd42,
fetchx = 6'd44,
stac2 = 6'd43,
idle = 6'd0;


always @(posedge clock)
    present <= next;

always @(posedge clock) begin
    if (present == endop)
    end_process <= 1'd1;
    else
    end_process <= 1'd0;
end

always @(present or z or instruction or status)
    case(present)

        idle: begin
            read_en <= 4'd0;
            write_en <= 16'b0000000000000000 ;
            inc_en <= 16'b0000000000000000 ;
            alu_op <= 3'd0;
            if (status == 2'b01)
            next <= fetch1;
            else
            next <= idle;
        end

        fetch1: begin
            read_en <= 4'd13;
            write_en <= 16'b0000000000010000 ;
            inc_en <= 16'b0000000000000000 ;
            alu_op <= 3'd0;
            next <= fetchx;
        end
        fetchx: begin
            read_en <= 4'd13;
            write_en <= 16'b0000000000010000 ;
            inc_en <= 16'b0000000000000000 ;
            alu_op <= 3'd0;
            next <= fetch2;
        end
        jumpz4: begin
        read_en <= 4'd0;
        write_en <= 16'b0000000000000000 ;
        inc_en <= 16'b0000000000000010 ;
        alu_op <= 3'd0;
        next <= jumpz3x;
        end
        nop: begin
        read_en <= 4'd0;
        write_en <= 16'b0000000000000000 ;
        inc_en <= 16'b0000000000000010 ;
        alu_op <= 3'd0;
        next <= fetch1;
        end
        endop: begin
        read_en <= 4'd12;
        write_en <= 16'b0000000000000000 ;
        inc_en <= 16'b0000000000000000 ;
        alu_op <= 3'd0;
        next <= endop;
        end
        default: begin
        read_en <= 4'd0;
        write_en <= 16'b0000000000000000 ;
        inc_en <= 16'b0000000000000000 ;
        alu_op <= 3'd0;
        next <= fetch1;
        end
    endcase
endmodule