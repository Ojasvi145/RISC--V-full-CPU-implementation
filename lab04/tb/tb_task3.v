`timescale 1ns/1ps

module tb_task3;
    reg  [31:0] A, B;
    reg         sel;
    wire [31:0] Y;

    dut task3_dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("task3.vcd");
        $dumpvars(0, tb_task3);
    end

    initial begin
        $display("Starting Task 3: Shifter Tests...");
        $monitor("Time=%0t | A=%h B[4:0]=%d Sel=%b | Y=%h", $time, A, B[4:0], sel, Y);

        A = 32'h8000_0001;

        // Case 1: Shift by 0
        B = 32'd0; sel = 0; #10;
        
        // Case 2: Shift by 1 (SLL)
        B = 32'd1; sel = 0; #10;
        
        // Case 3: Shift by 1 (SRL)
        B = 32'd1; sel = 1; #10;

        // Case 4: Shift by -1 (Interpret as 31)
        // In 2's complement, -1 is all 1s. B[4:0] will be 5'b11111 (31)
        B = -32'd1; sel = 0; #10;

        $display("Shifter Tests Completed.");
        $finish;
    end
endmodule