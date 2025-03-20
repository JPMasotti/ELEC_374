module fourTo16encoder(
input wire [3:0] FourbitInput,
output reg [16:0] SixteenbitOutput
);
	always@(*) begin
		case(FourbitInput)
			4'b0000 : SixteenbitOutput <= 16'h0001;
			4'b0001 : SixteenbitOutput <= 16'h0002;
			4'b0010 : SixteenbitOutput <= 16'h0004;
			4'b0011 : SixteenbitOutput <= 16'h0008;
			4'b0100 : SixteenbitOutput <= 16'h0010;
			4'b0101 : SixteenbitOutput <= 16'h0020;
			4'b0110 : SixteenbitOutput <= 16'h0040;
			4'b0111 : SixteenbitOutput <= 16'h0080;
			4'b1000 : SixteenbitOutput <= 16'h0100;
			4'b1001 : SixteenbitOutput <= 16'h0200;
			4'b1010 : SixteenbitOutput <= 16'h0400;
			4'b1011 : SixteenbitOutput <= 16'h0800;
			4'b1100 : SixteenbitOutput <= 16'h1000;
			4'b1101 : SixteenbitOutput <= 16'h2000;
			4'b1110 : SixteenbitOutput <= 16'h4000;
			4'b1111 : SixteenbitOutput <= 16'h8000;		
		endcase
	end
	
endmodule 
