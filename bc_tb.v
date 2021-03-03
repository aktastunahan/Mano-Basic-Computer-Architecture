`timescale 1ns / 1ps

module bc_tb();

reg clk, enable, clr;
wire [11:0] pc, ar;
wire [15:0] ir, dr, ac, mem, b;
wire alu_and, alu_add, alu_lda, alu_cla, alu_cle, alu_cma, alu_cme, alu_cir, alu_cil, alu_inc, ac_load, E;

initial begin
	clk <= 0;
	clr <= 0;
	enable <= 1;
end

computer DUT( 
	.clk(clk), .enable(enable), .clr(clr),
	.pco(pc), .aro(ar),
	.iro(ir), .dro(dr), .aco(ac), .memo(mem), .bus(b),
	.alu_and(alu_and), .alu_add(alu_add), .alu_lda(alu_lda), .alu_cla(alu_cla), .alu_cle(alu_cle), 
	.alu_cma(alu_cma), .alu_cme(alu_cme), .alu_cir(alu_cir), .alu_cil(alu_cil), .alu_inc(alu_inc), 
	.ac_loado(ac_load), .alu_test(ac_testi), .eo(E),
);

 always begin
 clk <= 0; #2.5 ;  clk <= 1; #2.5 ;
end

always begin
	#2000
	clr = 1;
	#5
	clr = 0;
	
end

endmodule
