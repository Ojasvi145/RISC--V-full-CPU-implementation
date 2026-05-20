`timescale 1ns/1ps
module dut (
  input wire clk,
  input reset,
  output wire [3:0] count
);
  wire [3:0] next_count;
  
  // Instantiate 4 DFFs to form the counter
  dff bit0 (.clk(clk), .d(next_count[0]), .reset(reset), .q(count[0]));
  dff bit1 (.clk(clk), .d(next_count[1]), .reset(reset), .q(count[1]));
  dff bit2 (.clk(clk), .d(next_count[2]), .reset(reset), .q(count[2]));
  dff bit3 (.clk(clk), .d(next_count[3]), .reset(reset), .q(count[3]));

  // Combinational logic to compute next count value (increment by 1)
  assign next_count = count + 1;

endmodule