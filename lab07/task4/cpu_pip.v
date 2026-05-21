`timescale 1ns/1ps

module cpu_pip (
    input clk,
    input reset
);

    // ================= IF =================
    wire [31:0] pc, instr;

    PCinc pc_unit (
        .clk(clk),
        .reset(reset),
        .imm(32'b0),
        .PCSrc(1'b0),
        .PC(pc)
    );

    InstructionMemory imem (
        .addr(pc),
        .instruction(instr)
    );

    // ================= IF/ID =================
    reg [31:0] IF_ID_instr, IF_ID_pc;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instr <= 0;
            IF_ID_pc <= 0;
        end else begin
            IF_ID_instr <= instr;
            IF_ID_pc <= pc;
        end
    end

    // ================= ID =================
    wire [31:0] imm, rdata1, rdata2;
    wire [2:0] immSel, alu_op;
    wire reg_write_en, alu_src, mem_write, mem_read;

    ControlUnit cu (
        .instruction(IF_ID_instr),
        .RegWrite(reg_write_en),
        .ALUSrc(alu_src),
        .MemWrite(mem_write),
        .MemRead(mem_read),
        .Branch(), .Jump(),
        .ALUOp(alu_op),
        .ImmSel(immSel)
    );

    immGen ig (
        .immSel(immSel),
        .instruction(IF_ID_instr),
        .immOut(imm)
    );

    wire [31:0] wd_data;
    wire [4:0] MEM_WB_rd;
    wire MEM_WB_RegWrite;

    reg_file rf (
        .clk(clk),
        .reset(reset),
        .rs1(IF_ID_instr[19:15]),
        .rs2(IF_ID_instr[24:20]),
        .rd(MEM_WB_rd),
        .reg_write_en(MEM_WB_RegWrite),
        .wd(wd_data),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // ================= ID/EX =================
    reg [31:0] ID_EX_rdata1, ID_EX_rdata2, ID_EX_imm;
    reg [4:0] ID_EX_rd;
    reg [2:0] ID_EX_ALUOp;
    reg ID_EX_ALUSrc, ID_EX_MemRead, ID_EX_MemWrite;
    reg ID_EX_RegWrite, ID_EX_MemToReg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_EX_rdata1 <= 0;
            ID_EX_rdata2 <= 0;
            ID_EX_imm <= 0;
            ID_EX_rd <= 0;
            ID_EX_ALUOp <= 0;
            ID_EX_ALUSrc <= 0;
            ID_EX_MemRead <= 0;
            ID_EX_MemWrite <= 0;
            ID_EX_RegWrite <= 0;
            ID_EX_MemToReg <= 0;
        end else begin
            ID_EX_rdata1 <= rdata1;
            ID_EX_rdata2 <= rdata2;
            ID_EX_imm <= imm;
            ID_EX_rd <= IF_ID_instr[11:7];
            ID_EX_ALUOp <= alu_op;
            ID_EX_ALUSrc <= alu_src;
            ID_EX_MemRead <= mem_read;
            ID_EX_MemWrite <= mem_write;
            ID_EX_RegWrite <= reg_write_en;
            ID_EX_MemToReg <= mem_read;
        end
    end

    // ================= EX =================
    wire [31:0] alu_b, alu_res;

    assign alu_b = ID_EX_ALUSrc ? ID_EX_imm : ID_EX_rdata2;

    alu alu_inst (
        .a(ID_EX_rdata1),
        .b(alu_b),
        .op(ID_EX_ALUOp),
        .res(alu_res),
        .Zero()
    );

    // ================= EX/MEM =================
    reg [31:0] EX_MEM_alu_res, EX_MEM_rdata2;
    reg [4:0] EX_MEM_rd;
    reg EX_MEM_MemRead, EX_MEM_MemWrite;
    reg EX_MEM_RegWrite, EX_MEM_MemToReg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EX_MEM_alu_res <= 0;
            EX_MEM_rdata2 <= 0;
            EX_MEM_rd <= 0;
            EX_MEM_MemRead <= 0;
            EX_MEM_MemWrite <= 0;
            EX_MEM_RegWrite <= 0;
            EX_MEM_MemToReg <= 0;
        end else begin
            EX_MEM_alu_res <= alu_res;
            EX_MEM_rdata2 <= ID_EX_rdata2;
            EX_MEM_rd <= ID_EX_rd;
            EX_MEM_MemRead <= ID_EX_MemRead;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_MemToReg <= ID_EX_MemToReg;
        end
    end

    // ================= MEM =================
    wire [31:0] mem_data;

    DataMemory dmem (
        .clk(clk),
        .mem_read(EX_MEM_MemRead),
        .mem_write(EX_MEM_MemWrite),
        .addr(EX_MEM_alu_res),
        .write_data(EX_MEM_rdata2),
        .read_data(mem_data)
    );

    // ================= MEM/WB =================
    reg [31:0] MEM_WB_mem_data, MEM_WB_alu_res;
    reg [4:0] MEM_WB_rd_reg;
    reg MEM_WB_RegWrite_reg, MEM_WB_MemToReg;

    assign MEM_WB_rd = MEM_WB_rd_reg;
    assign MEM_WB_RegWrite = MEM_WB_RegWrite_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEM_WB_mem_data <= 0;
            MEM_WB_alu_res <= 0;
            MEM_WB_rd_reg <= 0;
            MEM_WB_RegWrite_reg <= 0;
            MEM_WB_MemToReg <= 0;
        end else begin
            MEM_WB_mem_data <= mem_data;
            MEM_WB_alu_res <= EX_MEM_alu_res;
            MEM_WB_rd_reg <= EX_MEM_rd;
            MEM_WB_RegWrite_reg <= EX_MEM_RegWrite;
            MEM_WB_MemToReg <= EX_MEM_MemToReg;
        end
    end

    // ================= WB =================
    assign wd_data = MEM_WB_MemToReg ? MEM_WB_mem_data : MEM_WB_alu_res;

endmodule