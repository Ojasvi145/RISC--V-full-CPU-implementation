module dut(input [3:0]a,
           input [3:0]b,
           input cin,
           input m,
           output [3:0]sum,
           output cout);

wire [3:0]b_mux;
wire cin_adder;

// When m=1 (subtraction), invert b and set cin=1 for two's complement
// When m=0 (addition), use b as is and use cin from input
assign b_mux = m ? ~b : b;
assign cin_adder = m ? 1'b1 : cin;

// Instantiate the 4-bit adder
adder4bit adder(.a(a), .b(b_mux), .cin(cin_adder), .sum(sum), .cout(cout));

endmodule