module conFF (
	input wire [1:0] IR_Bits,        // Instruction bits IR[20..19] to indicate branch condition
	input wire [31:0] Bus_Data,      // Data from bus to be evaluated
	input wire CON_In,               // Enable signal for evaluating condition
	input wire clk,                  // Clock signal
	input wire clear,                  // Asynchronous clear signal
	output reg CON_Out               // Output indicating condition met or not
);

	always @(posedge clk or posedge clear) begin
		if (clear)
			CON_Out <= 1'b0;
		else if (CON_In) begin
			case (IR_Bits)
				2'b00: CON_Out <= (Bus_Data == 32'b0);        // brzr: branch if zero
				2'b01: CON_Out <= (Bus_Data != 32'b0);        // brnz: branch if nonzero
				2'b10: CON_Out <= (Bus_Data[31] == 1'b0);     // brpl: branch if positive
				2'b11: CON_Out <= (Bus_Data[31] == 1'b1);     // brmi: branch if negative
				default: CON_Out <= 1'b0;
			endcase
		end
endmodule
