module neg(
    input wire [31:0] A,
    output reg [31:0] OUT
);
    always @(*) begin
        OUT = -A;
    end
endmodule