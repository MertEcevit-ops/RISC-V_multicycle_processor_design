module comp_sign (
    input logic [31:0] A,B,
    output logic branch_greater,
    output logic branch_less
);
    logic signed [31:0] A_sign, B_sign;
    
    assign A_sign = $signed(A);
    assign B_sign = $signed(B);
    
    assign branch_less = (A_sign < B_sign) ? 1'b1 : 1'b0; 
    assign branch_greater = (A_sign >= B_sign) ? 1'b1 : 1'b0;
endmodule
