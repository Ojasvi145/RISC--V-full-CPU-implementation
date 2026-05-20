`timescale 1ns/1ps

module InstructionMemory (
    input [31:0] addr,
    output [31:0] instruction
);
    // 1024 words (4KB) of instruction space
    reg [31:0] mem [0:1023];

    // Asynchronous read: instruction is available as soon as address changes
    // We divide by 4 (shift right by 2) because instructions are word-aligned
    assign instruction = mem[addr >> 2];

    // Note: The actual loading of the hex file happens in the Testbench
    // using $readmemh to keep this module generic.
endmodule