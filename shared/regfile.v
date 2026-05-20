`timescale 1ns/1ps

module regFile (
    input clk,
    input we,              // Write Enable
    input [4:0] rs1,       // Source Register 1 Address
    input [4:0] rs2,       // Source Register 2 Address
    input [4:0] rd,        // Destination Register Address
    input [31:0] wd,       // Write Data
    output [31:0] rd1,     // Read Data 1
    output [31:0] rd2      // Read Data 2
);
    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];

    // Initialize all registers to zero for simulation stability
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    // Asynchronous Read Logic
    // Register x0 is always 0
    assign rd1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign rd2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

    // Synchronous Write Logic
    always @(posedge clk) begin
        // Only write if Write Enable is high and target is not x0
        if (we && (rd != 5'b0)) begin
            registers[rd] <= wd;
        end
    end
endmodule