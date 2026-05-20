`timescale 1ns/1ps

module ControlUnit (
    input [31:0] instruction,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,   // ⭐ ADD THIS
    output reg Branch,
    output reg Jump,         // NEW: High for jal
    output reg [2:0] ALUOp,
    output reg [2:0] ImmSel   // NEW: Expanded to 3 bits for B and J types
);

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    always @(*) begin
        // Default values to prevent latches
        RegWrite = 0; ALUSrc = 0; MemWrite = 0; 
        MemRead = 0; MemToReg = 0; Branch = 0; Jump = 0;

        case (opcode)
            // R-type (add, sub, and, or, xor)
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc   = 0;
                case (funct3)
                    3'b000: ALUOp = (funct7 == 7'b0100000) ? 3'b001 : 3'b000; // sub : add
                    3'b100: ALUOp = 3'b100; // xor (needed for Program 1)
                    3'b110: ALUOp = 3'b011; // or
                    3'b111: ALUOp = 3'b010; // and
                    default: ALUOp = 3'b000;
                endcase
            end

            // I-type ALU (addi, andi, xori)
            7'b0010011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ImmSel   = 3'b000; // I-type
                case (funct3)
                    3'b000: ALUOp = 3'b000; // addi
                    3'b100: ALUOp = 3'b100; // xori (needed for Program 1)
                    3'b111: ALUOp = 3'b010; // andi
                    default: ALUOp = 3'b000;
                endcase
            end

            // Load (lw)
            7'b0000011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemRead  = 1;
                MemToReg = 1;   // ⭐ ADD THIS
                ImmSel   = 3'b000;
                ALUOp    = 3'b000;
            end

            // Store (sw)
            7'b0100011: begin
                RegWrite = 0; ALUSrc = 1; MemWrite = 1;
                ImmSel = 3'b001; ALUOp = 3'b000;
            end

            // --- LAB 7 ADDITIONS ---

            // Branch (beq, bne)
            7'b1100011: begin
                RegWrite = 0;
                ALUSrc   = 0; 
                Branch   = 1;
                ImmSel   = 3'b010; // B-type
                ALUOp    = 3'b001; // Use subtraction to compare rs1 and rs2
            end

            // JAL (Jump and Link)
            7'b1101111: begin
                RegWrite = 1;      // JAL writes PC+4 to 'rd'
                Jump     = 1;
                ImmSel   = 3'b011; // J-type
                ALUOp    = 3'b000; 
            end

            default: begin
                RegWrite = 0; ALUSrc = 0; MemWrite = 0; MemRead = 0;
                Branch = 0; Jump = 0;
            end
        endcase
    end
endmodule
/*module ControlUnit (
    input [31:0] instruction,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg [2:0] ALUOp,
    output reg [1:0] ImmSel
);

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    always @(*) begin
        // Default values to prevent latches
        RegWrite = 0; ALUSrc = 0; MemWrite = 0; 
        MemRead = 0; ALUOp = 3'b000; ImmSel = 2'b00;

        case (opcode)
            // R-type (add, sub, and, or)
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc   = 0;
                case (funct3)
                    3'b000: ALUOp = (funct7 == 7'b0100000) ? 3'b001 : 3'b000; // sub : add
                    3'b111: ALUOp = 3'b010; // and
                    3'b110: ALUOp = 3'b011; // or
                    default: ALUOp = 3'b000;
                endcase
            end

            // I-type ALU (addi, andi)
            7'b0010011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ImmSel   = 2'b00; // I-type
                case (funct3)
                    3'b000: ALUOp = 3'b000; // addi
                    3'b111: ALUOp = 3'b010; // andi
                    default: ALUOp = 3'b000;
                endcase
            end

            // Load (lw)
            7'b0000011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemRead  = 1;
                ImmSel   = 2'b00; // I-type immediate for offset
                ALUOp    = 3'b000; // Address calculation (add)
            end

            // Store (sw)
            7'b0100011: begin
                RegWrite = 0;
                ALUSrc   = 1;
                MemWrite = 1;
                ImmSel   = 2'b01; // S-type immediate
                ALUOp    = 3'b000; // Address calculation (add)
            end

            default: begin
                RegWrite = 0; ALUSrc = 0; MemWrite = 0; MemRead = 0;
            end
        endcase
    end
endmodule*/