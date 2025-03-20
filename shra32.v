module shra32(
    input  wire [31:0] IN,
    input  wire [4:0]  shift_amt,
    output wire [31:0] OUT
);

    assign OUT = $signed(IN) >>> shift_amt;
endmodule
