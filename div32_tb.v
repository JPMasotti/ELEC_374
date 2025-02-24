`timescale 1ns/10ps

module div32_tb;
    
    reg clock_tb;
    reg clear_tb;
    reg read_tb;
    reg Zlowout_tb, Zhighout_tb, MDRout_tb;
    reg R2out_tb, R6out_tb;
    reg PCout_tb;
    reg MARin_tb, Zin_tb, PCin_tb, MDRin_tb, IRin_tb, Yin_tb;
    reg R2in_tb, R6in_tb;
    reg HIin_tb, LOin_tb;
    reg [31:0] Mdatain_tb, IncPC_tb;
    reg [7:0] ALU_control_tb;
    wire [31:0] BusMuxOut_tb, PCreg_tb, PCincremented_tb;

    parameter Default = 4'b0000, 
              Reg_load1a = 4'b0001, 
              Reg_load1b = 4'b0010, 
              Reg_load2a = 4'b0011, 
              Reg_load2b = 4'b0100, 
              T0 = 4'b0101, 
              T1 = 4'b0110, 
              T2 = 4'b0111, 
              T3 = 4'b1000, 
              T4 = 4'b1001, 
              T5 = 4'b1010, 
              T6 = 4'b1011; 
              
    reg [3:0] Present_state = Default;
    
    DataPath DUT (
        .clock(clock_tb), .clear(clear_tb), .read(read_tb), .ALU_control(ALU_control_tb),
        .PCout(PCout_tb), .Zlowout(Zlowout_tb), .MDRout(MDRout_tb), .R2out(R2out_tb), .R6out(R6out_tb),
        .MARin(MARin_tb), .Zin(Zin_tb), .PCin(PCin_tb), .MDRin(MDRin_tb), .IRin(IRin_tb), .Yin(Yin_tb), 
        .R2in(R2in_tb), .R6in(R6in_tb), .Mdatain(Mdatain_tb), .BusMuxOut(BusMuxOut_tb), .IncPC(IncPC_tb), 
        .PCincremented(PCincremented_tb), .PCreg(PCreg_tb), .HIin(HIin_tb), .HIout(), .LOin(LOin_tb), .LOout(), 
        .Zhighout(Zhighout_tb), .IRout(), .MARout(),
        // Disconnected
        .R0out(), .R1out(), .R3out(), .R4out(), .R5out(), .R7out(), 
        .R8out(), .R9out(), .R10out(), .R11out(), .R12out(), .R13out(), 
        .R14out(), .R15out(), .R0in(), .R1in(), .R3in(), .R4in(), .R5in(), .R7in(), 
        .R8in(), .R9in(), .R10in(), .R11in(), .R12in(), .R13in(), 
        .R14in(), .R15in(), .shift_count_in()
    );
    
 
    initial begin
        clock_tb = 0;
        forever #10 clock_tb = ~clock_tb;  
    end
     

    always @(posedge clock_tb) begin
        case (Present_state)
            Default: Present_state <= Reg_load1a;
            Reg_load1a: Present_state <= Reg_load1b;
            Reg_load1b: Present_state <= Reg_load2a;
            Reg_load2a: Present_state <= Reg_load2b;
            Reg_load2b: Present_state <= T0;
            T0: Present_state <= T1;
            T1: Present_state <= T2;
            T2: Present_state <= T3;
            T3: Present_state <= T4;
            T4: Present_state <= T5;
            T5: Present_state <= T6;
            T6: Present_state <= Default;
            default: Present_state <= Default;
        endcase
    end
    
    
    always @(Present_state) begin
        
        PCout_tb = 0; Zlowout_tb = 0; 
        MDRout_tb = 0; R2out_tb = 0; R6out_tb = 0;
        MARin_tb = 0; Zin_tb = 0; PCin_tb = 0; 
        MDRin_tb = 0; IRin_tb = 0; Yin_tb = 0; R2in_tb = 0; 
        R6in_tb = 0; read_tb = 0; clear_tb = 0; Mdatain_tb  = 32'h00000000; 
        ALU_control_tb = 8'b00000111; HIin_tb = 0; LOin_tb = 0; IncPC_tb = 0;
        
        case (Present_state)
            
            Reg_load1a: begin  
                Mdatain_tb <= 32'b011111; 
                read_tb <= 1;  
                MDRin_tb <= 1;
            end
            Reg_load1b: begin
                MDRin_tb <= 0; 
                read_tb <= 0;
                MDRout_tb <= 1; 
                R2in_tb <= 1;
            end
            
            Reg_load2a: begin  
                MDRout_tb <= 0; 
                R2in_tb <= 0;
                Mdatain_tb <= 32'b01000; 
                read_tb <= 1; 
                MDRin_tb <= 1;
            end
            Reg_load2b: begin
                MDRin_tb <= 0; 
                read_tb <= 0;
                MDRout_tb <= 1; 
                R6in_tb <= 1;
            end
            
            T0: begin
                MDRout_tb <= 0; 
                R6in_tb <= 0;
                PCout_tb <= 1; 
                MARin_tb <= 1; 
                IncPC_tb <= 1; 
                Zin_tb <= 1;
            end
            
            T1: begin
                PCout_tb <= 0; 
                MARin_tb <= 0; 
                IncPC_tb <= 0;
                Zlowout_tb <= 1; 
                PCin_tb <= 1; 
                read_tb <= 1; 
                MDRin_tb <= 1;
                Mdatain_tb <= 32'd9898;  
            end
            
            T2: begin
                PCout_tb <= 0; 
                MARin_tb <= 0; 
                IncPC_tb <= 0; 
                Zin_tb <= 0;
                MDRout_tb <= 1; 
                IRin_tb <= 1;
            end
            
            T3: begin
                MDRout_tb <= 0; 
                IRin_tb <= 0;
                R2out_tb <= 1; 
                Yin_tb <= 1;
            end
            
            T4: begin
                R2out_tb <= 0; 
                Yin_tb <= 0;
                R6out_tb <= 1; 
                ALU_control_tb <= 8'b00000111;  //div
                Zin_tb <= 1;
            end
            
            T5: begin
                R6out_tb <= 0; 
                Zin_tb <= 0;
                Zlowout_tb <= 1; 
                LOin_tb <= 1;
            end
            
            T6: begin
                
					 Zlowout_tb <= 0; 
                LOin_tb <= 0;
					 Zhighout_tb <= 1;
                HIin_tb <= 1;
            end
            default: ;
        endcase
    end

endmodule
