`timescale 1ns/1ps

module tb_task2;
    reg  [31:0] A, B;
    reg         sel;
    wire [31:0] Y;

    // Instantiate wrapper
    dut task2_dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );

    // Waveform dump
    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("task2.vcd");
        $dumpvars(0, tb_task2);
    end

    initial begin
        $display("Starting Task 2: Logic Unit Tests...");
        $monitor("Time=%0t | A=%h B=%h Sel=%b | Y=%h", $time, A, B, sel, Y);

        // Case 1: Bitwise AND
        A = 32'hF0F0_F0F0; B = 32'hAAAA_AAAA; sel = 0; #10;
        
        // Case 2: Bitwise OR
        A = 32'hF0F0_F0F0; B = 32'hAAAA_AAAA; sel = 1; #10;

        // Case 3: Edge Case (All Zeros)
        A = 32'h0; B = 32'hFFFF_FFFF; sel = 0; #10;

        // Case 4: Edge Case (All Ones)
        A = 32'hFFFF_FFFF; B = 32'hFFFF_FFFF; sel = 1; #10;

        $display("Logic Unit Tests Completed.");
        $finish;
    end
endmodule