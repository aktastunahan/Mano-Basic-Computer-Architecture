module sc #(parameter n = 4) // n bit sequence counter
	( 
    input clk,
	 input inc,
    input clr,
    output reg[n-1:0] count
    );
	  // classical n bit counter
	 initial
		count <= 0;
	always@(posedge clk)
		if(clr)
			count <= 0;
		else if(inc)
			count <= count+1;	
endmodule
