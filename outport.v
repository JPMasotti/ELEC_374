module outport(
    input wire clk, clear, enable,
    input wire [31:0] bus,
    output reg [31:0] out
);

  always @(posedge clk) begin
    if (clear)
      out <= 32'b0;
    else if (enable)
      out <= bus;      
  end

endmodule
