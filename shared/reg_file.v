`timescale 1ns/1ps

module reg_file (
    input clk,
    input reset,
    input [4:0] rs1, rs2, rd,  // 5-bit address lines
    input reg_write_en,        // Write Enable
    input [31:0] wd,           // 32-bit Write Data
    output [31:0] rdata1, rdata2 // 32-bit Read Data outputs
);

    wire [31:0] dec_out;
    wire [31:0] regs [31:0]; // Internal register array

    // Task 2B: Connect rd to decoder input
    decoder5to32 write_decoder (
        .rd(rd),
        .reg_write_en(reg_write_en),
        .dec_out(dec_out)
    );

    // Task 2B: Connect dec_out lines to 'we' ports
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : register_loop
            if (i == 0) begin : x0_logic
                // Constraint: Ensure x0 is never written to
                assign regs[i] = 32'b0;
            end else begin : general_regs
                reg32 inst (
                    .clk(clk),
                    .reset(reset),
                    .we(dec_out[i]), // Decoder bit controls this register
                    .d(wd),
                    .q(regs[i])
                );
            end
        end
    endgenerate

    // Read Logic
    assign rdata1 = regs[rs1];
    assign rdata2 = regs[rs2];

endmodule