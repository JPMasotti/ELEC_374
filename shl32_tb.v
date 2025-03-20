`timescale 1ns/10ps
module shl32_tb;
    reg PCout_tb, MARin_tb, IncPC_tb, Zin_tb, Zlowout_tb;
    reg PCin_tb, MDRin_tb, MDRout_tb, IRin_tb, Yin_tb;
    reg R3out_tb, R4in_tb;
    reg read_tb, R3in_tb;
    reg [31:0] Mdatain_tb;
    reg [7:0] ALU_control_tb;
    reg [4:0] shift_count_in_tb;
    reg Clock, clear_tb;
	 
    parameter Default = 4'b0000,
              Reg_load1a = 4'b0001, Reg_load1b = 4'b0010,
              T0 = 4'b0011, T1 = 4'b0100,
              T2 = 4'b0101, T3 = 4'b0110,
              T4 = 4'b0111, T5 = 4'b1000;

    reg [3:0] Present_state = Default;
	 
	 
    DataPath DUT (
        .clock(Clock), .clear(clear_tb), .read(read_tb), .ALU_control(ALU_control_tb),
        .PCout(PCout_tb), .Zlowout(Zlowout_tb), .MDRout(MDRout_tb), .R3out(R3out_tb), .R4out(), .MARin(MARin_tb),
        .Zin(Zin_tb), .PCin(PCin_tb), .MDRin(MDRin_tb), .IRin(IRin_tb), .Yin(Yin_tb),
        .R3in(R3in_tb), .R4in(R4in_tb), .R7in(), .Mdatain(Mdatain_tb), .BusMuxOut(),
        .IncPC(IncPC_tb), .PCincremented(), .PCreg(),
        .HIin(), .HIout(), .LOin(), .LOout(), .Zhighout(), .IRout(), .MARout(),
        .shift_count_in(shift_count_in_tb)
    );
	 
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end
    initial begin
        Present_state = Default;
    end
	 
    always @(posedge Clock) begin
        case (Present_state)
            Default: Present_state <= Reg_load1a;
            Reg_load1a: Present_state <= Reg_load1b;
            Reg_load1b: Present_state <= T0;
            T0: Present_state <= T1;
            T1: Present_state <= T2;
            T2: Present_state <= T3;
            T3: Present_state <= T4;
            T4: Present_state <= T5;
           
        endcase
    end
	 
	 
    always @(Present_state) begin
        PCout_tb = 0; MARin_tb = 0; IncPC_tb = 0; Zin_tb = 0;
        Zlowout_tb = 0; PCin_tb = 0; MDRin_tb = 0; IRin_tb = 0;
        Yin_tb = 0; R3out_tb = 0; R4in_tb = 0; read_tb = 0;
        Mdatain_tb = 32'h00000000; ALU_control_tb = 8'b00001100;
        shift_count_in_tb = 4; clear_tb = 0;
        case (Present_state)
		  
            Default: begin
                PCout_tb = 0; MARin_tb = 0; IncPC_tb = 0; Zin_tb = 0;
                Zlowout_tb = 0; PCin_tb = 0; read_tb = 0; MDRin_tb = 0;
                Mdatain_tb = 32'h00000000; ALU_control_tb = 8'b00001100;
                shift_count_in_tb = 4;
            end
				            Reg_load1a: begin
                Mdatain_tb <= 32'h0F0000F0; 
                read_tb <= 1; MDRin_tb <= 1;
            end
            Reg_load1b: begin
                MDRin_tb <= 0; read_tb <= 0;
                MDRout_tb <= 1; R3in_tb <= 1;
            end

            T0: begin
					 R3in_tb <= 0;
                PCout_tb = 1; MARin_tb = 1; IncPC_tb = 1; Zin_tb = 1;
            end
				
            T1: begin
                PCout_tb = 0; MARin_tb = 0; IncPC_tb = 0; Zin_tb = 0;
                Zlowout_tb = 1; PCin_tb = 1; read_tb = 1; MDRin_tb = 1;
                
            end
				
            T2: begin
                Zlowout_tb = 0; PCin_tb = 0; read_tb = 0; MDRin_tb = 0;
                MDRout_tb = 1; IRin_tb = 1;
            end
				
            T3: begin
                MDRout_tb = 0; IRin_tb = 0;
                R3out_tb = 1; Yin_tb = 1;
            end
				
            T4: begin
                R3out_tb = 1; Yin_tb = 0;
                shift_count_in_tb = 4;
					 
                Zin_tb = 1;
            end
				
            T5: begin
					 
					 shift_count_in_tb = 0;
                Zin_tb = 0;
                Zlowout_tb = 1; R4in_tb = 1;
            end
				
        endcase
    end
endmodule


