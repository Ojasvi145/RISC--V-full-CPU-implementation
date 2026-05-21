`timescale 1ns/1ps

module dut (
    input clk,
    input [31:0] oldPC,
    output [31:0] newPC
);

    PCInc pc_unit (
        .clk(clk),
        .oldPC(oldPC),
        .newPC(newPC)
    );

endmodule