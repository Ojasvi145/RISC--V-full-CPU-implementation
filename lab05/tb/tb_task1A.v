`timescale 1ns/1ps

module tb_task1A;
    reg clk, reset, we;
    reg [31:0] d;
    wire [31:0] q;

    // Instantiate the DUT
    dut DUT (
        .clk(clk),
        .reset(reset),
        .we(we),
        .d(d),
        .q(q)
    );

    // Waveform dump configuration
    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("task1A.vcd");
        $dumpvars(0, tb_task1A);
    end

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    initial begin
        // Initialize
        reset = 1; we = 0; d = 32'h0;
        #10;
        
        // Release Reset
        reset = 0;
        #10;

        // Test Case 1: Write data 0xDEADBEEF
        d = 32'hDEADBEEF; we = 1;
        #10; // Observe q updates 1ns after posedge clk
        
        // Test Case 2: Disable Write Enable and change d
        we = 0; d = 32'hCAFEBABE;
        #10; // q should remain 0xDEADBEEF
        
        // Test Case 3: Synchronous Reset
        reset = 1;
        #10; // q should become 0 after 1ns delay

        $display("Task 1A Simulation Complete");
        $finish;
    end
endmodule