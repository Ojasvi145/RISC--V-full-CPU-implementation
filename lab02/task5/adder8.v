`timescale 1ns/1ps
module fa(input a, input b, input cin, output sum, output cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a ^ b));
endmodule

module adder4bit(input [3:0]a,
                 input [3:0]b,
                 input cin,
                 output [3:0]sum,
                 output cout);

wire[3:1]cint;

fa FA0(a[0],b[0],cin,sum[0],cint[1]);
fa FA1(a[1],b[1],cint[1],sum[1],cint[2]); 
fa FA2(a[2],b[2],cint[2],sum[2],cint[3]); 
fa FA3(a[3],b[3],cint[3],sum[3],cout);     

endmodule

module adder8(input [7:0]a,
              input [7:0]b,
              input cin,
              output [7:0]sum,
              output cout);

wire cout_low;

// Low 4 bits
adder4bit low(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(cout_low));

// High 4 bits
adder4bit high(.a(a[7:4]), .b(b[7:4]), .cin(cout_low), .sum(sum[7:4]), .cout(cout));

endmodule