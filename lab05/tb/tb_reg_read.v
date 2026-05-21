`timescale 1ns/1ps

module tb_task1C;
    reg clk, reset, reg_write_en;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rdata1, rdata2;

    dut DUT (
        .clk(clk), .reset(reset), .rs1(rs1), .rs2(rs2), 
        .rd(rd), .reg_write_en(reg_write_en), .wd(wd), 
        .rdata1(rdata1), .rdata2(rdata2)
    );

    // Clock Generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("task1C.vcd");
        $dumpvars(0, tb_task1C);

        // Initialize and reset
        reset = 1; reg_write_en = 0; #10;
        reset = 0; 

        // Write 0xABCDE001 to register x1
        rd = 5'd1; wd = 32'hABCDE001; reg_write_en = 1;
        #10; // Value latches at next posedge
        
        reg_write_en = 0;
        rs1 = 5'd1; // Read from x1
        rs2 = 5'd0; // Read from x0
        
        #10;
        $display("rdata1: %h, rdata2: %h", rdata1, rdata2);
        $finish;
    end
endmodule