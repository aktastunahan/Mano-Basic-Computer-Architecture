module control_logic(
		input ind, E,
		input [12:0] ir_addr, 
		input [7:0] op,
		input [15:0] ac,
		input [15:0] dr,
		input [15:0] seq,
		output pc_inc, ir_inc, ar_inc, dr_inc, sc_inc, sc_clr,
		output mem_read, mem_wrt,
		output ir_load, ar_load, dr_load, ac_enable, pc_load,
		output alu_and, alu_add, alu_lda, alu_cla, alu_cle, alu_cma, alu_cme, alu_cir, alu_cil, alu_inc,
		output pc_sel, ar_sel, dr_sel, mem_sel, ac_sel, ir_sel, tr_sel
);
 wire I; // indirect signals
 assign I = ind;
 
 // instruction type
 wire mem_ref_dir = (~op[7]) & (~I) & seq[3]; // direct memory reference 
 wire mem_ref_ind = (~op[7]) & I & seq[3]; // indirect memory reference 
 wire r = (~I) & op[7] & seq[3];			  // register reference
 wire r_ac = (~I) & op[7] & (seq[3] | seq[2]);
 
 // AC signals
 wire ac_enable_reg = r & (ir_addr[5] | ir_addr[6] | ir_addr[7] | ir_addr[9] | ir_addr[10] | ir_addr[11]); // ac enable in reg ref inst.
 wire ac_enable_mem = seq[5] & ( op[0] | op[1] | op[2] ); // ac enable in mem ref inst.
 assign ac_enable = ac_enable_reg | ac_enable_mem;
 
 // PC signals
 wire pc_inc_reg ; // pc increment in register type
 assign pc_inc_reg = 
						(ac[15] == 0) ? (r & ir_addr[4]) :
						(ac[15] == 1) ? (r & ir_addr[3]) :
						(ac == 16'b0) ? (r & ir_addr[2]) :
						(E == 0) ? (r & ir_addr[4]) : 1'b0;
 
 wire pc_inc_mem = (dr == 16'b0) ? ( op[6] & seq[6] ) : 1'b0; 

 assign pc_inc = seq[1] | pc_inc_reg | pc_inc_mem;
 
 assign pc_load = (seq[4] & op[4]) | (seq[5] & op[5]);

 // AR signals
 assign ar_inc = seq[4] & op[5];
 assign ar_load = seq[0] | seq[2] | mem_ref_ind;
 
 // IR signals
 assign ir_inc = 1'b0;
 assign ir_load = seq[1];
 
 // DR signals
 assign dr_inc = seq[5] & op[6];
 assign dr_load = seq[4] & ( op[0] |  op[1] |  op[2] |  op[6] );
 
 // reset/increment seqer
 assign sc_clr = r | ( seq[5] & ( op[0] |  op[1] |  op[2] |  op[5]) ) | ( seq[4] & ( op[4] |  op[3]) ) | ( seq[6] & op[6] );
 assign sc_inc = ~sc_clr;

 // memory signals
 assign mem_read = ( seq[4] & ( op[0] |  op[1] |  op[2] |  op[6] ) ) | seq[1] | mem_ref_ind;
 assign mem_wrt = seq[4] & ( op[3] |  op[5] |  op[6] );

 // alu signals
 assign alu_and = (seq[5]) & op[0 ] ;
 assign alu_add = (seq[5]) & op[1 ] ;
 assign alu_lda = (seq[5]) & op[2 ] ;
 assign alu_cla = r & ir_addr[11] ;
 assign alu_cle = r & ir_addr[10] ;
 assign alu_cma = r & ir_addr[9 ] ;
 assign alu_cme = r & ir_addr[8 ] ;
 assign alu_cir = r & ir_addr[7 ] ;
 assign alu_cil = r & ir_addr[6 ] ;
 assign alu_inc = r & ir_addr[5 ] ;
 
 // bus select signals
 assign pc_sel  = seq[0] | (seq[4] & op[5]);
 assign ar_sel  = (seq[4] & op[4]) | (seq[5] & op[5]);
 assign dr_sel  = (seq[5] & op[2]) | (seq[6] & op[6]);
 assign mem_sel = seq[1] | ( (~op[7]) & I & seq[3]) | (seq[4] & (op[0] | op[1] | op[2] | op[6]));
 assign ac_sel  = seq[4] & op[3];
 assign ir_sel  = seq[2];
 assign tr_sel  = 1'b0;

endmodule
