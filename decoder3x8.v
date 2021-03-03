module decoder3x8 // 3 x 8 decoder
(
	input [2:0] in,
	output [7:0] out
);
reg [7:0] r_o;
assign out = r_o;
always@* begin
	case(in)
		3'b000: r_o <= 8'b00000001;
		3'b001: r_o <= 8'b00000010;
		3'b010: r_o <= 8'b00000100;
		3'b011: r_o <= 8'b00001000;
		3'b100: r_o <= 8'b00010000;
		3'b101: r_o <= 8'b00100000;
		3'b110: r_o <= 8'b01000000;
		3'b111: r_o <= 8'b10000000;
	endcase
end
endmodule
