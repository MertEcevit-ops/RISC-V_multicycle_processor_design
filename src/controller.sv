module controller(input logic clk,
						input logic reset,
						input logic [6:0] op,
						input logic [2:0] funct3,
						input logic funct7b5,
						input logic zero, cout, overflow, sign,
						output logic [2:0] imm_src,
						output logic [1:0] alu_src_a, alu_src_b,
						output logic [1:0] result_src,
						output logic adr_src,
						output logic [3:0] alu_control,
						output logic ir_write, pc_write,
						output logic reg_write, mem_write);
						
	logic beq, bne, blt, bge, bltu, bgeu, branch, pc_update;
	logic [1:0] alu_op;
	
	fsm MainFSM(clk, reset, op, branch, pc_update, reg_write, 
					mem_write, ir_write, result_src, alu_src_b, alu_src_a, adr_src, alu_op);
	alu_dec AluDecoder(alu_op, op[5], funct7b5, funct3, alu_control);
	instr_dec InstrDecoder(op, imm_src);
	branch_dec BranchDecoder(op, funct3, branch, beq, bne, blt, bge, bltu, bgeu); 
	
	assign pc_write = (beq & zero) | (bne & ~zero) | (bgeu & cout) | (bltu & ~cout) 
	| (bge & (sign == overflow)) | (blt & (sign != overflow)) | pc_update;
	
	
	
endmodule
