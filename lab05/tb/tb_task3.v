`timescale 1ns/1ps

module tb_task3;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [2:0] alu_ctrl_out;

    dut DUT (
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl_out(alu_ctrl_out)
    );

    initial begin
        $dumpfile("task3.vcd");
        $dumpvars(0, tb_task3);

        // Test ADD: funct3=000, funct7=0000000
        funct3 = 3'b000; funct7 = 7'b0000000;
        #5; $display("ADD Control: %b (Expected 001)", alu_ctrl_out);

        // Test SUB: funct3=000, funct7=0100000
        funct3 = 3'b000; funct7 = 7'b0100000;
        #5; $display("SUB Control: %b (Expected 000)", alu_ctrl_out);

        // Test AND: funct3=111
        funct3 = 3'b111;
        #5; $display("AND Control: %b (Expected 010)", alu_ctrl_out);

        // Test SLT: funct3=010
        funct3 = 3'b010;
        #5; $display("SLT Control: %b (Expected 110)", alu_ctrl_out);

        $finish;
    end
endmodule