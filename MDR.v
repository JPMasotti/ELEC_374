module MDR (
    output reg [31:0] Q,
    input  wire [31:0] BusMuxOut,
    input  wire [31:0] MDatain,
    input  wire clock, clear, MDRin, read
);
  reg [31:0] MDMux;
  always @(*) begin
    if (read)
      MDMux = MDatain;
    else
      MDMux = BusMuxOut;
  end
  always @(posedge clock)
    if (clear)
      Q <= 32'b0;
    else if (MDRin)
      Q <= MDMux;
endmodule
