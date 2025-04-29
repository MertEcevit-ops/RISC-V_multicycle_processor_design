module fsm (input logic clk,rst,
				input logic [6:0] op,
				output logic branch, pc_update, reg_write, mem_write, ir_write,
				output logic [1:0] result_src, alu_src_b, alu_src_a,
				output logic adr_src,
				output logic [1:0] alu_op);
				
	typedef enum logic [3:0] {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13} statetype; // s13 used for error detection
	statetype state, next_state;
	// state register
	always_ff @(posedge clk, posedge rst) begin
		if(rst)
			state <= s0;
		else
			state <= next_state;
	end
	// next_state logic
	always_comb begin
		case(state)
		s0: next_state = s1;
		s1: case(op)
				7'b0110011: next_state = s6;
				7'b0010011: next_state = s8;
				7'b0000011: next_state = s2;
				7'b0100011: next_state = s2;
				7'b1100011:	next_state = s10;
				7'b1101111: next_state = s9;
				7'b0010111: next_state = s11;
				7'b0110111: next_state = s12;
				7'b1100111: next_state = s2;
				default: next_state = s13;
				endcase
		s2: if(op[5]) begin
					if(op[6]) 
						next_state = s9;
					else
						next_state = s5;
				end
			 else
				next_state = s3;
		s3: next_state = s4;
		s4: next_state = s0;
		s5: next_state = s0;
		s6: next_state = s7;
		s7: next_state = s0;
		s8: next_state = s7;
		s9: next_state = s7;
		s10: next_state = s0;
		s11: next_state = s7;
		s12: next_state = s0;
		s13 : next_state = s13;
		endcase
	end
	// output logic
	always_comb begin
		case(state)
		s0: begin
				branch = 1'b0 ; 
				pc_update = 1'b1 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b1 ;
				result_src = 2'b10 ; 
				alu_src_b = 2'b10 ;
				alu_src_a = 2'b00 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
			end
		s1: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b01 ;
				alu_src_a = 2'b01 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
			end
		s2: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b01 ;
				alu_src_a = 2'b10 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
			end
		s3: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b00 ;
				alu_src_a = 2'b00 ;
				adr_src = 1'b1 ;
				alu_op = 2'b00 ;
			end
		s4: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b1 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b01 ; 
				alu_src_b = 2'b00 ;
				alu_src_a = 2'b00 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
			end
		s5: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b1 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b00 ;
				alu_src_a = 2'b00 ;
				adr_src = 1'b1 ;
				alu_op = 2'b00 ;
			end
		s6: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b00 ;
				alu_src_a = 2'b10 ;
				adr_src = 1'b0 ;
				alu_op = 2'b10 ;
			end
		s7: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b1 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b00 ;
				alu_src_a = 2'b00 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
			end
		s8: begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b01 ;
				alu_src_a = 2'b10 ;
				adr_src = 1'b0 ;
				alu_op = 2'b10 ;
			end
		s9: begin
				branch = 1'b0 ; 
				pc_update = 1'b1 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b10 ;
				alu_src_a = 2'b01 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
			end
		s10: begin
				branch = 1'b1 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b00 ;
				alu_src_a = 2'b10 ;
				adr_src = 1'b0 ;
				alu_op = 2'b01 ;
			end
		s11 : begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b0 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b00 ; 
				alu_src_b = 2'b01 ;
				alu_src_a = 2'b01 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
		end
		s12 : begin
				branch = 1'b0 ; 
				pc_update = 1'b0 ; 
				reg_write = 1'b1 ;
				mem_write = 1'b0 ;
				ir_write = 1'b0 ;
				result_src = 2'b11 ; 
				alu_src_b = 2'b00 ;
				alu_src_a = 2'b00 ;
				adr_src = 1'b0 ;
				alu_op = 2'b00 ;
		end
		s13: begin
				branch = 1'bx ; 
				pc_update = 1'bx ; 
				reg_write = 1'bx ;
				mem_write = 1'bx ;
				ir_write = 1'bx ;
				result_src = 2'bx ; 
				alu_src_b = 2'bx ;
				alu_src_a = 2'bx ;
				adr_src = 1'bx ;
				alu_op = 2'bx ;
			end
		endcase
	end
				
				
endmodule 