module instrDec ( input logic [6:0] op,
						output logic [2:0] imm_src);

	always_comb begin
	
		case(op)
		7'b0110011: imm_src = 3'b000;
		7'b0010011: imm_src = 3'b000;
		7'b0000011: imm_src = 3'b000;
		7'b0100011: imm_src = 3'b001;
		7'b1100011:	imm_src = 3'b010;
		7'b1101111: imm_src = 3'b011;
		7'b0010111: imm_src = 3'b100;
		7'b0110111: imm_src = 3'b100;
		7'b1100111: imm_src = 3'b000;
		default: imm_src = 3'bx;
		endcase
	
	end
						
						
endmodule
