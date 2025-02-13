module ALU (
    input [31:0] A,  
    input [31:0] B,  
    input [7:0] ALU_control, 
    output reg [31:0] ALU_result 
);

    wire [31:0] and_result, or_result, add_result, sub_result, not_result, shl_result, shr_result;

    // Instantiate operation modules
    and32 and_gate (A, B, and_result);
    // or32 or_gate (A, B, or_result);
    // add32 adder (A, B, add_result);
    // sub32 subtractor (A, B, sub_result);
    // not32 inverter (A, not_result);
    // shl32 shift_left (A, shl_result);
    // shr32 shift_right (A, shr_result);

    always @(*) begin
        $display("ALU: A=%b, B=%b, ALU_control=%b", A, B, ALU_control);

        case (ALU_control)
            8'b00000010: ALU_result = and_result;  // AND
            // Keeping other cases intact
            default: ALU_result = 32'h00000000; // Default: Zero
        endcase

        $display("ALU Result: %b", ALU_result);
    end
	 
	 always @(*) begin
    $display("ALU EXECUTING: A=%b, B=%b, ALU_control=%b", A, B, ALU_control);
	 end


endmodule
