// Ripple-Carry Subtractor using 2's complement
module sub(A, B, result);

  input [31:0] A, B;
  output [31:0] result;

  wire [31:0] result;
  wire [31:0] negB;

  neg32 negative(B, negB);
  add32 add(A, negB, result);

endmodule
