module ram(
    input wire clock, reset, read, write,
    input wire [8:0] address,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] memory[0:511];
    integer i;

    // ✅ Correct initialization to ensure 32-bit values are stored
    initial begin
        for(i = 0; i < 512; i = i+1) begin
            memory[i] = 32'b0;
        end
		  //case 1
//        memory[84] = 32'h00000097; 
//		  memory[0] = 32'b10000_010000000000000000001010100;
//		  memory[1] = 32'b10000_010000000000000000001010100;  

		  //case 2
		  memory[0] = 32'h83100063;
		  memory[1] = 32'h83100063;
		  memory[219] = 32'h00000046;
    end

    // ✅ Fix: Only read/write when enabled
    always @(posedge clock or posedge reset) begin
        if (reset)
            data_out <= 32'b0;
        else if (read)
            data_out <= memory[address]; // ✅ Read RAM
    end

    always @(posedge clock) begin
        if (write)
            memory[address] <= data_in; // ✅ Write to RAM
    end
endmodule
