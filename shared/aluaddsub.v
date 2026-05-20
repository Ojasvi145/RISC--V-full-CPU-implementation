`timescale 1ns/1ps

module aluaddsub (
    input  signed [31:0] A,
    input  signed [31:0] B,
    input                sub_ctrl, // 0 for ADD, 1 for SUB
    output signed [31:0] Y,
    output               pos_ovf,
    output               neg_ovf
);
    wire [31:0] b_not;
    wire [31:0] sum;
    
    // If sub_ctrl is 1, b_not becomes ~B. If 0, it stays B.
    assign b_not = B ^ {32{sub_ctrl}};

    // Canonical delay #3 for 32-bit Adder/Subtractor
    // sub_ctrl is used as the Carry-In to complete 2's complement: A + (~B) + 1
    assign #3 Y = A + b_not + sub_ctrl;

    // Overflow Logic:
    // Positive Overflow: Pos + Pos = Neg
    assign pos_ovf = (A[31] == 0 && b_not[31] == 0 && Y[31] == 1);
    
    // Negative Overflow: Neg + Neg = Pos
    assign neg_ovf = (A[31] == 1 && b_not[31] == 1 && Y[31] == 0);

endmodule