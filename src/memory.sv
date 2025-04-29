module memory(input  logic clk, we,
				  input  logic [31:0] a, wd,
				  output logic [31:0] rd);

  logic [31:0] RAM[63:0];
  
  initial
      $readmemh("/home/merte/RISC-V_multicycle_processor_design/src/test.hex",RAM);

  assign rd = RAM[a[31:2]]; // word aligned

  always_ff @(posedge clk) begin
    if (we) RAM[a[31:2]] <= wd;
  end
endmodule

