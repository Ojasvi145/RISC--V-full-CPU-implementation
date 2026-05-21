`timescale 1ns/1ps

module tb_mult_cpu();
    reg clk;
    reg rst;

    // Instantiate the Top-Level CPU
    mult_cpu cpu_inst (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;

        // Load the program into the datapath memory
        // Path: Top -> CPU -> Datapath -> Memory Module -> Memory Array
        $readmemh("program3.hex", cpu_inst.dp_inst.MEM.mem);

        // Hold reset for a few cycles
        #20;
        rst = 0;

        // Run simulation for enough time to execute instructions
        // Since it's multi-cycle, instructions take 4-10 cycles each
        #2000; 

        $display("Simulation Finished. Check waveforms for Register File updates.");
        $finish;
    end

    // Optional: Generate a VCD file for GTKWave
    initial begin
        $dumpfile("cpu_sim3.vcd");
        $dumpvars(0, tb_mult_cpu);
    end
endmodule