// 4-bit Ripple Carry Adder and Subtractor
// Uses 4 full adders connected in chain
// sub=0 means ADD, sub=1 means SUBTRACT

`timescale 1ns/1ps

module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       sub,
    output wire [3:0] result,
    output wire       cout,
    output wire       overflow
);

    // Internal carry wires between full adders
    wire c1, c2, c3;
    
    // When subtracting, invert B and set carry in to 1
    // This implements A - B = A + (~B) + 1
    wire [3:0] b_in;
    assign b_in = b ^ {4{sub}};

    // Chain four full adders together
    // Carry output of each goes to carry input of next
    full_adder FA0 (.a(a[0]), .b(b_in[0]), .cin(sub),  .sum(result[0]), .cout(c1));
    full_adder FA1 (.a(a[1]), .b(b_in[1]), .cin(c1),   .sum(result[1]), .cout(c2));
    full_adder FA2 (.a(a[2]), .b(b_in[2]), .cin(c2),   .sum(result[2]), .cout(c3));
    full_adder FA3 (.a(a[3]), .b(b_in[3]), .cin(c3),   .sum(result[3]), .cout(cout));

    // Overflow happens when carry into MSB differs from carry out of MSB
    assign overflow = c3 ^ cout;

endmodule
