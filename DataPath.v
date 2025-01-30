module DataPath(
	input wire clock,
	input wire clear
);

input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out,
input wire R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in,
input wire R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
input wire HIin, HIout, LOin, LOout,
input wire PCin, PCout, IRin, Zin, Zhighout, Zlowout, Yin, MARin,
//input wire Read,
input wire [31:0] Mdatain,
output wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
output wire [31:0] HI, LO, IR, BusMuxOut, Z

// Wires
wire [31:0] BusMuxInR0;
wire [31:0] BusMuxInR1;
wire [31:0] BusMuxInR2;
wire [31:0] BusMuxInR3;
wire [31:0] BusMuxInR4;
wire [31:0] BusMuxInR5;
wire [31:0] BusMuxInR6;
wire [31:0] BusMuxInR7;
wire [31:0] BusMuxInR8;
wire [31:0] BusMuxInR9;
wire [31:0] BusMuxInR10;
wire [31:0] BusMuxInR11;
wire [31:0] BusMuxInR12;
wire [31:0] BusMuxInR13;
wire [31:0] BusMuxInR14;
wire [31:0] BusMuxInR15;
wire [31:0] BusMuxInRZ;
wire [31:0] Zregin;
wire [31:0] HIreg;
wire [31:0] LOreg;
wire [31:0] PCreg;
wire [31:0] IRreg;
wire [31:0] Yreg;
wire [31:0] MARreg;

// Devices (registers)
register R0 (clear, clock, R0in, BusMuxOut, BusMuxInR0);
register R1 (clear, clock, R1in, BusMuxOut, BusMuxInR1);
register R2 (clear, clock, R2in, BusMuxOut, BusMuxInR2);
register R3 (clear, clock, R3in, BusMuxOut, BusMuxInR3);
register R4 (clear, clock, R4in, BusMuxOut, BusMuxInR4);
register R5 (clear, clock, R5in, BusMuxOut, BusMuxInR5);
register R6 (clear, clock, R6in, BusMuxOut, BusMuxInR6);
register R7 (clear, clock, R7in, BusMuxOut, BusMuxInR7);
register R8 (clear, clock, R8in, BusMuxOut, BusMuxInR8);
register R9 (clear, clock, R9in, BusMuxOut, BusMuxInR9);
register R10 (clear, clock, R10in, BusMuxOut, BusMuxInR10);
register R11 (clear, clock, R11in, BusMuxOut, BusMuxInR11);
register R12 (clear, clock, R12in, BusMuxOut, BusMuxInR12);
register R13 (clear, clock, R13in, BusMuxOut, BusMuxInR13);
register R14 (clear, clock, R14in, BusMuxOut, BusMuxInR14);
register R15 (clear, clock, R15in, BusMuxOut, BusMuxInR15);
register HI (clear, clock, HIin, BusMuxOut, HIreg);
register LO (clear, clock, LOin, BusMuxOut, LOreg);
register PC (clear, clock, PCin, BusMuxOut, PCreg);
register IR (clear, clock, IRin, BusMuxOut, IRreg);
register Z (clear, clock, Zin, Zregin, BusMuxInRZ);
register Y (clear, clock, Yin, BusMuxOut, Yreg);
register MAR (clear, clock, MARin, BusMuxOut, MARreg);


// Bus
Bus bus (BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3, 
	BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7, 
	BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11, 
	BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15, 
	BusMuxInHI, BusMuxINLO, BusMuxInPC, BusMuxInIR, 
	BusMuxInRY, BusMuxInRZ, BusMuxInMAR,
	R0out, R1out, R2out, R3out,
	R4out, R5out, R6out, R7out, 
	R8out, R9out, R10out, R11out, 
	R12out, R13out, R14out, R15out, 
	BusMuxOut);

endmodule
