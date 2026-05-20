`timescale 1ns/1ps

module dut (
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] Y
);
    // Instantiate the unsigned comparator
    alultu task6_inst (
        .A(A),
        .B(B),
        .Y(Y)
    );
endmodule