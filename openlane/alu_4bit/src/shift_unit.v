// Shift Unit
// Performs shift and rotate operations on 4-bit input
// shift_op selects type of shift

`timescale 1ns/1ps

module shift_unit (
    input  wire [3:0] a,
    input  wire [1:0] shift_op,
    output reg  [3:0] result,
    output reg        shift_out
);

    // Shift operation codes
    localparam SHL = 2'b00;  // Shift Left Logical
    localparam SHR = 2'b01;  // Shift Right Logical
    localparam ASR = 2'b10;  // Arithmetic Shift Right
    localparam ROL = 2'b11;  // Rotate Left

    always @(*) begin
        case (shift_op)
            SHL: begin
                result    = {a[2:0], 1'b0};
                shift_out = a[3];
            end
            SHR: begin
                result    = {1'b0, a[3:1]};
                shift_out = a[0];
            end
            ASR: begin
                result    = {a[3], a[3:1]};
                shift_out = a[0];
            end
            ROL: begin
                result    = {a[2:0], a[3]};
                shift_out = a[3];
            end
            default: begin
                result    = a;
                shift_out = 1'b0;
            end
        endcase
    end

endmodule
