`timescale 1ns/1ps

module tb_task4();

    reg clk;
    reg reset;

    // Instantiate PIPELINE CPU
    cpu_pip uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("===== TASK 4: PIPELINE CPU =====");

        // Load program (same as Task 2)
        $readmemh("labs/lab07/program.hex", uut.imem.mem);

        // Optional: initialize memory (for lw test)
        uut.dmem.mem[15 >> 2] = 32'd100;

        // Reset
        reset = 1; #10;
        reset = 0;

        // Run longer (pipeline needs more cycles)
        #200;

        // Display results
        $display("\n===== REGISTER VALUES (PIPELINE) =====");
        $display("| Register | Value |");
        $display("|----------|-------|");

        $display("| x1 | %0d |", uut.rf.regs[1]);
        $display("| x2 | %0d |", uut.rf.regs[2]);
        $display("| x3 | %0d |", uut.rf.regs[3]);
        $display("| x4 | %0d |", uut.rf.regs[4]);
        $display("| x5 | %0d |", uut.rf.regs[5]);
        $display("| x6 | %0d |", uut.rf.regs[6]);
        $display("| x7 | %0d |", uut.rf.regs[7]);

        $display("=====================================");

        $finish;
    end

endmodule