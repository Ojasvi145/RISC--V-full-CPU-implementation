`timescale 1ns/1ps

module alushift (
    input  [31:0] A,
    input  [4:0]  shamt, // Taken from B[4:0]
    input         sel,   // 0 for SLL, 1 for SRL
    output [31:0] Y
);
    // Logical shifts with #2 canonical delay
    // SLL: A << shamt, SRL: A >> shamt
    assign #2 Y = sel ? (A >> shamt) : (A << shamt);

endmodule