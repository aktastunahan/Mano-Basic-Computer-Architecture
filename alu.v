
module alu(
				input AND, ADD, LDA, CLA, CLE, CMA, CME, CIR, CIL, INC,
				input [15:0] ac,
				input [15:0] dr,
				input E_in,
				output [15:0] alu_out,
				output E_out
				);
				
wire [15:0] add_out, comp_out, cir_out, cil_out, and_out, inc_out;
wire c_out, E_cir, E_cil;

// circulate left
assign {E_cil, cil_out[15:1]} = ac[15:0];
assign cil_out[0] = E_in;

// circulate right
assign E_cir = ac[0]; 
assign cir_out[15:0] = {E_in, ac[15:1]};
 
// adder module
assign {Cout, add_out} = ac + dr;

// increment
assign inc_out = ac + 1'b1;
	
genvar i;
generate 
for (i = 0; i < 16 ; i = i + 1) begin : and_adder_logic 
	 // and gates
	 and(and_out[i], ac[i], dr[i]);
	 // not gates
	 not(comp_out[i], ac[i]);
end
endgenerate

assign {E_out, alu_out} = AND ? {E_in, and_out} :
								  ADD ? {Cout, add_out} :
								  LDA ? {E_in, dr} :
								  CLA ? {E_in, 15'b0} :
								  CLE ? {1'b0, ac} :
								  CMA ? {E_in, comp_out} :
								  CME ? {~E_in, ac} :
								  CIR ? {E_cir, cir_out} :
								  CIL ? {E_cil, cil_out} : 
								  INC ? {1'b0, inc_out} : 
								  {E_out, alu_out};
endmodule



