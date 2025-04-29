//------------------------------------------------------------------------------
// core_model.sv
//------------------------------------------------------------------------------
module core_model #(
  parameter XLEN = 32
)(
  // external IF interface
  input  logic             clk_i,
  input  logic             rstn_i,
  input  logic [XLEN-1:0]  addr_i,
  output logic [XLEN-1:0]  data_o,

  // retirement outputs
  output logic             update_o,
  output logic [XLEN-1:0]  pc_o,
  output logic [XLEN-1:0]  instr_o,
  output logic [4:0]       reg_addr_o,
  output logic [XLEN-1:0]  reg_data_o,

  // data-memory interface
  output logic [XLEN-1:0]  mem_addr_o,
  output logic [XLEN-1:0]  mem_data_o,
  output logic             mem_wrt_o
);

  // internal datapath signals
  logic [XLEN-1:0] pc, instr;
  logic [XLEN-1:0] alu_a_in, alu_b_in, alu_result;
  logic [XLEN-1:0] pc_plus4, imm_ext, mem_rdata;
  logic [XLEN-1:0] rd2, wb_data;
  logic [31:7]     instr_ext;
  logic [4:0]      rs1, rs2, rd;
  logic [6:0]      opcode;
  logic [2:0]      funct3, imm_src;
  logic            funct7b5;
  logic [1:0]      alu_src_a, alu_src_b, result_src;
  logic            adr_src, ir_write, pc_write, reg_write, mem_write;
  logic [3:0]      alu_control;
  logic            zero;

  // flags for controller
  logic cout, overflow, sign;
  assign cout     = 1'b0;
  assign overflow = 1'b0;
  assign sign     = 1'b0;

  // dummy wires for ALU’s comparison outputs
  logic greater_unused, less_unused, u_greater_unused, u_less_unused;

  // field extraction
  assign instr_ext = instr[31:7];
  assign rs1       = instr[19:15];
  assign rs2       = instr[24:20];
  assign rd        = instr[11:7];
  assign opcode    = instr[6:0];
  assign funct3    = instr[14:12];
  assign funct7b5  = instr[30];
  assign pc_plus4  = pc + 32'd4;

  // retirement outputs
  assign pc_o       = pc;
  assign instr_o    = instr;
  assign reg_addr_o = rd;
  assign reg_data_o = wb_data;
  assign mem_addr_o = alu_result;
  assign mem_data_o = rd2;
  assign mem_wrt_o  = mem_write;
  assign update_o   = pc_write;

  // controller instantiation (now driving cout/overflow/sign)
  controller u_controller (
    .clk         (clk_i),
    .reset       (rstn_i),
    .op          (opcode),
    .funct3      (funct3),
    .funct7b5    (funct7b5),
    .zero        (zero),
    .cout        (cout),
    .overflow    (overflow),
    .sign        (sign),

    .imm_src     (imm_src),
    .alu_src_a   (alu_src_a),
    .alu_src_b   (alu_src_b),
    .result_src  (result_src),
    .adr_src     (adr_src),
    .alu_control (alu_control),
    .ir_write    (ir_write),
    .pc_write    (pc_write),
    .reg_write   (reg_write),
    .mem_write   (mem_write)
  );

  // PC register
// Program Counter register
  pc u_pc (
    .pc_next (alu_result),  // next-PC is ALU result
    .clk     (clk_i),
    .rst     (rstn_i),      // active-low reset
    .pc_out  (pc)           // drives the internal `pc`
  );
  

  // Instruction register
  flopenr #(.WIDTH(XLEN)) u_ir_reg (
    .clk   (clk_i),
    .reset (rstn_i),
    .en    (ir_write),
    .d     (mem_rdata),
    .q     (instr)
  );

  // unified instruction + data memory
  memory u_memory (
    .clk (clk_i),
    .we  (mem_write),
    .a   (addr_i),
    .wd  (rd2),
    .rd  (mem_rdata)
  );
  assign data_o = mem_rdata;

  // register file
  reg_file u_reg_file (
    .clk  (clk_i),
    .rst  (rstn_i),
    .we3  (reg_write),
    .a1   (rs1),
    .a2   (rs2),
    .a3   (rd),
    .wd3  (wb_data),
    .rd1  (alu_a_in),
    .rd2  (rd2)
  );

  // immediate extender
  extend u_extend (
    .instr   (instr_ext),
    .imm_src (imm_src),
    .imm_ext (imm_ext)
  );

  // ALU operand A mux
  mux2 #(.WIDTH(XLEN)) u_mux_alu_a (
    .d0 (pc),
    .d1 (alu_a_in),
    .s  (alu_src_a[0]),
    .y  (alu_a_in)
  );

  // ALU operand B mux
  mux3 #(.WIDTH(XLEN)) u_mux_alu_b (
    .d0 (rd2),
    .d1 (imm_ext),
    .d2 (pc_plus4),
    .s  (alu_src_b),
    .y  (alu_b_in)
  );

  // ALU (all outputs hooked up)
  alu u_alu (
    .A            (alu_a_in),
    .B            (alu_b_in),
    .alu_control  (alu_control),
    .add_sub_mode (funct7b5),
    .alu_result   (alu_result),
    .zero         (zero),
    .greater      (greater_unused),
    .less         (less_unused),
    .u_greater    (u_greater_unused),
    .u_less       (u_less_unused)
  );

  // write-back mux
  mux4 #(.WIDTH(XLEN)) u_mux_wb (
    .d0 (alu_result),
    .d1 (mem_rdata),
    .d2 (pc_plus4),
    .d3 (imm_ext),
    .s  (result_src),
    .y  (wb_data)
  );

endmodule
