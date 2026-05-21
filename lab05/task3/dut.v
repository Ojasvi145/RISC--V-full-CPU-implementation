`timescale 1ns/1ps

module dut (
    input [2:0] funct3,
    input [6:0] funct7,
    output [2:0] alu_ctrl_out
);

    // Instantiate the ALU Control module from the shared folder
    alu_ctrl control_unit (
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl_out(alu_ctrl_out)
    );

endmodule