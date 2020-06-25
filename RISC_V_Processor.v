module RISC_V_Processor
(
  input wire clk, reset
);

  wire Branch;
  wire MemRead;
  wire MemtoReg;
  wire [1:0] ALUOp;
  wire MemWrite;
  wire ALUSrc;
  wire RegWrite;

  wire [63:0] readData1, readData2;


  wire [63:0]pc_in;
  wire [63:0]pc_out;
  wire [63:0]adderout;
  wire [63:0]adder2out;
  wire [63:0]mux2out;
  wire [3:0]Operation;
  wire [63:0]mux3out;


  wire [31:0] instruction;
  

  wire [63:0] imm_data;
  
  wire [63:0] Result;
  wire Zero;
  
  wire [63:0] WriteData;

  wire select;
  assign select = Branch & Zero;

  Program_Counter PC
(
  .PC_In(pc_in),
  .PC_Out(pc_out),
  .clk(clk),
  .reset(reset)
);


  Adder adder1
  (
    .a(pc_Out),
    .b(64'd4),
    .out(adderout)
  );

    MUX64 mux1
    (
        .a(adderout),
        .b(adder2out),
        .sel(select),
        .F(pc_in)
    );

     Instruction_Memory IM
  (
    .Inst_Address(pc_out),
    .Instruction(instruction)
  );

  instruction_parser IP
  (
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
  );

  ALU_Control ALUC
  (.ALUOp(ALUOp), 
  .Funct(instruction),
  .Operation(Opcode));

  Control_Unit CU
  (
    .Opcode(opcode),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp)
  );

    registerFile rg(
        .clk(clk), 
        .reset(reset),
        .RegWrite(RegWrite),
        .RS1(rs1),
        .RS2(rs2),
        .RD(rd),
        .WriteData(mux3out),
        .ReadData1(readData1),
        .ReadData2(readData2)
    );

    MUX64 mux2
        (.a(readData2),
        .b(imm_data),
        .sel(ALUSrc),
        .F(mux2out)
        );

    ALU_64_bit ALU(
        .a(readData1),
        .b(mux2out),
        .ALUOp(Operation),
        .Result(Mem_Addr)
        );



    DataMemory DM(
        .Mem_Addr(Mem_Addr),
        .Write_Data(readData2),
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Read_Data(readData)
    );

    MUX64 mux3(
        .a(ReadData),
        .b(Mem_Addr),
        .sel(MemtoReg),
        .F(mux3out)
    );

  endmodule


