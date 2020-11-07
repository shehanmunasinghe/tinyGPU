`include "../../constants.v"

module pstack (
	input                    clk,
	input                    reset,
	input      [`N_CORES - 1:0] d_in, 	//input to the stack
	output reg [`N_CORES - 1:0] tos, 	//top of stack
	input                    push,
	input                    pop,
    input                    comp,

	output	reg 			all_true,
	output	reg 			all_false	 );


	reg [`STACK_DEPTH - 1:0] ptr;
	reg [`N_CORES - 1:0] stack [((1 << `STACK_DEPTH) - 1) :0];

	always @(posedge clk) begin
		if (reset) begin
			ptr = 0;
            stack[ptr] = ((1 << `N_CORES) - 1);
        end
		else if (push) begin
			ptr = ptr + 1;
            stack[ptr] = d_in;//
        end
		else if (pop) begin
            if (ptr>0)
    			ptr = ptr - 1;
        end
        else if (comp) begin
            stack[ptr] = ~stack[ptr];
        end

        tos = stack[ptr];
	end


	always @(*) begin
		if (stack[ptr] == ((1 << `N_CORES) - 1) ) 
			all_true = 1;
		else
			all_true = 0;

		if (stack[ptr] == 0 ) 
			all_false = 1;
		else
			all_false = 0;
	end
    // assign tos = stack[ptr];



endmodule