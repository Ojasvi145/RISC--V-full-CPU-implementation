`timescale 1ns/1ps

module tb_task1();
    reg clk;
    reg reset;
    reg [31:0] instruction;
    wire [31:0] current_pc;

    // Instantiate the DUT
    dut uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .current_pc(current_pc)
    );

    // Clock Generation (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("----------------------------------------------");
        $display("STARTING TASK 1: CONTROL FLOW TEST");
        $display("----------------------------------------------");
        
        // 1. Reset System
        reset = 1; instruction = 32'h0;
        #10 reset = 0;
        $display("[TIME %0t] Reset De-asserted. PC: %d", $time, current_pc);

        // 2. Test Normal Increment (addi x1, x0, 10)
        // Opcode: 0010011, PC should go to 4
        instruction = 32'h00A00093; 
        #10;
        $display("[TIME %0t] Normal Inst: PC = %d (Expected: 4)", $time, current_pc);

        // 3. Test JAL (jal x1, 12)
        // Offset 12, PC should go to 4 + 12 = 16
        instruction = 32'h00C000EF; 
        #10;
        $display("[TIME %0t] JAL (Offset 12): PC = %d (Expected: 16)", $time, current_pc);

        // 4. Test BEQ (beq x0, x0, 8)
        // Offset 8, PC should go to 16 + 8 = 24
        instruction = 32'h00000463; 
        #10;
        $display("[TIME %0t] BEQ (Offset 8): PC = %d (Expected: 24)", $time, current_pc);

        $display("----------------------------------------------");
        $display("TEST COMPLETE");
        $display("----------------------------------------------");
        #10 $finish;
    end
endmodule