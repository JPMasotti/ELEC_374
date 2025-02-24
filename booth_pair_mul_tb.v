`timescale 1ns/10ps

module booth_pair_mul_tb;

    // Inputs to the multiplier
    reg [31:0] multiplicand;
    reg [31:0] multiplier;
    // Output from the multiplier
    wire [63:0] product;

    // Instantiate the booth multiplier
    booth_pair_mul uut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

    initial begin
        // Test Case 1: Both positive numbers
        multiplicand = 32'd15;
        multiplier   = 32'd3;
        #10;  // Wait for changes to propagate
        $display("Test 1: 15 * 3 = %d (Expected: %d)", product, 15*3);

        // Test Case 2: Multiplicand negative, multiplier positive
        multiplicand = -32'd7;
        multiplier   = 32'd5;
        #10;
        $display("Test 2: -7 * 5 = %d (Expected: %d)", product, -7*5);

        // Test Case 3: Both negative numbers
        multiplicand = -32'd12;
        multiplier   = -32'd4;
        #10;
        $display("Test 3: -12 * -4 = %d (Expected: %d)", product, -12*(-4));

        // Test Case 4: One operand is zero
        multiplicand = 32'd0;
        multiplier   = 32'd123;
        #10;
        $display("Test 4: 0 * 123 = %d (Expected: %d)", product, 0);

        // Test Case 5: Larger numbers
        multiplicand = 32'b11111111000011111111000011111111;
        multiplier   = 32'b11111111111111110000111111110000;
        #10;
        $display("Test 5: 100000 * 20000 = %d (Expected: %d)", product, 32'b11111111000011111111000011111111*32'b11111111111111110000111111110000);

        $finish;
    end

endmodule
