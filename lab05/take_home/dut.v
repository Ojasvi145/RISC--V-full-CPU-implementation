`timescale 1ns/1ps

module dut (
    input clk,
    input reset,
    input [31:0] instruction,
    input [31:0] wd,
    input reg_write_en,
    output [31:0] alu_out,
    output zero
);

    fragment_r_type core_engine (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .wd(wd),
        .reg_write_en(reg_write_en),
        .alu_out(alu_out),
        .zero(zero)
    );

endmodule