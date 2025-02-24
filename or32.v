module or32(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output reg  [31:0] result
);
integer i;
always @(A or B)
	begin
		for (i = 0; i < 32; i = i + 1)
		begin
			result[i] = A[i] | B[i];
		end
	end
endmodule