module registerFile
(
    input clk, reset,
    input [63:0] WriteData,
    input [4:0] RS1, RS2, RD,
    input RegWrite,
    output [63:0] ReadData1, ReadData2
);

reg [63:0] registers [31:0];
integer i;
integer register_select;
reg [63:0] readdata1, readdata2;

initial
begin
    for (i=0; i<64; i=i+1)
    begin
        registers[i] = i;
    end
end

always @ (RS1, RS2, reset, registers)
begin
    if (reset == 1'b1)
    begin
        readdata1 = {64{1'b0}};
        readdata2 = {64{1'b0}};
    end
    
    else if (RegWrite == 1'b0)
    begin
        register_select = RS1;
        readdata1 = registers[register_select];
        
        register_select = RS2;
        readdata2 = registers[register_select];
    end
end

assign ReadData1 = readdata1;
assign ReadData2 = readdata2;

always @ (clk)
begin
    if (RegWrite == 1'b1)
    begin
        register_select = RD;
        registers[register_select] = WriteData;
    end
end

endmodule
