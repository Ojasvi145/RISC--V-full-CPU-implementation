`timescale 1ns/1ps

module alulogic (
    input  [31:0] A,
    input  [31:0] B,
    input         sel, // 0 for AND, 1 for OR
    output [31:0] Y
);
    // Bitwise operations with #1 canonical delay
    assign #1 Y = sel ? (A | B) : (A & B);

endmodule