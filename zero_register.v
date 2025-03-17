module zero_register (
	input wire [31:0] D,
	input wire clk,
	input wire clr,
	input wire R0in,
	input wire BAout,
	output wire [31:0] BusMuxIn_R0
);

	reg [31:0] R0;

	always @(posedge clk or posedge clr) begin
		if (clr)
			R0 <= 32'b0;
		else if (R0in)
			R0 <= D;
	end

	assign BusMuxIn_R0 = BAout ? 32'b0 : R0;

endmodule
