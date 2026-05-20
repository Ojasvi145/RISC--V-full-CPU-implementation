`timescale 1ns/1ps

module alultu (
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] Y
);
    wire [32:0] sub_res;

    // Reuse subtraction logic: A + (~B) + 1
    // We use a 33-bit wire to capture the carry-out bit [32]
    // Timing: Adder delay (#3)
    assign #3 sub_res = {1'b0, A} + {1'b0, ~B} + 33'h1;

    // For SLTU: If Carry-Out is 0, then A < B (Unsigned)
    // Timing: Add 1 unit for the bit inversion/final result selection
    assign #1 Y = {31'b0, ~sub_res[32]};

endmodule