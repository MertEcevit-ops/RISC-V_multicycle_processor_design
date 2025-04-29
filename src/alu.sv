//------------------------------------------------------------------------------
//  alu.sv
//------------------------------------------------------------------------------
module alu (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  alu_control,
    input  logic        add_sub_mode,
    output logic [31:0] alu_result,
    output logic        zero,
    output logic        greater,
    output logic        less,
    output logic        u_greater,
    output logic        u_less
);

    // intermediate results
    logic [31:0] adder_sub_result, and_result, or_result, xor_result;
    logic [31:0] sll_result, srl_result, sra_result;
    logic [31:0] CTZ, CLZ, CPOP;

    // --- bitwise AND (module port is lowercase a,b,result) ---
    and_gate u_and_gate (
        .a      (A),
        .b      (B),
        .result (and_result)
    );

    // --- bitwise OR (module port is lowercase a,b,result) ---
    or_gate u_or_gate (
        .a      (A),
        .b      (B),
        .result (or_result)
    );

    // --- bitwise XOR (module port is lowercase a,b,result) ---
    xor_gate u_xor_gate (
        .a      (A),
        .b      (B),
        .result (xor_result)
    );

    // --- adder/subtractor (ports are A,B,Mode,result,Cout) ---
    adder_sub u_adder_sub (
        .A      (A),
        .B      (B),
        .Mode   (add_sub_mode),
        .result (adder_sub_result)
        // removed ".Cout()" since you weren’t using it
    );

    // --- logical shift left (ports A,B,result) ---
    logical_left u_sll (
        .A      (A),
        .B      (B),
        .result (sll_result)
    );

    // --- logical shift right (ports A,B,result) ---
    logical_right u_srl (
        .A      (A),
        .B      (B),
        .result (srl_result)
    );

    // --- arithmetic shift right (ports A,B,Result) ---
    arithmetic_right u_sra (
        .A      (A),
        .B      (B),
        .Result (sra_result)  // uppercase 'Result' matches the module
    );

    // --- equality comparator (ports A,B,branch_equal) ---
    equal u_eq (
        .A            (A),
        .B            (B),
        .branch_equal (zero)
    );

    // --- unsigned compare (ports A,B,branch_less,branch_greater) ---
    comp u_comp (
        .A             (A),
        .B             (B),
        .branch_less   (u_less),
        .branch_greater(u_greater)
    );

    // --- signed compare (ports A,B,branch_less,branch_greater) ---
    comp_sign u_comp_sign (
        .A             (A),
        .B             (B),
        .branch_less   (less),
        .branch_greater(greater)
    );

    // --- count trailing zeros (ports A,CTZ) ---
    CTZ u_ctz (
        .A   (A),
        .CTZ (CTZ)
    );

    // --- count leading zeros (ports A,CLZ) ---
    CLZ u_clz (
        .A   (A),
        .CLZ (CLZ)
    );

    // --- popcount (ports A,CPOP) ---
    CPOP u_cpop (
        .A    (A),
        .CPOP (CPOP)
    );

    // final ALU multiplexer
    always_comb begin
        case (alu_control)
            4'b0000: alu_result = adder_sub_result; // ADD
            4'b0001: alu_result = adder_sub_result; // SUB
            4'b0010: alu_result = and_result;       // AND
            4'b0011: alu_result = or_result;        // OR
            4'b0100: alu_result = xor_result;       // XOR
            4'b0101: alu_result = sll_result;       // SLL
            4'b0110: alu_result = srl_result;       // SRL
            4'b0111: alu_result = sra_result;       // SRA
            4'b1000: alu_result = 32'd1;            // set-less
            4'b1001: alu_result = 32'd0;            // not-less
            4'b1010: alu_result = CTZ;              // CTZ
            4'b1011: alu_result = CLZ;              // CLZ
            4'b1100: alu_result = CPOP;             // CPOP
            default: alu_result = 32'd0;
        endcase
    end

endmodule
