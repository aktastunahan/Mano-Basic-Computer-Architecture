
// Basic computer registers
module register #(parameter n=16)
( 
	input clk, clr, load,
	input [n-1:0] in,
	output [n-1:0] out
);
	reg [n-1:0] r_out;
	assign out = r_out;
	
	initial begin
		r_out <= 0;
	end
	always@(posedge clk)
		if(clr)
			r_out <= 0;
		else if(load)
			r_out <= in;
		else
			r_out <= out;

endmodule
