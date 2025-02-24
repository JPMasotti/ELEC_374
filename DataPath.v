module DataPath(
    input  wire clock,
    input  wire clear, read,
    input  wire R0out, R1out, R2out, R3out, R4out, R5out, R6out,
    input  wire R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input  wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in,
    input  wire R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
    input  wire HIin, HIout, LOin, LOout, MDRout, MARout, PCout,
    input  wire PCin, IRin, IRout, Zin, RZout, Zhighout, Zlowout, Yin, MARin, MDRin, IncPC,
    input  wire [7:0] ALU_control,
    input  wire [31:0] Mdatain,
    input  wire [4:0] shift_count_in,
    output wire [31:0] PCincremented, PCreg,
    output wire [31:0] BusMuxOut
);

  // Internal
  wire [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3;
  wire [31:0] BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7;
  wire [31:0] BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11;
  wire [31:0] BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15;
  wire [31:0] BusMuxInHI, BusMuxInLO, BusMuxInIR;
  wire [31:0] HIreg, LOreg, IRreg, Yreg, MARreg, MDRreg;
  wire [63:0] ALU_result;
  wire [63:0] Zreg;
  wire [31:0] BusLO = Zreg[31:0];
  wire [31:0] BusHI = Zreg[63:32];

  ALU alu(
    .A(Yreg),
    .B(BusMuxOut),
    .ALU_control(ALU_control),
    .shift_amt(shift_count_in),
    .ALU_result(ALU_result)
  );

  // Registers
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
  register HI (clear, clock, HIin, BusHI, HIreg);
  register LO (clear, clock, LOin, BusLO, LOreg);
  register IR (clear, clock, IRin, BusMuxOut, IRreg);
  register RY (clear, clock, Yin, BusMuxOut, Yreg);
  register #(.DATA_WIDTH_IN(64), .DATA_WIDTH_OUT(64)) RZ (clear, clock, Zin, ALU_result, Zreg);
  register MAR (clear, clock, MARin, BusMuxOut, MARreg);

  register PC (clear, clock, (PCin | IncPC), PCincremented, PCreg);

  PCincrementer pcInc(PCreg, IncPC, PCincremented);

  MDR mdr (
    .Q(MDRreg),
    .BusMuxOut(BusMuxOut),
    .MDatain(Mdatain),
    .clock(clock),
    .clear(clear),
    .MDRin(MDRin),
    .read(read)
  );

  Bus bus (
    .BusMuxInR0(BusMuxInR0), .BusMuxInR1(BusMuxInR1), .BusMuxInR2(BusMuxInR2), .BusMuxInR3(BusMuxInR3),
    .BusMuxInR4(BusMuxInR4), .BusMuxInR5(BusMuxInR5), .BusMuxInR6(BusMuxInR6), .BusMuxInR7(BusMuxInR7),
    .BusMuxInR8(BusMuxInR8), .BusMuxInR9(BusMuxInR9), .BusMuxInR10(BusMuxInR10), .BusMuxInR11(BusMuxInR11),
    .BusMuxInR12(BusMuxInR12), .BusMuxInR13(BusMuxInR13), .BusMuxInR14(BusMuxInR14), .BusMuxInR15(BusMuxInR15),
    .HIreg(HIreg), .LOreg(LOreg), .BusMuxInIR(IRreg), .BusMuxInMDR(MDRreg),
    .BusMuxInMAR(MARreg), .Yreg(Yreg),
    .BusMuxOut(BusMuxOut), .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out),
    .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out), .R9out(R9out),
    .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
    .Zreg(Zreg),
    .RZout(RZout), .Zlowout(Zlowout), .Zhighout(Zhighout), .HIout(HIout), .LOout(LOout),
    .IRout(IRout), .Yout(Yin), .MDRout(MDRout), .MARout(MARout)
  );
  
endmodule
