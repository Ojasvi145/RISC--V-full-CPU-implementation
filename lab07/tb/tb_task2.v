`timescale 1ns/1ps

module tb_task2();

    reg clk;
    reg reset;

    cpu_SC uut (.clk(clk), .reset(reset));

    // CLOCK
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("===== TASK 2 SIMULATION START =====");

        // LOAD PROGRAM (Make sure program.hex is in correct folder)
       

        $readmemh("labs/lab07/program.hex", uut.imem.mem);
        
        uut.dmem.mem[15 >> 2] = 32'd100;


// DEBUG PRINT
        $display("First instruction = %h", uut.imem.mem[0]);
        // RESET
        reset = 1;
        #15;
        reset = 0;

        // RUN SIMULATION
        #150;

        // ================= OUTPUT =================
        $display("\n===== REGISTER VALUES =====");
        $display("| Register | Value |");
        $display("|----------|-------|");

        $display("| x1 | %d |", uut.rf.regs[1]);
        $display("| x2 | %d |", uut.rf.regs[2]);
        $display("| x3 | %d |", uut.rf.regs[3]);
        $display("| x4 | %d |", uut.rf.regs[4]);
        $display("| x5 | %d |", uut.rf.regs[5]);
        $display("| x6 | %d |", uut.rf.regs[6]);
        $display("| x7 | %d |", uut.rf.regs[7]);

        $display("============================");

        $finish;
    end

endmodule