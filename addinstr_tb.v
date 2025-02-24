`timescale 1ns / 10ps

module addinstr_tb();

    reg clock, clear;
    reg R0out, R1out, R2out, R3out;
    reg R0in, R1in, R2in, R3in;
    reg Zin, Zlowout;
    reg [31:0] Mdatain;
    wire [31:0] BusMuxOut, RZ;

    // Instantiate the DataPath module
    DataPath DUT (
        .clock(clock),
        .clear(clear),
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out),
        .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in),
        .Zin(Zin), .Zlowout(Zlowout),
        .Mdatain(Mdatain),
        .BusMuxOut(BusMuxOut),
        .RZ(RZ)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #10 clock = ~clock;  // 10 ns clock period
    end

    initial begin
        // Initialize control signals
        clear = 1;
        R0out = 0; R1out = 0; R2out = 0; R3out = 0;
        R0in = 0; R1in = 0; R2in = 0; R3in = 0;
        Zin = 0; Zlowout = 0;
        Mdatain = 32'h0;

        // Clear the registers
        #20 clear = 0;  // Clear de-asserted after some time

        // Step 1: Load a value into R0
        Mdatain = 32'h00000010;  // Load 16 into Mdatain
        R0in = 1;  // Enable R0 for input
        #20 R0in = 0;  // Disable R0 after writing

        // Step 2: Load a value into R1
        Mdatain = 32'h00000020;  // Load 32 into Mdatain
        R1in = 1;  // Enable R1 for input
        #20 R1in = 0;  // Disable R1 after writing

        // Step 3: Perform operation or transfer between registers
        R0out = 1;  // Output value from R0
        Zin = 1;  // Enable Z register input
        #20 R0out = 0; Zin = 0;  // Turn off R0 and Z register input

        // Step 4: Move the result from Z to R2
        Zlowout = 1;  // Enable Z register output
        R2in = 1;  // Enable R2 input
        #20 Zlowout = 0; R2in = 0;  // Disable Z output and R2 input

        // Step 5: End of test, check BusMuxOut or internal values if needed
        $stop;
    end

endmodule
