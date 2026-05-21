`timescale 1ns/1ps

module tb_task5;
    reg  signed [31:0] A, B;
    reg  [2:0]         alu_ctrl;
    wire signed [31:0] Y;
    wire               zero;

    dut task5_dut (.A(A), .B(B), .alu_ctrl(alu_ctrl), .Y(Y), .zero(zero));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("task5.vcd");
        $dumpvars(0, tb_task5);
    end

    initial begin
        $display("Starting Task 5: Full ALU Integration Tests...");
        
        // ADD: 15 + 10 = 25
        A = 15; B = 10; alu_ctrl = 3'b001; #10;
        
        // SUB to Zero: 50 - 50 = 0 (Check zero flag)
        A = 50; B = 50; alu_ctrl = 3'b000; #10;
        
        // SLT: -10 < 5 = 1
        A = -10; B = 5; alu_ctrl = 3'b110; #10;
        
        // SLL: 1 << 4 = 16 (0x10)
        A = 1; B = 4; alu_ctrl = 3'b100; #10;

        $finish;
    end
endmodule