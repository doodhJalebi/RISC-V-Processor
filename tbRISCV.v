module tbRISCV();

    reg clk;
    reg reset;

    RISC_V_Processor RP
    (
    .clk(clk),
    .reset(reset)
    );

    initial

    begin
    clk = 1'b0;
    reset = 1'b0;
    end

    always
    #10 clk = ~clk;

endmodule