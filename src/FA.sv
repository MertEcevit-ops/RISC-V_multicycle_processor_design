module FA (
    input logic A, B, Cin,
    output logic S, Cout
);
    // Full adder logic implementation
    assign S = A ^ B ^ Cin; // Summation output
    assign Cout = (A & B) | (Cin & (A ^ B)); // Carry of adder output
endmodule
