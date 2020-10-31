`include "../../constants.v"

module pstack (
	input                    clk,
	input                    reset,
	input      [`N_CORES - 1:0] d,
	output reg [`N_CORES - 1:0] q,
	input                    push,
	input                    pop,
    input                    comp );

	reg [`STACK_DEPTH - 1:0] ptr;
	reg [`N_CORES - 1:0] stack [((1 << `STACK_DEPTH) - 1) :0];

	always @(posedge clk) begin
		if (reset) begin
			ptr = 0;
            stack[ptr] = 0;
        end
		else if (push) begin
			ptr = ptr + 1;
            stack[ptr] = d;//
        end
		else if (pop) begin
            if (ptr>0)
    			ptr = ptr - 1;
        end
        else if (comp) begin
            stack[ptr] = ~stack[ptr];
        end

        q = stack[ptr];
	end

    // assign q = stack[ptr];



endmodule