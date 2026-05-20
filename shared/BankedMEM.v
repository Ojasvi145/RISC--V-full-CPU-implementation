`timescale 1ns/1ps

module BankedMEM (
    input clk,
    input writeEn,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData
);
    // Four 8-bit memory banks, each with 1024 entries
    reg [7:0] b0 [0:1023];
    reg [7:0] b1 [0:1023];
    reg [7:0] b2 [0:1023];
    reg [7:0] b3 [0:1023];

    // Word-aligned index: extract 10 bits starting from bit 2
    // Bits [1:0] are ignored for word-aligned access
    wire [9:0] idx;
    assign idx = address[11:2];

    // ASYNCHRONOUS READ
    // Concatenate the byte from each bank to form a 32-bit word
    assign readData = {b3[idx], b2[idx], b1[idx], b0[idx]};

    // SYNCHRONOUS WRITE
    always @(posedge clk) begin
        if (writeEn) begin
            b0[idx] <= writeData[7:0];
            b1[idx] <= writeData[15:8];
            b2[idx] <= writeData[23:16];
            b3[idx] <= writeData[31:24];
        end
    end

endmodule