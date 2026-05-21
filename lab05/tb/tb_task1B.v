`timescale 1ns/1ps

module tb_task1B;
    reg clk, reset, reg_write_en;
    reg [4:0] rd;
    reg [31:0] wd;
    wire [31:0] x0_val, x1_val;

    // Instantiate DUT
    dut DUT (
        .clk(clk),
        .reset(reset),
        .rd(rd),
        .reg_write_en(reg_write_en),
        .wd(wd),
        .x0_val(x0_val),
        .x1_val(x1_val)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("task1B.vcd");
        $dumpvars(0, tb_task1B);
    end

    initial begin
        // Initialize and Reset
        reset = 1; reg_write_en = 0; rd = 0; wd = 0;
        #10 reset = 0;
        
        // Test Case 1: Write to x1
        #10 rd = 5'd1; wd = 32'hAAAA_BBBB; reg_write_en = 1;
        #10 reg_write_en = 0;
        
        // Test Case 2: Attempt to write to x0
        #10 rd = 5'd0; wd = 32'hFFFF_FFFF; reg_write_en = 1;
        #10 reg_write_en = 0;

        #10;
        if (x0_val == 32'h0 && x1_val == 32'hAAAA_BBBB)
            $display("SUCCESS: x0 is immutable and x1 updated.");
        else
            $display("FAILURE: Register behavior incorrect.");

        $finish;
    end
endmodule