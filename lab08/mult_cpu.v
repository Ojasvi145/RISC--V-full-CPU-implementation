`timescale 1ns/1ps

module mult_cpu (
    input wire clk,
    input wire rst
);
    // Control and Status Wires
    wire IRLd, RegWr, RegEn, ALd, BLd, ALUEn, MALd, MemWr, MemEn, ImmEn;
    wire [2:0] RegSel, ALUOp, ImmSel, uBr;
    wire [5:0] uPC, next_target;
    wire [6:0] opcode, funct7;
    wire [2:0] funct3;
    wire zero, busy;

    // 1. Datapath (Referencing your mult_datapath.v)
    datapath dp_inst (
        .clk(clk), .rst(rst),
        .IRLd(IRLd), .RegSel(RegSel), .RegWr(RegWr), .RegEn(RegEn),
        .ALd(ALd), .BLd(BLd), .ALUOp(ALUOp), .ALUEn(ALUEn),
        .MALd(MALd), .MemWr(MemWr), .MemEn(MemEn),
        .ImmSel(ImmSel), .ImmEn(ImmEn),
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .zero(zero), .busy(busy)
    );

    // 2. Control ROM (Your Task 1/3 module)
    mult_ctrl ctrl_inst (
        .uPC(uPC),
        .IRLd(IRLd), .RegWr(RegWr), .RegEn(RegEn), .ALd(ALd), .BLd(BLd),
        .ALUEn(ALUEn), .MALd(MALd), .MemWr(MemWr), .MemEn(MemEn), .ImmEn(ImmEn),
        .RegSel(RegSel), .ALUOp(ALUOp), .ImmSel(ImmSel),
        .uBr(uBr), .NextState(next_target)
    );

    // 3. Microsequencer (Your Task 2 module)
    mult_seq seq_inst (
        .clk(clk), .rst(rst), .zero(zero), .busy(busy),
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .uBr(uBr), .target(next_target),
        .uPC(uPC)
    );

endmodule