module full_adder (
	input a, b, c_in,
	output s_out, c_out
);
   wire w1, w2, w3;
	assign w1 = (a ^ b);
	assign w2 = (a & b);
	assign w3 = w1 & c_in;
	assign s_out =  w1 ^ c_in; // Sout = (A ^ B) ^ Cin
	assign c_out = w2 | w3; // cout = (A & B) | ((A ^ B) & Cin)
	
endmodule
