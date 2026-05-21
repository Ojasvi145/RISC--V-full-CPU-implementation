`timescale 1ns/1ps

module tb_reg_full;
    reg clk, reset, reg_write_en;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rdata1, rdata2;

    // Instantiate your complete reg_file through the DUT wrapper
    dut DUT (
        .clk(clk), .reset(reset), .rs1(rs1), .rs2(rs2), 
        .rd(rd), .reg_write_en(reg_write_en), .wd(wd), 
        .rdata1(rdata1), .rdata2(rdata2)
    );

    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        // 1. Initialize and Reset
        reset = 1; reg_write_en = 0; rd = 0; wd = 0;
        rs1 = 0; rs2 = 0;
        #10 reset = 0;

        // 2. Test Writing to x5
        @(negedge clk);
        rd = 5'd5; wd = 32'hDEADBEEF; reg_write_en = 1;
        @(negedge clk);
        reg_write_en = 0;
        
        // 3. Test Reading from x5
        rs1 = 5'd5;
        #2; // Wait for total read latency (1ns clk-to-q + 1ns mux)
        if (rdata1 == 32'hDEADBEEF) 
            $display("Success: x5 written and read correctly at %t", $time);

        // 4. Test x0 Immutability (The x0 Rule)
        @(negedge clk);
        rd = 5'd0; wd = 32'hFFFFFFFF; reg_write_en = 1;
        @(negedge clk);
        reg_write_en = 0;
        rs2 = 5'd0;
        #2;
        if (rdata2 == 32'h0)
            $display("Success: x0 remains zero after write attempt at %t", $time);
        else
            $display("Error: x0 was overwritten!");

        $finish;
    end
endmodule