module selectEncode(
input [31:0] instruction,
input Gra, Grb, Grc,
input Rin, Rout,
input BAout, Cout,
output [4:0] opcode,
output [31:0] CSignExtended,
output [15:0] RegIn, RegOut,
output wire [3:0] decoderInput
);
wire [15:0] decoderOutput;

assign decoderInput = (Gra ? instruction[26:23] : 4'b0000) | (Grb ? instruction[22:19] : 4'b0000) | (Grc ? instruction[18:15] : 4'b0000);

fourTo16encoder encode(decoderInput, decoderOutput);

assign opcode = instruction[31:27];
assign CSignExtended = {{13{instruction[18]}}, instruction[18:0]};
assign RegIn = {16{Rin}} & decoderOutput;
assign RegOut = ({16{Rout}} | {16{BAout}}) & decoderOutput;




endmodule
