`timescale 1ns/1ps
module register8 (
  input wire clk,
  input wire [7:0] d,
  input reset,
  input enable,
  output wire [7:0] q
);
  // Instantiate 8 DFFs to form the 8-bit register
  dff bit0 (.clk(clk), .d(enable ? d[0] : q[0]), .reset(reset), .q(q[0]));
  dff bit1 (.clk(clk), .d(enable ? d[1] : q[1]), .reset(reset), .q(q[1]));
  dff bit2 (.clk(clk), .d(enable ? d[2] : q[2]), .reset(reset), .q(q[2]));
  dff bit3 (.clk(clk), .d(enable ? d[3] : q[3]), .reset(reset), .q(q[3]));
  dff bit4 (.clk(clk), .d(enable ? d[4] : q[4]), .reset(reset), .q(q[4]));
  dff bit5 (.clk(clk), .d(enable ? d[5] : q[5]), .reset(reset), .q(q[5]));
  dff bit6 (.clk(clk), .d(enable ? d[6] : q[6]), .reset(reset), .q(q[6]));
  dff bit7 (.clk(clk), .d(enable ? d[7] : q[7]), .reset(reset), .q(q[7]));
endmodule