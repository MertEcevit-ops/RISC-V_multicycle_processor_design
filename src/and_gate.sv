module and_gate (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] result
);

  genvar i;
  generate
    for (i = 0; i < 32; i++) begin
      assign result[i] = a[i] & b[i];
    end
  endgenerate

endmodule
