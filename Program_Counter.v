module Program_Counter
(
  input clk, reset,
  input [63:0] PC_In,
  output reg [63:0] PC_Out
);

initial
begin
  PC_Out = 64'd0;
end

always @(posedge clk)
begin
  if (reset)
    begin
      PC_Out = 64'd0;
    end
  else
    begin
      PC_Out = PC_In;
      $display("PC_In = %b\nPC_Out = %b\n\n", PC_In, PC_Out);
    end
end

endmodule