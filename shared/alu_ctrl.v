`timescale 1ns/1ps

module alu_ctrl (
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [2:0] alu_ctrl_out
);

    // Combinational logic with #1 unit delay
    always @(*) begin
        case (funct3)
            3'b000: begin
                // Check funct7[5] to distinguish between ADD and SUB
                if (funct7[5] == 1'b1) 
                    alu_ctrl_out = #1 3'b000; // SUB
                else 
                    alu_ctrl_out = #1 3'b001; // ADD
            end
            3'b111: alu_ctrl_out = #1 3'b010; // AND
            3'b110: alu_ctrl_out = #1 3'b011; // OR 
            3'b001: alu_ctrl_out = #1 3'b100; // SLL
            3'b010: alu_ctrl_out = #1 3'b110; // SLT
            default: alu_ctrl_out = #1 3'b001; // Default to ADD for safety
        endcase
    end

endmodule