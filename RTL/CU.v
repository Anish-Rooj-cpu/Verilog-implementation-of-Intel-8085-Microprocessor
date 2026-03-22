module CU(

input clk,
input rst,

input MOV,
input MVI,
input LXI,

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

input JMP,
input CALL,
input RET,

input PUSH,
input POP,

input NOP,
input HLT,

output reg pc_inc,
output reg pc_load,

output reg mem_read,
output reg mem_write,

output reg ir_load,

output reg reg_write,

output reg alu_enable,
output reg flag_write,

output reg sp_inc,
output reg sp_dec,

output reg [2:0] state
);

localparam T1=0,T2=1,T3=2,T4=3,EX1=4,EX2=5,EX3=6;

reg [2:0] next;

always @(posedge clk or posedge rst)
if(rst) state<=T1;
else state<=next;

always @(*) begin

pc_inc=0;
pc_load=0;
mem_read=0;
mem_write=0;
ir_load=0;
reg_write=0;
alu_enable=0;
flag_write=0;
sp_inc=0;
sp_dec=0;

next=state;

case(state)

/* FETCH */

T1: next=T2;

T2:
begin
mem_read=1;
next=T3;
end

T3:
begin
mem_read=1;
ir_load=1;
pc_inc=1;
next=T4;
end

T4:
begin
if(HLT)
next=T4;
else if(NOP)
next=T1;
else
next=EX1;
end


/* EXECUTE */

EX1:
begin

if(MOV)
begin
reg_write=1;
next=T1;
end

else if(ADD||ADC||SUB||SBB||ANA||XRA||ORA)
begin
reg_write=1;
flag_write=1;
next=T1;
end

else if(CMP)
begin
flag_write=1;
next=T1;
end

else if(INR||DCR)
begin
reg_write=1;
flag_write=1;
next=T1;
end

else if(MVI)
begin
mem_read=1;
next=EX2;
end

end


EX2:
begin
mem_read=1;
reg_write=1;
pc_inc=1;
next=T1;
end

endcase

end

endmodule