`timescale 1ns/1ps

module cpu_SC (
    input clk,
    input reset
);

    // ================= WIRES =================
    wire [31:0] pc, instr, imm;
    wire [31:0] alu_res, mem_data, wd_data;
    wire [31:0] rdata1, rdata2, alu_b;

    wire [2:0] immSel, alu_op;

    wire reg_write_en, alu_src;
    wire mem_write, mem_read, MemToReg;
    wire branch, jump;

    wire pc_src;

    // ================= BRANCH LOGIC =================
    wire eq = (rdata1 == rdata2);
    wire ne = (rdata1 != rdata2);

    assign pc_src = jump |
                   (branch &
                   ((instr[14:12] == 3'b000 && eq) ||   // BEQ
                    (instr[14:12] == 3'b001 && ne)));  // BNE

    // ================= PC =================
    PCinc pc_unit (
        .clk(clk),
        .reset(reset),
        .imm(imm),
        .PCSrc(pc_src),
        .PC(pc)
    );

    // ================= INSTRUCTION MEMORY =================
    InstructionMemory imem (
        .addr(pc),
        .instruction(instr)
    );

    // ================= CONTROL UNIT =================
    ControlUnit cu (
        .instruction(instr),
        .RegWrite(reg_write_en),
        .ALUSrc(alu_src),
        .MemWrite(mem_write),
        .MemRead(mem_read),
        .MemToReg(MemToReg),   // ⭐ IMPORTANT
        .Branch(branch),
        .Jump(jump),
        .ALUOp(alu_op),
        .ImmSel(immSel)
    );

    // ================= REGISTER FILE =================
    assign wd_data = jump ? (pc + 4) :
                     (MemToReg ? mem_data : alu_res);

    reg_file rf (
        .clk(clk),
        .reset(reset),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .reg_write_en(reg_write_en),
        .wd(wd_data),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // ================= IMMEDIATE GENERATOR =================
    immGen ig (
        .immSel(immSel),
        .instruction(instr),
        .immOut(imm)
    );

    // ================= ALU =================
    assign alu_b = (alu_src) ? imm : rdata2;

    alu alu_inst (
        .a(rdata1),
        .b(alu_b),
        .op(alu_op),
        .res(alu_res),
        .Zero()   // Not used for branch anymore
    );

    // ================= DATA MEMORY =================
    DataMemory dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_res),
        .write_data(rdata2),
        .read_data(mem_data)
    );

endmodule