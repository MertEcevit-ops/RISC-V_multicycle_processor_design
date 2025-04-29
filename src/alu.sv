module alu (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [3:0] alu_control,
    input logic add_sub_mode,
    output logic [31:0] alu_result,
    output logic zero, greater, less, u_greater, u_less
);

    logic [31:0] adder_sub_result, sub_result, and_result, or_result, xor_result;
    logic [31:0] sll_result, srl_result, sra_result, CTZ, CLZ, CPOP;

    
    and and_gate (
        .A(A),
        .B(B),
        .result(and_result)
    );

    or or_gate (
        .A(A),
        .B(B),
        .result(or_result)
    );

    xor xor_gate (
        .A(A),
        .B(B),
        .result(xor_result)
    );

    adder_sub addsub_gate (
        .A(A),
        .B(B),
        .Mode(add_sub_mode),
        .result(adder_sub_result),
        .Cout()
    );

    logical_left sll_gate (
        .A(A),
        .B(B),
        .result(sll_result)
    );

    logical_right srl_gate (
        .A(A),
        .B(B),
        .result(srl_result)
    );

    arithmetic_right sra_gate (
        .A(A),
        .B(B),
        .result(sra_result)
    );

    equal eq_gate (
        .A(A),
        .B(B),
        .branch_equal(zero)
    );

    comp comp_gate (
        .A(A),
        .B(B),
        .branch_less(u_less),
        .branch_greater(u_greater)
    );

    comp_sign comp_signed_gate (
        .A(A),
        .B(B),
        .branch_less(less),
        .branch_greater(greater)
    );

    CTZ ctz_gate (
        .A(A),
        .CTZ(CTZ)
    );

    CLZ clz_gate (
        .A(A),
        .CLZ(CLZ)
    );

    CPOP cpop_gate (
        .A(A),
        .CPOP(CPOP)
    );

    always_comb begin
        case (alu_control)
            4'b0000: alu_result = adder_sub_result; // ADD
            4'b0001: alu_result = adder_sub_result; // SUB
            4'b0010: alu_result = and_result; // AND
            4'b0011: alu_result = or_result;  // OR
            4'b0100: alu_result = xor_result; // XOR
            4'b0101: alu_result = sll_result; // SLL
            4'b0110: alu_result = srl_result; // SRL
            4'b0111: alu_result = sra_result; // SRA
            4'b1000: alu_result = 32'b1; // rs1 is less than rs2
            4'b1001: alu_result = 32'b0; // rs1 is not less than rs2
            4'b1010: alu_result = CTZ; // CTZ
            4'b1011: alu_result = CLZ; // CLZ
            4'b1100: alu_result = CPOP; // CPOP
            default: alu_result = 32'b0;
        endcase
    end

endmodule
