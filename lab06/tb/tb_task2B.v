`timescale 1ns/1ps

module tb_task2B;
    reg clk;
    reg [31:0] oldPC;
    wire [31:0] newPC;

    // Instantiate the DUT
    dut uut (
        .clk(clk),
        .oldPC(oldPC),
        .newPC(newPC)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("Time\t oldPC\t\t newPC (After Posedge)");
        $monitor("%0t\t %h\t %h", $time, oldPC, newPC);

        // Initial PC value
        oldPC = 32'h0000_0000;
        
        // Wait for a few clock cycles and simulate PC updating
        #10 oldPC = newPC; // Simulate the feedback loop at T=10
        #10 oldPC = newPC; // T=20
        #10 oldPC = newPC; // T=30
        #10 oldPC = newPC; // T=40

        #10 $finish;
    end
endmodule