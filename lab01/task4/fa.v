module fa(input a, input b, input cin,
          output sum, output cout);

  // Dataflow implementation (continuous assignments)
  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);

endmodule