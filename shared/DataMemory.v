`timescale 1ns/1ps

module DataMemory (
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] addr,       // From ALU
    input [31:0] write_data, // From RegFile rdata2
    output [31:0] read_data  // To RegFile wd MUX
);
    // Memory array (e.g., 1024 words of 32 bits each)
    reg [31:0] mem [0:1023];

    // Reading logic (Asynchronous)
    assign read_data = (mem_read) ? mem[addr >> 2] : 32'b0;

    // Writing logic (Synchronous)
    always @(posedge clk) begin
        if (mem_write) begin
            mem[addr >> 2] <= write_data;
        end
    end
endmodule