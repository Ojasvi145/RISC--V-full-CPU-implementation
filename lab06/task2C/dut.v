`timescale 1ns/1ps

module dut (
    input clk,
    input writeEn,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData
);

    BankedMEM memory_unit (
        .clk(clk),
        .writeEn(writeEn),
        .address(address),
        .writeData(writeData),
        .readData(readData)
    );

endmodule