module data_path (input logic clk, reset,
					  input logic [2:0] imm_src, 
					  input logic [3:0] alu_control, 
					  input logic [1:0] result_src, 
					  input logic ir_write,
					  input logic reg_write,
					  input logic [1:0] alu_src_a, alu_src_b, 
					  input logic adr_src, 
					  input logic pc_write,  
					  input logic [31:0] read_data,
					  output logic zero, cout, overflow, sign, 
					  output logic [31:0] adr, 
					  output logic [31:0] write_data,
					  output logic [31:0] instr);

		 
logic [31:0] result , alu_out, alu_result;
logic [31:0] rd1, rd2, A , src_a, src_b, data;
logic [31:0] imm_ext;
logic [31:0] pc, old_pc;


//pc
flopenr #(32) pcFlop(clk, reset, pc_write, result, pc);


//reg_file
reg_file rf(clk, reg_write, instr[19:15], instr[24:20], instr[11:7], result, rd1, rd2); 
extend ext(instr[31:7], imm_src, imm_ext);
flopr #(32) regF( clk, reset, rd1, A);
flopr #(32) regF_2( clk, reset, rd2, write_data);


//alu
mux3 #(32) src_amux(pc, old_pc, A, alu_src_a, src_a);
mux3 #(32) src_bmux(write_data, imm_ext, 32'd4, alu_src_b, src_b);
alu alu(src_a, src_b, alu_control, alu_result, zero, cout, overflow, sign);
flopr #(32) aluReg (clk, reset, alu_result, alu_out);
mux4 #(32) resultMux(alu_out, data, alu_result, imm_ext, result_src, result );

//mem
mux2 #(32) adrMux(pc, result, adr_src, adr);
flopenr #(32) memFlop1(clk, reset, ir_write, pc, old_pc); 
flopenr #(32) memFlop2(clk, reset, ir_write, read_data, instr);
flopr #(32) memdataFlop(clk, reset, read_data, data);

endmodule
