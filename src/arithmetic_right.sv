module arithmetic_right (
    input logic[31:0] A,
    input logic[31:0] B,
    output logic[31:0] Result
);
    assign Result = A >>> B[4:0];
endmodule
