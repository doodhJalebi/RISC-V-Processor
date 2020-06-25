module tb
(
);

reg clk;
reg reset;

RISC_V_Processor r1
(
  .clk(clk),
  .reset(reset)
);

initial
begin
  clk <= 1'b0;
  reset <= 1'b0;
end

always
#5 clk = ~clk;

initial
begin
#35 reset <= 1'b1;
#1	reset <= 1'b0;
end

endmodule