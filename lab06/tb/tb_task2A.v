`timescale 1ns/1ps

module tb_task2A;
    reg [1:0] immSel;
    reg [31:0] instruction;
    wire [31:0] immOut;

    // Intermediate nets for $monitor workarounds
    wire signed [31:0] immOut_signed = immOut;
    
    // Instantiate the DUT
    dut uut (
        .immSel(immSel),
        .instruction(instruction),
        .immOut(immOut)
    );

    initial begin
        $display("Time\t ImmSel\t Instruction\t ImmOut (Hex)\t ImmOut (Dec)");
        // Using only simple signals in $monitor
        $monitor("%0t\t %b\t %h\t %h\t %d", $time, immSel, instruction, immOut, immOut_signed);

        // Test 1: I-Type (addi x1, x0, -10)
        immSel = 2'b00;
        instruction = 32'hFF600093; 
        #10;

        // Test 2: S-Type (sw x3, 4(x10))
        immSel = 2'b01;
        instruction = 32'h00352223; 
        #10;

        // Test 3: B-Type (beq x1, x2, -8)
        immSel = 2'b10;
        instruction = 32'hFE208CE3;
        #10;

        $finish;
    end
endmodule