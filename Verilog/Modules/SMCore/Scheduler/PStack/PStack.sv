`ifndef INC_CONSTANTS
	`define STACK_DEPTH 3 //2^3 = 8 locations in mask_stack
	`define N_CORES 4
`endif

`ifndef PStack
    `define PStack 1
`endif
module PStack (
	input                    clk,
	input                    reset,
	input      [`N_CORES - 1:0] d_in, 	//input to the mask_stack
	output reg [`N_CORES - 1:0] tos, 	//top of mask_stack
	input                    push,
	input                    pop,
    input                    comp,

	output	reg 			all_true,
	output	reg 			all_false	 );


	reg [`STACK_DEPTH - 1:0] ptr;
	reg [`N_CORES - 1:0] mask_stack [((1 << `STACK_DEPTH) - 1) :0];
	reg [`N_CORES - 1:0] dont_care_stack [((1 << `STACK_DEPTH) - 1) :0];

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			ptr = 0;
            mask_stack[ptr] = ((1 << `N_CORES) - 1);
			dont_care_stack[ptr] = 0;
        end
		else if (push) begin
			ptr = ptr + 1;
            mask_stack[ptr] = d_in;//
			dont_care_stack[ptr] = ~mask_stack[ptr-1];
        end
		else if (pop) begin
            if (ptr>0)
    			ptr = ptr - 1;
        end
        else if (comp) begin
            mask_stack[ptr] = ~mask_stack[ptr];
        end

        tos = mask_stack[ptr];
	end


	always @(*) begin
		// if (mask_stack[ptr] == ((1 << `N_CORES) - 1) ) 
		if ((mask_stack[ptr]|dont_care_stack[ptr]) == ((1 << `N_CORES) - 1) )
			all_true = 1;
		else
			all_true = 0;

		// if (mask_stack[ptr] == 0 ) 
		if ((mask_stack[ptr]&(~dont_care_stack[ptr])) == 0 ) 
			all_false = 1;
		else
			all_false = 0;
	end
    // assign tos = mask_stack[ptr];



endmodule