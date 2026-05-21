`timescale 1ns/1ps

module tb_task6;
    reg  [31:0] A, B;
    wire [31:0] Y;

    dut task6_dut (
        .A(A),
        .B(B),
        .Y(Y)
    );

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("task6.vcd");
        $dumpvars(0, tb_task6);
    end

    initial begin
        $display("Starting Task 6: Unsigned Comparator (SLTU) Tests...");
        $monitor("Time=%0t | A=%h (%u) | B=%h (%u) | SLTU Result=%b", $time, A, A, B, B, Y[0]);

        // Case 1: Simple comparison (10 < 20) -> Result: 1
        A = 32'd10; B = 32'd20; #10;

        // Case 2: Simple comparison (20 < 10) -> Result: 0
        A = 32'd20; B = 32'd10; #10;

        // Case 3: The "Signed Trap" 
        // In SLT (signed), 0x1 < 0xFFFFFFFF is false (1 < -1)
        // In SLTU (unsigned), 0x1 < 0xFFFFFFFF is true (1 < 4.29 Billion)
        A = 32'h0000_0001; B = 32'hFFFF_FFFF; #10;

        // Case 4: Equal values -> Result: 0
        A = 32'hAAAA_AAAA; B = 32'hAAAA_AAAA; #10;

        $display("SLTU Tests Completed.");
        $finish;
    end
endmodule