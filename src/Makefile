#————————————————————————————————————————————————————————————————————
# All of your design sources
SV_FILES := \
  src/adder_sub.sv        \
  src/alu.sv              \
  src/alu_dec.sv          \
  src/and.sv              \
  src/arithmetic_right.sv \
  src/branch_dec.sv       \
  src/CLZ.sv              \
  src/comp.sv             \
  src/comp_sign.sv        \
  src/controller.sv       \
  src/core_model.sv       \
  src/CPOP.sv             \
  src/CTZ.sv              \
  src/data_path.sv        \
  src/extend.sv           \
  src/flopenr.sv          \
  src/flopr.sv            \
  src/fsm.sv              \
  src/instr_dec.sv        \
  src/logical_left.sv     \
  src/logical_right.sv    \
  src/memory.sv           \
  src/mux2.sv             \
  src/mux3.sv             \
  src/mux4.sv             \
  src/pc.sv               \
  src/reg_file.sv         \
  src/pkg/riscv_pkg.sv    \
  src/top.sv              \
  src/xor.sv

# Your testbench(s)
TB_FILES := \
  tb/tb.sv

ALL_FILES := $(SV_FILES) $(TB_FILES)

#————————————————————————————————————————————————————————————————————
# Lint-only
.PHONY: lint
lint:
	@echo ">>> Verilator lint-only check"
	verilator \
	  --lint-only \
	  -Wall --timing \
	  -Wno-UNUSED -Wno-MULTIDRIVEN -Wno-CASEINCOMPLETE \
	  $(ALL_FILES)

# Build the simulator
.PHONY: build
build:
	@echo ">>> Building with Verilator"
	verilator \
	  --binary \
	  --top-module tb \
	  -j0 \
	  --trace \
	  -Wno-CASEINCOMPLETE -Wno-MULTIDRIVEN \
	  $(ALL_FILES)

# Run the sim
.PHONY: run
run: build
	@echo ">>> Running sim"
	./obj_dir/Vtb

# Launch waveform
.PHONY: wave
wave: run
	@echo ">>> Launching GTKWave"
	gtkwave --dark dump.vcd

# Clean up
.PHONY: clean
clean:
	@echo ">>> Cleaning"
	rm -rf obj_dir/ dump.vcd

#————————————————————————————————————————————————————————————————————
