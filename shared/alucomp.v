`timescale 1ns/1ps

module alucomp (
    input  signed [31:0] A,
    input  signed [31:0] B,
    output [31:0] Y
);
    wire signed [31:0] sub_res;
    wire p_ovf, n_ovf;

    // Instantiate Subtractor (sub_ctrl = 1)
    aluaddsub sub_for_comp (
        .A(A),
        .B(B),
        .sub_ctrl(1'b1), 
        .Y(sub_res),
        .pos_ovf(p_ovf),
        .neg_ovf(n_ovf)
    );

    // SLT Logic: Result bit 31 XORed with Overflow flag
    // Includes #1 additional delay for the comparison logic
    assign #1 Y = {31'b0, (sub_res[31] ^ (p_ovf | n_ovf))};

endmodule