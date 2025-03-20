module RAM(
    input wire clk, reset, read, write,
    input wire [8:0] address,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] memory[511:0];
    integer i;

    // Initialize memory to zero
    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end 

    // Handle Reset and Read
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0; // Reset data_out
        end else if (read) begin
            data_out <= memory[address]; // Read from memory
        end
    end

    // Write operation (only on positive clock edge)
    always @(posedge clk) begin
        if (write) begin
            memory[address] <= data_in;
        end
    end

endmodule
