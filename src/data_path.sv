module data_path (
    input  logic        clk,
    input  logic        reset,

    // control signals from controller
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

    // data memory read port
    input  logic [31:0] read_data,

    // status flags out
    output logic        zero,
    output logic        cout,      // carry-out from adder
    output logic        overflow,  // not currently driven—tie low?
    output logic        sign,      // not currently driven—tie low?

    // writebacks / retire
    output logic [31:0] adr,
    output logic [31:0] write_data,
    output logic [31:0] instr
);

    //==========================================================================
    // Internal signals
    //==========================================================================
    logic [31:0] result, alu_out, alu_result;
    logic [31:0] rd1, rd2, A, src_a, src_b, data;
    logic [31:0] imm_ext;
    logic [31:0] pc, old_pc;

    //==========================================================================
    // PC register (with enable=pc_write)
    //==========================================================================
    flopenr #(.WIDTH(32)) u_pc_ff (
        .clk   (clk),
        .reset (reset),
        .en    (pc_write),
        .d     (result),
        .q     (pc)
    );

    //==========================================================================
    // Instruction register (with enable=ir_write)
    //==========================================================================
    flopenr #(.WIDTH(32)) u_ir_ff (
        .clk   (clk),
        .reset (reset),
        .en    (ir_write),
        .d     (read_data),
        .q     (instr)
    );

    //==========================================================================
    // Register file
    //==========================================================================
    reg_file u_rf (
        .clk   (clk),
        .rst   (reset),
        .we3   (reg_write),
        .a1    (instr[19:15]),  // rs1
        .a2    (instr[24:20]),  // rs2
        .a3    (instr[11:7]),   // rd
        .wd3   (result),        // write-back data
        .rd1   (rd1),
        .rd2   (rd2)
    );

    // pipeline rd1→A and rd2→write_data (two flops)
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

    //==========================================================================
    // Immediate extension
    //==========================================================================
    extend u_ext (
        .instr     (instr[31:7]),
        .imm_src   (imm_src),
        .imm_ext   (imm_ext)
    );

    //==========================================================================
    // ALU source --3:1 MUXes
    //==========================================================================
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

    //==========================================================================
    // ALU instance (now named-port mapped, all pins covered)
    //==========================================================================
    alu u_alu (
        .A            (src_a),
        .B            (src_b),
        .alu_control  (alu_control),
        .add_sub_mode (add_sub_mode),
        .alu_result   (alu_result),
        .zero         (zero),
        .greater      (),         // unused here
        .less         (),         // unused
        .u_greater    (),         // unused
        .u_less       (),         // unused
        .cout         (cout)      // if your alu-gate provides carry
        // .overflow and .sign are not driven by alu—tie off or wire in adder_sub
    );

    // pipeline alu_result→alu_out
    flopr #(.WIDTH(32)) u_alu_ff (
        .clk   (clk),
        .reset (reset),
        .d     (alu_result),
        .q     (alu_out)
    );

    //==========================================================================
    // Write-back MUX (4→1)
    //==========================================================================
    mux4 #(.WIDTH(32)) u_mux_wb (
        .d0 (alu_out),
        .d1 (data),
        .d2 (alu_result),
        .d3 (imm_ext),
        .s  (result_src),
        .y  (result)
    );

    //==========================================================================
    // Data-memory pipeline & address MUX
    //==========================================================================
    mux2 #(.WIDTH(32)) u_mux_adr (
        .d0 (pc),
        .d1 (result),
        .s  (adr_src),
        .y  (adr)
    );

    // pipeline old_pc and data
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
