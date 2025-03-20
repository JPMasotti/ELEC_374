`timescale 1ns/10ps

module load_tb;
    reg clock, clear, ram_read, ram_write, MD_read;
    reg PCout, MARin, IncPC, Zin, PCin, MDRin, IRin, MDRout;
    reg Grb, BAout, Yin, Cout, Gra, R1in, R1out, R4in, Zlowout;
	 wire [31:0] PCincremented, PCreg, Mdatain;
    wire [31:0] BusMuxOut;
	 reg [7:0] ALU_control;

    reg [3:0] state;
    parameter RESET = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, 
              T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, 
              T7 = 4'b1000;
    // Instantiate DataPath
    DataPath uut (
        .clock(clock),
        .clear(clear),
        .ram_read(ram_read),
        .ram_write(ram_write),
        .PCout(PCout),
        .MARin(MARin),
        .IncPC(IncPC),
        .Zin(Zin),
        .PCin(PCin),
        .MDRin(MDRin),
        .IRin(IRin),
        .MDRout(MDRout),
        .Zlowout(Zlowout),
        .Grb(Grb),
        .BAout(BAout),
        .Yin(Yin),
        .Cout(Cout),
        .Gra(Gra),
        .R1in(R1in),
		  .ALU_control(ALU_control),
        .R1out(R1out),
        .R4in(R4in),
        .BusMuxOut(BusMuxOut),
		  .PCincremented(PCincremented),
		  .PCreg(PCreg),
		  .Mdatain(Mdatain),
		  .MD_read(MD_read)
    );

    // Clock Generation
    always #5 clock = ~clock;

    initial begin
        // Initialize Signals
        clock = 0; clear = 0; ram_read = 0; ram_write = 0;
        PCout = 0; MARin = 0; IncPC = 0; Zin = 0; PCin = 0; MDRin = 0; IRin = 0;
        MDRout = 0; Grb = 0; BAout = 0; Yin = 0; Cout = 0; Gra = 0; 
        R1in = 0; R1out = 0; R4in = 0; state = RESET; ALU_control = 8'b00001111; 

    end
	 
    always @(posedge clock) begin
        case (state)
            // Instruction Fetch
            RESET: begin
                state <= T0;
            end
            T0: begin
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1; 
                state <= T1;
            end
            T1: begin
                PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                Zlowout <= 1; PCin <= 1; ram_read <= 1; MDRin <= 1;
                state <= T2;
            end
            T2: begin
                Zlowout <= 0; PCin <= 0; ram_read <= 0; MDRin <= 0;
                MDRout <= 1; IRin <= 1;
                state <= T3;
            end
            
            // Load Instruction Execution
            T3: begin
                MDRout <= 0; IRin <= 0;
                Grb <= 1; BAout <= 1; Yin <= 1;
                state <= T4;
            end
            T4: begin
                Grb <= 0; BAout <= 0; Yin <= 0;
                Cout <= 1; Zin <= 1;
                state <= T5;
            end
            T5: begin
                Cout <= 0; Zin <= 0;
                Zlowout <= 1; MARin <= 1;
                state <= T6;
            end
            T6: begin
                Zlowout <= 0; MARin <= 0;
                ram_read <= 1; MDRin <= 1;
                state <= T7;
            end
            T7: begin
                ram_read <= 0; MDRin <= 0;
                MDRout <= 1; Gra <= 1; R4in <= 1;
            end
        endcase
    end
endmodule
