`timescale 1ns/10ps

module mf_tb;

  reg clock = 0, clear = 0;
  reg ram_read = 0, ram_write = 0, MD_read = 0;
  reg PCout = 0, MARin = 0, IncPC = 0, Zin = 0, PCin = 0;
  reg MDRin = 0, IRin = 0, MDRout = 0;
  reg Grb = 0, BAout = 0, Yin = 0, Yout = 0, Cout = 0, Gra = 0, Grc = 0, Zlowout = 0;
  reg Rin = 0, Rout = 0;
  reg [31:0] Mdatain = 0;

  wire [31:0] PCreg, BusMuxOut, instruction;
  wire [3:0] decoderInput;
  wire [15:0] RegIn, RegOut;
  wire [31:0] CSignExtended;
  wire [4:0] shift_count_in;
  reg change_PC, HIin, HIout, LOin, LOout, CONin, CON;
  wire IRout, MARout, Zhighout, read, write;

  reg [4:0] state, next_state;
  parameter RegLoad1 = 0,   // Preload: load instruction word "ld R4, #54"
            RegLoad2 = 1,   // Transfer MDR -> IR
            RegLoad3 = 2,   // (Unused in this example, but kept for consistency)
            RegLoad4 = 3,   // (Unused)
            RegLoad5 = 4,   // (Unused)
            T0       = 5,   // Instruction fetch: PCout, MARin, IncPC, PCin, Zin
            T1       = 6,   // Instruction fetch: Zlowout, ram_read, MDRin
            T2       = 7,   // Instruction fetch: Cout (placing the immediate on the bus)
            T3       = 8,   // Execution: (for load immediate, do NOT load Y with the immediate)
            T4       = 9,   // Execution: capture computed effective value (Zin)
            T5       = 10,  // Execution: drive effective address onto the bus and load MAR
            T6       = 11,  // Execution: ram_read and MDRin (read memory at EA into MDR)
            T7       = 12;  // Execution: MDRout to destination register R4 (via Gra & Rin)

  DataPath Dut (
    .clock(clock), .clear(clear),
    .ram_read(ram_read), .ram_write(ram_write),
    .PCout(PCout), .MARin(MARin), .IncPC(IncPC), .Zin(Zin), .PCin(PCin),
    .MDRin(MDRin), .IRin(IRin), .MDRout(MDRout),
    .Zlowout(Zlowout), .Grb(Grb), .BAout(BAout), .Yin(Yin), .Cout(Cout), .Yout(Yout),
    .Gra(Gra), .Grc(Grc), .Rin(Rin), .Rout(Rout),
    .Mdatain(Mdatain), .MD_read(MD_read),
    .BusMuxOut(BusMuxOut), .PCreg(PCreg), .instruction(instruction),
    .decoderInput(decoderInput), .RegIn(RegIn), .RegOut(RegOut),
    .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout),
    .IRout(IRout), .MARout(MARout), .Zhighout(Zhighout),
    .change_PC(change_PC), .read(read), .write(write),
    .shift_count_in(shift_count_in), .CSignExtended(CSignExtended),
	 .CONin(CONin), .CON(CON)
  );

  initial begin
    clock = 0;
    forever #10 clock = ~clock;
  end

  initial begin
	  clear = 1;
	  #20 clear = 0;
  end

  always @(posedge clock) begin
    if (clear)
      state <= RegLoad1;
    else
      state <= next_state;
  end

  always @(*) begin
    ram_read         = 0;
    ram_write        = 0;
    MD_read          = 0;
    PCout            = 0;
    MARin            = 0;
    IncPC            = 0;
    Zin              = 0;
    PCin             = 0;
    MDRin            = 0;
    IRin             = 0;
    MDRout           = 0;
    Grb              = 0;
    BAout            = 0;
    Yin              = 0;
    Cout             = 0;
    Gra              = 0;
    Grc              = 0;
    Zlowout          = 0;
    Rin              = 0;
    Rout             = 0;
    Yout             = 0;
	 HIout = 0;
	 HIin = 0;
	 LOout = 0;
	 LOin = 0;
    Mdatain          = 32'h0;
    
    next_state = state;
    
    case (state)
      RegLoad1: begin
         // Format: [31:27]=opcode (10000), [26:23]=R4 (0100), [22:19]=R0 (0000), [18:0]=#54.
			//Mdatain = 32'b00100_001100000000000000000000000; //case mfhi r3
			Mdatain = 32'b00100_001000000000000000000000000; //case mflo r2
         MD_read = 1;
         MDRin   = 1;
         next_state = RegLoad2;
      end
      RegLoad2: begin
         MDRout = 1;
         IRin   = 1;
         next_state = RegLoad3;
      end
      RegLoad3: begin

			Mdatain = 8'b00000101; //case 4
			MD_read = 1;
			MDRin = 1;
			next_state = RegLoad4;
		end
		RegLoad4: begin
			MDRout = 1;
			//HIin = 1;  //case 1
			LOin = 1;    //case 2
			next_state = T0;
		end
      T0: begin
         PCout = 1;
         MARin = 1;
         IncPC = 1;
         PCin  = 1;
         next_state = T1;
      end
      T1: begin
         ram_read = 1;
         MDRin   = 1;
         next_state = T2;
      end
      T2: begin
         next_state = T3;
      end
      
      T3: begin
			//HIout = 1; 
			Gra = 1; Rin = 1;
			LOout = 1;
         next_state = T3;
      end
    endcase
  end

  initial begin
    #300 $stop;
  end

endmodule
