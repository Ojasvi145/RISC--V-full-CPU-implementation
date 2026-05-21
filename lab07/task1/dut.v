`timescale 1ns/1ps

module dut (
    input clk,
    input reset,
    input [31:0] instruction,
    output [31:0] current_pc
);

    wire [31:0] imm;
    wire [2:0] immSel;
    wire RegWrite, ALUSrc, MemWrite, MemRead, Branch, Jump;
    wire [2:0] ALUOp;
    wire PCSrc;

    // Fake Zero for testing branch
    wire Zero = (instruction[6:0] == 7'b1100011);

    ControlUnit cu (
        .instruction(instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp),
        .ImmSel(immSel)
    );

    immGen ig (
        .immSel(immSel),
        .instruction(instruction),
        .immOut(imm)
    );

    assign PCSrc = Jump | (Branch & (instruction[14:12] == 3'b000 ? Zero : !Zero));

    PCinc pc_unit (
        .clk(clk),
        .reset(reset),
        .imm(imm),
        .PCSrc(PCSrc),
        .PC(current_pc)
    );

endmodule