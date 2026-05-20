`timescale 1ns/1ps

module bank (
    input wire [31:0] addr,
    output wire [7:0] data_out
);
    // Simple asynchronous ROM/RAM for demonstration
    reg [7:0] mem [0:255]; 

    // Initialize with some dummy data for testing
    initial begin
        integer i;
        for (i = 0; i < 256; i = i + 1) mem[i] = i[7:0];
    end

    assign data_out = mem[addr[7:0]]; // Using lower bits for index
endmodule