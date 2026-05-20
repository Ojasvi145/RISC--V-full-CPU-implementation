`timescale 1ns/1ps

module dut (
    input  [31:0] A,
    input  [31:0] B,     // Full 32-bit B input
    input         sel,   // 0 for SLL, 1 for SRL
    output [31:0] Y
);
    // Instantiate shared shifter using B[4:0] as the shift amount
    alushift task3_inst (
        .A(A),
        .shamt(B[4:0]),
        .sel(sel),
        .Y(Y)
    );
endmodule