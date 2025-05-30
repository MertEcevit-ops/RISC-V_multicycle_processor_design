module extend (
    input logic [31:7] instr,
    input logic [2:0] imm_src,
    output logic [31:0] imm_ext
    );
    always_comb begin
        case (imm_src)
            3'b000: imm_ext = {{21{instr[31]}}, {instr[30:20]}}; // I-type
            3'b001: imm_ext = {{21{instr[31]}}, {instr[30:25]}, {instr[11:7]}}; // S-type
            3'b010: imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], {1'b0}}; // B-type
            3'b011: imm_ext = {{instr[31]}, {instr[30:12]}, {12{1'b0}}}; // U-type
            3'b100: imm_ext = {{12{instr[31]}}, {instr[19:12]}, {instr[20]}, {instr[30:21]}, {1'b0}}; // J-type
        endcase
    end
    
endmodule
