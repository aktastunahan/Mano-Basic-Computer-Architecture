// Basic computer registers
module program_counter #(parameter n=16)
( 
	input clk, clr, load, inc,
	input [n-1:0] in,
	output reg [n-1:0] out
);
initial begin
	out <= 1'b0;
	end

always@(posedge clk)
	if(clr)
		out <= 0;
	else if(load)
		out <= in;
	else if(inc)
		out <= out + 1;
endmodule
