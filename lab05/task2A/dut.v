`timescale 1ns/1ps

module dut (
    input [4:0] rd,
    input reg_write_en,
    output [31:0] dec_out
);

    // Structural instantiation of the decoder
    decoder5to32 decoder_inst (
        .rd(rd),
        .reg_write_en(reg_write_en),
        .dec_out(dec_out)
    );

endmodule