
module control_unit(
				input [15:0] ir, ac, dr,
				input clk, E,
				output pc_inc, pc_load, ir_inc, ir_load,
				output ar_inc, ar_load, dr_inc, dr_load,
				output ac_enable, mem_read, mem_wrt,
				output alu_and, alu_add, alu_lda, alu_cla, alu_cle, alu_cma, alu_cme, alu_cir, alu_cil, alu_inc,
				output pc_sel, ar_sel, dr_sel, mem_sel, ac_sel, ir_sel, tr_sel
				);

	// sequence counter and decoder modules
	wire [15:0] seq;
	wire [7:0] op_code;
	wire [3:0] state_counter;
	wire  sc_inc, sc_clr;
	
	sc seq_cntr(.clk(clk), .inc(sc_inc), .clr(sc_clr), .count(state_counter));
	decoder4x16 time_decoder(.in(state_counter), .out(seq));
	
	// op code decoder
	decoder3x8 opcode_decoder(.in(ir[14:12]), .out(op_code));
	
	// combinational control logic
	control_logic cl( .ind(ir[15]), .ir_addr(ir[11:0]), .op(op_code), .seq(seq), .ac(ac), .dr(dr),
							.sc_inc(sc_inc), .sc_clr(sc_clr),
							.pc_inc(pc_inc), .pc_load(pc_load),
							.ir_inc(ir_inc), .ir_load(ir_load), 
							.ar_inc(ar_inc), .ar_load(ar_load), 
							.dr_inc(dr_inc), .dr_load(dr_load), 
							.ac_enable(ac_enable), .mem_read(mem_read), .mem_wrt(mem_wrt),
							.alu_and(alu_and), .alu_add(alu_add), .alu_lda(alu_lda), .alu_cla(alu_cla), .alu_cle(alu_cle), 
							.alu_cma(alu_cma), .alu_cme(alu_cme), .alu_cir(alu_cir), .alu_cil(alu_cil), .alu_inc(alu_inc),
							.pc_sel(pc_sel), .ar_sel(ar_sel), .dr_sel(dr_sel), .mem_sel(mem_sel), .ac_sel(ac_sel), .ir_sel(ir_sel), .tr_sel(tr_sel)
							);
		

endmodule
