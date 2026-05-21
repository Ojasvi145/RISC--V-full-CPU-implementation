`timescale 1ns/1ps

module dut (
    input clk,
    input reset,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input reg_write_en,
    input [31:0] wd,
    output [31:0] rdata1,
    output [31:0] rdata2
);

    // Final structural integration of the Register File
    reg_file rf_inst (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .reg_write_en(reg_write_en),
        .wd(wd),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

endmodule