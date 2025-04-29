module alu_dec (input logic [1:0] alu_op,
					input logic op5, funct7b5,
					input logic [2:0] funct3,
					output logic [3:0] alu_control);

	always_comb begin
	
		case(alu_op)
		2'b00: alu_control = 4'b0000;
		2'b01: alu_control = 4'b0001;
		2'b10: case (funct3)
					3'b000: if({op5, funct7b5} == 2'b11)
									alu_control = 4'b0001;
							  else
									alu_control = 4'b0000;
					3'b001: // sll
							  alu_control = 4'b0111;
					3'b010: alu_control = 4'b0101;
					3'b011:// sltu
							  alu_control = 4'b1000;
					3'b100:// xor
							  alu_control = 4'b1001;
					3'b101: if(funct7b5) // sra
									alu_control = 4'b0100;
							  else // srl
									alu_control = 4'b0110;
					3'b110: alu_control = 4'b0011;
					3'b111: alu_control = 4'b0010;
					default: alu_control = 4'bx;
				 endcase
		default: alu_control = 4'bx;
		endcase
	end

endmodule 