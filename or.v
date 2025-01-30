module or(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output reg  [31:0] result
);
	 genvar i;
	 generate
		for(i=0; i<32; i=i+1) begin : loop
			assign result[i] = (A[i] | B[i]);
		end
	 endgenerate
endmodule
