module aluControl(
input ADD,
input ADC,
input SUB,
input SBB,
input ANA,
input XRA,
input ORA,
input CMP,
input INR,
input DCR,
input RLC,
input RRC,
input RAL,
input RAR,
input CMA,
input STC,
input CMC,
input DAA,
output reg [3:0] alu_op
);

always @(*) begin

case(1'b1)

ADD: alu_op = 4'b0000;
ADC: alu_op = 4'b0001;
SUB: alu_op = 4'b0010;
SBB: alu_op = 4'b0011;

ANA: alu_op = 4'b0100;
XRA: alu_op = 4'b0101;
ORA: alu_op = 4'b0110;
CMP: alu_op = 4'b0111;

INR: alu_op = 4'b1000;
DCR: alu_op = 4'b1001;

RLC: alu_op = 4'b1010;
RRC: alu_op = 4'b1011;
RAL: alu_op = 4'b1100;
RAR: alu_op = 4'b1101;

CMA: alu_op = 4'b1110;

default: alu_op = 4'b1111;

endcase

end

endmodule