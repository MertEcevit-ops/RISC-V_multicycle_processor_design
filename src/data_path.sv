//------------------------------------------------------------------------------
// data_path.sv
//------------------------------------------------------------------------------

module data_path (
	input  logic        clk,
	input  logic        reset,
  
	// control inputs
	input  logic [2:0]  imm_src,
	input  logic [3:0]  alu_control,
	input  logic [1:0]  result_src,
	input  logic        ir_write,
	input  logic        reg_write,
	input  logic [1:0]  alu_src_a,
	input  logic [1:0]  alu_src_b,
	input  logic        adr_src,
	input  logic        pc_write,
	input  logic        add_sub_mode,
  
	// data‐memory interface
	input  logic [31:0] read_data,
  
	// status flags out
	output logic        zero,
	output logic        cout,      // tied off
	output logic        overflow,  // tied off
	output logic        sign,      // tied off
  
	// datapath outputs
	output logic [31:0] adr,
	output logic [31:0] write_data,
	output logic [31:0] instr
  );
  
	// internal nets
	logic [31:0] result, alu_out, alu_result;
	logic [31:0] rd1, rd2, A, src_a, src_b, data;
	logic [31:0] imm_ext;
	logic [31:0] pc, old_pc;
  
	// tie off unused flags
	assign cout     = 1'b0;
	assign overflow = 1'b0;
	assign sign     = 1'b0;
  
	// dummy wires for ALU comparisons
	logic greater_unused, less_unused, u_greater_unused, u_less_unused;
  
	// PC register
// Program Counter register
	pc u_pc (
		.pc_next (result),   // next-PC is the write-back result
		.clk     (clk),
		.rst     (reset),    // active-low reset
		.pc_out  (pc)        // drives your internal `pc` signal
	  );
	  
  
	// IR register
	flopenr #(.WIDTH(32)) u_ir_ff (
	  .clk   (clk),
	  .reset (reset),
	  .en    (ir_write),
	  .d     (read_data),
	  .q     (instr)
	);
  
	// register file
	reg_file u_rf (
	  .clk  (clk),
	  .rst  (reset),
	  .we3  (reg_write),
	  .a1   (instr[19:15]),
	  .a2   (instr[24:20]),
	  .a3   (instr[11:7]),
	  .wd3  (result),
	  .rd1  (rd1),
	  .rd2  (rd2)
	);
  
	// pipeline read-data → A, and RD2 → write_data
	flopr #(.WIDTH(32)) u_regA_ff (
	  .clk   (clk),
	  .reset (reset),
	  .d     (rd1),
	  .q     (A)
	);
	flopr #(.WIDTH(32)) u_regB_ff (
	  .clk   (clk),
	  .reset (reset),
	  .d     (rd2),
	  .q     (write_data)
	);
  
	// immediate extension
	extend u_ext (
	  .instr   (instr[31:7]),
	  .imm_src (imm_src),
	  .imm_ext (imm_ext)
	);
  
	// ALU source muxes
	mux3 #(.WIDTH(32)) u_mux_src_a (
	  .d0 (pc),
	  .d1 (old_pc),
	  .d2 (A),
	  .s  (alu_src_a),
	  .y  (src_a)
	);
	mux3 #(.WIDTH(32)) u_mux_src_b (
	  .d0 (write_data),
	  .d1 (imm_ext),
	  .d2 (32'd4),
	  .s  (alu_src_b),
	  .y  (src_b)
	);
  
	// ALU instance
	alu u_alu (
	  .A            (src_a),
	  .B            (src_b),
	  .alu_control  (alu_control),
	  .add_sub_mode (add_sub_mode),
	  .alu_result   (alu_result),
	  .zero         (zero),
	  .greater      (greater_unused),
	  .less         (less_unused),
	  .u_greater    (u_greater_unused),
	  .u_less       (u_less_unused)
	);
  
	// pipeline ALU result
	flopr #(.WIDTH(32)) u_alu_ff (
	  .clk   (clk),
	  .reset (reset),
	  .d     (alu_result),
	  .q     (alu_out)
	);
  
	// write-back mux
	mux4 #(.WIDTH(32)) u_mux_wb (
	  .d0 (alu_out),
	  .d1 (data),
	  .d2 (alu_result),
	  .d3 (imm_ext),
	  .s  (result_src),
	  .y  (result)
	);
  
	// address mux
	mux2 #(.WIDTH(32)) u_mux_adr (
	  .d0 (pc),
	  .d1 (result),
	  .s  (adr_src),
	  .y  (adr)
	);
  
	// pipeline old_pc & data
	flopenr #(.WIDTH(32)) u_oldpc_ff (
	  .clk   (clk),
	  .reset (reset),
	  .en    (ir_write),
	  .d     (pc),
	  .q     (old_pc)
	);
	flopenr #(.WIDTH(32)) u_data_ff (
	  .clk   (clk),
	  .reset (reset),
	  .en    (ir_write),
	  .d     (read_data),
	  .q     (data)
	);
  
  endmodule
  