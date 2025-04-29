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
