`timescale 1ns / 1ps

module ld_tb;
    reg clock, clear, read;
    reg R0in, R0out, MARin, MDRin, MDRout, PCin, PCout, IRin, Zin, IncPC;
    reg Zlowout, Yin, BAout;
    reg [7:0] ALU_control;
    reg [31:0] Mdatain;
    reg [4:0] shift_count_in;
    
    wire [31:0] PCincremented, PCreg, BusMuxOut;

    // Instantiate DataPath module
    DataPath uut (
        .clock(clock), .clear(clear), .read(read),
        .R0in(R0in), .R0out(R0out),
        .MARin(MARin), .MDRin(MDRin), .MDRout(MDRout),
        .PCin(PCin), .PCout(PCout), .IRin(IRin),
        .Zin(Zin), .IncPC(IncPC), .Zlowout(Zlowout),
        .Yin(Yin), .BAout(BAout), .ALU_control(ALU_control),
        .Mdatain(Mdatain), .shift_count_in(shift_count_in),
        .PCincremented(PCincremented), .PCreg(PCreg),
        .BusMuxOut(BusMuxOut)
    );

    // Clock Generation (50MHz)
    always #10 clock = ~clock;

    initial begin
        // Initialize signals
        clock = 0;
        clear = 1; // Reset the system
        read = 0;
        R0in = 0; R0out = 0; MARin = 0; MDRin = 0; MDRout = 0;
        PCin = 0; PCout = 0; IRin = 0; Zin = 0; IncPC = 0;
        Zlowout = 0; Yin = 0; BAout = 0;
        ALU_control = 8'b00000000;
        Mdatain = 32'h00000000;
        shift_count_in = 5'b00000;

        #20 clear = 0; // Release reset

        // Step 0: PCout, MARin, IncPC, Zin
        #20 PCout = 1; MARin = 1; IncPC = 1; Zin = 1;
        #20 PCout = 0; MARin = 0; IncPC = 0; Zin = 0;

        // Step 1: Zlowout, PCin, Read, Mdatain -> MDRin
        #20 Zlowout = 1; PCin = 1; read = 1; Mdatain = 32'hA5A5A5A5; MDRin = 1;
        #20 Zlowout = 0; PCin = 0; read = 0; MDRin = 0;

        // Step 2: MDRout, IRin
        #20 MDRout = 1; IRin = 1;
        #20 MDRout = 0; IRin = 0;

        // Step 3: Grb, BAout, Yin (Selecting Register B)
        #20 R0out = 1; BAout = 1; Yin = 1;
        #20 R0out = 0; BAout = 0; Yin = 0;

        // Step 4: Cout, ADD, Zin (Perform ADD operation)
        #20 Zin = 1; ALU_control = 8'b00000100; // ADD opcode
        #20 Zin = 0; ALU_control = 8'b00000000;

        // Step 5: Zlowout, MARin (Store Result)
        #20 Zlowout = 1; MARin = 1;
        #20 Zlowout = 0; MARin = 0;

        // Step 6: Read, Mdatain -> MDRin (Fetch from Memory)
        #20 read = 1; Mdatain = 32'hDEADBEEF; MDRin = 1;
        #20 read = 0; MDRin = 0;

        // Step 7: MDRout, Gra, Rin (Store in Register A)
        #20 MDRout = 1; R0in = 1;
        #20 MDRout = 0; R0in = 0;

        // Finish simulation
        #100;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | PC=%h | MAR=%h | MDR=%h | R0=%h | Bus=%h",
            $time, PCreg, uut.MARreg, uut.MDRreg, uut.BusMuxInR0, BusMuxOut);
    end

endmodule
