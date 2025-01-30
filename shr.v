module shr(
    input wire [31:0] IN,
    input wire [4:0] shift_amt,
    output reg [31:0] OUT
);
    always @(*) begin
        OUT = IN >> shift_amt;
    end
endmodule