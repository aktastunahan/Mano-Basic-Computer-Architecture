module computer(
	input clk, enable, clr,
	output [11:0] pco, aro,
	output [15:0] iro, dro, aco, memo, bus,
	output  alu_and, alu_add, alu_lda, alu_cla, alu_cle, alu_cma, alu_cme, alu_cir, alu_cil, alu_inc, ac_loado, eo,
	input [15:0] alu_test
);

// input-output pin decleration for BC registers
// Common bus
wire [15:0] common_bus;
wire pc_sel, ar_sel, dr_sel, mem_sel, ac_sel, ir_sel, tr_sel;
// PC pins
wire pc_inc, pc_load, pc_clr;
wire [11:0] pc_ipin, pc_opin;
// AR pins
wire ar_inc, ar_load, ar_clr;
wire [11:0] ar_opin;
// IR pins
wire ir_inc, ir_load, ir_clr;
wire [15:0] ir_opin;
// DR pins
wire dr_inc, dr_load, dr_clr;
wire [15:0] dr_opin;
// TR pins
wire tr_inc, tr_load, tr_clr;
wire [15:0] tr_opin;
// AC pins
wire ac_inc, ac_load, ac_clr;
wire [15:0] ac_opin;
wire [15:0] ac_ipin;
// ALU pins
wire e_in, e_out, alu_e;
wire [15:0] alu_opin;
//wire alu_and, alu_add, alu_lda, alu_cla, alu_cle, alu_cma, alu_cme, alu_cir, alu_cil, alu_inc;

// memory pins
wire mem_wrt, mem_read;
wire [15:0] mem_data;

// control signals
wire [7:0] op_code; // D0, D1, ...
wire [15:0] time_code; // T0, T1, ...
wire and_sig, add_sig, lda_sig, cla_sig, cle_sig, cma_sig, cme_sig, cir_sig, cil_sig, inc_sig;
assign {alu_and, alu_add, alu_lda, alu_cla, alu_cle, alu_cma, alu_cme, alu_cir, alu_cil, alu_inc}
				= {and_sig, add_sig, lda_sig, cla_sig, cle_sig, cma_sig, cme_sig, cir_sig, cil_sig, inc_sig};

// memory signals:
// clk: clock, mem_read: is read, mem_wrt: is write, address: AR, write value: AC, read value: mem_data
memory mem (.clk(clk), .read(mem_read), .write(mem_wrt), .address(ar_opin), .wrt_data(ac_opin), .read_data(mem_data));

// create PC
program_counter #(.n(12)) pc(.clk(clk), .clr(pc_clr), .inc(pc_inc), .load(pc_load), .in(common_bus[11:0]), .out(pc_opin));
// create AR
register #(.n(12)) ar(.clk(clk), .clr(ar_clr), .load(ar_load), .in(common_bus[11:0]), .out(ar_opin));
// create IR
register ir(.clk(clk), .clr(ir_clr), .load(ir_load), .in(common_bus), .out(ir_opin));
// create TR
register tr(.clk(clk), .clr(tr_clr), .load(tr_load), .in(common_bus), .out(tr_opin));
// create DR
register dr(.clk(clk), .clr(dr_clr), .load(dr_load), .in(common_bus), .out(dr_opin));
// create AC
register ac(.clk(clk), .clr(ac_clr), .load(ac_load), .in(ac_ipin), .out(ac_opin));
// create E
register #(.n(1)) e(.clk(clk), .clr(ac_clr), .load(ac_load), .in(e_in), .out(e_out));

// create ALU
alu alu_unit(  .AND(and_sig), .ADD(add_sig), .LDA(lda_sig), .CLA(cla_sig), .CLE(cle_sig), 
					.CMA(cma_sig), .CME(cme_sig), .CIR(cir_sig), .CIL(cil_sig), .INC(inc_sig),
				   .ac(ac_opin), .dr(dr_opin), .alu_out(ac_ipin), .E_in(e_out), .E_out(e_in)    );
					
							
// select common bus
assign common_bus = pc_sel  ? {4'b0, pc_opin}:
						  ar_sel  ? {4'b0, ar_opin}:
						  dr_sel  ? dr_opin:
						  mem_sel ? mem_data:
						  ac_sel  ? ac_opin:
						  ir_sel  ? ir_opin:
						  tr_sel  ? tr_opin:
						  16'bz;
						  
control_unit cu(
				.ir(ir_opin), .ac(ac_opin), .dr(dr_opin),
				.clk(clk), .E(e_out),
				.pc_inc(pc_inc), .pc_load(pc_load), .ir_inc(ir_inc), .ir_load(ir_load),
				.ar_inc(ar_inc), .ar_load(ar_load), .dr_inc(dr_inc), .dr_load(dr_load),
				.ac_enable(ac_load), .mem_read(mem_read), .mem_wrt(mem_wrt),
				.alu_and(and_sig), .alu_add(add_sig), .alu_lda(lda_sig), .alu_cla(cla_sig), 
				.alu_cle(cle_sig), .alu_cma(cma_sig), .alu_cme(cme_sig), .alu_cir(cir_sig),
				.alu_cil(cil_sig), .alu_inc(inc_sig),
				.pc_sel(pc_sel), .ar_sel(ar_sel), .dr_sel(dr_sel), .mem_sel(mem_sel), .ac_sel(ac_sel), .ir_sel(ir_sel), .tr_sel(tr_sel)
				);
				
// testing signals
assign pco = pc_opin;
assign aro = ar_opin;
assign aco = ac_opin;
assign dro = dr_opin;
assign iro = ir_opin;
assign eo = e_out;
assign memo = mem_data;
assign ac_loado = ac_load;
//assign to = time_code;
//assign op_codeo = op_code;
assign bus = common_bus;
//assign aluo = alu_opin;
//assign ac_i = ac_ipin;
endmodule
