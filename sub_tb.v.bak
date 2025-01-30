`timescale 1ns/10ps
module adder_tb;

    // Inputs
    reg [31:0] A;
    reg [31:0] B;

    // Outputs
    wire [31:0] result;

    // Instantiate the Unit Under Test (UUT)
    adder uut (
        .A(A), 
        .B(B), 
        .result(result)
    );

    initial begin
        // Initialize Inputs
        A = 32'hFFFFFFFF; B = 32'h00000000;
        #10;
        A = 32'hAAAAAAAA; B = 32'h55555555;
        #10;
        A = 32'h12345678; B = 32'h87654321;
        #10;
        A = 32'hDEADBEEF; B = 32'hCAFEBABE;
        #10;
        A = 32'h00000000; B = 32'hFFFFFFFF;
        #10;
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF;
        #10;

        // End simulation
        $finish;
    end
endmodule
