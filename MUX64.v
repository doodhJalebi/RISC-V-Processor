module MUX64 (input [63:0]a, b, 
            sel, 
            output wire [63:0] F);
    assign F = sel? a:b;
    endmodule

