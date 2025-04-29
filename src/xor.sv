module xor (
    input logic [31:0] A,B,
    output logic [31:0] result
);

genvar i;
generate
    for (i = 0; i<32; i++) begin
        assign result[i] = A[i] ^ B[i];
    end
endgenerate
    
endmodule
