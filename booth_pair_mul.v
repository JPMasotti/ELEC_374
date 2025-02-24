module booth_pair_mul(
    input [31:0] multiplicand, 
    input [31:0] multiplier, 
    output reg [63:0] product
);
    reg [63:0] A, Q, M;
    reg prev;
    integer i;
    
    always @(*) begin
        A = 64'b0;
        Q = {32'b0, multiplier};
        M = multiplicand[31] ? {32'hFFFFFFFF, multiplicand} : {32'b0, multiplicand};
        prev = 1'b0;
        for (i = 0; i < 32; i = i + 2) begin
            case ({Q[i+1], Q[i], prev})
                3'b001, 3'b010: A = A + M;    // +M
                3'b011: A = A + (M << 1); // +2M
                3'b100: A = A - (M << 1); // -2M
                3'b101,3'b110: A = A - M;    // -M
                default: ;
            endcase
            prev = Q[i+1];
            M = M << 2;
        end
        product = A;
    end
endmodule
