module riscv_multicycle
(
    input  logic             clk_i,       // system clock
    input  logic             rstn_i,      // system reset, active low
    input  logic  [XLEN-1:0] addr_i,      // instruction‐fetch address
    output logic  [XLEN-1:0] data_o,      // instruction‐fetch data
    output logic             update_o,    // retire pulse
    output logic  [XLEN-1:0] pc_o,        // retired PC
    output logic  [XLEN-1:0] instr_o,     // retired instruction
    output logic  [     4:0] reg_addr_o,  // retired register address
    output logic  [XLEN-1:0] reg_data_o,  // retired register data
    output logic  [XLEN-1:0] mem_addr_o,  // data‐memory address
    output logic  [XLEN-1:0] mem_data_o,  // data‐memory write data
    output logic             mem_wrt_o    // data‐memory write enable
);

    // Internal bus between core and data‐memory
    logic [XLEN-1:0] read_data;

    // CPU core instance
    riscv_multicycle u_rv_multi (
        .clk_i       (clk_i),        // system clock
        .rstn_i      (rstn_i),       // system reset
        .addr_i      (addr_i),       // IF address
        .data_o      (data_o),       // IF data
        .update_o    (update_o),     // retire pulse
        .pc_o        (pc_o),         // retired PC
        .instr_o     (instr_o),      // retired instruction
        .reg_addr_o  (reg_addr_o),   // retired rd address
        .reg_data_o  (reg_data_o),   // retired rd data
        .data_adr    (mem_addr_o),   // data‐memory address
        .write_data  (mem_data_o),   // data‐memory write data
        .mem_write   (mem_wrt_o),    // data‐memory write enable
        .read_data   (read_data)     // data‐memory read data
    );

    // Single‐port data memory
    memory u_memory (
        .clk (clk_i),                // clock
        .we  (mem_wrt_o),            // write enable
        .a   (mem_addr_o),           // address
        .wd  (mem_data_o),           // write data
        .rd  (read_data)             // read data
    );

endmodule
