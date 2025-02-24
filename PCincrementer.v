`timescale 1ns/10ps
module PCincrementer (
    input wire [31:0] PCreg,
    input wire IncPC,
    output wire [31:0] PCincremented
);
    wire [31:0] increment_value = 32'b1;
    wire [31:0] incremented_PC;
    
    adder add1 (
        .A(PCreg),
        .B(increment_value),
        .Result(incremented_PC)
    );
    
    assign PCincremented = IncPC ? incremented_PC : PCreg;
endmodule
