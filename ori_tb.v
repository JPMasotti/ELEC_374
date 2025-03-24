`timescale 1ns/10ps

module ori_tb;

  // Control signal declarations
  reg clock = 0, clear = 0;
  reg ram_read = 0, ram_write = 0, MD_read = 0;
  reg PCout = 0, MARin = 0, IncPC = 0, Zin = 0, PCin = 0;
  reg MDRin = 0, IRin = 0, MDRout = 0;
  reg Grb = 0, BAout = 0, Yin = 0, Yout = 0, Cout = 0, Gra = 0, Grc = 0, Zlowout = 0;
  reg Rin = 0, Rout = 0;
  reg [31:0] Mdatain = 0;

  // Wires from the datapath
  wire [31:0] PCreg, BusMuxOut, instruction;
  wire [3:0] decoderInput;
  wire [15:0] RegIn, RegOut;
  wire [31:0] CSignExtended;
  wire [4:0] shift_count_in;
  wire change_PC, HIin, HIout, LOin, LOout;
  wire IRout, MARout, Zhighout, read, write;

  // FSM state declarations using two registers: state and next_state.
  reg [4:0] state, next_state;
  // Use your original state names:
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

  // Instantiate your DataPath (signal names must match your design)
  DataPath uut (
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
    .shift_count_in(shift_count_in), .CSignExtended(CSignExtended)
  );

  // Clock generation: 20 ns period (10 ns high, 10 ns low)
  initial begin
    clock = 0;
    forever #10 clock = ~clock;
  end

  // Reset: Assert clear initially.
  initial begin
	  clear = 1;
	  #20 clear = 0;
  end

  // Sequential state update process using nonblocking assignment.
  always @(posedge clock) begin
    if (clear)
      state <= RegLoad1;
    else
      state <= next_state;
  end

  // Combinational process: drive control signals and compute next_state based on current state.
  always @(*) begin
    // Default all control signals to 0.
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
    Mdatain          = 32'h0;
    
    // Default next_state = current state.
    next_state = state;
    
    case (state)
      // Preload phase: load the instruction word for "ld R4, #54"
      RegLoad1: begin
         // The binary literal is your instruction word.
         // Format: [31:27]=opcode (10000), [26:23]=R4 (0100), [22:19]=R0 (0000), [18:0]=#54.
         Mdatain = 32'b00011_010101100000000000010010101;
         MD_read = 1;
         MDRin   = 1;
         next_state = RegLoad2;
      end
      RegLoad2: begin
         // Transfer the fetched instruction from MDR to IR.
         MDRout = 1;
         IRin   = 1;
         next_state = RegLoad3;
      end
      RegLoad3: begin
			Mdatain = 8'b00001101;
			MD_read = 1;
			MDRin = 1;
			next_state = RegLoad4;
		end
		RegLoad4: begin
			MDRout = 1;
			Rin = 1; Grb = 1;
			next_state = T0;
		end
      // Instruction fetch cycle:
      T0: begin
         PCout = 1;
         MARin = 1;
         IncPC = 1;
         PCin  = 1;
         Zin   = 1;
         next_state = T1;
      end
      T1: begin
         Zlowout = 1;
         ram_read = 1;
         MDRin   = 1;
         next_state = T2;
      end
      T2: begin
         // Place the sign-extended immediate (constant #54) on the bus.
         //MDRout = 1; IRin = 1;
         next_state = T3;
      end
      
      // Execution phase:
      T3: begin
			Grb = 1; Rout = 1; Yin = 1;
         // For load immediate, we want the immediate value to be used.
         // **Modification:** Do not load Y with the immediate.
         // Y remains 0 so that the ALU computes 0 + immediate = immediate.
         next_state = T4;
      end
      T4: begin
         // Capture the computed effective value using Zin.
         // Since Y is 0, effective value = 0 + immediate = immediate (#54).
			Cout = 1;
         Zin = 1;
         // Optionally, you can assert Yout to drive 0 onto the bus if needed.
         next_state = T5;
      end
      T5: begin
         // Drive the effective address onto the bus and load it into MAR.
         Zlowout = 1;          Gra = 1;
         Rin = 1;
			
         next_state = T5;
      end

    endcase
  end

  // End simulation after sufficient time.
  initial begin
    #300 $stop;
  end

endmodule