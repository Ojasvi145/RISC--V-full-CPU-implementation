`timescale 1ns/1ps

module PCinc (
    input clk,
    input reset,        // Added reset for safety
    input [31:0] imm,   // From ImmGen
    input PCSrc,        // From Control Unit (Logic: Branch & Zero)
    output reg [31:0] PC
);
    wire [31:0] pc_plus_4;
    wire [31:0] pc_target;
    wire [31:0] next_pc;

    // Sequential Path
    assign pc_plus_4 = PC + 4;
    
    // Jump/Branch Path
    assign pc_target = PC + imm;

    // MUX: If PCSrc is high, take the jump/branch
    assign next_pc = (PCSrc) ? pc_target : pc_plus_4;

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'h0;
        else
            PC <= next_pc;
    end
endmodule

/*module PCInc (
    input clk,
    input [31:0] oldPC,
    output reg [31:0] newPC
);
    wire [31:0] pc_plus_4;

    // Instantiate the Adder from previous labs
    // Requirement: oldPC + 4
    adder pc_adder (
        .a(oldPC),
        .b(32'd4),
        .sum(pc_plus_4)
    );

    // Sequential logic: Update the PC register on the rising edge
    always @(posedge clk) begin
        newPC <= pc_plus_4;
    end

endmodule*/