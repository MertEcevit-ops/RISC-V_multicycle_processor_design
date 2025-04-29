module CPOP (
    input logic [31:0] A,
    output logic [31:0] CPOP
);

    integer i;

    always_comb begin 
        CPOP = 0;
        for (i = 0; i<32; i++) begin
            CPOP = CPOP + {31'b0,{A[i]}};
        end
        
    end
    
endmodule
