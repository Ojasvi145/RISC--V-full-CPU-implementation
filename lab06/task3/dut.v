`timescale 1ns/1ps

module cpu_sc_part (
    input clk,
    input rst
);
    // Internal Wires
    wire [31:0] pc_curr, pc_next;
    wire [31:0] instr;
    wire [31:0] imm;
    wire [31:0] regData1, regData2;
    wire [31:0] alu_input2, alu_result;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;
    
    // Control Signals
    wire regWrite, aluSrc, memWrite, memRead;
    wire [2:0] aluOp;
    wire [1:0] immSel;

    // --- 1. Instruction Fetch (IF) ---
    // PC Register
    reg [31:0] pc_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) pc_reg <= 32'b0;
        else     pc_reg <= pc_next;
    end
    assign pc_curr = pc_reg;

    // PC + 4 (Instruction Fetch Logic)
    // Reusing logic from PCInc but integrated here for clarity
    adder pc_adder_inst (
        .a(pc_curr),
        .b(32'd4),
        .sum(pc_next)
    );

    // IMEM instantiation (Read-only)
    BankedMEM IMEM (
        .clk(clk),
        .writeEn(1'b0),
        .address(pc_curr),
        .writeData(32'b0),
        .readData(instr)
    );

    // --- 2. Decode (ID) ---
    ControlUnit CU (
        .instruction(instr),
        .RegWrite(regWrite),
        .ALUSrc(aluSrc),
        .MemWrite(memWrite),
        .MemRead(memRead),
        .ALUOp(aluOp),
        .ImmSel(immSel)
    );

    immGen IG (
        .immSel(immSel),
        .instruction(instr),
        .immOut(imm)
    );

    // Register File instantiation
    // Assuming rs1 = instr[19:15], rs2 = instr[24:20], rd = instr[11:7]
    regFile RF (
        .clk(clk),
        .we(regWrite),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .wd(write_back_data),
        .rd1(regData1),
        .rd2(regData2)
    );

    // --- 3. Execute (EX) ---
    // MUX for ALU source
    assign alu_input2 = aluSrc ? imm : regData2;

    // ALU instantiation
    alu ALU_unit (
        .a(regData1),
        .b(alu_input2),
        .op(aluOp),
        .res(alu_result)
    );

    // --- 4. Memory Access (MEM) ---
    BankedMEM DMEM (
        .clk(clk),
        .writeEn(memWrite),
        .address(alu_result),
        .writeData(regData2),
        .readData(mem_read_data)
    );

    // --- 5. Write Back (WB) ---
    // Select between ALU result and Memory data
    assign write_back_data = memRead ? mem_read_data : alu_result;

endmodule