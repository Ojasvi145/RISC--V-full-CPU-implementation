`timescale 1ns/1ps

module tb_task;
    reg clk;
    reg rst;

    // Instantiate CPU
    cpu_sc_part cpu (.clk(clk), .rst(rst));

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // --- Assemble & Load Machine Code ---
        
        // Index 0: addi x1, x0, 10 -> 00a00093
        cpu.IMEM.b0[0] = 8'h93; cpu.IMEM.b1[0] = 8'h00; cpu.IMEM.b2[0] = 8'ha0; cpu.IMEM.b3[0] = 8'h00;
        
        // Index 1: addi x2, x0, 20 -> 01400113
        cpu.IMEM.b0[1] = 8'h13; cpu.IMEM.b1[1] = 8'h01; cpu.IMEM.b2[1] = 8'h40; cpu.IMEM.b3[1] = 8'h01;
        
        // Index 2: add  x3, x1, x2 -> 002081b3
        cpu.IMEM.b0[2] = 8'hb3; cpu.IMEM.b1[2] = 8'h81; cpu.IMEM.b2[2] = 8'h20; cpu.IMEM.b3[2] = 8'h00;
        
        // Index 3: sw   x3, 0(x0)  -> 00302023
        cpu.IMEM.b0[3] = 8'h23; cpu.IMEM.b1[3] = 8'h20; cpu.IMEM.b2[3] = 8'h30; cpu.IMEM.b3[3] = 8'h00;
        
        // Index 4: lw   x4, 0(x0)  -> 00002203
        cpu.IMEM.b0[4] = 8'h03; cpu.IMEM.b1[4] = 8'h22; cpu.IMEM.b2[4] = 8'h00; cpu.IMEM.b3[4] = 8'h00;

        // Index 5: sub  x5, x4, x1 -> 401202b3
        // Corrected bytes to ensure rs1=x4 and rs2=x1
        cpu.IMEM.b0[5] = 8'hb3; 
        cpu.IMEM.b1[5] = 8'h02; 
        cpu.IMEM.b2[5] = 8'h12; // This byte contains rs1 and part of rs2
        cpu.IMEM.b3[5] = 8'h40;

        // Reset system
        rst = 1; #10;
        rst = 0;

        $display("Time\t PC\t\t Instr\t\t ALU_Res\t WB_Data");
        $monitor("%0t\t %h\t %h\t %h\t %h", $time, cpu.pc_curr, cpu.instr, cpu.alu_result, cpu.write_back_data);

        // Run for enough cycles to finish the snippet
        #100;

        // Final verification of registers (accessing internal regFile)
        $display("\n--- Register File Final State ---");
        $display("x1 (10): %d", cpu.RF.registers[1]);
        $display("x2 (20): %d", cpu.RF.registers[2]);
        $display("x3 (30): %d", cpu.RF.registers[3]);
        $display("x4 (30): %d", cpu.RF.registers[4]);
        $display("x5 (20): %d", cpu.RF.registers[5]);

        $finish;
    end
endmodule