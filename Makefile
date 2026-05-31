# 4-Bit ALU Project Makefile
# Run 'make help' to see all commands

IVERILOG = iverilog
VVP      = vvp
YOSYS    = yosys

RTL_FILES = rtl/modules/full_adder.v \
            rtl/modules/adder_4bit.v \
            rtl/modules/logic_unit.v \
            rtl/modules/shift_unit.v \
            rtl/top/alu_4bit.v

all: lint sim_fa sim_unit sim_exh syn
	@echo "ALL FLOWS COMPLETE"

lint:
	verilator --lint-only --top-module alu_4bit $(RTL_FILES)
	@echo "Lint check done"

sim_fa:
	$(IVERILOG) -o sim/fa_sim $(RTL_FILES) tb/unit/tb_full_adder.v
	$(VVP) sim/fa_sim

sim_unit:
	$(IVERILOG) -o sim/alu_unit_sim $(RTL_FILES) tb/unit/tb_alu_unit.v
	$(VVP) sim/alu_unit_sim

sim_exh:
	$(IVERILOG) -o sim/alu_exh_sim $(RTL_FILES) tb/integration/tb_alu_complete.v
	$(VVP) sim/alu_exh_sim

wave_fa:
	gtkwave waves/full_adder.vcd &

wave_alu:
	gtkwave waves/alu_unit.vcd &

wave_exh:
	gtkwave waves/alu_complete.vcd &

syn:
	$(YOSYS) syn/synthesize.ys

schematic:
	netlistsvg syn/netlists/alu_4bit.json -o docs/results/schematic.svg
	@echo "Schematic saved to docs/results/schematic.svg"

clean:
	rm -f sim/*.sim sim/*.vvp
	rm -f waves/*.vcd
	@echo "Clean done"

help:
	@echo "make all        - Run everything"
	@echo "make lint       - Check code quality"
	@echo "make sim_fa     - Test full adder"
	@echo "make sim_unit   - Run unit tests"
	@echo "make sim_exh    - Run all 4096 tests"
	@echo "make wave_fa    - View full adder waves"
	@echo "make wave_alu   - View ALU unit waves"
	@echo "make syn        - Synthesize design"
	@echo "make schematic  - Generate circuit diagram"
	@echo "make clean      - Remove generated files"
