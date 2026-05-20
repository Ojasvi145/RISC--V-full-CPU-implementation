module fa (
    input  wire a,
    input  wire b,
    input  wire cin,
    output reg sum,
    output reg cout
);

    // Behavioral modeling using always @(*)
    always @(*) begin
        {cout, sum} = a + b + cin;
    end

endmodule