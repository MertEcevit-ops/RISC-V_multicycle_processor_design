module RCA (
    input  logic [31:0] A,
    input  logic [31:0] B, 
    input  logic        Cin,    // <-- changed from output to input
    output logic [31:0] S,
    output logic        Cout
);

    logic [31:0] C_wire;

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin : FA_loop
            if (i == 0) begin : first_bit
                FA fa_first (
                    .A    (A[i]),
                    .B    (B[i]),
                    .Cin  (Cin),          // now uses the input Cin
                    .S    (S[i]),
                    .Cout (C_wire[i])
                );
            end else begin : other_bits
                FA fa_rest (
                    .A    (A[i]),
                    .B    (B[i]),
                    .Cin  (C_wire[i-1]),
                    .S    (S[i]),
                    .Cout (C_wire[i])
                );
            end
        end
    endgenerate

    assign Cout = C_wire[31];

endmodule
