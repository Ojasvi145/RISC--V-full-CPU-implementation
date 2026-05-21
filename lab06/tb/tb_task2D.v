`timescale 1ns/1ps

module tb_task2D;
    reg [31:0] instruction;
    wire RegWrite, ALUSrc, MemWrite, MemRead;
    wire [2:0] ALUOp;
    wire [1:0] ImmSel;

    dut uut (
        .instruction(instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUOp(ALUOp),
        .ImmSel(ImmSel)
    );

    initial begin
        $display("Instruction\t Opcode\t RW\t ASrc\t MW\t MR\t ALUOp\t ISel");
        
        // Test addi x1, x0, 10
        instruction = 32'h00a00093; #10;
        $display("%h\t %b\t %b\t %b\t %b\t %b\t %b\t %b", instruction, instruction[6:0], RegWrite, ALUSrc, MemWrite, MemRead, ALUOp, ImmSel);

        // Test sw x3, 0(x0)
        instruction = 32'h00302023; #10;
        $display("%h\t %b\t %b\t %b\t %b\t %b\t %b\t %b", instruction, instruction[6:0], RegWrite, ALUSrc, MemWrite, MemRead, ALUOp, ImmSel);

        // Test sub x5, x4, x1
        instruction = 32'h401202b3; #10;
        $display("%h\t %b\t %b\t %b\t %b\t %b\t %b\t %b", instruction, instruction[6:0], RegWrite, ALUSrc, MemWrite, MemRead, ALUOp, ImmSel);

        $finish;
    end
endmodule