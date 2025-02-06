// Manual Multiplication
module mul(A, B, result);

	input [31:0] A, B;
	output [31:0] result;

	reg [31:0] result;
	reg [31:0] temp;

	integer i;

	always @(*) begin
		result = 32'b0;  // Initialize result to 0
		for (i = 0; i < 32; i = i + 1) begin
			if (B[i]) begin
				temp = A << i;  // Shift A left by i positions
				result = result + temp;  // Accumulate the shifted value
			end
		end
   end

endmodule 