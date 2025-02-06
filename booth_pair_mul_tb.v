`timescale 1ns/10ps
module booth_pair_mul_tb;

    // Inputs
    reg [31:0] multiplicand;
    reg [31:0] multiplier;

    // Outputs
    wire [63:0] product;

    // Instantiate the Unit Under Test (UUT)
    booth_pair_mul uut (
        .multiplicand(multiplicand), 
        .multiplier(multiplier), 
        .product(product)
    );

    initial begin
        // Initialize Inputs
        multiplicand = 32'h00000006; multiplier = 32'h00000003;
        #10;
        multiplicand = 32'h0000002C; multiplier = 32'h000000AB;
        #10;
        multiplicand = 32'h12345678; multiplier = 32'h87654321;
        #10;
        multiplicand = 32'hDEADBEEF; multiplier = 32'hCAFEBABE;
        #10;
        multiplicand = 32'h00000000; multiplier = 32'hFFFFFFFF;
        #10;
        multiplicand = 32'hFFFFFFFF; multiplier = 32'hFFFFFFFF;
        #10;

        // End simulation
        $finish;
    end
endmodule
