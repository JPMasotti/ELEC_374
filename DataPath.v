module DataPath(
    input wire clock,
    input wire clear, read, write, ram_read, ram_write,
    input wire HIin, HIout, LOin, LOout, MDRout, MARout, PCout,
    input wire EffectiveAddrOut, ValueToStoreOut,
    input wire PCin, IRin, IRout, Zin, Zhighout, Zlowout,
    input wire Yin, MARin, MDRin, IncPC,
    input wire Cout, MD_read, Gra, Grb, Grc, BAout, Rin, Rout,
    input wire change_PC, Yout,
    input wire [31:0] Mdatain,
    input wire [4:0] shift_count_in,

    output wire [3:0] decoderInput,
    output wire [31:0] CSignExtended,
    output wire [31:0] PCreg,
    output wire [31:0] instruction,
    output wire [31:0] BusMuxOut,
    output wire [15:0] RegIn,
    output wire [15:0] RegOut
);

  // === Internal Connections ===
  wire [31:0] memory_data_out;
  wire [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3;
  wire [31:0] BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7;
  wire [31:0] BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11;
  wire [31:0] BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15;
  wire [31:0] HIreg, LOreg, IRreg, Yreg, BusMuxInMDR;
  wire [8:0]  BusMuxInMAR;
  wire [63:0] ALU_result, Zreg;
  wire [31:0] Mdatain_mux;
  wire [31:0] BusHI = Zreg[63:32];
  wire [31:0] BusLO = Zreg[31:0];

  assign instruction = IRreg;
  assign Mdatain_mux = ram_read ? memory_data_out : Mdatain;

  // === Select and Encode Logic ===
  wire [4:0] opcode;
  selectEncode encodeselect(
    .instruction(IRreg),
    .Gra(Gra), .Grb(Grb), .Grc(Grc),
    .Rin(Rin), .Rout(Rout),
    .BAout(BAout), .Cout(Cout),
    .opcode(opcode),
    .CSignExtended(CSignExtended),
    .RegIn(RegIn), .RegOut(RegOut),
    .decoderInput(decoderInput)
  );

  // === ALU ===
  ALU alu(
    .A(Yreg),
    .B(BusMuxOut),
    .ALU_control(opcode),
    .shift_amt(shift_count_in),
    .ALU_result(ALU_result)
  );

  // === Memory ===
  ram ram_inst(
    .clock(clock),
    .reset(clear),
    .read(ram_read),
    .write(ram_write),
    .address(BusMuxInMAR),
    .data_in(BusMuxOut),         // MDR register gets its input from the bus
    .data_out(memory_data_out)
  );

  // === Registers R0–R15 ===
  zero_register R0 (.D(BusMuxOut), .clk(clock), .clr(clear), .R0in(RegIn[0]), .BAout(BAout), .BusMuxIn_R0(BusMuxInR0));
  register R1  (clear, clock, RegIn[1],  BusMuxOut, BusMuxInR1);
  register R2  (clear, clock, RegIn[2],  BusMuxOut, BusMuxInR2);
  register R3  (clear, clock, RegIn[3],  BusMuxOut, BusMuxInR3);
  register R4  (clear, clock, RegIn[4],  BusMuxOut, BusMuxInR4);
  register R5  (clear, clock, RegIn[5],  BusMuxOut, BusMuxInR5);
  register R6  (clear, clock, RegIn[6],  BusMuxOut, BusMuxInR6);
  register R7  (clear, clock, RegIn[7],  BusMuxOut, BusMuxInR7);
  register R8  (clear, clock, RegIn[8],  BusMuxOut, BusMuxInR8);
  register R9  (clear, clock, RegIn[9],  BusMuxOut, BusMuxInR9);
  register R10 (clear, clock, RegIn[10], BusMuxOut, BusMuxInR10);
  register R11 (clear, clock, RegIn[11], BusMuxOut, BusMuxInR11);
  register R12 (clear, clock, RegIn[12], BusMuxOut, BusMuxInR12);
  register R13 (clear, clock, RegIn[13], BusMuxOut, BusMuxInR13);
  register R14 (clear, clock, RegIn[14], BusMuxOut, BusMuxInR14);
  register R15 (clear, clock, RegIn[15], BusMuxOut, BusMuxInR15);
	
  // === Special Registers ===
  register HI (clear, clock, HIin, BusHI, HIreg);
  register LO (clear, clock, LOin, BusLO, LOreg);
  register IR (clear, clock, IRin, BusMuxOut, IRreg);
  register RY (clear, clock, Yin, BusMuxOut, Yreg);
  register #(.DATA_WIDTH_IN(64), .DATA_WIDTH_OUT(64)) RZ (
    .clear(clear), .clock(clock), .enable(Zin), .BusMuxOut(ALU_result), .BusMuxIn(Zreg)
  );

  // === PC Register ===
  wire [31:0] PC_input = IncPC ? (PCreg + 1) : (change_PC ? BusMuxOut : PCreg);
  register PC (clear, clock, PCin, PC_input, PCreg);

  // === MDR and MAR ===
  MDR mdr (
    .Q(BusMuxInMDR),
    .BusMuxOut(BusMuxOut),
    .Mdatain(Mdatain_mux),
    .clock(clock),
    .clear(clear),
    .MDRin(MDRin),
    .MD_read(MD_read)
  );
  MAR mar (clock, clear, MARin, BusMuxOut, BusMuxInMAR);

  // === Bus ===
  Bus bus (
    .BusMuxInR0(BusMuxInR0), .BusMuxInR1(BusMuxInR1), .BusMuxInR2(BusMuxInR2), .BusMuxInR3(BusMuxInR3),
    .BusMuxInR4(BusMuxInR4), .BusMuxInR5(BusMuxInR5), .BusMuxInR6(BusMuxInR6), .BusMuxInR7(BusMuxInR7),
    .BusMuxInR8(BusMuxInR8), .BusMuxInR9(BusMuxInR9), .BusMuxInR10(BusMuxInR10), .BusMuxInR11(BusMuxInR11),
    .BusMuxInR12(BusMuxInR12), .BusMuxInR13(BusMuxInR13), .BusMuxInR14(BusMuxInR14), .BusMuxInR15(BusMuxInR15),
    .HIreg(HIreg), .LOreg(LOreg), .BusMuxInIR(IRreg), .BusMuxInMDR(BusMuxInMDR),
    .BusMuxInMAR(BusMuxInMAR), .Yreg(Yreg),
    .CSignExtended(CSignExtended),
    .PCreg(PCreg), .Zreg(Zreg),
    .Rout(Rout), .RegOut(RegOut),
    .Zlowout(Zlowout), .Zhighout(Zhighout),
    .HIout(HIout), .LOout(LOout), .IRout(IRout),
    .Yout(Yout), .MDRout(MDRout), .MARout(MARout),
    .Cout(Cout), .PCout(PCout),
    .BusMuxOut(BusMuxOut)
  );

endmodule
