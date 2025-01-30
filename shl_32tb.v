`timescale 1ns/10ps
module shl_32tb;

    // Inputs
    reg [31:0] IN;
	 reg [4:0] shift_amt;

    // Outputs
    wire [31:0] OUT;

    // Instantiate the Unit Under Test (UUT)
    shl32 uut (
        .IN(IN),
		  .shift_amt(shift_amt),
        .OUT(OUT)
    );

    initial begin
        // Initialize Inputs
        IN = 32'hFFFFFFFF; shift_amt = 1;
        #10;
        IN = 32'hAAAAAAAA; shift_amt = 1;
        #10;
        IN = 32'h12345678; shift_amt = 1;
        #10;
        IN = 32'hDEADBEEF; shift_amt = 1;
        #10;
        IN = 32'h00000000; shift_amt = 1;
        #10;
        IN = 32'hFFFFFFFF; shift_amt = 1;
        #10;

        // End simulation
        $finish;
    end

endmodule
