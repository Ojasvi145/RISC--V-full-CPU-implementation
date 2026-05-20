module fa(input a,b,cin,
          output reg sum,cout);
wire e,r,t,y;
xor (e,a,b);
xor (sum,e,cin);
and (r,a,b);
and (t,cin,e);
or (y,r,t);
assign cout=y;  
endmodule