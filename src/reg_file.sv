module reg_file (
    input logic clk,
    input logic rst,
    input logic we3,
    input logic [4:0] a1,a2,a3,
    input logic [31:0] wd3,
    output logic [31:0] rd1,rd2
);
    logic [31:0] register [31:0];

    assign rd1 = register[a1];
    assign rd2 = register[a2];
    assign register[0] = 32'b0;

    always_ff @(posedge clk  or negedge rst) begin 
        if (rst == 0) begin
            for (int i = 0; i<32; i++) begin
                register[i] <= 32'b0;
            end
        end else
        if (we3) begin
            if (a3 != 0) begin
                register[a3] <= wd3;
            end
        end
    end
endmodule
