module Program_Counter
(
  input clk, reset,
  input [63:0] PC_In,
  output reg [63:0] PC_Out
);

initial
begin
  PC_Out = 64'b0;
end

always @(posedge clk)
begin
  if(!reset)
    begin
      PC_Out = PC_In;
    end
end

always @(reset)
begin
  if (reset)
  begin
    PC_Out = 64'b0;
  end
end

endmodule