module MAR(
    input wire clock,          
    input wire clear,          
    input wire MARin,          
    input wire [31:0] BusMuxOut, 
    output reg [8:0] BusMuxInMAR 
);

    always @(posedge clock or posedge clear) begin
        if (clear)
            BusMuxInMAR <= 9'b0; 
        else if (MARin)
            BusMuxInMAR <= BusMuxOut[8:0]; 
    end

endmodule
