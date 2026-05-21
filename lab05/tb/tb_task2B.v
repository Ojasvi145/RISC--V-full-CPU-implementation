`timescale 1ns/1ps

module tb_task2B;
    reg clk, reset, reg_write_en;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rdata1, rdata2;

    dut DUT (.*); // Connect all ports by name

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("task2B.vcd");
        $dumpvars(0, tb_task2B);

        // Reset
        reset = 1; reg_write_en = 0; #10 reset = 0;

        // Test Case 1: Write to x5 and verify
        rd = 5'd5; wd = 32'hFEEDFACE; reg_write_en = 1;
        #10 reg_write_en = 0; rs1 = 5'd5;
        #10;
        if (rdata1 == 32'hFEEDFACE) $display("PASS: x5 written and read correctly.");

        // Test Case 2: Attempt write to x0
        rd = 5'd0; wd = 32'hFFFFFFFF; reg_write_en = 1;
        #10 reg_write_en = 0; rs2 = 5'd0;
        #10;
        if (rdata2 == 32'h0) $display("PASS: x0 correctly ignored the write.");

        $finish;
    end
endmodule