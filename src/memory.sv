module memory (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] a,   // byte address
    input  logic [31:0] wd,  // write data
    output logic [31:0] rd   // read data
);

    // 64 words of 32-bit RAM
    logic [31:0] RAM [0:63];

    initial begin
        // adjust this path to wherever your hex file lives
        $readmemh("/home/merte/RISC-V_multicycle_processor_design/src/test.hex", RAM);
    end

    // Extract word-address index (bits [7:2]) for 64 entries
    wire [5:0] addr_index = a[7:2];

    // Combinational read
    assign rd = RAM[addr_index];

    // Synchronous write
    always_ff @(posedge clk) begin
        if (we) begin
            RAM[addr_index] <= wd;
        end
    end

endmodule
