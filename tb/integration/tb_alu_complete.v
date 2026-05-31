// Complete ALU Integration Testbench
// Tests all 4096 input combinations exhaustively
// Computes expected result in testbench and compares

`timescale 1ns/1ps

module tb_alu_complete;

    reg  [3:0] a, b, opcode;
    wire [3:0] result;
    wire       zero, carry, overflow, negative;

    integer total  = 0;
    integer passed = 0;
    integer failed = 0;
    integer i, va, vb;

    alu_4bit dut (
        .a(a), .b(b), .opcode(opcode),
        .result(result), .zero(zero),
        .carry(carry), .overflow(overflow),
        .negative(negative)
    );

    initial begin
        $dumpfile("waves/alu_complete.vcd");
        $dumpvars(0, tb_alu_complete);
    end

    // Compute expected result for given inputs
    reg [3:0] exp_result;
    reg       exp_zero, exp_carry, exp_overflow, exp_negative;
    reg [4:0] wide;  // 5-bit for carry detection

    task compute_expected;
        begin
            exp_result   = 4'b0;
            exp_zero     = 1'b0;
            exp_carry    = 1'b0;
            exp_overflow = 1'b0;
            exp_negative = 1'b0;

            case (opcode)
                4'b0000: begin  // ADD
                    wide         = {1'b0,a} + {1'b0,b};
                    exp_result   = wide[3:0];
                    exp_carry    = wide[4];
                    exp_overflow = (~a[3]&~b[3]&wide[3]) | (a[3]&b[3]&~wide[3]);
                end
                4'b0001: begin  // SUB
                    wide         = {1'b0,a} - {1'b0,b};
                    exp_result   = wide[3:0];
                    exp_carry    = ~wide[4];
                    exp_overflow = (a[3]&~b[3]&~wide[3]) | (~a[3]&b[3]&wide[3]);
                end
                4'b0010: begin  // INC
                    wide         = {1'b0,a} + 5'd1;
                    exp_result   = wide[3:0];
                    exp_carry    = wide[4];
                    exp_overflow = (~a[3] & wide[3]);
                end
                4'b0011: begin  // DEC
                    wide         = {1'b0,a} - 5'd1;
                    exp_result   = wide[3:0];
                    exp_carry    = ~wide[4];
                    exp_overflow = (a[3] & ~wide[3]);
                end
                4'b0100: exp_result = a & b;
                4'b0101: exp_result = a | b;
                4'b0110: exp_result = a ^ b;
                4'b0111: exp_result = ~a;
                4'b1000: exp_result = ~(a & b);
                4'b1001: exp_result = ~(a | b);
                4'b1010: exp_result = ~(a ^ b);
                4'b1011: begin  // SHL
                    exp_result = {a[2:0], 1'b0};
                    exp_carry  = a[3];
                end
                4'b1100: begin  // SHR
                    exp_result = {1'b0, a[3:1]};
                    exp_carry  = a[0];
                end
                4'b1101: begin  // ASR
                    exp_result = {a[3], a[3:1]};
                    exp_carry  = a[0];
                end
                4'b1110: begin  // CMP
                    wide         = {1'b0,a} - {1'b0,b};
                    exp_result   = wide[3:0];
                    exp_carry    = ~wide[4];
                    exp_overflow = (a[3]&~b[3]&~wide[3]) | (~a[3]&b[3]&wide[3]);
                end
                4'b1111: exp_result = a;
                default: exp_result = 4'b0;
            endcase

            exp_zero     = (exp_result == 4'b0);
            exp_negative = exp_result[3];
        end
    endtask

    initial begin
        $display("===========================================");
        $display("    EXHAUSTIVE ALU TEST - ALL 4096 CASES");
        $display("===========================================");

        // Test every opcode with every A and B combination
        for (i = 0; i < 16; i = i + 1) begin
            for (va = 0; va < 16; va = va + 1) begin
                for (vb = 0; vb < 16; vb = vb + 1) begin
                    opcode = i[3:0];
                    a = va[3:0];
                    b = vb[3:0];
                    #10;

                    compute_expected;

                    total = total + 1;

                    if (result      == exp_result   &&
                        zero        == exp_zero     &&
                        carry       == exp_carry    &&
                        overflow    == exp_overflow &&
                        negative    == exp_negative) begin
                        passed = passed + 1;
                    end else begin
                        $display("FAIL: op=%b a=%h b=%h", opcode, a, b);
                        $display("  Expected: r=%h z=%b c=%b v=%b n=%b",
                                  exp_result, exp_zero, exp_carry,
                                  exp_overflow, exp_negative);
                        $display("  Got:      r=%h z=%b c=%b v=%b n=%b",
                                  result, zero, carry, overflow, negative);
                        failed = failed + 1;
                    end
                end
            end
        end

        $display("===========================================");
        $display("TOTAL: %0d", total);
        $display("PASSED: %0d", passed);
        $display("FAILED: %0d", failed);
        $display("PASS RATE: %0.2f%%", (100.0*passed)/total);
        if (failed == 0)
            $display("PERFECT SCORE - ALL 4096 TESTS PASSED");
        else
            $display("FAILURES FOUND - PLEASE FIX YOUR CODE");
        $display("===========================================");
        $finish;
    end

endmodule
