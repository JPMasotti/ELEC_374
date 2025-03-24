`timescale 1ns/10ps

module branch_tb;

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
  parameter RegLoad1 = 0,   
            RegLoad2 = 1,   
            RegLoad3 = 2,   
            RegLoad4 = 3,   
            RegLoad5 = 4,   
            T0       = 5,   
            T1       = 6,   
            T2       = 7,   
            T3       = 8,   
            T4       = 9,   
            T5       = 10,  
            T6       = 11,  
            T7       = 12;  

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
    Mdatain          = 32'h0;
    
    next_state = state;
    
    case (state)
      RegLoad1: begin
         // Format: [31:27]=opcode (10000), [26:23]=R4 (0100), [22:19]=R0 (0000), [18:0]=#54.
         //Mdatain = 32'b00100_000100000000000000000011011; //case 1
			//Mdatain = 32'b00100_000100010000000000000011011; //case 2
			//Mdatain = 32'b00100_000100100000000000000011011; //case 3
			Mdatain = 32'b00100_000100110000000000000011011; //case 4
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
			//Mdatain = 8'b00000000; //case 1
			//Mdatain = 8'b00010100; //case 2
			//Mdatain = 8'b00010100; //case 3
			Mdatain = 32'hFFFFFFEC; //case 4
			MD_read = 1;
			MDRin = 1;
			next_state = RegLoad4;
		end
		RegLoad4: begin
			MDRout = 1;
			Rin = 1; Gra = 1;
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
         next_state = T3;
      end
      
      // Execution phase:
      T3: begin
			Gra = 1; Rout = 1; CONin = 1;
         next_state = T4;
      end
      T4: begin
			PCout = 1;
         Yin = 1;
         next_state = T5;
      end
      T5: begin
			Cout = 1; Zin = 1;
         next_state = T6;
      end
		T6: begin
			Zlowout = 1; PCin = 1; change_PC = 1;
		
			next_state = T6;
		end
    endcase
  end

  initial begin
    #300 $stop;
  end

endmodule