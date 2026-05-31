// ALU Unit Testbench
// Tests each ALU operation with specific known values
// Checks result and all four flags

`timescale 1ns/1ps

module tb_alu_unit;

    reg  [3:0] a, b, opcode;
    wire [3:0] result;
    wire       zero, carry, overflow, negative;

    integer total  = 0;
    integer passed = 0;
    integer failed = 0;

    alu_4bit dut (
        .a        (a),
        .b        (b),
        .opcode   (opcode),
        .result   (result),
        .zero     (zero),
        .carry    (carry),
        .overflow (overflow),
        .negative (negative)
    );

    initial begin
        $dumpfile("waves/alu_unit.vcd");
        $dumpvars(0, tb_alu_unit);
    end

    // Task checks one test case
    task check;
        input [3:0] in_a;
        input [3:0] in_b;
        input [3:0] in_op;
        input [3:0] exp_res;
        input       exp_z;
        input       exp_c;
        input       exp_v;
        input       exp_n;
        input [8*10:1] test_name;
        begin
            a = in_a; b = in_b; opcode = in_op;
            #10;
            total = total + 1;
            if (result==exp_res && zero==exp_z && carry==exp_c &&
                overflow==exp_v && negative==exp_n) begin
                $display("PASS | %s | A=%h B=%h | R=%h Z=%b C=%b V=%b N=%b",
                         test_name, in_a, in_b, result, zero, carry, overflow, negative);
                passed = passed + 1;
            end else begin
                $display("FAIL | %s | A=%h B=%h", test_name, in_a, in_b);
                $display("     | Expected R=%h Z=%b C=%b V=%b N=%b",
                         exp_res, exp_z, exp_c, exp_v, exp_n);
                $display("     | Got      R=%h Z=%b C=%b V=%b N=%b",
                         result, zero, carry, overflow, negative);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $display("===========================================");
        $display("       ALU UNIT TEST RESULTS");
        $display("===========================================");

        // ADD tests
        $display("--- ADDITION ---");
        check(4'h3, 4'h4, 4'b0000, 4'h7, 0,0,0,0, "ADD 3+4   ");
        check(4'hF, 4'h1, 4'b0000, 4'h0, 1,1,0,0, "ADD F+1   ");
        check(4'h7, 4'h1, 4'b0000, 4'h8, 0,0,1,1, "ADD 7+1   ");
        check(4'h0, 4'h0, 4'b0000, 4'h0, 1,0,0,0, "ADD 0+0   ");

        // SUB tests
        $display("--- SUBTRACTION ---");
        check(4'h7, 4'h3, 4'b0001, 4'h4, 0,1,0,0, "SUB 7-3   ");
        check(4'h5, 4'h5, 4'b0001, 4'h0, 1,1,0,0, "SUB 5-5   ");
        check(4'h3, 4'h4, 4'b0001, 4'hF, 0,0,0,1, "SUB 3-4   ");
        check(4'h8, 4'h1, 4'b0001, 4'h7, 0,0,1,0, "SUB -8-1  ");

        // AND tests
        $display("--- AND ---");
        check(4'hF, 4'hA, 4'b0100, 4'hA, 0,0,0,1, "AND F,A   ");
        check(4'hF, 4'h0, 4'b0100, 4'h0, 1,0,0,0, "AND F,0   ");
        check(4'h5, 4'h6, 4'b0100, 4'h4, 0,0,0,0, "AND 5,6   ");

        // OR tests
        $display("--- OR ---");
        check(4'h5, 4'h6, 4'b0101, 4'h7, 0,0,0,0, "OR  5,6   ");
        check(4'h0, 4'h0, 4'b0101, 4'h0, 1,0,0,0, "OR  0,0   ");
        check(4'hA, 4'h5, 4'b0101, 4'hF, 0,0,0,1, "OR  A,5   ");

        // XOR tests
        $display("--- XOR ---");
        check(4'hA, 4'hA, 4'b0110, 4'h0, 1,0,0,0, "XOR A,A   ");
        check(4'hA, 4'h5, 4'b0110, 4'hF, 0,0,0,1, "XOR A,5   ");

        // NOT tests
        $display("--- NOT ---");
        check(4'hA, 4'h0, 4'b0111, 4'h5, 0,0,0,0, "NOT A     ");
        check(4'hF, 4'h0, 4'b0111, 4'h0, 1,0,0,0, "NOT F     ");
        check(4'h0, 4'h0, 4'b0111, 4'hF, 0,0,0,1, "NOT 0     ");

        // SHIFT tests
        $display("--- SHIFTS ---");
        check(4'h3, 4'h0, 4'b1011, 4'h6, 0,0,0,0, "SHL 3     ");
        check(4'h9, 4'h0, 4'b1011, 4'h2, 0,1,0,0, "SHL 9     ");
        check(4'hC, 4'h0, 4'b1100, 4'h6, 0,0,0,0, "SHR C     ");
        check(4'h8, 4'h0, 4'b1101, 4'hC, 0,0,0,1, "ASR 8     ");

        // PASS test
        $display("--- PASS ---");
        check(4'h7, 4'h0, 4'b1111, 4'h7, 0,0,0,0, "PASS 7    ");

        $display("===========================================");
        $display("TOTAL: %0d  PASSED: %0d  FAILED: %0d",
                  total, passed, failed);
        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILURES FOUND - CHECK ABOVE");
        $display("===========================================");
        $finish;
    end

endmodule
