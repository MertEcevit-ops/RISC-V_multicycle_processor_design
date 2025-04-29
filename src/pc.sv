//------------------------------------------------------------------------------
// pc.sv
//------------------------------------------------------------------------------
// Simple program-counter register with asynchronous active-low reset.
// Output port renamed to pc_out to avoid name collisions.

module pc (
    input  logic [31:0] pc_next,  // next PC value
    input  logic        clk,      // clock
    input  logic        rst,      // active-low reset
    output logic [31:0] pc_out    // current PC value
);

  always_ff @(posedge clk or negedge rst) begin
    if (!rst)
      pc_out <= 32'h8000_0000;
    else
      pc_out <= pc_next;
  end

endmodule
