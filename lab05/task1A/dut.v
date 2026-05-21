`timescale 1ns/1ps

module dut (
    input clk,
    input reset,
    input we,
    input [31:0] d,
    output [31:0] q
);

    // Instantiate the 32-bit register from shared components
    reg32 register_inst (
        .clk(clk),
        .reset(reset),
        .we(we),
        .d(d),
        .q(q)
    );

endmodule