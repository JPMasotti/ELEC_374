module sub32(A, B, result);

  input [31:0] A, B;
  output [31:0] result;

  reg [31:0] result;
  reg [32:0] LocalCarry; 

  integer i;

  always @(A or B)
  begin
    // Initialize carry to 1 for the +1 in (two’s complement of B)
    LocalCarry = 33'd1;

    for(i = 0; i < 32; i = i + 1)
    begin
      // Subtraction = A + (~B) + 1
      result[i]       = A[i] ^ (~B[i]) ^ LocalCarry[i];
      LocalCarry[i+1] = (A[i] & ~B[i]) | (A[i] & LocalCarry[i]) | ((~B[i]) & LocalCarry[i]);
    end
  end

endmodule

