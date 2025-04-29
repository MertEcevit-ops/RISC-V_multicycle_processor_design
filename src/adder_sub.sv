module adder_sub(
    input logic [31:0] A, B,
    input logic Mode,
    output logic [31:0] result,
    output logic Cout
);

    logic [31:0] B_xor;
    logic [31:0] S_wire;
    logic Cout_wire;
    logic Mode_wire;
    assign Mode_wire = Mode;

    always_comb begin
        B_xor = Mode ? ~B : B;     // Mode 1 ise B'yi tersine çevir
    end

    RCA rca (
        .A(A),
        .B(B_xor),
        .Cin(Mode_wire),
        .S(result),
        .Cout(Cout_wire)
    );

    assign Cout = Cout_wire; // Adjust carry out based on subtraction    

endmodule

module RCA (
    input logic [31:0] A, B, 
    output logic Cin,
    output logic [31:0] S,
    output logic Cout
);

    logic [31:0] C_wire;
    logic [31:0] S_wire;
    genvar i;

    generate
        for (i = 0; i < 32; i++) begin : FA_loop
            if (i == 0) begin
                FA fa (
                    .A(A[i]),
                    .B(B[i]),
                    .Cin(Cin),
                    .S(S[i]),
                    .Cout(C_wire[i])
                );
            end else begin
                FA fa (
                    .A(A[i]),
                    .B(B[i]),
                    .Cin(C_wire[i-1]),
                    .S(S[i]),
                    .Cout(C_wire[i])
                );
            end
        end
    endgenerate

    assign Cout = C_wire[31];
    
endmodule

module FA (
    input logic A, B, Cin,
    output logic S, Cout
);
    // Full adder logic implementation
    assign S = A ^ B ^ Cin; // Summation output
    assign Cout = (A & B) | (Cin & (A ^ B)); // Carry of adder output
endmodule
