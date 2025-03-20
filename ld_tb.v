`timescale 1ns/10ps

module ld_tb;
    reg clock, clear, read;
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, HIout, LOin, LOout, MDRout, MARout, PCout, PCin, IRin, IRout, Zin, RZout, Zhighout, Zlowout, Yin, MARin, MDRin, IncPC, BAout;
    reg [7:0] ALU_control;
    reg [31:0] Mdatain;
    reg [4:0] shift_count_in;
    wire [31:0] PCincremented, PCreg, BusMuxOut;

    DataPath DUT (
        .clock(clock),
        .clear(clear),
        .read(read),
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out),
        .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
        .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in), .R4in(R4in), .R5in(R5in), .R6in(R6in), .R7in(R7in),
        .R8in(R8in), .R9in(R9in), .R10in(R10in), .R11in(R11in), .R12in(R12in), .R13in(R13in), .R14in(R14in), .R15in(R15in),
        .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout), .MDRout(MDRout), .MARout(MARout), .PCout(PCout),
        .PCin(PCin), .IRin(IRin), .IRout(IRout), .Zin(Zin), .RZout(RZout), .Zhighout(Zhighout), .Zlowout(Zlowout), .Yin(Yin), .MARin(MARin), .MDRin(MDRin), .IncPC(IncPC), .BAout(BAout),
        .ALU_control(ALU_control),
        .Mdatain(Mdatain),
        .shift_count_in(shift_count_in),
        .PCincremented(PCincremented),
        .PCreg(PCreg),
        .BusMuxOut(BusMuxOut)
    );

    parameter Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000;
    reg [3:0] Present_state = Default;

    initial begin
        clock = 0;
        clear = 0;
        read = 0;
        // Initialize all control signals to 0
        {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out} = 16'b0;
        {R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in} = 16'b0;
        {HIin, HIout, LOin, LOout, MDRout, MARout, PCout, PCin, IRin, IRout, Zin, RZout, Zhighout, Zlowout, Yin, MARin, MDRin, IncPC, BAout} = 0;
        ALU_control = 8'b0;
        Mdatain = 32'b0;
        shift_count_in = 5'b0;

        // Initialize R2 with a base address (e.g., 8)
        R2in <= 1; Mdatain <= 32'd8; #20; // Load 8 into R2
        R2in <= 0; Mdatain <= 32'b0;

        // Initialize memory location 8 with a value (e.g., 15)
        MARin <= 1; Mdatain <= 32'd8; #20; // Set MAR to 8
        MARin <= 0; Mdatain <= 32'd15; MDRin <= 1; #20; // Load 15 into MDR
        MDRin <= 0; read <= 1; #20; // Write 15 to memory location 8
        read <= 0;
    end

    always #10 clock <= ~clock;

    always @(posedge clock) begin
        case (Present_state)
            Default: #40 Present_state = T0;
            T0: #40 Present_state = T1;
            T1: #40 Present_state = T2;
            T2: #40 Present_state = T3;
            T3: #40 Present_state = T4;
            T4: #40 Present_state = T5;
            T5: #40 Present_state = T6;
            T6: #40 Present_state = T7;
            T7: #40 Present_state = Default;
        endcase
    end

    always @(Present_state) begin
        #10
        case (Present_state)
            Default: begin
                // Initialize all control signals to 0
                {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out} = 16'b0;
                {R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in} = 16'b0;
                {HIin, HIout, LOin, LOout, MDRout, MARout, PCout, PCin, IRin, IRout, Zin, RZout, Zhighout, Zlowout, Yin, MARin, MDRin, IncPC, BAout} = 0;
                ALU_control = 8'b0;
                Mdatain = 32'b0;
                shift_count_in = 5'b0;
            end

            T0: begin
                // Fetch instruction: PC -> MAR
                PCout <= 1; MARin <= 1;
                $display("T0: PC -> MAR");
            end

            T1: begin
                // Read instruction from memory into MDR
                PCout <= 0; MARin <= 0;
                read <= 1; MDRin <= 1;
                $display("T1: Read instruction from memory into MDR");
            end

            T2: begin
                // MDR -> IR, increment PC
                read <= 0; MDRin <= 0;
                MDRout <= 1; IRin <= 1; IncPC <= 1;
                $display("T2: MDR -> IR, increment PC");
            end

            T3: begin
                // Decode instruction: R2 -> Y
                MDRout <= 0; IRin <= 0; IncPC <= 0;
                R2out <= 1; Yin <= 1;
                $display("T3: R2 -> Y");
            end

            T4: begin
                // Calculate effective address: Y + 0 -> Z
                R2out <= 0; Yin <= 0;
                ALU_control <= 8'b00000010; // Set ALU to ADD
                Zin <= 1;
                $display("T4: Y + 0 -> Z");
            end

            T5: begin
                // Z -> MAR
                Zin <= 0;
                Zlowout <= 1; MARin <= 1;
                $display("T5: Z -> MAR");
            end

            T6: begin
                // Read data from memory into MDR
                Zlowout <= 0; MARin <= 0;
                read <= 1; MDRin <= 1;
                $display("T6: Read data from memory into MDR");
            end

            T7: begin
                // MDR -> R1
                read <= 0; MDRin <= 0;
                MDRout <= 1; R1in <= 1;
                $display("T7: MDR -> R1");
                $display("R1 = %d (Expected: 15)", BusMuxOut); // Check final value of R1
					 $finish;
            end
        endcase
    end
endmodule