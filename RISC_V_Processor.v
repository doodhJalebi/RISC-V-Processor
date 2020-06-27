module RISC_V_Processor
(
  input wire clk, reset
);

  wire branch;
  wire memRead;
  wire memtoReg;
  wire memWrite;
  wire ALUsrc;
  wire regWrite;

  reg branchand;

  wire [6:0] opcode;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] Funct3;
  wire [6:0] Funct7;

  wire [63:0] readData1, readData2;

  wire [63:0]pc_in;
  wire [63:0]pc_out;
  wire [63:0]adderout;
  wire [63:0]adder2out;
  wire [63:0]mux2out;
  wire [3:0]Operation;
  wire [63:0]mux3out;

  wire [63:0]mem_add;
  wire [63:0]ReadData;
  
  wire [31:0] Instruction;
  reg [3:0] Instruction_Conc;

  wire [63:0] Imm_data;
  reg [63:0] Imm_data_adder; //Left Shifted by 1 Imm_data 
  
  wire [63:0] Result;
  wire zero;
  
  wire [63:0] WriteData;

  wire [1:0] ALUOp_2bit; // This goes from Control Unit to ALU Control
  wire [3:0] ALUOp_4bit; // This goes from Control Unit Operation to ALU ALUOp

  assign select = branch & zero;

  //Left Shifter
  always @ (Imm_data)
    begin
      Imm_data_adder = Imm_data << 1;
    end
  
  always @ (Instruction)
    begin
      Instruction_Conc = {Instruction[30], Instruction[14:12]};
    end

  always @ (branch)
    begin
      branchand = branch & zero;
    end

  Program_Counter PC
(
  .PC_In(pc_in), //Coming from mux 1 output
  .PC_Out(pc_out), //going from instruction memory, adder 1 a
  .clk(clk), //Inputs are correct
  .reset(reset)
);

  Adder adder1
  (
    .a(pc_out),//Coming from PC out
    .b(64'd4), // input 4
    .out(adderout) //Going to mux 1
  );

  Adder adder2 (
    .a(pc_out), //Coming from PC 
    .b(Imm_data_adder), //Coming from Imm_data generator
    .out(adder2out) // going to mux 1 b
  );

  MUX64 mux1
  (
      .a(adderout), //Coming from adder 1
      .b(adder2out), //Coming from adder 2
      .sel(branchand), //Coming from Control Unit branch and zero
      .F(pc_in) // Going to Program Counter
  );

     Instruction_Memory IM
  (
    .Inst_Address(pc_out), // Coming from Program Counter
    .Instruction(Instruction) //Outputing to Instruction Parser
  );

  instruction_parser IP
  (
    .instruction(Instruction), //Coming from Instruction_Memory
    .opcode(opcode), //Going to Control Unit
    .rd(rd), //Going to registerFile
    .funct3(Funct3), //Going nowhere
    .rs1(rs1), //Going to registerFile
    .rs2(rs2), //Going to registerFile
    .funct7(Funct7) // Going nowhere
  );

  ALU_Control ALUC
  (.ALUOp(ALUOp_2bit), //Coming from Control unit aluop
  .Funct(Instruction_Conc), //Coming from Instruction (Concatenated)
  .Operation(ALUOp_4bit)); //Going to ALUop of ALU

  Control_Unit CU
  (
    .Opcode(opcode), //Coming from instruction_parser
    .Branch(branch),  //going to branchand and then to mux 1 select
    .MemRead(memRead), //going to data memory memread
    .MemtoReg(memtoReg), //going to mux 3 select
    .MemWrite(memWrite), //Goin to DataMemory memwrite
    .ALUSrc(ALUsrc),//Going to mux 2 sel
    .RegWrite(regWrite), // Going to registerFile regWrite
    .ALUOp(ALUOp_2bit) // Going to alu control aluOp
  );

    registerFile rg(
        .clk(clk), 
        .reset(reset),
        .RegWrite(regWrite), //Coming from control unit regWrite
        .RS1(rs1), //Coming from Instruction Parser
        .RS2(rs2), //Coming from Instruction Parser
        .RD(rd),//Coming from Instruction Parser
        .WriteData(mux3out), //Coming from mux 3
        .ReadData1(readData1), //Going to ALU a
        .ReadData2(readData2) //Going to Mux 2, DataMemory WriteData
    );

    MUX64 mux2(
      .a(readData2),//Coming from registerFile
      .b(Imm_data), //Coming from Imm_data_gen
      .sel(ALUsrc), //Coming from Control Unit ALUSrc
      .F(mux2out) // Going to ALU b
      );

    ALU_64_bit ALU(
        .a(readData1), //Coming from registerFile 
        .b(mux2out), //Coming from Mux 2
        .ALUOp(ALUOp_4bit), //Coming from ALU control
        .Result(mem_add), // Going to data memory, MUX 3
        .Zero(zero) // Anding with branch, going to mux 1 select
        );


    DataMemory DM(
        .Mem_Addr(mem_add), //Coming from ALU Result
        .Write_Data(readData2),
        .clk(clk), 
        .MemWrite(memWrite), //Coming from control unit memwrite
        .MemRead(memRead),//Coming from control unit memread
        .Read_Data(ReadData) //Going to Mux 3 b
    );

    MUX64 mux3(
        .a(mem_add), //Coming from ALU Result
        .b(ReadData), //Coming from DataMemory
        .sel(memtoReg), //Coming from Control Unit memtoReg
        .F(mux3out) // Going to registerfile
    );

    imm_data_gen IDG (

        .instruction(Instruction), //Coming from Instruction_Memory, also went to ALU Control
        .imm_data(Imm_data) //Going to the adder, left Shifted, 
        //Going to mux 2

    );
  
  endmodule


  

