`timescale 1ns/1ps

module tb_take_home;
    reg clk, reset, reg_write_en;
    reg [31:0] instruction, wd;
    wire [31:0] alu_out;
    wire zero;

    dut DUT (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("take_home.vcd");
        $dumpvars(0, tb_take_home);

        // Reset and Load data into registers x1 and x2
        reset = 1; #10 reset = 0;
        
        // Manual write to x1=10 and x2=20 (Mimicking prior instructions)
        // Note: In a real CPU, these would come from previous ALU cycles
        #10; // (Apply stimulus to internal regs if necessary, or use wd/rd)

        // Test Instruction: ADD x3, x1, x2
        // Funct7=0000000, rs2=00010, rs1=00001, funct3=000, rd=00011, opcode=0110011
        instruction = 32'b0000000_00010_00001_000_00011_0110011;
        reg_write_en = 1;
        
        #20;
        $display("Instruction Executed. ALU Result: %d", alu_out);
        $finish;
    end
endmodule