`timescale 1ns / 1ps

module div_tb;
    reg [31:0] dividend;
    reg [31:0] divisor;
    wire [31:0] quotient;
    wire [31:0] remainder;
    
    // Instantiate the signed non-restoring divider
    div uut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    
    initial begin
        // Test Case 1: Positive / Positive (100 / 3)
        dividend = 32'd100;
        divisor = 32'd3;
        #10;
        $display("Test 1: 100 / 3 = Quotient: %d, Remainder: %d", quotient, remainder);
        
        // Test Case 2: Positive / Negative (100 / -3)
        dividend = 32'd100;
        divisor = -32'd3;
        #10;
        $display("Test 2: 100 / -3 = Quotient: %d, Remainder: %d", quotient, remainder);
        
        // Test Case 3: Negative / Positive (-100 / 3)
        dividend = -32'd100;
        divisor = 32'd3;
        #10;
        $display("Test 3: -100 / 3 = Quotient: %d, Remainder: %d", quotient, remainder);
        
        // Test Case 4: Negative / Negative (-100 / -3)
        dividend = -32'd100;
        divisor = -32'd3;
        #10;
        $display("Test 4: -100 / -3 = Quotient: %d, Remainder: %d", quotient, remainder);
        
        // Test Case 5: Dividend < Divisor (5 / 20)
        dividend = 32'd5;
        divisor = 32'd20;
        #10;
        $display("Test 5: 5 / 20 = Quotient: %d, Remainder: %d", quotient, remainder);
        
        // Test Case 6: Zero Dividend (0 / 7)
        dividend = 32'd0;
        divisor = 32'd7;
        #10;
        $display("Test 6: 0 / 7 = Quotient: %d, Remainder: %d", quotient, remainder);
        
        // Test Case 7: Dividend = Divisor (20 / 20)
        dividend = 32'd20;
        divisor = 32'd20;
        #10;
        $display("Test 7: 20 / 20 = Quotient: %d, Remainder: %d", quotient, remainder);
        
        // End of simulation
        #10;
        $finish;
    end
endmodule
