module and32 (A, B, result);

input [31:0] A, B;
output reg [31:0] result;

integer i;

always @(A or B)
	begin
		for (i = 0; i < 32; i = i + 1)
		begin
			result[i] = A[i] & B[i];
		end
	end
endmodule
