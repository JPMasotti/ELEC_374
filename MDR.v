module MDR (
    output reg [31:0] Q,
    input  wire [31:0] BusMuxOut,
    input  wire [31:0] Mdatain,
    input  wire clock, clear, MDRin, MD_read
);
  reg [31:0] MDMux;

  always @(*) begin
    MDMux = MD_read ? Mdatain : BusMuxOut;
  end

  always @(posedge clock) begin
    if (clear)
      Q <= 32'b0;
    else if (MDRin)
      Q <= MDMux; 
  end
endmodule
