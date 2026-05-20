`timescale 1ns/1ps

module decoder5to32 (
    input [4:0] rd,            // 5-bit Destination Register Index
    input reg_write_en,        // Global Write Enable
    output [31:0] dec_out      // 32 individual one-hot enable signals
);

    // Canonical delay of #1 applied to the logic output
    // If reg_write_en is 0, all outputs are 0.
    // Otherwise, bit 'rd' is set to 1.
    assign #1 dec_out = (reg_write_en) ? (32'b1 << rd) : 32'b0;

endmodule