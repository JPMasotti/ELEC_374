module selectEncode(
input [31:0] instruction,
input Gra, Grb, Grc,
input Rin, Rout,
input RBout,
output [4:0] opcode,
output [31:0] CSignExtended,
// phase 3 output [15:0] RegIn, RegOut,
output wire [3:0] decoderInput
);
wire [15:0] decoderOutput;

assign decoderInput = (instruction[26:23] & {4{Gra}}) | (instruction[22:19] & {4{Grb}}) | (instruction[18:15] & {4{Grc}});

fourTo16encoder encode(decoderInput, decoderOutput);

assign opcode = instruction[31:27];
assign CSignExtended = {{13{instruction[18]}}, instruction[18:0]};

endmodule
