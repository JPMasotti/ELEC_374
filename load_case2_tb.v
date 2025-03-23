`timescale 1ns/10ps

module load_case2_tb;
  // --- Control signal declarations ---
  reg clock = 0, clear = 0;
  reg ram_read = 0, ram_write = 0, MD_read = 0;
  reg PCout = 0, MARin = 0, IncPC = 0, Zin = 0, PCin = 0;
  reg MDRin = 0, IRin = 0, MDRout = 0;
  reg Grb = 0, BAout = 0, Yin = 0, Yout = 0, Cout = 0, Gra = 0, Grc = 0, Zlowout = 0;
  reg Rin = 0, Rout = 0;
  reg [31:0] Mdatain = 0;

  // --- Wires from the datapath ---
  wire [31:0] PCreg, BusMuxOut, instruction;
  wire [3:0] decoderInput;
  wire [15:0] RegIn, RegOut;
  wire [31:0] CSignExtended;
  wire [4:0] shift_count_in;
  wire change_PC, HIin, HIout, LOin, LOout;
  wire IRout, MARout, Zhighout, read, write;

  // --- FSM state declarations using two registers: state and next_state ---
  reg [4:0] state, next_state;
  // We'll use two preloading states to load R2, then states for fetch and execution.
  parameter PreR2a = 0,    // Preload: load 0x78 into MDR for R2
            PreR2b = 1,    // Transfer MDR -> R2
            T0      = 2,    // Instruction fetch: PCout, MARin, IncPC, PCin, Zin
            T1      = 3,    // Instruction fetch: Zlowout, ram_read, MDRin
            T2      = 4,    // Instruction fetch: transfer MDR -> IR and drive instruction word
            T3      = 5,    // Execution: transfer R2 to Y (base for effective addr)
            T4      = 6,    // Execution: drive offset (0x63) via Cout; ALU computes effective addr = Y+offset
            T5      = 7,    // Execution: drive effective address (Zlowout) onto bus and load MAR
            T6      = 8,    // Execution: read memory at effective address into MDR (memory already holds desired data)
            T7      = 9;    // Execution: transfer MDR -> destination register R6

  // The instruction word for "ld R6, 0x63(R2)" is 0x83100063:
  //  [31:27] = 10000 (load opcode),
  //  [26:23] = 0110 (R6),
  //  [22:19] = 0010 (R2),
  //  [18:0]  = 0x63.
  localparam [31:0] LD_R6_R2_63 = 32'h83100063;

  // --- Instantiate your DataPath (signal names must match your design) ---
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

  // --- Clock generation: 20 ns period (10 ns high, 10 ns low) ---
  initial begin
    clock = 0;
    forever #10 clock = ~clock;
  end

  // --- Reset: Assert clear initially ---
  initial begin
    clear = 1;
    #20 clear = 0;
  end

  // --- Sequential state update (nonblocking) ---
  always @(posedge clock) begin
    if (clear)
      state <= PreR2a;
    else
      state <= next_state;
  end

  // --- Combinational process: drive control signals and compute next_state ---
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
      //--------------------------------------------------
      // Preload phase: Load R2 with 0x78.
      //--------------------------------------------------
      PreR2a: begin
        // Drive Mdatain with 0x78; assert MD_read and MDRin.
        Mdatain = 32'h00000078;
        MD_read = 1;
        MDRin   = 1;
        next_state = PreR2b;
      end
      PreR2b: begin
        // Transfer MDR to R2.
        MDRout = 1;
        // Assume that R2 is selected via Grb and Rin.
        Grb = 1;
        Rin = 1;
        next_state = T0;
      end

      //--------------------------------------------------
      // Instruction Fetch:
      //--------------------------------------------------
      T0: begin
        // PCout, MARin, IncPC, PCin, Zin.
        PCout = 1; MARin = 1; IncPC = 1; PCin = 1; Zin = 1;
        next_state = T1;
      end
      T1: begin
        // Zlowout, ram_read, MDRin to fetch the instruction.
        Zlowout = 1;
        ram_read = 1;
        MDRin = 1;
        next_state = T2;
      end
      T2: begin
        // Transfer fetched instruction from MDR to IR.
        MDRout = 1;
        IRin = 1;
        // Also drive the instruction word for "ld R6, 0x63(R2)".
        Mdatain = LD_R6_R2_63;
        MD_read = 1;
        next_state = T3;
      end

      //--------------------------------------------------
      // Execution for "ld R6, 0x63(R2)":
      //--------------------------------------------------
      // T3: Transfer base (R2) to Y.
      T3: begin
        // Select R2 via Grb; assert Rout to drive its value; load Y.
        Grb = 1;
        Rout = 1;
        Yin = 1;
        next_state = T4;
      end
      // T4: Drive the offset (0x63) onto the bus.
      T4: begin
        // Assert Cout so that the sign-extended immediate (0x63) appears on the bus.
        Cout = 1;
        // ALU will compute effective address = Y + immediate = 0x78 + 0x63 = 0xDB.
        Zin = 1; // latch computed effective address into Z.
        next_state = T5;
      end
      // T5: Transfer effective address (Zlowout) to MAR.
      T5: begin
        Zlowout = 1;
        MARin = 1;
        next_state = T6;
      end
      // T6: Read memory at the effective address into MDR.
      T6: begin
        ram_read = 1;
        MD_read = 1;
        MDRin = 1;
        // Do NOT override Mdatain here—memory returns its preloaded value.
        next_state = T7;
      end
      // T7: Transfer the data from MDR to destination register R6.
      T7: begin
        MDRout = 1;
        // Select R6 using the Gra path (assuming IR[26:23] = 0110 for R6).
        Gra = 1;
        Rin = 1;
        $display("✅ Load complete | BusMuxOut: %h", BusMuxOut);
        next_state = T7; // Remain in this state.
      end

      default: next_state = PreR2a;
    endcase
  end

  // --- End simulation after sufficient time ---
  initial begin
    #300 $stop;
  end

endmodule
