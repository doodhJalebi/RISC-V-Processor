module tb
(
);

reg clk = 1'b0;
reg reset = 1'b0;

RISC_V_Processor r1
(
  .clk(clk),
  .reset(reset)
);



always
#5 clk = ~clk;



endmodule