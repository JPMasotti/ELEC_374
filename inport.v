module inport(
    input wire clk, clear,
    // If your design expects to store external data, you can add an enable here too
    input wire [31:0] d,
    output reg [31:0] q
);

  always @(posedge clk) begin
    if (clear)
      q <= 32'b0;
    else
      q <= d;       // or latch if you have an enable signal
  end

endmodule
