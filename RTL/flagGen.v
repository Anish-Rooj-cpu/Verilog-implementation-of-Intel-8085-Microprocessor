module flagGen(

input [7:0] A,
input [7:0] B,
input [7:0] result,

input carry_in,
input carry_out,

input [3:0] alu_op,

output reg S,
output reg Z,
output reg P,
output reg AC,
output reg CY

);

wire ac_add;
wire ac_sub;

assign ac_add = ((A[3] & B[3]) | (B[3] & ~result[3]) | (~result[3] & A[3]));
assign ac_sub = ((~A[3] & B[3]) | (B[3] & result[3]) | (result[3] & ~A[3]));

always @(*) begin

S  = result[7];
Z  = (result == 8'h00);
P  = ~^result;

CY = carry_out;
AC = 0;

case(alu_op)

/* ADD */
4'b0000:
begin
AC = ac_add;
end

/* ADC */
4'b0001:
begin
AC = ac_add;
end

/* SUB */
4'b0010:
begin
AC = ac_sub;
end

/* SBB */
4'b0011:
begin
AC = ac_sub;
end

/* ANA */
4'b0100:
begin
CY = 0;
AC = 1;
end

/* XRA */
4'b0101:
begin
CY = 0;
AC = 0;
end

/* ORA */
4'b0110:
begin
CY = 0;
AC = 0;
end

/* CMP */
4'b0111:
begin
AC = ac_sub;
CY = carry_out;
end

/* INR (CY unchanged) */
4'b1000:
begin
AC = ((B[3] & 1'b1) | (1'b1 & ~result[3]) | (~result[3] & B[3]));
CY = carry_in;
end

/* DCR (CY unchanged) */
4'b1001:
begin
AC = ((~B[3] & 1'b1) | (1'b1 & result[3]) | (result[3] & ~B[3]));
CY = carry_in;
end

default:
begin
AC = 0;
CY = carry_out;
end

endcase

end

endmodule