`timescale 1ns/1ps

module tb_task4;
    reg  signed [31:0] A, B;
    wire [31:0] Y;

    dut task4_dut (.A(A), .B(B), .Y(Y));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("task4.vcd");
        $dumpvars(0, tb_task4);
    end

    initial begin
        $display("Starting Task 4: Signed Comparator Tests...");
        $monitor("Time=%0t | A=%d B=%d | SLT_Result=%d", $time, A, B, Y[0]);

        // Case 1: Simple True (-10 < 5)
        A = -10; B = 5; #10;
        
        // Case 2: Simple False (10 < 5)
        A = 10; B = 5; #10;
        
        // Case 3: Edge Case Overflow (Large Positive < Large Negative)
        // A is Max Positive, B is Max Negative. Result should be 0 (False)
        A = 32'h7FFFFFFF; B = 32'h80000000; #10;

        // Case 4: Edge Case Overflow (Large Negative < Large Positive)
        // Result should be 1 (True)
        A = 32'h80000000; B = 32'h7FFFFFFF; #10;

        $finish;
    end
endmodule