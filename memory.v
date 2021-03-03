module memory (
	input clk, read, write,
	input [11:0] address,
	input [15:0] wrt_data,
	output [15:0] read_data
);

reg [15:0] mem_data [0:4095]; // an array of 2**12 bits (for address), each has 16 bit data (memory data) in hex format
integer i;
initial 
	begin
		// initially, load the program to the RAM memory.
		mem_data[0] = 16'h200a; // LDA
		mem_data[1] = 16'h100b; // ADD
		mem_data[2] = 16'h300c; // STA
		mem_data[3] = 16'h200c; // LDA
		mem_data[4] = 16'h7020; // INC
		mem_data[5] = 16'h7400; // CLE
		mem_data[6] = 16'h7080; // CIR
		mem_data[7] = 16'h7100; // CME
		mem_data[8] = 16'h7040; // CIL
		mem_data[9] = 16'h0000;
		mem_data[10] = 16'h0f0f;
		mem_data[11] = 16'hf102;
		
		for(i=12; i<4096; i = i+1)
			mem_data[i] = 16'h0;
	end
	assign read_data = (read) ? mem_data[address] : 16'bz;
	
always@(posedge clk)
	if (write) begin
		mem_data[address] <= wrt_data;
	end

endmodule