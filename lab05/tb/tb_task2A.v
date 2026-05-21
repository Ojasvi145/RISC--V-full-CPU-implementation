`timescale 1ns/1ps

module tb_task2A;
    reg [4:0] rd;
    reg reg_write_en;
    wire [31:0] dec_out;

    // Instantiate the DUT
    dut DUT (
        .rd(rd),
        .reg_write_en(reg_write_en),
        .dec_out(dec_out)
    );

    // Waveform dump
    initial begin
        $dumpfile("task2A.vcd");
        $dumpvars(0, tb_task2A);
    end

    initial begin
        // Test Case 1: Write Enable is OFF
        rd = 5'd5; reg_write_en = 0;
        #5;
        if (dec_out == 32'b0) 
            $display("T1 Pass: dec_out is 0 when write_en is low.");

        // Test Case 2: Write Enable is ON, select Register 5
        #5;
        reg_write_en = 1; rd = 5'd5;
        #0.5; // Check middle of delay
        if (dec_out == 32'b0) 
            $display("T2 Logic: dec_out still 0 before 1ns delay.");
        #1;
        if (dec_out == (32'b1 << 5)) 
            $display("T2 Pass: dec_out[5] is high after 1ns delay.");

        // Test Case 3: Select Register 31
        #10;
        rd = 5'd31;
        #1;
        if (dec_out == (32'b1 << 31))
            $display("T3 Pass: dec_out[31] is high.");

        $finish;
    end
endmodule