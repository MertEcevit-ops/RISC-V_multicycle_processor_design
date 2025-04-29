#————————————————————————————————————————————————————————————————————
# List all of your design sources (in project root)
SV_FILES := \
  adder_sub.sv        \
  alu.sv              \
  alu_dec.sv          \
  and_gate.sv         \
  arithmetic_right.sv \
  branch_dec.sv       \
  CLZ.sv              \
  comp.sv             \
  comp_sign.sv        \
  controller.sv       \
  CPOP.sv             \
  CTZ.sv              \
  data_path.sv        \
  extend.sv           \
  equal.sv            \
  FA.sv               \
  flopenr.sv          \
  flopr.sv            \
  fsm.sv              \
  instr_dec.sv        \
  logical_left.sv     \
  logical_right.sv    \
  memory.sv           \
  mux2.sv             \
  mux3.sv             \
  mux4.sv             \
  pc.sv               \
  RCA.sv              \
  reg_file.sv         \
  riscv_pkg.sv        \
  riscv_multicycle.sv \
  xor_gate.sv

# Single testbench in project root
TB_FILES := \
  tb.sv

ALL_FILES := $(SV_FILES) $(TB_FILES)

#————————————————————————————————————————————————————————————————————
.PHONY: lint build run wave clean

# Lint-only target
lint:
	@echo ">>> Verilator lint-only check"
	verilator \
	  --lint-only \
	  -Wall --timing \
	  -Wno-UNUSED -Wno-MULTIDRIVEN -Wno-CASEINCOMPLETE \
	  $(ALL_FILES)

# Build simulator
build:
	@echo ">>> Building simulator"
	verilator \
	  --binary \
	  --top-module tb \
	  -j0 \
	  --trace \
	  -Wno-CASEINCOMPLETE -Wno-MULTIDRIVEN \
	  $(SV_FILES) $(TB_FILES)

# Run simulation
run: build
	@echo ">>> Running simulator"
	./obj_dir/Vtb

# View waveform
wave: run
	@echo ">>> Launching GTKWave"
	gtkwave --dark dump.vcd

# Clean up build artefacts
clean:
	@echo ">>> Cleaning"
	rm -rf obj_dir/ dump.vcd
