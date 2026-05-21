`timescale 1ns/1ps

module dut (
    input [31:0] instruction,
    output RegWrite,
    output ALUSrc,
    output MemWrite,
    output MemRead,
    output [2:0] ALUOp,
    output [1:0] ImmSel
);

    ControlUnit controller (
        .instruction(instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUOp(ALUOp),
        .ImmSel(ImmSel)
    );

endmodule