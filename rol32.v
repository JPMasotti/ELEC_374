module rol32(
    input  wire [31:0] IN,
    input  wire [4:0]  shift_amt,
    output wire [31:0] OUT
);
    assign OUT = (IN << shift_amt) | (IN >> (32 - shift_amt));
endmodule
