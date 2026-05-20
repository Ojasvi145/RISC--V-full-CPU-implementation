`timescale 1ns/1ps

module dut (
    input  signed [31:0] A,
    input  signed [31:0] B,
    input                sub_ctrl,
    output signed [31:0] Y,
    output               pos_ovf,
    output               neg_ovf
);
    // Instantiate the shared logic
    aluaddsub task1_inst (
        .A(A),
        .B(B),
        .sub_ctrl(sub_ctrl),
        .Y(Y),
        .pos_ovf(pos_ovf),
        .neg_ovf(neg_ovf)
    );
endmodule