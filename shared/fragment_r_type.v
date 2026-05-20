`timescale 1ns/1ps

module fragment_r_type (
    input clk,
    input reset,
    input [31:0] instruction, // 32-bit R-type instruction
    input [31:0] wd,          // Write Data (for write-back)
    input reg_write_en,       // Global Write Enable
    output [31:0] alu_out,    // Result from ALU
    output zero               // Zero flag from ALU
);

    // Internal Wires for structural interconnection
    wire [31:0] rdata1, rdata2;
    wire [2:0] alu_ctrl_wire;

    // 1. Register File (Task 2B)
    // Provides the operands A and B for the ALU
    reg_file rf_inst (
        .clk(clk),
        .reset(reset),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .reg_write_en(reg_write_en),
        .wd(wd),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // 2. ALU Control Unit (Task 3)
    // Decodes the specific ALU operation
    alu_ctrl ctrl_inst (
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .alu_ctrl_out(alu_ctrl_wire)
    );

    // 3. 32-bit ALU (Lab 4)
    // Performs the actual computation
    rv32ialu alu_inst (
        .A(rdata1),
        .B(rdata2),
        .alu_ctrl(alu_ctrl_wire),
        .Y(alu_out),
        .zero(zero)
    );

endmodule