module Bus (
    input wire [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3,
    input wire [31:0] BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7,
    input wire [31:0] BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11,
    input wire [31:0] BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15,
    input wire [31:0] HIreg, LOreg, BusMuxInIR,
    input wire [31:0] BusMuxInMAR, BusMuxInMDR, Yreg, CSignExtended,
    input wire [31:0] PCreg,
    input wire [63:0] Zreg,

    input wire [15:0] RegOut,
    input wire Rout,

    input wire Zlowout, Zhighout, HIout, LOout, IRout, Yout, MARout, MDRout, Cout,
    input wire PCout,

    output wire [31:0] BusMuxOut
);

  reg [31:0] q;

  always @(*) begin

    if (Rout) begin
      //if (RegOut[0])      q = BusMuxInR0;
      if (RegOut[1]) q = BusMuxInR1;
      else if (RegOut[2]) q = BusMuxInR2;
      else if (RegOut[3]) q = BusMuxInR3;
      else if (RegOut[4]) q = BusMuxInR4;
      else if (RegOut[5]) q = BusMuxInR5;
      else if (RegOut[6]) q = BusMuxInR6;
      else if (RegOut[7]) q = BusMuxInR7;
      else if (RegOut[8]) q = BusMuxInR8;
      else if (RegOut[9]) q = BusMuxInR9;
      else if (RegOut[10]) q = BusMuxInR10;
      else if (RegOut[11]) q = BusMuxInR11;
      else if (RegOut[12]) q = BusMuxInR12;
      else if (RegOut[13]) q = BusMuxInR13;
      else if (RegOut[14]) q = BusMuxInR14;
      else if (RegOut[15]) q = BusMuxInR15;
    end
    else if (MDRout)          q = BusMuxInMDR;
    else if (Zlowout)         q = Zreg[31:0];
    else if (Zhighout)        q = Zreg[63:32];
    else if (HIout)           q = HIreg;
    else if (LOout)           q = LOreg;
    else if (IRout)           q = BusMuxInIR;
    else if (Yout)            q = Yreg;
    else if (PCout)           q = PCreg;
    else if (Cout)            q = CSignExtended;
    else if (MARout)          q = BusMuxInMAR;
  end

  assign BusMuxOut = q;

endmodule
