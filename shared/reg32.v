`timescale 1ns/1ps

module reg32 (
    input clk,
    input reset,    // Active High, Synchronous
    input we,       // Write Enable
    input [31:0] d,
    output reg [31:0] q
);

    // Register clk→Q propagation delay must be #1
    always @(posedge clk) begin
        if (reset) begin
            q <= #1 32'b0;
        end else if (we) begin
            q <= #1 d;
        end
    end

endmodule