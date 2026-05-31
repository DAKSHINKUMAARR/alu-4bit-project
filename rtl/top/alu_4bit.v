// 4-bit ALU Top Level
// Connects arithmetic unit, logic unit, and shift unit
// Opcode selects which operation to perform
// Generates all status flags

`timescale 1ns/1ps

module alu_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [3:0] opcode,
    output reg  [3:0] result,
    output reg        zero,
    output reg        carry,
    output reg        overflow,
    output reg        negative
);

    // Opcode definitions
    localparam OP_ADD  = 4'b0000;
    localparam OP_SUB  = 4'b0001;
    localparam OP_INC  = 4'b0010;
    localparam OP_DEC  = 4'b0011;
    localparam OP_AND  = 4'b0100;
    localparam OP_OR   = 4'b0101;
    localparam OP_XOR  = 4'b0110;
    localparam OP_NOT  = 4'b0111;
    localparam OP_NAND = 4'b1000;
    localparam OP_NOR  = 4'b1001;
    localparam OP_XNOR = 4'b1010;
    localparam OP_SHL  = 4'b1011;
    localparam OP_SHR  = 4'b1100;
    localparam OP_ASR  = 4'b1101;
    localparam OP_CMP  = 4'b1110;
    localparam OP_PASS = 4'b1111;

    // Wires from each sub-unit
    wire [3:0] arith_result;
    wire       arith_cout;
    wire       arith_overflow;
    wire [3:0] logic_result;
    wire [3:0] shift_result;
    wire       shift_carry;

    // Control signals
    wire sub_op;
    wire [3:0] b_arith;
    wire [1:0] logic_sel;
    wire [1:0] shift_sel;

    // Subtraction control
    assign sub_op = (opcode == OP_SUB) || (opcode == OP_DEC) || (opcode == OP_CMP);

    // B input for arithmetic
    assign b_arith = ((opcode == OP_INC) || (opcode == OP_DEC)) ? 4'b0001 : b;

    // Logic operation select
    assign logic_sel = (opcode == OP_AND || opcode == OP_NAND) ? 2'b00 :
                       (opcode == OP_OR  || opcode == OP_NOR)  ? 2'b01 :
                       (opcode == OP_XOR || opcode == OP_XNOR) ? 2'b10 : 2'b11;

    // Shift operation select
    assign shift_sel = (opcode == OP_SHL) ? 2'b00 :
                       (opcode == OP_SHR) ? 2'b01 :
                       (opcode == OP_ASR) ? 2'b10 : 2'b11;

    // Instantiate arithmetic unit
    adder_4bit u_adder (
        .a        (a),
        .b        (b_arith),
        .sub      (sub_op),
        .result   (arith_result),
        .cout     (arith_cout),
        .overflow (arith_overflow)
    );

    // Instantiate logic unit
    logic_unit u_logic (
        .a        (a),
        .b        (b),
        .logic_op (logic_sel),
        .result   (logic_result)
    );

    // Instantiate shift unit
    shift_unit u_shift (
        .a         (a),
        .shift_op  (shift_sel),
        .result    (shift_result),
        .shift_out (shift_carry)
    );

    // Result selection and flag generation
    always @(*) begin
        // Default values to prevent latches
        result   = 4'b0000;
        carry    = 1'b0;
        overflow = 1'b0;

        case (opcode)
            OP_ADD, OP_SUB, OP_INC, OP_DEC, OP_CMP: begin
                result   = arith_result;
                carry    = arith_cout;
                overflow = arith_overflow;
            end

            OP_AND: result = logic_result;
            OP_OR:  result = logic_result;
            OP_XOR: result = logic_result;
            OP_NOT: result = logic_result;

            OP_NAND: result = ~(a & b);
            OP_NOR:  result = ~(a | b);
            OP_XNOR: result = ~(a ^ b);

            OP_SHL, OP_SHR, OP_ASR: begin
                result = shift_result;
                carry  = shift_carry;
            end

            OP_PASS: result = a;

            default: result = 4'b0000;
        endcase

        // Flags always computed from final result
        zero     = (result == 4'b0000);
        negative = result[3];
    end

endmodule
