`timescale 1ns / 1ps

module RAM_tb();

    reg clock;
    reg clear;
    reg read;
    reg write;
    reg [8:0] address;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Instantiate RAM module
    RAM memory_unit (
        .clk(clock),
        .reset(clear),
        .read(read),
        .write(write),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Generate clock signal (10ns period, 50% duty cycle)
    always #5 clock = ~clock;

    initial begin
        // Initialize signals
        clock = 0;
        clear = 1;  // Reset memory
        read = 0;
        write = 0;
        address = 0;
        data_in = 0;

        #10 clear = 0;  // Release reset

        // Write test: Store 32'hA5A5A5A5 at address 5
        #10 address = 9'd5;
        data_in = 32'hA5A5A5A5;
        write = 1;    // Enable write
        #10 write = 0; // Disable write

        // Read test: Read from address 5
        #10 read = 1;
        #10 if (data_out !== 32'hA5A5A5A5) 
                $display("Test Failed: Expected 0xA5A5A5A5, got %h", data_out);
            else
                $display("Test Passed: Read data correctly");

        read = 0;

        // Another Write-Read Test
        #10 address = 9'd10;
        data_in = 32'h12345678;
        write = 1;
        #10 write = 0;
        #10 read = 1;
        #10 if (data_out !== 32'h12345678) 
                $display("Test Failed: Expected 0x12345678, got %h", data_out);
            else
                $display("Test Passed: Read data correctly");

        // End simulation
        #10 $stop;
    end
endmodule
