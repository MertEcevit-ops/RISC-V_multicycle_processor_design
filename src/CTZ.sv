module CTZ (
    input logic [31:0] A,
    output logic [31:0] CTZ
);

    integer i;

    always_comb begin 
        CTZ = 0;
        for (i = 0; i<32; i++) begin
            if(A[i] == 0) begin
                CTZ = CTZ + 1;
            end else begin
                i = 32;
                break;
            end
        end
        
    end
    
endmodule
