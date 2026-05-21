`timescale 1ns/1ps

module mult_ctrl (
    input  wire [5:0]  uPC,
    // Datapath Control Signals
    output reg         IRLd, RegWr, RegEn, ALd, BLd, ALUEn, MALd, MemWr, MemEn, ImmEn,
    output reg  [2:0]  RegSel, ALUOp, ImmSel,
    // Sequencer Control Signals
    output reg  [2:0]  uBr,       // 0:N, 1:J, 2:EZ, 3:NZ, 4:D, 5:S
    output reg  [5:0]  NextState
);

    // Micro-branch definitions for clarity
    localparam BR_N = 3'd0, BR_J = 3'd1, BR_EZ = 3'd2, BR_NZ = 3'd3, BR_D = 3'd4, BR_S = 3'd5;

    always @(*) begin
        // --- Default State (Active Low/De-asserted) ---
        {IRLd, RegWr, RegEn, ALd, BLd, ALUEn, MALd, MemWr, MemEn, ImmEn} = 10'b0;
        {RegSel, ALUOp, ImmSel} = 9'b0;
        {uBr, NextState} = {BR_N, 6'd0};

        case (uPC)
            // --- FETCH (Common for all instructions) ---
            6'd0: begin RegSel = 3'b000; RegEn = 1; MALd = 1; ALd = 1; end      // MA <- PC, A <- PC
            6'd1: begin MemEn = 1; IRLd = 1; uBr = BR_S; end                    // IR <- Mem (Spin if busy)
            6'd2: begin ALUOp = 3'b101; ALUEn = 1; RegSel = 3'b000; RegWr = 1; uBr = BR_D; end // PC <- A + 4, Dispatch

            // --- ADD (R-type) ---
            6'd10: begin RegSel = 3'b011; RegEn = 1; ALd = 1; end               // A <- rs1
            6'd11: begin RegSel = 3'b100; RegEn = 1; BLd = 1; end               // B <- rs2
            6'd12: begin ALUOp = 3'b000; ALUEn = 1; RegSel = 3'b010; RegWr = 1; uBr = BR_J; NextState = 6'd0; end

            // --- SUB (R-type) ---
            6'd13: begin RegSel = 3'b011; RegEn = 1; ALd = 1; end               // A <- rs1
            6'd14: begin RegSel = 3'b100; RegEn = 1; BLd = 1; end               // B <- rs2
            6'd15: begin ALUOp = 3'b001; ALUEn = 1; RegSel = 3'b010; RegWr = 1; uBr = BR_J; NextState = 6'd0; end

            // --- ADDI (I-type) ---
            6'd20: begin RegSel = 3'b011; RegEn = 1; ALd = 1; end               // A <- rs1
            6'd21: begin ImmSel = 3'b000; ImmEn = 1; BLd = 1; end               // B <- ImmI
            6'd22: begin ALUOp = 3'b000; ALUEn = 1; RegSel = 3'b010; RegWr = 1; uBr = BR_J; NextState = 6'd0; end

            // --- XORI (I-type) ---
            6'd25: begin RegSel = 3'b011; RegEn = 1; ALd = 1; end               // A <- rs1
            6'd26: begin ImmSel = 3'b000; ImmEn = 1; BLd = 1; end               // B <- ImmI
            6'd27: begin ALUOp = 3'b100; ALUEn = 1; RegSel = 3'b010; RegWr = 1; uBr = BR_J; NextState = 6'd0; end

            // --- LW (Load Word) ---
            6'd30: begin RegSel = 3'b011; RegEn = 1; ALd = 1; end               // A <- rs1
            6'd31: begin ImmSel = 3'b000; ImmEn = 1; BLd = 1; end               // B <- ImmI
            6'd32: begin ALUOp = 3'b000; ALUEn = 1; MALd = 1; end               // MA <- A + B (rs1 + ImmI)
            6'd33: begin MemEn = 1; RegSel = 3'b010; RegWr = 1; uBr = BR_S; NextState = 6'd0; end // rd <- Mem

            // --- SW (Store Word) ---
            6'd35: begin RegSel = 3'b011; RegEn = 1; ALd = 1; end               // A <- rs1
            6'd36: begin ImmSel = 3'b001; ImmEn = 1; BLd = 1; end               // B <- ImmS
            6'd37: begin ALUOp = 3'b000; ALUEn = 1; MALd = 1; end               // MA <- A + B (rs1 + ImmS)
            6'd38: begin RegSel = 3'b100; RegEn = 1; MemWr = 1; uBr = BR_S; NextState = 6'd0; end // Mem <- rs2

            // --- BNE (Branch Not Equal) ---
            6'd40: begin RegSel = 3'b011; RegEn = 1; ALd = 1; end               // A <- rs1
            6'd41: begin RegSel = 3'b100; RegEn = 1; BLd = 1; end               // B <- rs2
            6'd42: begin ALUOp = 3'b001; ALUEn = 1; BLd = 1; end               // B <- A - B (rs1 - rs2)
            6'd43: begin uBr = BR_NZ; NextState = 6'd44; end                    // If B != 0, Jump to 44 (Take Branch)
            // If branch is taken (Targeting 44):
            6'd44: begin RegSel = 3'b000; RegEn = 1; ALd = 1; end               // A <- PC
            6'd45: begin ImmSel = 3'b010; ImmEn = 1; BLd = 1; end               // B <- ImmB
            6'd46: begin ALUOp = 3'b000; ALUEn = 1; ALd = 1; end               // A <- A + B (PC + Offset)
            6'd47: begin ALUOp = 3'b001; ALUEn = 1; RegSel = 3'b000; RegWr = 1; uBr = BR_J; NextState = 6'd0; end // PC <- A - 4

            default: begin uBr = BR_J; NextState = 6'd0; end
        endcase
    end
endmodule