module Instruction_Fetch
(
  input clk, reset,
  output wire [31:0] Instruction
);

  wire [63:0] In;
  wire [63:0] Out;

  Adder Sum
  (
    .a(PC_Out),
    .b(64'd4),
    .out(In)
  );

  Program_Counter PC
  (
    .clk(clk),
    .reset(reset),
    .PC_In(In),
    .PC_Out(Out)
  );
  
  Instruction_Memory IM
  (  .Inst_Address(Out),
    .Instruction(Instruction)
  );

endmodule