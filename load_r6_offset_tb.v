`timescale 1ns/10ps

module load_r6_offset_tb;

  // Control signal declarations
  reg clock, clear;
  reg ram_read, ram_write, MD_read;
  reg PCout, MARin, IncPC, Zin, PCin;
  reg MDRin, IRin, MDRout;
  reg Grb, BAout, Yin, Cout, Gra, Grc, Zlowout;
  reg EffectiveAddrOut, ValueToStoreOut;
  reg Rin, Rout;
  reg [31:0] Mdatain;

  // Other signals (wires) from the datapath
  wire [31:0] PCreg, BusMuxOut, instruction;
  wire [3:0] decoderInput;
  wire [15:0] RegIn, RegOut;
  wire [31:0] CSignExtended;
  wire [4:0] shift_count_in;
  wire change_PC, HIin, HIout, LOin, LOout;
  wire IRout, MARout, Zhighout, read, write;
  wire [31:0] value_to_store, effective_address;

  // FSM state definitions
  reg [4:0] state, next_state;
  parameter RegLoad1 = 0,   // Preload R2 value from memory (0x78)
            RegLoad2 = 1,   // Transfer MDR -> R2 (via Grb & Rin)
            T0       = 5,   // Instruction fetch T0
            T1       = 6,   // Instruction fetch T1
            T2       = 7,   // Instruction fetch T2
            T3       = 8,   // Execution: Transfer R2 to Y
            T4       = 9,   // Execution: Place immediate (offset) on bus (Cout)
            T5       = 10,  // Execution: Drive effective address onto bus and load MAR
            T6       = 11,  // Execution: Read memory at EA into MDR
            T7       = 12;  // Execution: Transfer MDR -> R6 (via Gra & Rin)

  // Instantiate your DataPath (adjust port names as needed)
  DataPath uut (
    .clock(clock), .clear(clear),
    .ram_read(ram_read), .ram_write(ram_write),
    .PCout(PCout), .MARin(MARin), .IncPC(IncPC), .Zin(Zin), .PCin(PCin),
    .MDRin(MDRin), .IRin(IRin), .MDRout(MDRout),
    .Zlowout(Zlowout), .Grb(Grb), .BAout(BAout), .Yin(Yin), .Cout(Cout),
    .Gra(Gra), .Grc(Grc), .Rin(Rin), .Rout(Rout),
    .EffectiveAddrOut(EffectiveAddrOut), .ValueToStoreOut(ValueToStoreOut),
    .Mdatain(Mdatain), .MD_read(MD_read),
    .BusMuxOut(BusMuxOut), .PCreg(PCreg), .instruction(instruction),
    .decoderInput(decoderInput), .RegIn(RegIn), .RegOut(RegOut),
    .value_to_store(value_to_store), .effective_address(effective_address),
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

  // State update process (sequential)
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
    EffectiveAddrOut = 0;
    ValueToStoreOut  = 0;
    Rin              = 0;
    Rout             = 0;
    Mdatain          = 32'h0;
    
    // Default next_state is the current state.
    next_state = state;
    
    case (state)
      // Preload R2 with 0x78.
      RegLoad1: begin
         Mdatain = 32'h00000078;
         MD_read = 1;
         MDRin   = 1;
         next_state = RegLoad2;
      end
      // Transfer value from MDR to R2 (assumed to be selected via Grb & Rin).
      RegLoad2: begin
         MDRout = 1;
         Grb    = 1;
         Rin    = 1;
         next_state = T0;
      end
      
      // Instruction Fetch Cycle:
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
         // Provide the instruction word for "ld R6, 0x63(R2)".
         // Format: [31:27]=10000, [26:23]=R6 (0110), [22:19]=R2 (0010), [18:0]=0x63.
         // This yields 32'h86100063.
         Mdatain = 32'h86100063;
         next_state = T2;
      end
      T2: begin
         MDRout = 1;
         IRin   = 1;
         next_state = T3;
      end
      
      // Execution Cycle:
      T3: begin
         // Transfer R2's value (base address) onto Y.
         Grb   = 1;
         Rout  = 1;
         Yin   = 1;
         next_state = T4;
      end
      T4: begin
         // Place the sign-extended immediate (offset) on the bus.
         Cout = 1;
         next_state = T5;
      end
      T5: begin
         // Drive effective address (EA = Y + CSignExtended) onto the bus and load MAR.
         EffectiveAddrOut = 1;
         MARin = 1;
         next_state = T6;
      end
      T6: begin
         // Read memory at EA into MDR.
         ram_read = 1;
         MDRin   = 1;
         next_state = T7;
      end
      T7: begin
         // Transfer MDR to R6.
         MDRout = 1;
         // Assuming R6 is selected via the Gra path (with IR[26:23]=R6).
         Gra = 1;
         Rin = 1;
         $display("✅ Load complete | BusMuxOut: %h", BusMuxOut);
         next_state = T7; // Stay here.
      end
      default: begin
         next_state = RegLoad1;
      end
    endcase
  end

  // Generate reset pulse.
  initial begin
    clear = 1;
    #20 clear = 0;
  end

  // End simulation after sufficient time.
  initial begin
    #300 $stop;
  end

endmodule
