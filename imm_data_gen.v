module imm_data_gen
(
    input [31:0] instruction,
    output [63:0] imm_data
);

reg [63:0] temp_data;
reg [1:0] select;

// 00 load bits 31:20
// 01 store bits 31:25 + 11:7
// 11 & 10 conditional branching bits 31 + 7 + 30:25 + 11:8

always @ instruction
begin
    select = instruction[6:5];

    case (select)
        2'b00 : temp_data[11:0] = instruction[31:20];
        2'b01 : temp_data[11:0] = {instruction[31:25], instruction[11:7]};
        2'b11 : temp_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
        2'b10 : temp_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
    endcase
end


assign imm_data = {{52{temp_data[11]}}, temp_data[11:0]};



endmodule
