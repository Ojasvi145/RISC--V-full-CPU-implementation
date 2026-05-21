`timescale 1ns/1ps

module dut (
    input clk,
    input reset,
    input [4:0] rd,
    input reg_write_en,
    input [31:0] wd,
    output [31:0] x0_val, // Verification output
    output [31:0] x1_val  // Verification output
);

    // Internal wires to satisfy the reg_file port list
    wire [31:0] rdata1, rdata2;

    // Instantiate the register file
    reg_file rf_inst (
        .clk(clk),
        .reset(reset),
        .rs1(5'd0),      // Hardcode to 0 to read x0
        .rs2(5'd1),      // Hardcode to 1 to read x1
        .rd(rd),
        .reg_write_en(reg_write_en),
        .wd(wd),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Map the read ports to your verification outputs
    assign x0_val = rdata1;
    assign x1_val = rdata2;

endmodule