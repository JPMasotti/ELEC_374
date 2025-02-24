module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [7:0] ALU_control,
    input wire [4:0] shift_amt,
    output reg  [63:0] ALU_result
);
  wire [31:0] and_result, or_result, add_result, sub_result, not_result, neg_result;
  wire [63:0] mul_result;
  wire [31:0] quotient, remainder;
  wire [31:0] shr_result, shra_result, shl_result, ror_result, rol_result;

  and32 and_gate(A, B, and_result);
  or32 or_gate(A, B, or_result);
  add32 adder(A, B, add_result);
  sub32 subtractor(A, B, sub_result);
  booth_pair_mul multiplier(A, B, mul_result);
  div32 divisor(A, B, quotient, remainder);
  neg32 negator(A, neg_result);
  not32 inverter(A, not_result);
  
  shr32 shr(.IN(A), .shift_amt(shift_amt), .OUT(shr_result));
  shra32 shra(.IN(A), .shift_amt(shift_amt), .OUT(shra_result));
  shl32 shl(.IN(A), .shift_amt(shift_amt), .OUT(shl_result));
  ror32 ror(.IN(A), .shift_amt(shift_amt), .OUT(ror_result));
  rol32 rol(.IN(A), .shift_amt(shift_amt), .OUT(rol_result));
  
  always @(*) begin
    case (ALU_control)
      8'b00000010: ALU_result = {32'b0, and_result};
      8'b00000011: ALU_result = {32'b0, or_result};
      8'b00000100: ALU_result = {32'b0, add_result};
      8'b00000101: ALU_result = {32'b0, sub_result};
      8'b00000110: ALU_result = mul_result;
      8'b00000111: ALU_result = {remainder, quotient};
      8'b00001000: ALU_result = {32'b0, neg_result};
      8'b00001001: ALU_result = {32'b0, not_result};
      8'b00001010: ALU_result = {32'b0, ror_result};
      8'b00001011: ALU_result = {32'b0, rol_result};
      8'b00001100: ALU_result = {32'b0, shl_result};
      8'b00001101: ALU_result = {32'b0, shr_result};
      8'b00001110: ALU_result = {32'b0, shra_result};
      default:     ALU_result = 64'h0000000000000001;
    endcase
  end

endmodule
