module equal (
    input logic [31:0] A,B,
    output logic branch_equal
);

    assign branch_equal = (A == B) ? 1'b1 : 1'b0;

endmodule
