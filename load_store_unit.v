module load_store_unit (
    input wire [31:0] base_reg,   // Rb value
    input wire [31:0] immediate,  // Sign-extended constant C
    input wire [31:0] stored_value, // Value to be stored (from Ra or immediate for STI)
    input wire ld, ldi, st, sti,  // Control signals for memory operations
    output reg [31:0] effective_address, // Computed memory address
    output reg [31:0] value_to_store // Value to be stored in memory
);
    always @(*) begin
        if (ld || ldi || st || sti)
            effective_address = base_reg + immediate; // Compute effective memory address
        else
            effective_address = 32'b0;

        if (st)
            value_to_store = stored_value;  // Store value from register Ra
        else if (sti)
            value_to_store = immediate;  // Store immediate value C
        else
            value_to_store = 32'b0;
    end
endmodule
