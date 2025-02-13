module Bus (
    // Mux inputs
    input [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3,
    input [31:0] BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7,
    input [31:0] BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11,
    input [31:0] BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15,
    input [31:0] BusMuxInHI, BusMuxInLO, BusMuxInPC, BusMuxInIR, 
    input [31:0] BusMuxInMAR, BusMuxInMDR, Zreg, Yreg,

    // Control signals
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out,
    input wire R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input wire RZout, Zlowout, Zhighout, HIout, LOout, PCout, IRout, Yout, MARout, MDRout,

    // Output
    output wire [31:0] BusMuxOut
);

reg [31:0] q;

always @(*) begin
    // Default the output to high impedance
    q = 32'bz;

    case (1'b1) // Only one active signal should drive BusMuxOut
        R0out: q = BusMuxInR0;
        R1out: q = BusMuxInR1;
        R2out: q = BusMuxInR2;
        R3out: q = BusMuxInR3;
        R4out: q = BusMuxInR4;
        R5out: q = BusMuxInR5;
        R6out: q = BusMuxInR6;
        R7out: q = BusMuxInR7;
        R8out: q = BusMuxInR8;
        R9out: q = BusMuxInR9;
        R10out: q = BusMuxInR10;
        R11out: q = BusMuxInR11;
        R12out: q = BusMuxInR12;
        R13out: q = BusMuxInR13;
        R14out: q = BusMuxInR14;
        R15out: q = BusMuxInR15;
        RZout, Zlowout, Zhighout: q = Zreg; // Ensure only one selects `Zreg`
        HIout: q = BusMuxInHI;
        LOout: q = BusMuxInLO;
        PCout: q = BusMuxInPC;
        IRout: q = BusMuxInIR;
        Yout: q = Yreg;  // Ensure `Yreg` can be read properly
        MARout: q = BusMuxInMAR;
        MDRout: q = BusMuxInMDR;
    endcase
	 
	 $display("BUS DEBUG: Time=%0d, Selected Register Value=%b", $time, q);
end

assign BusMuxOut = q;

endmodule
