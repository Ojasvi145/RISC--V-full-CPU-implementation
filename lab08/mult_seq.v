`timescale 1ns/1ps

module mult_seq (
    input wire clk, rst, zero, busy,
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    input wire [2:0] uBr,
    input wire [5:0] target,
    output reg [5:0] uPC
);
    // Micro-branch types from the Handout
    localparam BR_N = 3'd0, BR_J = 3'd1, BR_EZ = 3'd2, BR_NZ = 3'd3, BR_D = 3'd4, BR_S = 3'd5;

    always @(posedge clk or posedge rst) begin
        if (rst) uPC <= 6'd0;
        else begin
            case (uBr)
                BR_N: uPC <= uPC + 6'd1;                // Next state
                BR_J: uPC <= target;                    // Forced Jump
                BR_EZ: uPC <= zero ? target : uPC + 6'd1; // Jump if ALU Zero
                BR_NZ: uPC <= !zero ? target : 6'd0;    // Jump if ALU Not Zero (BNE), else Fetch
                BR_D: begin                             // Dispatch (Task 3 Mapping)
                    case (opcode)
                        7'b0110011: uPC <= (funct7[5]) ? 6'd13 : 6'd10; // SUB : ADD
                        7'b0010011: uPC <= (funct3 == 3'b100) ? 6'd25 : 6'd20; // XORI : ADDI
                        7'b0000011: uPC <= 6'd30;        // LW
                        7'b0100011: uPC <= 6'd35;        // SW
                        7'b1100011: uPC <= 6'd40;        // BNE
                        default: uPC <= 6'd0;            // Default to Fetch
                    endcase
                end
                BR_S: uPC <= busy ? uPC : uPC + 6'd1;   // Spin until Memory is ready
                default: uPC <= 6'd0;
            endcase
        end
    end
endmodule