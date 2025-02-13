module MDR (
    output reg [31:0] Q,
    input [31:0] BusMuxOut,
    input [31:0] MDatain,
    input clock, clear, MDRin, read
);

    reg [31:0] MDMux;

    always @(*) begin
        if (read)
            MDMux = MDatain;
        else
            MDMux = BusMuxOut;
    end

    always @(posedge clock) begin
        if (clear)
            Q <= 32'b0;
        else if (MDRin)
            Q <= MDMux;
    end

endmodule
