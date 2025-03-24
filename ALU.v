`timescale 1ns/10ps

module ALU (
    input  wire [31:0] A,
    input  wire [31:0] B,           
    input  wire [4:0]  ALU_control, 
    input  wire [4:0]  shift_amt,  
    output reg  [63:0] ALU_result  
);


  wire [31:0] and_result, or_result, add_result, sub_result, not_result, neg_result;
  wire [63:0] mul_result;
  wire [31:0] quotient, remainder;
  wire [31:0] shr_result, shra_result, shl_result, ror_result, rol_result;


  and32   and_gate_inst     (A, B, and_result);
  or32    or_gate_inst      (A, B, or_result);
  add32   adder_inst        (A, B, add_result);
  sub32   subtractor_inst   (A, B, sub_result);
  booth_pair_mul multiplier_inst (A, B, mul_result);
  div32   divisor_inst      (A, B, quotient, remainder);
  neg32   negator_inst      (A, neg_result);
  not32   inverter_inst     (A, not_result);
  
  shr32   shr_inst          (A, shift_amt, shr_result);
  shra32  shra_inst         (A, shift_amt, shra_result);
  shl32   shl_inst          (A, shift_amt, shl_result);
  ror32   ror_inst          (A, shift_amt, ror_result);
  rol32   rol_inst          (A, shift_amt, rol_result);
  
 
  always @(*) begin
  
    ALU_result = 64'h0;
    case (ALU_control)
    
      5'b00010: ALU_result = {32'b0, and_result};
      5'b00011: ALU_result = {32'b0, or_result};
      5'b00100: ALU_result = {32'b0, add_result};
      5'b00101: ALU_result = {32'b0, sub_result};
      5'b00110: ALU_result = mul_result;
      5'b00111: ALU_result = {remainder, quotient};
      5'b01000: ALU_result = {32'b0, neg_result};
      5'b01001: ALU_result = {32'b0, not_result};
      5'b01010: ALU_result = {32'b0, ror_result};
      5'b01011: ALU_result = {32'b0, rol_result};
      5'b01100: ALU_result = {32'b0, shl_result};
      5'b01101: ALU_result = {32'b0, shr_result};
      5'b01110: ALU_result = {32'b0, shra_result};
      5'b01111: ALU_result = {32'b0, add_result}; 

      5'b10000: ALU_result = {32'b0, add_result};  // LD
      5'b10001: ALU_result = {32'b0, add_result};  // LDI
      5'b10010: ALU_result = {32'b0, add_result};  // ST
      5'b10011: ALU_result = {32'b0, add_result};  // STI

      default: ALU_result = 64'h0;
    endcase
  end

endmodule
