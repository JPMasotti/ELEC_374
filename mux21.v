module mux21 (input wire [31:0] input1, input wire [31:0] input2, input wire signal, output reg [31:0] out);
 
always@(*)begin
		if (signal) begin
			out[31:0] <= input2[31:0];
		end
		else begin
			out[31:0] <= input1[31:0];
		end
	end
 
endmodule