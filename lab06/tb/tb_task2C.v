`timescale 1ns/1ps

module tb_task2C;
    reg clk;
    reg writeEn;
    reg [31:0] address;
    reg [31:0] writeData;
    wire [31:0] readData;

    // Instantiate DUT
    dut uut (
        .clk(clk),
        .writeEn(writeEn),
        .address(address),
        .writeData(writeData),
        .readData(readData)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("Time\t Addr\t WriteData\t WriteEn\t ReadData");
        $monitor("%0t\t %h\t %h\t %b\t\t %h", $time, address, writeData, writeEn, readData);

        // Step 1: Write to Address 4 (Index 1)
        address = 32'h0000_0004;
        writeData = 32'hDEADBEEF;
        writeEn = 1;
        #10; // Wait for posedge

        // Step 2: Stop writing and change address to see if it holds
        writeEn = 0;
        address = 32'h0000_0008; // Address 8 (Index 2)
        writeData = 32'hCAFEBABE;
        #10;

        // Step 3: Write to Address 8
        writeEn = 1;
        #10;

        // Step 4: Read back from Address 4
        writeEn = 0;
        address = 32'h0000_0004;
        #10;

        $finish;
    end
endmodule