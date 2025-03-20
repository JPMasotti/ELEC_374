module ram(
input wire clk, reset, read, write,
input wire [8:0] address,
input wire [31:0] data_in,
output reg [31:0] data_out
);
	reg [31:0] memory[511:0];
	integer i;
	initial begin
		for(i = 0; i < 512; i = i+1) begin
			memory[i] = 32'b0;
		end
	end 
	
	always @(posedge clk, reset) begin
		if(reset) begin
			data_out <= 32'b0;
		end else if(read) begin
			data_out <= memory[address];
		end
	end
	
	always @(posedge clk) begin
		if(write) begin
			memory[address] <= data_in;
		end
	end
	
endmodule
