`timescale 1ns/1ps
// Simple wrapper if required, or direct instantiation of the module
module dut (
    input [1:0] immSel,
    input [31:0] instruction,
    output [31:0] immOut
);

    immGen generator (
        .immSel(immSel),
        .instruction(instruction),
        .immOut(immOut)
    );

endmodule
