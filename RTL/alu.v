module alu(

input [7:0] A,
input [7:0] B,
input CY,

input [3:0] alu_op,

output reg [7:0] result,
output reg carry

);

reg [8:0] tmp;

always @(*) begin

result = 8'h00;
carry  = 0;
tmp    = 9'd0;

case(alu_op)

/* ADD */
4'b0000:
begin
tmp = A + B;
result = tmp[7:0];
carry  = tmp[8];
end

/* ADC */
4'b0001:
begin
tmp = A + B + CY;
result = tmp[7:0];
carry  = tmp[8];
end

/* SUB (8085 borrow) */
4'b0010:
begin
tmp = {1'b0,A} - {1'b0,B};
result = tmp[7:0];
carry  = tmp[8];   
end

/* SBB */
4'b0011:
begin
tmp = {1'b0,A} - {1'b0,B} - CY;
result = tmp[7:0];
carry  = tmp[8];
end

/* ANA */
4'b0100:
begin
result = A & B;
carry  = 0;
end

/* XRA */
4'b0101:
begin
result = A ^ B;
carry  = 0;
end

/* ORA */
4'b0110:
begin
result = A | B;
carry  = 0;
end

/* CMP */
4'b0111:
begin
tmp = {1'b0,A} - {1'b0,B};
result = tmp[7:0];
carry  = tmp[8];
end

4'b1000:
begin
{carry,result} = B + 1;
carry = CY;   
end

4'b1001:
begin
{carry,result} = B - 1;
carry = CY;
end

/* RLC */
4'b1010:
begin
result = {A[6:0],A[7]};
carry  = A[7];
end

/* RRC */
4'b1011:
begin
result = {A[0],A[7:1]};
carry  = A[0];
end

/* RAL */
4'b1100:
begin
result = {A[6:0],CY};
carry  = A[7];
end

/* RAR */
4'b1101:
begin
result = {CY,A[7:1]};
carry  = A[0];
end

/* CMA */
4'b1110:
begin
result = ~A;
carry  = CY;
end

default:
begin
result = A;
carry  = CY;
end

endcase

end

endmodule