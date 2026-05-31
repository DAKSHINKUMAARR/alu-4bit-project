// Full Adder Module
// This is the basic building block for our 4-bit adder
// Adds three 1-bit inputs: a, b, carry_in
// Produces: sum and carry_out

`timescale 1ns/1ps

module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    // Sum is XOR of all three inputs
    assign sum  = a ^ b ^ cin;
    
    // Carry out is 1 if at least two inputs are 1
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule
