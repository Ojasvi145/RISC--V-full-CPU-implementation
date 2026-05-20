/*`timescale 1ns/1ps

module alu (
    input [31:0] a,        // Operand 1
    input [31:0] b,        // Operand 2
    input [2:0] op,        // ALU Operation Select
    output reg [31:0] res  // ALU Result
);
    // Behavioral logic for ALU operations
    always @(*) begin
        case (op)
            3'b000: res = a + b;   // ADD / ADDI / Address Calc (LW, SW)
            3'b001: res = a - b;   // SUB
            3'b010: res = a & b;   // AND / ANDI
            3'b011: res = a | b;   // OR
            default: res = 32'b0;  // Default case to prevent latches
        endcase
    end
endmodule*/
`timescale 1ns/1ps

module alu (
    input [31:0] a,
    input [31:0] b,
    input [2:0] op,
    output reg [31:0] res,
    output Zero               // NEW: Useful for Branching (beq/bne)
);

    // Zero flag is high if the result is 0
    assign Zero = (res == 32'b0);

    always @(*) begin
        case (op)
            3'b000: res = a + b;   // ADD / ADDI / LW / SW
            3'b001: res = a - b;   // SUB / BEQ / BNE
            3'b010: res = a & b;   // AND / ANDI
            3'b011: res = a | b;   // OR
            3'b100: res = a ^ b;   // XOR / XORI (Added for Lab 7)
            default: res = 32'b0;
        endcase
    end
endmodule