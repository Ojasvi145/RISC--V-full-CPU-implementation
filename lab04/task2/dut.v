`timescale 1ns/1ps

module dut (
    input  [31:0] A,
    input  [31:0] B,
    input         sel,
    output [31:0] Y
);
    // Instantiate shared logic unit
    alulogic task2_inst (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
endmodule