// Logic Unit
// Performs all bitwise logic operations
// logic_op selects which operation to perform

`timescale 1ns/1ps

module logic_unit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [1:0] logic_op,
    output reg  [3:0] result
);

    // Operation codes
    localparam AND_OP = 2'b00;
    localparam OR_OP  = 2'b01;
    localparam XOR_OP = 2'b10;
    localparam NOT_OP = 2'b11;

    always @(*) begin
        case (logic_op)
            AND_OP:  result = a & b;
            OR_OP:   result = a | b;
            XOR_OP:  result = a ^ b;
            NOT_OP:  result = ~a;
            default: result = 4'b0000;
        endcase
    end

endmodule
