module comp (
    input logic [31:0] A,B,
    output logic branch_less,
    output logic branch_greater
);
    
    assign branch_less = (A < B) ? 1'b1 : 1'b0;
    assign branch_greater = (A >= B) ? 1'b1 : 1'b0;
endmodule
