// Full Adder Testbench
// Tests all 8 possible input combinations
// Checks sum and carry against expected values

`timescale 1ns/1ps

module tb_full_adder;

    // Declare test inputs as reg (driven by testbench)
    reg a, b, cin;
    
    // Declare outputs as wire (driven by DUT)
    wire sum, cout;
    
    // Connect DUT
    full_adder dut (
        .a   (a),
        .b   (b),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );

    // Create waveform file for GTKWave
    initial begin
        $dumpfile("waves/full_adder.vcd");
        $dumpvars(0, tb_full_adder);
    end

    // Test all combinations
    integer pass_count;
    integer fail_count;
    
    initial begin
        pass_count = 0;
        fail_count = 0;
        
        $display("===========================================");
        $display("      FULL ADDER TEST RESULTS");
        $display("===========================================");
        $display("A  B  Cin | Sum Cout | Status");
        $display("----------|---------|-------");

        // Test case 0: 0+0+0 = 0, carry 0
        a=0; b=0; cin=0; #10;
        if (sum==0 && cout==0) begin
            $display("0  0   0  |  0    0  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("0  0   0  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        // Test case 1: 0+0+1 = 1, carry 0
        a=0; b=0; cin=1; #10;
        if (sum==1 && cout==0) begin
            $display("0  0   1  |  1    0  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("0  0   1  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        // Test case 2: 0+1+0 = 1, carry 0
        a=0; b=1; cin=0; #10;
        if (sum==1 && cout==0) begin
            $display("0  1   0  |  1    0  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("0  1   0  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        // Test case 3: 0+1+1 = 0, carry 1
        a=0; b=1; cin=1; #10;
        if (sum==0 && cout==1) begin
            $display("0  1   1  |  0    1  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("0  1   1  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        // Test case 4: 1+0+0 = 1, carry 0
        a=1; b=0; cin=0; #10;
        if (sum==1 && cout==0) begin
            $display("1  0   0  |  1    0  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("1  0   0  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        // Test case 5: 1+0+1 = 0, carry 1
        a=1; b=0; cin=1; #10;
        if (sum==0 && cout==1) begin
            $display("1  0   1  |  0    1  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("1  0   1  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        // Test case 6: 1+1+0 = 0, carry 1
        a=1; b=1; cin=0; #10;
        if (sum==0 && cout==1) begin
            $display("1  1   0  |  0    1  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("1  1   0  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        // Test case 7: 1+1+1 = 1, carry 1
        a=1; b=1; cin=1; #10;
        if (sum==1 && cout==1) begin
            $display("1  1   1  |  1    1  | PASS");
            pass_count = pass_count + 1;
        end else begin
            $display("1  1   1  |  %b    %b  | FAIL", sum, cout);
            fail_count = fail_count + 1;
        end

        $display("===========================================");
        $display("PASSED: %0d  FAILED: %0d", pass_count, fail_count);
        
        if (fail_count == 0)
            $display("ALL TESTS PASSED - FULL ADDER IS CORRECT");
        else
            $display("SOME TESTS FAILED - CHECK YOUR CODE");
        
        $display("===========================================");
        $finish;
    end

endmodule
