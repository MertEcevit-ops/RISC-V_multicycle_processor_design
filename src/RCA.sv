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
