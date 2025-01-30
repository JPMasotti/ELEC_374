`timescale 1ns/10ps
module not_32tb;

    // Inputs
    reg [31:0] A;

    // Outputs
    wire [31:0] OUT;

    // Instantiate the Unit Under Test (UUT)
    not32 uut (
        .A(A),  
        .OUT(OUT)
    );

    initial begin
        // Initialize Inputs
        A = 32'hFFFFFFFF;
        #10;
        A = 32'hAAAAAAAA;
        #10;
        A = 32'h12345678;
        #10;
        A = 32'hDEADBEEF;
        #10;
        A = 32'h00000000;
        #10;
        A = 32'hFFFFFFFF;
        #10;

        // End simulation
        $finish;
    end

endmodule
