`timescale 1ns/1ps

module tb_task1;
    reg  signed [31:0] A, B;
    reg                sub_ctrl;
    wire signed [31:0] Y;
    wire               pos_ovf, neg_ovf;

    // Instantiate the wrapper (dut)
    dut task1_dut (
        .A(A),
        .B(B),
        .sub_ctrl(sub_ctrl),
        .Y(Y),
        .pos_ovf(pos_ovf),
        .neg_ovf(neg_ovf)
    );

    // VCD Dump Configuration
    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("task1.vcd");
        $dumpvars(0, tb_task1);
    end

    initial begin
        $display("Starting Task 1 Tests...");
        $monitor("Time=%0t | A=%d B=%d Sub=%b | Y=%d | OV(P/N)=%b/%b", $time, A, B, sub_ctrl, Y, pos_ovf, neg_ovf);

        // Case 1: Positive + Positive (Normal)
        A = 100; B = 200; sub_ctrl = 0; #10;

        // Case 2: Positive + Positive (Positive Overflow)
        // 2147483647 is Max Signed 32-bit Integer
        A = 32'h7FFFFFFF; B = 1; sub_ctrl = 0; #10;

        // Case 3: Positive + Negative (Normal)
        A = 50; B = -30; sub_ctrl = 0; #10;

        // Case 4: Subtraction resulting in negative values
        A = 10; B = 50; sub_ctrl = 1; #10;

        // Case 5: Negative + Negative (Negative Overflow)
        A = 32'h80000000; B = -1; sub_ctrl = 0; #10;

        $display("Tests Completed.");
        $finish;
    end
endmodule