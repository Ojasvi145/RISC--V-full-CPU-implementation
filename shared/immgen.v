/*`timescale 1ns/1ps

module immGen (
    input [1:0] immSel,
    input [31:0] instruction,
    output [31:0] immOut
);
    wire [31:0] i_imm, s_imm, b_imm;

    assign i_imm = {{20{instruction[31]}}, instruction[31:20]};
    assign s_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    assign b_imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    assign immOut = (immSel == 2'b00) ? i_imm :
                    (immSel == 2'b01) ? s_imm :
                    (immSel == 2'b10) ? b_imm : 32'b0;
endmodule*/
`timescale 1ns/1ps

module immGen (
    input [2:0] immSel,        // Updated to 3 bits
    input [31:0] instruction,
    output reg [31:0] immOut   // Changed to reg for easier case logic
);

    wire [31:0] i_imm, s_imm, b_imm, j_imm;

    // I-type: 12-bit immediate
    assign i_imm = {{20{instruction[31]}}, instruction[31:20]};

    // S-type: 12-bit immediate (split)
    assign s_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

    // B-type: 13-bit signed (bit 0 is always 0, bits 12, 11, 10:5, 4:1)
    assign b_imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    // J-type: 21-bit signed (bit 0 is always 0, bits 20, 19:12, 11, 10:1)
    assign j_imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

    always @(*) begin
        case (immSel)
            3'b000:  immOut = i_imm; // I-type
            3'b001:  immOut = s_imm; // S-type
            3'b010:  immOut = b_imm; // B-type
            3'b011:  immOut = j_imm; // J-type
            default: immOut = 32'b0;
        endcase
    end
endmodule