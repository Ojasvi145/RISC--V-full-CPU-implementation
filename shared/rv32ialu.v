`timescale 1ns/1ps

module rv32ialu (
    input  signed [31:0] A,
    input  signed [31:0] B,
    input  [2:0]         alu_ctrl,
    output signed [31:0] Y,
    output               zero
);
    // Internal wires for unit outputs
    wire [31:0] res_addsub, res_logic, res_shift, res_comp;
    reg  [31:0] mux_out;

    // 1. Adder/Subtractor Unit (Task 1)
    // sub_ctrl is 1 if alu_ctrl is 000 (SUB)
    aluaddsub unit_addsub (
        .A(A), .B(B), 
        .sub_ctrl(alu_ctrl == 3'b000), 
        .Y(res_addsub)
    );

    // 2. Logic Unit (Task 2)
    // sel is alu_ctrl[0]: 0 for AND (010), 1 for OR (011)
    alulogic unit_logic (
        .A(A), .B(B), 
        .sel(alu_ctrl[0]), 
        .Y(res_logic)
    );

    // 3. Shifter Unit (Task 3)
    // sel is alu_ctrl[0]: 0 for SLL (100), 1 for SRL (101)
    alushift unit_shift (
        .A(A), .shamt(B[4:0]), 
        .sel(alu_ctrl[0]), 
        .Y(res_shift)
    );

    // 4. Comparator Unit (Task 4)
    alucomp unit_comp (
        .A(A), .B(B), 
        .Y(res_comp)
    );

    // Final Multiplexer with #1 Delay
    always @(*) begin
        case (alu_ctrl)
            3'b000:  mux_out = res_addsub; // SUB
            3'b001:  mux_out = res_addsub; // ADD
            3'b010:  mux_out = res_logic;  // AND
            3'b011:  mux_out = res_logic;  // OR
            3'b100:  mux_out = res_shift;  // SLL
            3'b101:  mux_out = res_shift;  // SRL
            3'b110:  mux_out = res_comp;   // SLT
            default: mux_out = 32'b0;      // Reserved
        endcase
    end

    assign #1 Y = mux_out;
    
    // Zero flag derived from final output
    assign zero = (Y == 32'b0);

endmodule