module tb_program_counter();

reg [63:0] pc_in;
wire [63:0] pc_out;
reg clk = 1'b0;
reg reset = 1'b0;


Program_Counter PC (
    .PC_In(pc_in),
    .PC_Out(pc_out),
    .clk(clk),
    .reset(reset)
);

initial reset = 1'b0;

always
begin
    #5
    clk = ~clk;
end

initial
begin
    #5
    pc_in = 64'b0;

    #5
    pc_in = 64'b1;

    #5
    pc_in = 64'd80;

    #5
    pc_in = 64'd5;

    #5
    pc_in = 64'd11;
end


endmodule