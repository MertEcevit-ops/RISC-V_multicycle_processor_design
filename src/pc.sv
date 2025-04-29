module pc (
    input logic [31:0] pc_next,
    input logic clk,rst,
    output logic [31:0] pc
);
    
    always_ff @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            pc <= 32'h8000_0000;
        end else begin
            pc <= pc_next;
        end
    end 
endmodule
