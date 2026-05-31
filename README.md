# 4-Bit ALU VLSI Project

A complete 4-bit Arithmetic Logic Unit designed in Verilog HDL
with full verification and synthesis.

## Features
- 16 operations: ADD SUB INC DEC AND OR XOR NOT NAND NOR XNOR SHL SHR ASR CMP PASS
- Status flags: Zero Carry Overflow Negative
- Fully verified with 4096 exhaustive test cases
- Synthesized with Yosys

## Project Structure
- rtl/modules/  - Individual building blocks
- rtl/top/      - Top level ALU integration
- tb/unit/      - Unit testbenches
- tb/integration/ - Full integration test
- syn/          - Synthesis scripts and output
- waves/        - Simulation waveforms
- docs/         - Documentation and results

## How to Run
Install tools: iverilog verilator yosys gtkwave

Run all tests:
  make all

Run just simulation:
  make sim_unit

View waveforms:
  make wave_alu

Run synthesis:
  make syn

## Results
- 4096 out of 4096 tests passed
- 62 logic gates after synthesis
- Critical path: 4 full adder delays

## What I Learned
- Binary arithmetic and 2s complement
- Verilog RTL design methodology
- Hierarchical module design
- Testbench writing and verification
- Synthesis with Yosys
- Reading timing and area reports
